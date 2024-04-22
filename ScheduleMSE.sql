drop database if exists schedulemse;
create database if not exists schedulemse;
use schedulemse;

-- TABLES --

drop table if exists admins;
create table admins (
	gtid varchar(9) not null,
    name varchar(100) not null,
    email varchar(100) not null, -- before GT SSO, should be GT email. after, maybe all before @
    password varchar(100) not null, -- maybe not needed with GT SSO
    primary key (gtid)
) engine=innodb;

insert into admins (gtid, name, email, password)
	values 
		('903673758', 'Jake Neighbors', 'jneighbors7@gatech.edu', 'password'),
        ('123456789', 'Mary Realff', 'mr37@gatech.edu', 'password');
    

-- Students Table
DROP TABLE IF EXISTS students;
CREATE TABLE students (
    id VARCHAR(100) NOT NULL,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    PRIMARY KEY (id)
) ENGINE=INNODB;

insert into students (id, name, email)
	values 
		('buzz1907', 'Buzz YellowJacket', 'buzz1907@gatech.edu'),
        ('gburdell', 'George Burdell', 'gburdell@gatech.edu'),
        ('ttower', 'Tech Tower', 'ttower@gatech.edu'),
        ('cklaus', 'Chris Klaus', 'cklaus@gatech.edu'),
        ('gwclough', 'Wayne Clough', 'gwclough@gatech.edu');

-- Courses Table
drop table if exists courses;
create table courses (
	id varchar(25) not null,
    semester varchar(25) not null,
    credit_hours int not null,
    capacity int not null,
    day varchar(25) not null,
    start_time time not null,
    end_time time not null,
    professors varchar(250) null,
    primary key (id)
) engine=innodb;

insert into courses (id, semester, credit_hours, capacity, day, start_time, end_time, professors)
	values 
		('mse1001', 'spring 2024', 3, 20, 'monday', '9:30', '10:20', 'Dr. Realff'),
        ('mse2001', 'spring 2024', 4, 30, 'tuesday', '9:30', '10:20', 'Dr. Realff'),
        ('phys2011', 'spring 2024', 3, 50, 'wednesday', '9:30', '10:45',  'Dr. Murray'),
        ('phys2012', 'spring 2024', 3, 50, 'wednesday', '11:00', '12:15',  'Dr. Murray'),
        ('engl1101', 'spring 2024', 4, 60, 'wednesday', '9:30', '10:20', 'N/A'),
        ('engl1102', 'spring 2024', 4, 60, 'wednesday', '11:00', '11:50', 'N/A'),
        ('hts2012', 'spring 2024', 3, 80, 'wednesday', '9:30', '10:20', 'N/A'),
        ('math1554', 'spring 2024', 3, 25, 'thursday', '9:30', '10:20', 'Dr. Barone'),
        ('mse4400', 'spring 2024', 2, 35, 'friday', '9:30', '10:20', 'Dr. Realff');

drop table if exists plans;
create table plans (
	id int not null auto_increment,
	student_id varchar(100) not null,
    expected_graduation varchar(25) not null,
    date_submitted date not null,
    semester varchar(25) not null,
    credit_hours int not null,
    course1 varchar(25) null,
    course2 varchar(25) null,
    course3 varchar(25) null,
    course4 varchar(25) null,
    course5 varchar(25) null,
    course6 varchar(25) null,
    course7 varchar(25) null,
    course8 varchar(25) null,
    primary key (id, date_submitted, semester),
    foreign key (course1) references courses(id),
    foreign key (course2) references courses(id),
    foreign key (course3) references courses(id),
    foreign key (course4) references courses(id),
    foreign key (course5) references courses(id),
    foreign key (course6) references courses(id),
    foreign key (course7) references courses(id),
    foreign key (course8) references courses(id)
) engine=innodb;

insert into plans (student_id, expected_graduation, date_submitted, semester, credit_hours,
course1, course2, course3, course4, course5, course6, course7, course8)
	values 
		('buzz1907', 'spring 2025', '2023-10-02', 'fall 2023', 15,
        'mse1001', 'phys2011', 'engl1101', 'hts2012', 'math1554', null, null, null),
        ('buzz1907', 'spring 2025', '2023-10-02', 'spring 2024', 13,
        'mse1001', 'phys2011', 'hts2012', 'math1554', null, null, null, null),
        ('buzz1907', 'spring 2025', '2023-11-02', 'spring 2024', 11,
        'mse1001', 'mse2001', 'engl1102', 'phys2012', null, null, null, null),
        ('buzz1907', 'spring 2025', '2023-11-02', 'fall 2024', 14,
        'mse4400', 'math1554', 'hts2012', 'phys2012', 'engl1102', null, null, null),
        
        ('gburdell', 'spring 2025', '2023-10-02', 'fall 2023', 13,
        'mse2001', 'phys2011', 'engl1101', 'math1554', null, null, null, null),
        ('gburdell', 'spring 2025', '2023-10-02', 'spring 2024', 12,
        'mse1001', 'phys2012', 'engl1102', 'math1554', null, null, null, null),
        ('gburdell', 'spring 2025', '2023-11-02', 'spring 2024', 18,
        'math1554', 'engl1102', 'mse4400', 'phys2012', 'mse2001', 'hts2012', null, null),
        ('gburdell', 'spring 2025', '2023-11-02', 'fall 2024', 12,
        'mse2001', 'hts2012', 'phys2011', 'math1554', null, null, null, null),
        
        ('cklaus', 'spring 2024', '2023-08-03', 'fall 2023', 14,
        'mse2001', 'phys2011', 'math1554', 'engl1101', null, null, null, null);
        
        
-- VIEWS --

-- Queries information to be displayed on the View Students page
-- Gets all students, their email, and the number of credit hours their plan in the current plan context
-- If there exists multiple plans in the current plan context, the most recent one is selected
drop view if exists view_students;
create view view_students as
SELECT name, email, credit_hours 
FROM students INNER JOIN plans 
ON students.id = plans.student_id
WHERE semester LIKE '%spring 2024%'
AND date_submitted IN
	(SELECT MAX(date_submitted)
    FROM students INNER JOIN plans 
	ON students.id = plans.student_id
    WHERE semester LIKE '%spring 2024%'
    GROUP BY plans.student_id
    );
    
-- Queries information to be displayed on the View Courses page
-- Gets all courses, their number of credit hours, and the number of students who plan on taking it in the current plan context
drop view if exists view_courses;
create view view_courses as
SELECT id, credit_hours, 
	(SELECT COUNT(*)
    FROM plans
    WHERE (course1=courses.id
    OR course2=courses.id
    OR course3=courses.id
    OR course4=courses.id
    OR course5=courses.id
    OR course6=courses.id
    OR course7=courses.id
    OR course8=courses.id)
    AND semester LIKE '%spring 2024%'
    AND plans.id IN
		(SELECT MAX(id)
        FROM plans
        GROUP BY student_id, semester
        HAVING MAX(date_submitted)
        )
    ) AS num_students,
capacity
FROM courses
WHERE semester LIKE '%spring 2024%';

-- -- View Courses
-- DROP VIEW IF EXISTS view_courses;
-- CREATE VIEW view_courses AS
-- SELECT id, credit_hours, 
--     (SELECT COUNT(*)
--      FROM plans
--      WHERE (course1=courses.id
--             OR course2=courses.id
--             OR course3=courses.id
--             OR course4=courses.id
--             OR course5=courses.id
--             OR course6
		