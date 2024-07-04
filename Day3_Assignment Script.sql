create schema day3assignment;

-- Create Students table
CREATE TABLE
    Students (
        student_id INT PRIMARY KEY,
        student_name VARCHAR(100),
        student_major VARCHAR(100)
    );

-- Create Courses table
CREATE TABLE
    Courses (
        course_id INT PRIMARY KEY,
        course_name VARCHAR(100),
        course_description VARCHAR(255)
    );

-- Create Enrollments table
CREATE TABLE
    Enrollments (
        enrollment_id INT PRIMARY KEY,
        student_id INT,
        course_id INT,
        enrollment_date DATE,
        FOREIGN KEY (student_id) REFERENCES Students (student_id),
        FOREIGN KEY (course_id) REFERENCES Courses (course_id)
    );

-- Insert data into Students table
INSERT INTO
    Students (student_id, student_name, student_major)
VALUES
    (1, 'Alice', 'Computer Science'),
    (2, 'Bob', 'Biology'),
    (3, 'Charlie', 'History'),
    (4, 'Diana', 'Mathematics');

-- Insert data into Courses table
INSERT INTO
    Courses (course_id, course_name, course_description)
VALUES
    (
        101,
        'Introduction to CS',
        'Basics of Computer Science'
    ),
    (102, 'Biology Basics', 'Fundamentals of Biology'),
    (
        103,
        'World History',
        'Historical events and cultures'
    ),
    (104, 'Calculus I', 'Introduction to Calculus'),
    (105, 'Data Structures', 'Advanced topics in CS');

-- Insert data into Enrollments table
INSERT INTO
    Enrollments (
        enrollment_id,
        student_id,
        course_id,
        enrollment_date
    )
VALUES
    (1, 1, 101, '2023-01-15'),
    (2, 2, 102, '2023-01-20'),
    (3, 3, 103, '2023-02-01'),
    (4, 1, 105, '2023-02-05'),
    (5, 4, 104, '2023-02-10'),
    (6, 2, 101, '2023-02-12'),
    (7, 3, 105, '2023-02-15'),
    (8, 4, 101, '2023-02-20'),
    (9, 1, 104, '2023-03-01'),
    (10, 2, 104, '2023-03-05');

-- Questions and Solution
-- Join
--  Retrieve the list of students and their enrolled courses (Inner Join)
select
    s.*,
    c.course_name
from
    students s
    join enrollments e on s.student_id = e.student_id
    join courses c on e.course_id = c.course_id;

-- List all students and their enrolled courses, including those who haven't enrolled in any course (Left Join)
select
    s.*,
    c.*
from
    students s
    left join enrollments e ON s.student_id = e.student_id
    left join courses c ON e.course_id = c.course_id;

-- Display all courses and the students enrolled in each course, including courses with no enrolled students (Right Join)
select
    c.course_name,
    s.*
from
    students s
    right join enrollments e ON s.student_id = e.student_id
    right join courses c ON e.course_id = c.course_id;

-- Find pairs of students who are enrolled in at least one common course (Self Join)
select distinct
    (
        (
            select
                student_name
            from
                students
            where
                student_id = e.student_id
        ),
        (
            select
                student_name
            from
                students
            where
                student_id = e2.student_id
        )
    )
from
    enrollments e
    join enrollments e2 on e.student_id <> e2.student_id;

-- Retrieve students who are enrolled in 'Introduction to CS' but not in 'Data Structures' (Complex Join)
select
    s.student_name
from
    students s
    join enrollments e on s.student_id = e.student_id
    join courses c on e.course_id = c.course_id
    and c.course_name = 'Introduction to CS'
where
    s.student_id not in (
        select
            s2.student_id
        from
            students s2
            join enrollments e2 ON s.student_id = e2.student_id
            join courses c2 ON e2.course_id = c2.course_id
            and c2.course_name = 'Data Structures'
    );

-- Window Function
-- List all students along with a row number based on their enrollment date in ascending order (ROW_NUMBER())
select
    (
        select
            student_name
        from
            students
        where
            student_id = e.student_id
    ),
    row_number() over (
        order by
            e.enrollment_date asc
    ) as row_num
from
    enrollments e;

-- Rank students based on the number of courses they are enrolled in, handling ties by assigning the same rank (RANK())
select
    student_name,
    rank() over (
        order by
            courseCount desc
    ) as rank
from
    (
        select
            s.student_name,
            count(e.course_id) as courseCount
        from
            students s
            join enrollments e on s.student_id = e.student_id
        group by
            s.student_name
    ) as studentCourseCount;

-- Determine the dense rank of courses based on their enrollment count across all students (DENSE_RANK())
select
    course_name,
    dense_rank() over (
        order by
            enrollmentCount desc
    ) as denseRank
from
    (
        select
            c.course_name,
            count(e.student_id) as enrollmentCount
        from
            courses c
            join enrollments e on c.course_id = e.course_id
        group by
            c.course_name
    ) as courseEnrollmentCount;