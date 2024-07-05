-- Create Schema employeeRecords
create schema employeeRecords;

-- Create table Employees
create table
	Employees (
		first_name varchar(50),
		last_name varchar(50),
		sex varchar(1),
		DOJ date,
		curr_date date,
		designation varchar(50),
		age int,
		salary decimal(10, 2),
		department varchar(50),
		leaves_used int,
		leaves_remaining int,
		ratings int,
		past_exp int
	);


-- Copy the records from dataset.csv in the Employees table (command run in SQL Shell (psql))
-- \copy employeeRecords.employees
-- (first_name, last_name, sex, DOJ, curr_date, designation, age, salary, department, leaves_used, leaves_remaining, ratings, past_exp)
-- from '\LF-SE-Fellowship-2024-Database-Assignments\dataset.csv' WITH DELIMITER ',' CSV HEADER;

select * from Employees; -- Shows the Employees table


-- Qno.1 Calculate the average salary by department for all Analysts using CTEs.
with
	analyst_records as (
		select
			*
		from
			employees
		where
			designation = 'Analyst'
	),
	avg_analyst_salary_from_department as (
		select
			department,
			round(avg(salary), 2) as avg_salary
		from
			analyst_records
		group by
			department
	)
select
	*
from
	avg_analyst_salary_from_department;


-- Qno.2 List all employees who have used more than 10 leaves using CTEs.
with
	employees_leaves_used as (
		select
			first_name,
			last_name,
			leaves_used
		from
			employees
	),
	employees_having_leaves_used_gt_ten as (
		select
			*
		from
			employees_leaves_used
		where
			leaves_used > 10
	)
select
	*
from
	employees_having_leaves_used_gt_ten;


-- Qno.3 Create a view to show the details of all Senior Analysts using Views.
create view
	senior_analysts as
select
	*
from
	employees
where
	designation = 'Senior Analyst';


select
	*
from
	senior_analysts;


-- Qno.4 Create a materialized view to store the count of employees by department using Materialized Views.
create materialized view employees_by_department as
select
	department,
	count(first_name) as employees_count
from
	employees
group by
	department
order by
	employees_count desc;


select
	*
from
	employees_by_department;


-- Qno.6 Create a procedure to update an employee's salary by their first name and last name using Stored Procedures.
create
or replace procedure update_salary (f_name varchar, l_name varchar, new_salary int) language plpgsql as $$
begin

update employees
set
	salary = new_salary
where
	first_name = first_name
	and last_name = last_name;

commit;

end;

select first_name, last_name, salary from employees 
where first_name = 'TOMASA' and  last_name = 'ARMEN'; -- before calling update_salary procedure

call update_salary ('TOMASA', 'ARMEN', 50000); -- Call the update_salary procedure

select first_name, last_name, salary from employees 
where first_name = 'TOMASA' and  last_name = 'ARMEN'; -- after calling update_salary procedure


-- Qno.7 Create a procedure to calculate the total number of leaves used across all departments using Stored Procedures.
create
or replace procedure show_total_leaves_by_department () language plpgsql as $$
begin

drop table if exists 
total_leaves_by_department;

create table
	total_leaves_by_department (department varchar(50), total_leaves_used int);

insert into
	total_leaves_by_department (
		select
			department,
			sum(leaves_used) as total_leaves_used
		from
			employees
		group by
			department
		order by
			total_leaves_used desc
	);

commit;

end;$$;


call show_total_leaves_by_department(); -- Call the show_total_leaves procedure


select
	*
from
	total_leaves_by_department; -- Show the results of total_leaves table
