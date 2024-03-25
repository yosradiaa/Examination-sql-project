USE [Examination system]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[DeleteStudent]
    @id INT
AS
BEGIN
   

    BEGIN TRY
  
        IF EXISTS (SELECT 1 FROM Student WHERE Std_ID = @id)
        BEGIN
          
            DELETE FROM Student
            WHERE Std_ID = @id;

            SELECT 'Student deleted successfully.';
        END
        ELSE
        BEGIN
            SELECT 'Student not found. No deletion performed.';
        END
    END TRY
    BEGIN CATCH
        -- Handle errors if any
        SELECT 'An error occurred while deleting the student. Error: ' + ERROR_MESSAGE();
    END CATCH
END;

GO


[dbo].[DeleteStudent]  7

SELECT* FROM dbo.Student