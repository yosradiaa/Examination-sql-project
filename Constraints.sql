

--Constraints

--Branch
	alter table Branch add constraint Branch_unique_phone unique(Branch_phone)

--Departments
	alter table Department add constraint Department_unique_phone unique(dept_phone)
--Tracks
	alter table Track add constraint Track_Department_FK foreign key(dept_ID) references Department(dept_id)
--Intake
	alter table Intake add constraint Intake_Branch_FK foreign key(Branch_id) references Branch(Branch_id)
--Class
	alter table Class add constraint Class_Branch_FK foreign key(Branch_id) references Branch(Branch_id)
	alter table Class add constraint Class_Track_FK foreign key(Track_id) references Track(Track_id)
	alter table Class add constraint Class_Department_FK foreign key(Dept_id) references Department(Dept_id)
	alter table class add constraint Class_unique unique(Branch_id , Dept_id , Track_id)
--Student
	alter table Student add constraint Student_unique_phone unique(Std_Phone)
	alter table Student add constraint Student_check_age check(Std_Age between 10 and 100)
	alter table Student add constraint Student_Class_FK foreign key(Class_id) references Class(Class_id)
	alter table Student add constraint Student_Intake_FK foreign key(Intake_id) references Intake(Int_id)
--Courses
	alter table Course add constraint Course_check_minDegree check(Crs_minDegree between 0 and 50)
	alter table Course add constraint Course_check_maxDegree check(Crs_maxDegree between 10 and 100)
--Questions
	alter table Question add constraint Question_Course_FK foreign key(Course_id) references Course(Crs_id)
	alter table Question add constraint Question_Instructor_FK foreign key(Instructor_id) references Instructor(Ins_id)
	alter table question add constraint Question_check_Type check(Type = 'MCQ' or type = 'BOOLEAN' or type = 'TEXT')
--Instructors
	alter table Instructor add constraint Instructor_check_age check(Ins_age between 30 and 60)
	alter table Instructor add constraint Instructor_unique_phone unique(Ins_Phone)

--Exams
	alter table Exam add constraint Exam_check_date check(Day(Convert(date , Exam_date)) >= Day(GETDATE()))
	alter table Exam add constraint Exam_check_start check(Exam_start != Exam_end and Exam_start < Exam_end)
	alter table Exam add constraint Exam_check_end check(Exam_end != Exam_start and Exam_end > Exam_start)
	alter table Exam add Total_time as DATEDIFF(MINUTE, Exam_start, Exam_end)
	alter table Exam add constraint Exam_unique unique(Exam_date , Exam_start , course_id , intake_id)
	alter table Exam add constraint Exam_course_FK foreign key(course_id) references Course(Crs_id)
	alter table Exam add constraint Exam_Instructor_FK foreign key(Instructor_id) references Instructor(Ins_id)
	alter table Exam add constraint Exam_Intake_FK foreign key(Intake_id) references Intake(Int_id)

--Department_Branch
	alter table Department_Branch add constraint Department_Branch_Dept_FK foreign key(Dept_id) references Department(Dept_id)
	alter table Department_Branch add constraint Department_Branch_Branch_FK foreign key(Branch_id) references Branch(Branch_id)

--Track_Course
	alter table Track_Course add constraint Track_Course_Track_FK foreign key(Track_id) references Track(Track_id)
	alter table Track_Course add constraint Track_Course_Course_FK foreign key(Course_id) references Course(Crs_id)

--Class_Course_Instractor
	alter table Class_Course_Instractor add constraint Class_Course_Instractor_class_FK foreign key(Class_id) references Class(Class_id)
	alter table Class_Course_Instractor add constraint Class_Course_Instractor_Course_FK foreign key(Course_id) references Course(Crs_id)
	alter table Class_Course_Instractor add constraint Class_Course_Instractor_Instructor_FK foreign key(Course_id) references Instructor(Ins_id)
	alter table Class_Course_Instractor add constraint Class_Course_Instractor_unique unique(Class_id , Course_id , Year)

--Student_Course
	alter table Student_Course add constraint Student_Course_student_FK foreign key(Student_id) references Student(Std_id)
	alter table Student_Course add constraint Student_Course_Course_FK foreign key(Course_id) references Course(Crs_id)
--Exam_Questions
	alter table Exam_Questions add constraint Exam_Questions_Exam_FK foreign key(Exam_id) references Exam(Exam_id)
	alter table Exam_Questions add constraint Exam_Questions_Question_FK foreign key(Question_Id) references Question(Question_Id)
	alter table Exam_Questions add constraint Exam_Questions_check_degree check(Degree between 1 and 10)

--Exam_Questions_Student
	alter table Exam_Questions_Student add constraint Exam_Questions_Student_Std_FK foreign key(Student_id) references Student(Std_id)
	alter table Exam_Questions_Student add constraint Exam_Questions_Student_Exam_FK foreign key(Exam_id) references Exam(Exam_id)
	alter table Exam_Questions_Student add constraint Exam_Questions_Student_Quest_FK foreign key(Question_id) references Question(Question_id)
--Intake_Instructor
	alter table Intake_Instructor add constraint Intake_Instructor_Intake_FK foreign key(Intake_id) references Intake(Int_id)
	alter table Intake_Instructor add constraint Intake_Instructor_Ins_FK foreign key(Ins_id) references Instructor(Ins_id)

--Student_Exam
	alter table Student_Exam add constraint Student_Exam_Std_FK foreign key(Student_id) references Student(Std_id)
	alter table Student_Exam add constraint Student_Exam_Exam_FK foreign key(Exam_id) references Exam(Exam_id)
