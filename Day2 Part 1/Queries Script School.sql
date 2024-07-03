create schema school;

-- Create Grades table
create table
    Grades (grade_id int primary key, grade_name varchar(10));

-- Create Courses table
create table
    Courses (
        course_id int primary key,
        course_name varchar(50)
    );

-- Create Students table
create table
    Students (
        student_id int primary key,
        student_name varchar(50),
        student_age int,
        student_grade_id int,
        foreign key (student_grade_id) references Grades (grade_id)
    );

-- Create Enrollments table
create table
    Enrollments (
        enrollment_id int primary key,
        student_id int,
        course_id int,
        enrollment_date date,
        foreign key (student_id) references Students (student_id),
        foreign key (course_id) references Courses (course_id)
    );

-- Insert into Grades table
INSERT INTO
    Grades (grade_id, grade_name)
VALUES
    (1, 'A'),
    (2, 'B'),
    (3, 'C');

-- Insert into Courses table
INSERT INTO
    Courses (course_id, course_name)
VALUES
    (101, 'Math'),
    (102, 'Science'),
    (103, 'History');

-- Insert into Students table
INSERT INTO
    Students (
        student_id,
        student_name,
        student_age,
        student_grade_id
    )
VALUES
    (1, 'Alice', 17, 1),
    (2, 'Bob', 16, 2),
    (3, 'Charlie', 18, 1),
    (4, 'David', 16, 2),
    (5, 'Eve', 17, 1),
    (6, 'Frank', 18, 3),
    (7, 'Grace', 17, 2),
    (8, 'Henry', 16, 1),
    (9, 'Ivy', 18, 2),
    (10, 'Jack', 17, 3);

-- Insert into Enrollments table
INSERT INTO
    Enrollments (
        enrollment_id,
        student_id,
        course_id,
        enrollment_date
    )
VALUES
    (1, 1, 101, '2023-09-01'),
    (2, 1, 102, '2023-09-01'),
    (3, 2, 102, '2023-09-01'),
    (4, 3, 101, '2023-09-01'),
    (5, 3, 103, '2023-09-01'),
    (6, 4, 101, '2023-09-01'),
    (7, 4, 102, '2023-09-01'),
    (8, 5, 102, '2023-09-01'),
    (9, 6, 101, '2023-09-01'),
    (10, 7, 103, '2023-09-01');


-- Qno.1 solution
select
    *
from
    students
where
    student_id in (
        select
            student_id
        from
            enrollments
        where
            course_id = (
                select
                    course_id
                from
                    courses
                where
                    course_name = 'Math'
            )
    );


-- Qno.2 solution
select
    *
from
    courses
where
    course_id in (
        select
            course_id
        from
            enrollments
        where
            student_id = (
                select
                    student_id
                from
                    students
                where
                    student_name = 'Bob'
            )
    );


-- Qno.3 solution
select
    student_name
from
    students
where
    student_id in (
        select
            student_id
        from
            enrollments
        group by
            student_id
        having
            count(student_id) > 1
    );


-- Qno.4 solution
select
    s.student_name,
    (
        select
            grade_name
        from
            grades
        where
            s.student_grade_id = grade_id
    )
from
    students s
where
    student_grade_id = (
        select
            grade_id
        from
            grades
        where
            grade_name = 'A'
    );


-- Qno.5 solution
select
    c.course_name,
    (
        select
            count(e.student_id)
        from
            enrollments e
        where
            e.course_id = c.course_id
    ) as studentCount
from
    courses c;


-- Qno.6 solution
select
    c.course_id,
    c.course_name,
    (
        select
            count(e.student_id)
        from
            enrollments e
        where
            e.course_id = c.course_id
    ) as studentCount
from
    courses c
where
    (
        select
            count(e.student_id)
        from
            enrollments e
        where
            e.course_id = c.course_id
    ) = (
        select
            max(courseCount)
        from
            (
                select
                    count(*) as courseCount
                from
                    enrollments e,
                    courses c
                where
                    e.course_id = c.course_id
                group by
                    c.course_name
            ) as maxStudentCount
    );


-- Qno.7 solution
select
    s.student_name
from
    students s
where
    (
        select
            count(e.course_id)
        from
            enrollments e
        where
            s.student_id = e.student_id
    ) = (
        select
            count(*)
        from
            Courses
    );


-- Qno.8 solution
select
    student_name
from
    students
where
    student_id not in (
        select
            e.student_id
        from
            enrollments e
    );


-- Qno.9 solution
select
    c.course_name,
    (
        select
            avg(s.student_age) as avgStudentAge
        from
            students s
        where
            s.student_id in (
                select
                    e.student_id
                from
                    enrollments e
                where
                    e.course_id = (
                        select
                            c.course_id
                        from
                            courses c
                        where
                            c.course_name = 'Science'
                    )
            )
    )
from
    courses c
where
    c.course_name = 'Science';


-- Qno.10 solution
select
    s.student_name,
    (
        select
            grade_name
        from
            grades
        where
            grade_id = s.student_grade_id
    )
from
    students s
where
    s.student_id in (
        select
            e.student_id
        from
            enrollments e
        where
            e.course_id = (
                select
                    c.course_id
                from
                    courses c
                where
                    c.course_name = 'History'
            )
    );