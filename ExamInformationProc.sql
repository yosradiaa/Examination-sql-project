CREATE OR ALTER PROCEDURE GetAllExams
AS
BEGIN
    SELECT *
    FROM HRExam
END

Go


--Get Exams for Course by id
CREATE OR ALTER PROCEDURE GetExamsByCourse
    @Course_id INT
AS
BEGIN
    SELECT *
    FROM Exam
    WHERE Course_id = @Course_id
END

Go

--Get Exams by date
CREATE OR ALTER PROCEDURE GetExamsByDate
    @Exam_date Date
AS
BEGIN
    SELECT *
    FROM Exam
    WHERE DAY(Exam_date) = DAY(@Exam_date)
END
--GetExamsByDate '2024-1-20'

Go
--Get Exams from Range
CREATE OR ALTER PROCEDURE GetExamsByDateRange
    @Exam_start TIME,
    @Exam_end TIME
AS
BEGIN
    SELECT *
    FROM Exam
    WHERE Exam_start BETWEEN @Exam_start AND @Exam_end
END
Go 
--GetExamsByDateRange '08:00:00' , '09:00:00'



