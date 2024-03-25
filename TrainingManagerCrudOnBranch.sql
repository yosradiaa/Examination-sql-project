--Training Manager Procedure


--BRANCH

--ADD BRANCH
create or alter proc AddBranch
    @Branch_Name nvarchar(MAX),
	 @Branch_Address nvarchar(MAX),
	  @Branch_Phone nvarchar(MAX)
as
begin
	BEGIN TRY
		INSERT INTO HRBranch 
		VALUES(@Branch_Name , @Branch_Address , @Branch_Phone);
		SELECT 'Branch is Added Successfully'
	END TRY 
	BEGIN CATCH
		SELECT 'Something is wrong' , ERROR_LINE() , ERROR_MESSAGE()
	END CATCH
end

--AddBranch 'Cairo' , 'Cairo Nasr City' , '01004382577'
GO

--Update Branch 
create or alter proc UpdateBranch
		@Branch_id int,
		@Branch_Name nvarchar(MAX),
		@Branch_Address nvarchar(MAX),
		@Branch_Phone nvarchar(MAX)
as
begin
	IF Not Exists(select Branch_id from HRBranch where Branch_id = @Branch_id) 
		BEGIN 
			SELECT 'Something is wrong Branch may be not found try again' , ERROR_LINE() , ERROR_MESSAGE()
			RETURN
		END
	ELSE
		BEGIN
			BEGIN TRY
				UPDATE HRBranch 
				SET Branch_name = @Branch_Name , Branch_address = @Branch_Address , Branch_phone = @Branch_Phone
				Where Branch_id = @Branch_id;
					SELECT 'Branch is Updated Successfully'
				END TRY 
				BEGIN CATCH
					SELECT 'Something is wrong' , ERROR_LINE() , ERROR_MESSAGE()
			END CATCH
		END

end

--UpdateBranch 3 , 'Alex' , 'Alex 3agamy' , '01225693656'

GO

--Delete Branch 
create or alter proc DeleteBranch
		@Branch_id int
as
begin
	IF Not Exists(select Branch_id from HRBranch where Branch_id = @Branch_id) 
		BEGIN 
			SELECT 'Something is wrong Branch may be not found try again' , ERROR_LINE() , ERROR_MESSAGE()
			RETURN
		END
	ELSE
		BEGIN
			BEGIN TRY
				DELETE FROM HRBranch 
				Where Branch_id = @Branch_id;
					SELECT 'Branch is Deleted Successfully'
				END TRY 
				BEGIN CATCH
					SELECT 'Something is wrong' , ERROR_LINE() , ERROR_MESSAGE()
			END CATCH
		END

end

--DeleteBranch 1