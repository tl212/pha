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