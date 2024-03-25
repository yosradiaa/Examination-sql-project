--Select Questions for Exam Manualy
Go
create or alter proc SelectQuestionsManualForExam 
	@Exam_id int,
	@Question_Selected_Id int,
	@Degree int 
as
begin
	IF Not Exists(select Exam_id from HRExam where Exam_id = @Exam_id) or 
		Not Exists(select Question_id from HRQuestions where Question_id = @Question_Selected_Id)
		BEGIN 
			SELECT 'Something is wrong Exam or Question that you selected may be not found try again' , ERROR_LINE() , ERROR_MESSAGE()
			RETURN
		END

	declare @course_id int;
	declare @crs_maxDegree int;

	select @course_id = Course_id from HRExam where Exam_id = @Exam_id;
	select @crs_maxDegree = Crs_maxDegree from HRCousres where Crs_id = @course_id;

	declare @questions_course table(Question_id int);

	insert into @questions_course
	select Question_id from  dbo.getQuestionsForSpecificCourse(@course_id)

	IF NOT EXISTS (select * from @questions_course where Question_id = @Question_Selected_Id)
		BEGIN
			SELECT 'This Question Not Belong to Course of Exam' , ERROR_LINE() , ERROR_MESSAGE()
			RETURN
		END
	ELSE 
		BEGIN 
		--check if Degree of Questions More than Degree of Exam
		Declare @totalDegree int;
		select @totalDegree = sum(Degree) from HR_Exam_Questions where Exam_Id = @Exam_id
		set @totalDegree = @totalDegree + @Degree;
			IF @totalDegree > @crs_maxDegree 
				BEGIN
					select CONCAT('Sum of Questions Degree more than Exam Degree ' , @totalDegree , ' Max is ' , @crs_maxDegree )
					return
				END
			Else
				BEGIN
					BEGIN TRY
						Insert into HR_Exam_Questions
						values(@Exam_id , @Question_Selected_Id , @Degree);
						select 'Question Added to Exam'
					END TRY
					BEGIN CATCH
						select 'Something is wrong' , ERROR_LINE() , ERROR_MESSAGE();
					END CATCH

				END
		END
end

--SelectQuestionsManualForExam 1023 , 6 , 10
Go


--Select Questions Random For Exam
create or alter proc SelectQuestionsRandomForExam 
	@Exam_id int,
	@Number_Of_Question int
as
begin
	IF Not Exists(select Exam_id from HRExam where Exam_id = @Exam_id)
		BEGIN 
			SELECT 'Something is wrong Exam that you selected may be not found try again' , ERROR_LINE() , ERROR_MESSAGE()
			RETURN
		END

	declare @course_id int;
	declare @crs_maxDegree int;

	select @course_id = Course_id from HRExam where Exam_id = @Exam_id;
	select @crs_maxDegree = Crs_maxDegree from HRCousres where Crs_id = @course_id;

	declare @questions_course table(Question_id int);
	insert into @questions_course
	select top(@Number_Of_Question) Question_id from  dbo.getQuestionsForSpecificCourse(@course_id) order by NEWID()

	Declare @Number_Of_Questions_After_Randomizing int;
	Declare @Degree_Each_Question int;

	select @Number_Of_Questions_After_Randomizing = Count(Question_id) from @questions_course;
	set @Degree_Each_Question = @crs_maxDegree / @Number_Of_Questions_After_Randomizing;

	Declare @Question_id_row int;

	Declare RandomCursor CURSOR 
	for select Question_id from @questions_course;
	
	OPEN RandomCursor;
	FETCH RandomCursor INTO @Question_id_row;

	WHILE @@FETCH_STATUS = 0
	BEGIN
		BEGIN TRY
			Insert into HR_Exam_Questions
			values(@Exam_id , @Question_id_row , @Degree_Each_Question);
			select 'Question Added to Exam'
			FETCH RandomCursor INTO @Question_id_row;
		END TRY
		BEGIN CATCH
			select 'Something is wrong' , ERROR_LINE() , ERROR_MESSAGE();
		END CATCH
	END
end

--SelectQuestionsRandomForExam 1022 , 5
Go
--update Exam Questions 
create or alter proc UpdateQuestionsForExam 
	@Exam_id int,
	@Question_Old_id int,
	@Question_New_id int,
	@Degree int 
as
begin
	IF Not Exists(select Exam_id from HRExam where Exam_id = @Exam_id) or 
		Not Exists(select @Question_Old_id from HRQuestions where Question_id = @Question_Old_id) or
		Not Exists(select @Question_New_id from HRQuestions where Question_id = @Question_New_id)
		BEGIN 
			SELECT 'Something is wrong Exam or Questions that you selected may be not found try again' , ERROR_LINE() , ERROR_MESSAGE()
			RETURN
		END
	ELSE IF NOT EXISTS(select * from HR_Exam_Questions where Exam_Id = @Exam_id and Question_id = @Question_Old_id)
		BEGIN 
			SELECT 'Exam Not Have This Question to update it' , ERROR_LINE() , ERROR_MESSAGE()
			RETURN
		END
	declare @course_id int;
	declare @crs_maxDegree int;

	select @course_id = Course_id from HRExam where Exam_id = @Exam_id;
	select @crs_maxDegree = Crs_maxDegree from HRCousres where Crs_id = @course_id;

	declare @questions_course table(Question_id int);

	insert into @questions_course
	select Question_id from  dbo.getQuestionsForSpecificCourse(@course_id)

	IF NOT EXISTS (select * from @questions_course where Question_id = @Question_New_id)
		BEGIN
			SELECT 'This Question Not Belong to Course of Exam' , ERROR_LINE() , ERROR_MESSAGE()
			RETURN
		END
	ELSE 
		BEGIN 
		--check if Degree of Questions More than Degree of Exam
		Declare @totalDegree int;
		select @totalDegree = sum(Degree) from HR_Exam_Questions where Exam_Id = @Exam_id

		Declare @UpdatedDegree int;
		select @UpdatedDegree = Degree from HR_Exam_Questions where Exam_Id = @Exam_id and Question_Id = @Question_New_id;
		set @totalDegree = @totalDegree - @UpdatedDegree + @Degree;
			IF @totalDegree > @crs_maxDegree 
				BEGIN
					select CONCAT('Sum of Questions Degree more than Exam Degree ' , @totalDegree , ' Max is ' , @crs_maxDegree )
					return
				END
			Else
				BEGIN
					BEGIN TRY
						Update HR_Exam_Questions
						set Question_Id = @Question_New_id , Degree = @Degree
						where Question_Id = @Question_Old_id and Exam_Id = @Exam_id;
						select 'Question Updated to Exam'
					END TRY
					BEGIN CATCH
						select 'Something is wrong' , ERROR_LINE() , ERROR_MESSAGE();
					END CATCH

				END
		END
end
--UpdateQuestionsForExam 1022 , 10 , 8 , 10
Go
--Delete all Question from Exam 
create or alter proc DeleteAllQuestionFromExam 
	@Exam_id int
as
begin
	IF Not Exists(select Exam_id from HRExam where Exam_id = @Exam_id) 
		BEGIN 
			SELECT 'Something is wrong Exam that you selected may be not found try again' , ERROR_LINE() , ERROR_MESSAGE()
			RETURN
		END
	ELSE IF NOT EXISTS(select * from HR_Exam_Questions where Exam_Id = @Exam_id)
		BEGIN 
			SELECT 'Exam Not Have Any Questions to update it' , ERROR_LINE() , ERROR_MESSAGE()
			RETURN
		END
	ELSE
		BEGIN 
			BEGIN TRY
				DELETE FROM HR_Exam_Questions 
				WHERE Exam_Id = @Exam_id;
				SELECT 'All Answer are Removed'
			END TRY
			BEGIN CATCH
				SELECT 'Something is Wrong' , ERROR_LINE() , ERROR_MESSAGE()
			END CATCH
		END
end
--DeleteAllQuestionFromExam 1022
Go