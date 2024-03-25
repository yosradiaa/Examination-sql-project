--Get total degree For student and status
CREATE OR ALTER PROCEDURE GetTotalDegreeForStudentExamAndStatus
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
	ELSE IF NOT EXISTS(SELECT Student_id FROM HR_Exam_Questions_Student WHERE Student_id = @Student_id AND Exam_id = @Exam_id)
		BEGIN 
			SELECT 'This Student not answer this exam yet' , ERROR_LINE() , ERROR_MESSAGE()
			RETURN
		END
	ELSE
		BEGIN
			 DECLARE @Exam_result INT;
			 SELECT @Exam_result = Exam_result FROM HR_Student_Exam WHERE Student_id = @Student_id and Exam_id = @Exam_id;

			 DECLARE @Course_MinDegree INT ,  @Crs_name NVARCHAR(50);
		     SELECT @Course_MinDegree = Crs_minDegree , @Crs_name = Crs_name FROM Course c inner join Exam e ON c.Crs_id = e.Course_id WHERE e.Exam_id = @Exam_id;

			 DECLARE @Std_name NVARCHAR(50);
			 SELECT @Std_name = Std_name FROM HRStudent WHERE Std_id = @Student_id;


			

			IF @Exam_result >= @Course_MinDegree 
				BEGIN
					select CONCAT('Result for Student : ' , @Std_name , ' of ' , @Crs_name , ' Course is: ' , @Exam_result , ' Passed')
				END
			ELSE
				BEGIN
					select CONCAT('Result for Student : ' , @Std_name , ' of ' , @Crs_name , ' Course is: ' , @Exam_result , ' Failed')
				END
		END

   
END

--GetTotalDegreeForStudentExamAndStatus 30 , 1
