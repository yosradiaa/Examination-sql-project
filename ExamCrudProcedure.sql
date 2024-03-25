--Exam Crud Procedure

--Get Details of Exam by Exam_id
CREATE OR ALTER PROCEDURE GetDetailsForExam @Exam_id INT
AS
BEGIN
	if exists(SELECT Exam_id from Exam where Exam_id = @Exam_id)
	begin
		SELECT *
		FROM Exam
		WHERE Exam_id = @Exam_Id
	end
	else
		begin
			select 'This exam not found must try again by another Exam_id' , ERROR_LINE() , ERROR_MESSAGE()
		end
END

-- GetDetailsForExam 1
GO

--Exam Create by Instructor
CREATE OR ALTER PROCEDURE CreateExamProc
    @Exam_start TIME,
    @Exam_end TIME,
    @Exam_date DATE,
    @Exam_type NVARCHAR(50),
    @Course_id INT,
    @Instructor_id INT,
	@Intake_id INT
AS
BEGIN	
	IF Not Exists(select Crs_id from HRCousres where Crs_id = @Course_id) or 
		Not Exists(select Ins_id from HRInstructoe where Ins_Id = @Instructor_id) or
		Not Exists(select Int_id from HRIntake where Int_Id = @Intake_id) 
		BEGIN 
			SELECT 'Something is wrong Course or Instructor or Intake may be not found try again' , ERROR_LINE() , ERROR_MESSAGE()
			RETURN
		END
	ELSE IF NOT EXISTS(SELECT i.Ins_id from HRInstructoe i inner join HR_Class_Course_Instructor cci on i.Ins_Id = cci.Instractor_id and cci.Instractor_id = @Instructor_id inner join HRCousres c ON cci.Course_id = c.Crs_id and cci.Course_id = @Course_id)
	BEGIN 
		SELECT 'This Instructor not belong to this Course' , ERROR_LINE() , ERROR_MESSAGE()
		RETURN
	END
	ELSE IF EXISTS(SELECT * from HRExam where Instructor_id = @Instructor_id and Course_id = @Course_id and Intake_id = @Intake_id and Exam_date = @Exam_date)
	BEGIN 
		SELECT 'This Exam is already existed' , ERROR_LINE() , ERROR_MESSAGE()
		RETURN
	END
	ELSE 
		BEGIN
				begin try
					insert into HRExam
						values( 
								convert(TIME ,  @Exam_start), --convert from varchar to Time
								convert(TIME ,  @Exam_end), --convert from varchar to Time
								convert(DATE ,  @Exam_date), --convert from varchar to Date
								@Exam_type,
								@Course_id,
								@Instructor_id,
								@Intake_id
					
								)
				end try
				begin catch
					select 'Something is wrong Try enter another data' , ERROR_LINE() , ERROR_MESSAGE()
				end catch
		END
END

--CreateExamProc '10:00:00.0000000' , '11:00:00.0000000', '2024-01-18', 'Corrective' , 1 , 1 , 1

Go

--Exam Update by Exam_id
CREATE OR ALTER PROCEDURE UpdateExamProc
    @Exam_Id INT,
    @Exam_start TIME,
    @Exam_end TIME,
    @Exam_date DATE,
    @Exam_type NVARCHAR(50),
    @Course_id INT,
    @Instructor_id INT,
	@Intake_id INT
AS
BEGIN
	IF Not Exists(select Crs_id from HRCousres where Crs_id = @Course_id) or 
		Not Exists(select Ins_id from HRInstructoe where Ins_Id = @Instructor_id) or
		Not Exists(select Int_id from HRIntake where Int_Id = @Intake_id) 
		BEGIN 
			SELECT 'Something is wrong Course or Instructor or Intake may be not found try again' , ERROR_LINE() , ERROR_MESSAGE()
			RETURN
		END
	ELSE IF NOT EXISTS(SELECT i.Ins_id from HRInstructoe i inner join HR_Class_Course_Instructor cci on i.Ins_Id = cci.Instractor_id and cci.Instractor_id = @Instructor_id inner join HRCousres c ON cci.Course_id = c.Crs_id and cci.Course_id = @Course_id)
	BEGIN 
		SELECT 'This Instructor not belong to this Course' , ERROR_LINE() , ERROR_MESSAGE()
		RETURN
	END
	ELSE IF Not EXISTS(SELECT * from HRExam where Instructor_id = @Instructor_id and Course_id = @Course_id and Intake_id = @Intake_id and Exam_date = @Exam_date)
	BEGIN 
		SELECT 'This Exam is not existed' , ERROR_LINE() , ERROR_MESSAGE()
		RETURN
	END
	ELSE
	BEGIN
			begin try
				--check if exam already exists to do your operations
				if Exists(select Exam_id from HRExam where Exam_id = @Exam_Id)
					begin
						UPDATE HRExam
						SET Exam_start =  convert(TIME ,  @Exam_start), --convert from varchar to Time
							Exam_end = convert(TIME ,  @Exam_end), --convert from varchar to Time
							Exam_date = convert(DATE ,  @Exam_date), --convert from varchar to Date
							Exam_type = @Exam_type,
							Course_id = @Course_id,
							Instructor_id = @Instructor_id,
							Intake_id = @Intake_id
						WHERE Exam_id = @Exam_Id
					end
				else
					begin
						select 'This exam not found must try again by another Exam_id' , ERROR_LINE() , ERROR_MESSAGE()
					end
			end try
			begin catch
				select 'Something is wrong Try enter another data' , ERROR_LINE() , ERROR_MESSAGE()
			end catch
	END

END

--UpdateExamProc 1016 , '11:00:00.0000000' , '12:00:00.0000000', '2024-01-25', 'Corrective' , 3 , 10 , 1

Go


--Exam Delete by Exam_id
CREATE OR ALTER PROCEDURE DeleteExamProc
    @Exam_id INT
AS
BEGIN
	if Exists(Select Exam_id from Exam where Exam_id = @Exam_id)
		begin 
			DELETE FROM HRExam
			WHERE Exam_id = @Exam_id
		end
	else
	begin
		select 'This exam not found must try again by another Exam_id' , ERROR_LINE() , ERROR_MESSAGE()
	end

END
--DeleteExamProc 2
Go
