
--indexes -- to manage search by name

--index on student name 
create nonclustered index Student_name_index 
on Student(std_name)

--index on track name 
create nonclustered index Track_name_index 
on Track(track_name)

--index on course name 
create nonclustered index Course_name_index 
on Course(crs_name) 

--index on instructor name 
create nonclustered index Instructor_name_index 
on Instructor(ins_name) 

--index on intake name 
create nonclustered index Intake_name_index 
on Intake(int_name) 

--index on class name 
create nonclustered index Class_name_index 
on Class(class_name) 

