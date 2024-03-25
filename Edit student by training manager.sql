USE [Examination system]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[EditStudent]
    @name NVARCHAR(50),
    @id INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
      
        IF EXISTS (SELECT 1 FROM Student WHERE Std_ID = @id)
        BEGIN
            UPDATE [dbo].[Student]
            SET Std_name = @name
            WHERE Std_ID = @id;

            PRINT 'Student information updated successfully.';
        END
        ELSE
        BEGIN
            PRINT 'Student not found. No update performed.';
        END
    END TRY
    BEGIN CATCH
      
        PRINT 'An error occurred while updating the student information. Error: ' + ERROR_MESSAGE();
    END CATCH
END;

GO


