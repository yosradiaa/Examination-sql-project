--Training Manager Procedure


--Instructor

--ADD Instructor
create or alter proc AddInstructor
      @Ins_Name nvarchar(MAX),
	  @Ins_Age nvarchar(MAX),
	  @Ins_Address nvarchar(MAX),
	  @Ins_Phone nvarchar(MAX)
as
begin
	BEGIN TRY
		INSERT INTO HRInstructoe 
		VALUES(@Ins_Name , @Ins_Age , @Ins_Address , @Ins_Phone);
		SELECT 'Instructor is Added Successfully'
	END TRY 
	BEGIN CATCH
		SELECT 'Something is wrong' , ERROR_LINE() , ERROR_MESSAGE()
	END CATCH
end

--AddInstructor 'Mrihan' , 30 , 'Cairo Nasr City' , '01004382577'
GO

--Update Instructor 
create or alter proc UpdateInstructor
	  @Ins_id int,
      @Ins_Name nvarchar(MAX),
	  @Ins_Age nvarchar(MAX),
	  @Ins_Address nvarchar(MAX),
	  @Ins_Phone nvarchar(MAX)
as
begin
	IF Not Exists(select Ins_Id from HRInstructoe where Ins_Id = @Ins_id) 
		BEGIN 
			SELECT 'Something is wrong Instructor may be not found try again' , ERROR_LINE() , ERROR_MESSAGE()
			RETURN
		END
	ELSE
		BEGIN
			BEGIN TRY
				UPDATE HRInstructoe 
				SET Ins_name = @Ins_Name , Ins_Age = @Ins_Age , Ins_Address = @Ins_Address , Ins_Phone = @Ins_Phone
				Where Ins_Id = @Ins_id;
					SELECT 'Instructor is Updated Successfully'
				END TRY 
				BEGIN CATCH
					SELECT 'Something is wrong' , ERROR_LINE() , ERROR_MESSAGE()
			END CATCH
		END

end
--UpdateInstructor 7 , 'Mrihan' , 30 ,'Minya' , '01004382525'
GO
--Delete Instructor 
create or alter proc DeleteInstructor 
		@Ins_id int
as
begin
	IF Not Exists(select Ins_Id from HRInstructoe where Ins_Id = @Ins_id) 
		BEGIN 
			SELECT 'Something is wrong Branch may be not found try again' , ERROR_LINE() , ERROR_MESSAGE()
			RETURN
		END
	ELSE
		BEGIN
			BEGIN TRY
				DELETE FROM HRInstructoe 
				Where Ins_Id = @Ins_id;
					SELECT 'Instructor is Deleted Successfully'
				END TRY 
				BEGIN CATCH
					SELECT 'Something is wrong' , ERROR_LINE() , ERROR_MESSAGE()
			END CATCH
		END

end

--DeleteInstructor 7

