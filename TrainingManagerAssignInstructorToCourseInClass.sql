--Assing Course to Instructor

create or alter proc AssignCourseToInstructor
	  @Class_id int,
      @Ins_id int,
	  @Course_id int,
	  @Year int
as
begin
	IF Not Exists(select Ins_Id from HRInstructoe where Ins_Id = @Ins_id) or 
		Not Exists(select Crs_id from HRCousres where Crs_id = @Course_id) or 
		Not Exists(select Class_id from HRClass where Class_id = @Class_id)
		BEGIN 
			SELECT 'Something is wrong Instructor may be not found try again' , ERROR_LINE() , ERROR_MESSAGE()
			RETURN
		END
	ELSE IF Exists(select * from HRClassCourseInstructor where Class_id = @Class_id and Course_Id = @Course_id and Year = @Year)
			BEGIN 
				SELECT 'This Course Already hava instructor in this class in this year' , ERROR_LINE() , ERROR_MESSAGE()
			RETURN
		END
	ELSE
	BEGIN
		BEGIN TRY
			INSERT INTO HRClassCourseInstructor 
			VALUES(@Class_id , @Course_id , @Year , @Ins_id);
			SELECT 'Instructor is Added Successfully to Course in this Class'
		END TRY 
		BEGIN CATCH
			SELECT 'Something is wrong' , ERROR_LINE() , ERROR_MESSAGE()
		END CATCH
	END
	
end

--AssignCourseToInstructor 1 , 5, 2 , 2024

GO
--update course to instructor
create or alter proc UpdateAssignCourseToInstructor
	  @Class_id int,
      @Ins_id int,
	  @Course_id int,
	  @Year int,
	  @Class_New_id int,
      @Ins_New_id int,
	  @Course_New_id int,
	  @Year_New int
as
begin
	IF Not Exists(select Ins_Id from HRInstructoe where Ins_Id = @Ins_New_id) or 
		Not Exists(select Crs_id from HRCousres where Crs_id = @Course_New_id) or 
		Not Exists(select Class_id from HRClass where Class_id = @Class_New_id)
		BEGIN 
			SELECT 'Something is wrong Instructor may be not found try again' , ERROR_LINE() , ERROR_MESSAGE()
			RETURN
		END
	ELSE IF NOT Exists(select * from HRClassCourseInstructor where Class_id = @Class_id and Course_Id = @Course_id and Year = @Year)
			BEGIN 
				SELECT 'This Instructor Not Assigned to this Course' , ERROR_LINE() , ERROR_MESSAGE()
			RETURN
		END
	ELSE
	BEGIN
		BEGIN TRY
			UPDATE HRClassCourseInstructor 
			set Class_Id = @Class_New_id , Course_Id = @Course_New_id , Year = @Year_New , Instractor_ID =  @Ins_New_id
			where Class_Id = @Class_id and Instractor_ID = @Ins_id and Course_Id = @Course_id and Year = @Year;
			SELECT 'Instructor is Updated Successfully to Course in this Class'
		END TRY 
		BEGIN CATCH
			SELECT 'Something is wrong' , ERROR_LINE() , ERROR_MESSAGE()
		END CATCH
	END
	
end

--UpdateAssignCourseToInstructor 1 , 5, 2 , 2024 , 1 , 5 , 2 , 2025
GO
--Delete course to instructor
create or alter proc DeleteAssignCourseToInstructor
	  @Class_id int,
	  @Course_id int,
	  @Year int
as
begin
	IF  Not Exists(select Crs_id from HRCousres where Crs_id = @Course_id) or 
		Not Exists(select Class_id from HRClass where Class_id = @Class_id)
		BEGIN 
			SELECT 'Something is wrong Instructor may be not found try again' , ERROR_LINE() , ERROR_MESSAGE()
			RETURN
		END
	ELSE IF NOT Exists(select * from HRClassCourseInstructor where Class_id = @Class_id and Course_Id = @Course_id and Year = @Year)
			BEGIN 
				SELECT 'This Course not Have instructor in this class in this year' , ERROR_LINE() , ERROR_MESSAGE()
			RETURN
		END
	ELSE
	BEGIN
		BEGIN TRY
			DELETE FROM HRClassCourseInstructor 
			where Class_Id = @Class_id and Course_Id = @Course_id and Year = @Year;
			SELECT 'Instructor is Deleted Successfully from Course in this Class'
		END TRY 
		BEGIN CATCH
			SELECT 'Something is wrong' , ERROR_LINE() , ERROR_MESSAGE()
		END CATCH
	END
	
end

--DeleteAssignCourseToInstructor 1 , 2, 2025
GO
