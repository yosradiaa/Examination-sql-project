--Students

--Assign Student To Course
create or alter proc AssignStudentToCourse
	  @Student_id int,
	  @Course_id int

as
begin
	IF  Not Exists(select Crs_id from HRCousres where Crs_id = @Course_id) or 
		Not Exists(select Std_id from HRStudent where Std_id = @Student_id)
		BEGIN 
			SELECT 'Something is wrong Student Or Course may be not found try again' , ERROR_LINE() , ERROR_MESSAGE()
			RETURN
		END
	ELSE IF Exists(select * from HRStudent_Course where Course_id = @Course_id and Student_id = @Student_id)
			BEGIN 
				SELECT 'This Student Aready join in this course' , ERROR_LINE() , ERROR_MESSAGE()
			RETURN
		END
	ELSE
	BEGIN
		BEGIN TRY
			INSERT INTO HRStudent_Course 
			VALUES(@Student_id , @Course_id);
			SELECT 'Student is Joined Successfully to Course'
		END TRY 
		BEGIN CATCH
			SELECT 'Something is wrong' , ERROR_LINE() , ERROR_MESSAGE()
		END CATCH
	END
	
end

--AssignStudentToCourse 3 , 3

GO

--Delete Student from Course
create or alter proc DeleteAssignStudentToCourse
	  @Student_id int,
	  @Course_id int

as
begin
	IF  Not Exists(select Crs_id from HRCousres where Crs_id = @Course_id) or 
		Not Exists(select Std_id from HRStudent where Std_id = @Student_id)
		BEGIN 
			SELECT 'Something is wrong Student Or Course may be not found try again' , ERROR_LINE() , ERROR_MESSAGE()
			RETURN
		END
	ELSE IF NOT Exists(select * from HRStudent_Course where Course_id = @Course_id and Student_id = @Student_id)
			BEGIN 
				SELECT 'This Student Not join in this course' , ERROR_LINE() , ERROR_MESSAGE()
			RETURN
		END
	ELSE
	BEGIN
		BEGIN TRY
			DELETE FROM HRStudent_Course
			WHERE Course_id = @Course_id and Student_id = @Student_id
			SELECT 'Student is Removed Successfully from Course'
		END TRY 
		BEGIN CATCH
			SELECT 'Something is wrong' , ERROR_LINE() , ERROR_MESSAGE()
		END CATCH
	END
	
end

--DeleteAssignStudentToCourse 3 , 4

GO