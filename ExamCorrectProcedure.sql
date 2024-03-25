--Exam Asnwers Result Procedures

--GetExamResultForStudent 2 , 1


--Get result for student by id
CREATE OR ALTER PROCEDURE GetExamResultForStudent 
    @Student_id INT, 
    @Exam_id INT
AS
BEGIN

	IF Not Exists(select Std_id from HRStudent where Std_id = @student_id) or 
		Not Exists(select Exam_id from HRExam where Exam_id = @Exam_id)
		BEGIN 
			SELECT 'Something is wrong Exam or Student may be not found try again' , ERROR_LINE() , ERROR_MESSAGE()
			RETURN
		END
    ELSE IF NOT EXISTS(SELECT hse.Student_id , hse.Exam_id FROM HRStudent s inner join HR_Student_Exam hse ON s.Std_id = hse.Student_id AND hse.Student_id = @Student_id INNER JOIN HRExam e ON e.Exam_id = hse.Exam_id AND hse.Exam_id = @Exam_id )
		BEGIN 
			SELECT 'This Student is not have this exam' , ERROR_LINE() , ERROR_MESSAGE()
			RETURN
		END
	ELSE
		BEGIN
			-- Create a temporary table to hold student exam results
			CREATE TABLE #ExamAnswersResults_TMP(
				[Exam_id] [int] NOT NULL,
				[Question_id] [int] NOT NULL,
				[Student_id] [int] NOT NULL,
				[Student_Answer] [nvarchar](50) NOT NULL,
			)

			INSERT INTO #ExamAnswersResults_TMP 
			SELECT * FROM Exam_Questions_Student WHERE Student_id =  @Student_id AND Exam_id = @Exam_id

			DECLARE @Question_id INT
			DECLARE @Total_result INT = 0;
			DECLARE @Student_Answer NVARCHAR(50)
			DECLARE @Correct_Answer NVARCHAR(50)

			DECLARE CalculateAnswerExamCursor CURSOR FOR 
			SELECT tr.Question_id, tr.Student_Answer , q.Correct_answer
			FROM #ExamAnswersResults_TMP tr
			INNER JOIN Question q ON tr.Question_id = q.Question_id

			OPEN CalculateAnswerExamCursor
			FETCH NEXT FROM CalculateAnswerExamCursor INTO @Question_id, @Student_Answer , @Correct_Answer

			--Get total degree for course
			DECLARE @Exam_Total_degree int = 0;

			WHILE @@FETCH_STATUS = 0
			BEGIN

				DECLARE @Question_Degree INT --Get question degree
				SELECT @Question_Degree = Degree --set degree in varriable
				FROM HR_Exam_Questions 
				WHERE Exam_ID = @Exam_id AND Question_id = @Question_id

				SET @Exam_Total_degree = @Exam_Total_degree +  @Question_Degree; 
           
				IF @Student_Answer = @Correct_Answer
					BEGIN
						SET @Total_result = @Total_result +  @Question_Degree
					END
				ELSE
					BEGIN
						SET @Total_result = @Total_result + 0 -- Set the question grade if none of the conditions match
					END
				FETCH NEXT FROM CalculateAnswerExamCursor INTO @Question_id, @Student_Answer , @Correct_Answer
			END

			 -- Update the question result
				UPDATE HR_Student_Exam SET Exam_result = @Total_result
				WHERE Student_id = @student_id AND Exam_id = @Exam_id

				DECLARE @Std_name NVARCHAR(50);
				DECLARE @Crs_name NVARCHAR(50);

				SELECT @Std_name = Std_name FROM HRStudent WHERE Std_id = @Student_id;
				SELECT @Crs_name = c.Crs_name FROM HRCousres c INNER JOIN Exam e 
				ON c.crs_id = e.Course_id AND e.Exam_id = @Exam_id;

				SELECT Concat('Result for Student : ' , @Std_name , ' of ' , @Crs_name , ' Course is: ' , @Total_result , '/' ,  @Exam_Total_degree);
			CLOSE CalculateAnswerExamCursor 
			DEALLOCATE CalculateAnswerExamCursor
			-- Drop temporary table after complete calculation
			DROP TABLE #ExamAnswersResults_TMP
		END
END