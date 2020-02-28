-- creating tables for PH-EmployeeDB

CREATE TABLE departments (
	dept_no VARCHAR(4) NOT NULL, 
	dept_name VARCHAR(40) NOT NULL, 
		FOREIGN KEY (dept_no) REFERENCES dept_emp (dept_no), 
		PRIMARY KEY (dept_no), 
		UNIQUE (dept_name)
);

CREATE TABLE dept_emp (
	dept_no VARCHAR(4) NOT NULL,
	emp_no INT NOT NULL, 
	from_date DATE NOT NULL, 
	to_date DATE NOT NULL,
		FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
		PRIMARY KEY (dept_no)
);

CREATE TABLE dept_manager (
	dept_no VARCHAR(4) NOT NULL,
	emp_no INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL, 
		FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
		FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
		PRIMARY KEY (dept_no)
);

CREATE TABLE employees (
	emp_no INT NOT NULL,
	birth_day DATE NOT NULL,
	first_name VARCHAR NOT NULL,
	last_name VARCHAR NOT NULL,
	gender VARCHAR NOT NULL,
	hire_date DATE NOT NULL, 
		-- FOREIGN KEY (emp_no) REFERENCES dept_emp (emp_no),
		PRIMARY KEY (emp_no)
);

CREATE TABLE salaries (
	emp_no INT NOT NULL, 
	salary INT NOT NULL, 
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
		FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
		PRIMARY KEY (emp_no)
);

CREATE TABLE titles (
	emp_no INT NOT NULL,
	title VARCHAR NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
		FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
		PRIMARY KEY (emp_no)
);


-- 02/20/2020

SELECT first_name, last_name
FROM employees
WHERE (birth_day BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- query and save into a table

SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_day BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT * FROM retirement_info;

-- update from 02/27/20

SELECT * FROM employees;

SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_day BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988--12-31');

SELECT * FROM retirement_info;

SELECT retirement_info.emp_no, retirement_info.first_name, retirement_info.last_name, dept_emp.dept_no
FROM retirement_info
LEFT OUTER JOIN dept_emp
ON retirement_info.emp_no = dept_emp.emp_no;

SELECT departments.dept_name, dept_manager.emp_no, dept_manager.from_date, dept_manager.to_date
FROM departments 
INNER JOIN dept_manager
ON departments.dept_no = dept_manager.dept_no;

SELECT retirement_info.emp_no, 
	   retirement_info.first_name, 
	   retirement_info.last_name, 
	   dept_emp.to_date
FROM retirement_info
LEFT OUTER JOIN dept_emp
ON retirement_info.emp_no = dept_emp.emp_no;

SELECT ri.emp_no, 
	   ri.first_name, 
	   ri.last_name, 
	   de.to_date
FROM retirement_info AS ri 
LEFT JOIN dept_emp AS de 
ON ri.emp_no = de.emp_no;

SELECT d.dept_name, 
	   dm.emp_no, 
	   dm.from_date,
	   dm.to_date
FROM departments AS d
INNER JOIN dept_manager AS dm
ON d.dept_no = dm.dept_no;

SELECT ri.emp_no, 
	   ri.first_name, 
	   ri.last_name, 
	   de.to_date
INTO current_emp
FROM retirement_info AS ri 
LEFT JOIN dept_emp AS de 
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');

-- employee count by department number 
SELECT COUNT(ce.emp_no), de.dept_no
FROM current_emp AS ce 
LEFT JOIN dept_emp AS de 
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no;

-- employee count by department number and order by department number (increase order)
SELECT COUNT(ce.emp_no), de.dept_no
FROM current_emp AS ce 
LEFT JOIN dept_emp AS de 
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

-- creating a table w/ counts of current employees groping by dept # and ordering by (descending order)
-- dept # 
SELECT COUNT(ce.emp_no), 
		     de.dept_no
INTO currentEmployee_countBy_deptNumber
FROM current_emp AS ce 
LEFT JOIN dept_emp AS de 
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

-- We want to know what the most recent date on this list is, 
-- so let’s sort that column in descending order.
SELECT * FROM salaries
ORDER BY to_date DESC;

-- Description here..
SELECT emp_no,
	   first_name, 
	   last_name, 
	   gender
INTO emp_info 
FROM employees
WHERE (birth_day BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- creating emp_info table 
-- Employee Information: A list of employees containing their unique employee number, 
-- their last name, first name, gender, and salary.
SELECT e.emp_no,
	   e.first_name, 
	   e.last_name, 
	   e.gender,
	   s.salary, 
	   de.to_date
INTO emp_info
FROM employees AS e 
INNER JOIN salaries AS s
ON (e.emp_no = s.emp_no)
INNER JOIN dept_emp AS de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_day BETWEEN '1952-01-01' AND '1955-12-31')
AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
AND (de.to_date = '9999-01-01');

-- check final created table
SELECT * FROM emp_info;

-- create management table 
-- Management: A list of managers for each department, including the department number, 
-- name, and the manager’s employee number, last name, first name, 
-- and the starting and ending employment dates.
SELECT dm.dept_no,
 	   d.dept_name, 
	   dm.emp_no,
	   ce.last_name,
	   ce.first_name,
	   dm.from_date,
	   dm.to_date
INTO manager_info
FROM dept_manager AS dm
	INNER JOIN departments AS d
		ON (dm.dept_no = d.dept_no)
	INNER JOIN current_emp AS ce
		ON (dm.emp_no = ce.emp_no);
		
-- check final created table
SELECT * FROM manager_info;

-- create dept retirees table
-- Department Retirees: An updated current_emp list that includes everything it currently has, 
-- but also the employee’s departments.
SELECT ce.emp_no,
	   ce.first_name,
	   ce.last_name, 
	   d.dept_name
INTO dept_info
FROM current_emp AS ce
	INNER JOIN dept_emp AS de
		ON (ce.emp_no = de.emp_no)
	INNER JOIN departments AS d
		ON (de.dept_no = d.dept_no);

SELECT * FROM dept_info;
