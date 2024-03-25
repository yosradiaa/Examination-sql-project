create or Alter trigger InsertTriggerMessageCourse
on Course
after insert 
as 
	select 'Added Done'

GO

create trigger InsertTriggerMessageInstructor
on Instructor
after insert 
as 
	select 'Added Done'

GO

--Trigger To prevent drop any table from system

CREATE OR ALTER Trigger PreventDropTable_TRIGGER
ON DATABASE FOR DROP_TABLE
AS

SELECT
 EventType = EVENTDATA().value('(EVENT_INSTANCE/EventType)[1]', 'sysname'),
 PostTime = EVENTDATA().value('(EVENT_INSTANCE/PostTime)[1]', 'datetime'),
 LoginName = EVENTDATA().value('(EVENT_INSTANCE/LoginName)[1]', 'sysname'),
 UserName = EVENTDATA().value('(EVENT_INSTANCE/UserName)[1]', 'sysname'),
 DatabaseName = EVENTDATA().value('(EVENT_INSTANCE/DatabaseName)[1]', 'sysname'),
 SchemaName = EVENTDATA().value('(EVENT_INSTANCE/SchemaName)[1]', 'sysname'),
 ObjectName = EVENTDATA().value('(EVENT_INSTANCE/ObjectName)[1]', 'sysname'),
 ObjectType = EVENTDATA().value('(EVENT_INSTANCE/ObjectType)[1]', 'sysname'),
 CommandText = EVENTDATA().value('(EVENT_INSTANCE//TSQLCommand[1]/CommandText)[1]', 'nvarchar(max)')

RAISERROR ('You can not drop table in this database', 10, 1);
ROLLBACK;

--DROP TABLE [dbo].[Branch]

GO
--Prevent Student to update if has relation with courses
CREATE OR ALTER TRIGGER PreventStudentUpdate_TRIGGER
ON Student
INSTEAD OF UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT *
        FROM inserted i
        INNER JOIN HRStudent_Course sc ON i.Std_id = sc.Student_id
    )
    BEGIN
        RAISERROR ('Cannot update Student Becouse have Relationship with courses', 16, 1);
    END
    ELSE
    BEGIN
        UPDATE s
        SET s.Std_name = i.Std_name, s.Std_age = i.Std_age, s.Std_address = i.Std_address, s.Intake_id = i.Intake_id , s.Class_id = i.Class_id
        FROM Student s
        INNER JOIN inserted i ON s.Std_id = i.Std_id;
    END
END;

--update Student 
--set Std_name = 'omar' , Std_age = 22 , Std_address = 'sharqia' , Std_phone = '01004325257' , Intake_id = 1 , Class_id = 1
--where Std_id = 5
