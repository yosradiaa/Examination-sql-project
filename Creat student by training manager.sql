USE [Examination system]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

alter PROC [dbo].[CreateStudent]
    @name NVARCHAR(50),
    @age INT,
    @address NVARCHAR(50),
    @phone INT,
    @intakeID INT,
    @classID INT
AS
BEGIN
    

    BEGIN TRY
        INSERT INTO [dbo].[Student]
               (Std_name, Std_age, Std_address, Std_phone, Intake_id, class_id)
         VALUES
               (@name, @age, @address, @phone, @intakeID, @classID);

        SELECT 'Student created successfully.';
    END TRY
    BEGIN CATCH
        SELECT 'An error occurred while creating the student. Error: ' + ERROR_MESSAGE();
    END CATCH
END;
GO





EXEC [dbo].[CreateStudent] 'Eman' ,12,'cairo','01001214712',1,1;

SELECT* FROM dbo.Student