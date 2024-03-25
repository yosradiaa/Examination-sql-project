--Functions

--Function get Questions for specific course by course_id
create or alter function getQuestionsForSpecificCourse(@Course_id int) 
returns table 
as 
return 
(
	select *
	from Question 
	where Course_id = @Course_id
)

--select * from dbo.getQuestionsForSpecificCourse(1)



