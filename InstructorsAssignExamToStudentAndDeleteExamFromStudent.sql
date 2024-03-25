--Assign Exam to Specific Student
create or alter proc AddExamToSpecificStudent	
			@Student_id int,
			@Exam_id int

as
BEGIN
	IF Not Exists(select Std_id from HRStudent where Std_id = @student_id) or 
		Not Exists(select Exam_id from HRExam where Exam_id = @Exam_id)
		BEGIN 
			SELECT 'Something is wrong Exam or Student may be not found try again' , ERROR_LINE() , ERROR_MESSAGE()
			RETURN
		END
    ELSE IF EXISTS(SELECT hse.Student_id , hse.Exam_id FROM HRStudent s inner join HR_Student_Exam hse ON s.Std_id = hse.Student_id AND hse.Student_id = @Student_id INNER JOIN HRExam e ON e.Exam_id = hse.Exam_id AND hse.Exam_id = @Exam_id )
		BEGIN 
			SELECT 'This Student already this exam' , ERROR_LINE() , ERROR_MESSAGE()
			RETURN
		END
	ELSE IF NOT EXISTS(SELECT s.Std_id from HRStudent s inner join HRStudent_Course sc on s.Std_id = sc.Student_id and sc.Student_id = @Student_id inner join HRExam e ON sc.Course_id = e.Course_id and e.Exam_id = @Exam_id)
		BEGIN 
			SELECT 'This Student not belong to Course of this Exam' , ERROR_LINE() , ERROR_MESSAGE()
			RETURN
		END
		
	ELSE IF EXISTS(SELECT s.Std_name , se.Exam_id from HRStudent s inner join HR_Student_Exam se on s.Std_id = se.Student_id and se.Student_id = @Student_id inner join HRExam e on se.Exam_id = e.Exam_id and e.Exam_date = (select Exam_date from HRExam where Exam_id = @Exam_id) and e.Exam_start < (select Exam_end from HRExam where Exam_id = @Exam_id))
	BEGIN 
		SELECT 'This Student has another exam in this date' , ERROR_LINE() , ERROR_MESSAGE()
		RETURN
	END
	ELSE IF NOT EXISTS(select * from HR_Exam_Questions where Exam_Id = @Exam_id)
		BEGIN
			SELECT 'This Exam Not Have Any Questions yet' , ERROR_LINE() , ERROR_MESSAGE()
			RETURN
		END
	ELSE
		BEGIN
			insert into HR_Student_Exam(Student_ID, Exam_ID)
			values(@Student_ID, @Exam_ID)
			select 'Student Added to Exam Successfully!' as ALERT_MESSAGE
		END

end
Go

--AddExamToSpecificStudent 3 , 1023
-- Delete Assign exam from student
create or alter proc DeleteExamFromStudent
			@Student_id int,
			@Exam_id int
as
begin
	IF Not Exists(select Std_id from HRStudent where Std_id = @Student_id) or 
		Not Exists(select Exam_id from HRExam where Exam_id = @Exam_id)
		BEGIN 
			SELECT 'Something is wrong Exam or Student may be not found try again' , ERROR_LINE() , ERROR_MESSAGE()
			RETURN
		END
    ELSE IF NOT EXISTS(SELECT hse.Student_id , hse.Exam_id FROM HR_Student_Exam hse where hse.Student_id = @Student_id and Exam_id = @Exam_id )
		BEGIN 
			SELECT 'This Exam not assigned to this Student' , ERROR_LINE() , ERROR_MESSAGE()
			RETURN
		END

	ELSE 
		BEGIN
			BEGIN TRY
				DELETE FROM HR_Student_Exam
				WHERE Student_ID = @Student_ID AND Exam_id = @Exam_id;
				SELECT 'Exam Removed From This Student' as ALERT_MESSAGE
			END TRY
			BEGIN CATCH
				SELECT 'Something is wrong try again' as ALERT_MESSAGE
			END CATCH
		END
end

GO

--DeleteExamFromStudent 2 , 2
