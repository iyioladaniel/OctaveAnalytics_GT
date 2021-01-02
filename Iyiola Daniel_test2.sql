/*1.display the first name of all employees and the first name of their 
manager including those who does not work under any manager.*/
SELECT b.first_name manager, a.first_name employee
FROM employees a
	LEFT JOIN employees b ON a.employee_id = b.manager_id
ORDER BY b.manager_id;
    
/*2. display the first name, last name, and department number for those 
employees who works in the same department as the employee who holds the 
last name as Taylor.*/
SELECT first_name, last_name, department_id
FROM employees
WHERE department_id IN (SELECT department_id FROM employees 
						WHERE last_name LIKE '%Taylor%');

/*3. display the full name (first and last name ) of employees, job title 
and the salary differences to their own job for those employees who is working 
in the department ID 80.*/
SELECT	CONCAT(first_name,' ',last_name) AS full_name,
		j.job_title,
        (j.max_salary - e.salary) AS salary_difference
FROM employees e
	JOIN jobs j ON e.job_id = j.job_id
WHERE e.department_id = 80;

-- OR

SELECT	CONCAT(first_name,' ',last_name) AS full_name,
		j.job_title,
        (e.salary - (SELECT AVG(salary) FROM employees WHERE department_id=80)) AS salary_difference
FROM employees e
	JOIN jobs j ON e.job_id = j.job_id;

/*4. display the country name, city, and number of those departments where at 
least 2 employees are working.*/
SELECT c.country_name, l.city, COUNT(e.department_id) no_in_dept, d.department_name
FROM employees e
	JOIN departments d ON e.department_id = d.department_id
	JOIN locations l ON l.location_id = d.location_id
    JOIN countries c ON c.country_id = l.country_id
GROUP BY d.department_id
HAVING COUNT(e.department_id) >= 2;

/*5. display the employee id, employee name (first name and last name ) for 
all employees who earn more than the average salary in each departments.*/
SELECT	employee_id, CONCAT(first_name,' ',last_name) AS full_name, 
	salary, (salary - AVG(salary)) '>avg'
FROM employees
GROUP BY department_id
HAVING (salary - AVG(salary)) > 0;

/*6.display the employee name ( first name and last name ), employee id and salary 
of all employees who report to Payam. */
SELECT employee_id, CONCAT(first_name,' ',last_name) full_name, salary
FROM employees 
WHERE manager_id IN (SELECT employee_id FROM employees
						WHERE first_name LIKE '%Payam%');

/*7.display all the information of the employees who does not work in those departments 
where some employees works whose manager id within the range 100 and 200.*/
SELECT *
FROM employees
WHERE manager_id NOT IN (SELECT employee_id FROM employees
							WHERE employee_id BETWEEN 100 AND 200);
                            
/*8. display all the information for those employees whose id is any id who earn the 
second highest salary.*/
SELECT *
FROM employees
WHERE employee_id 
ORDER BY salary DESC
LIMIT 1,2;

/*9. display the employee name( first name and last name ) and hire date for all 
employees in the same department as Clara. Exclude Clara.*/
SELECT CONCAT(first_name,' ',last_name) full_name, hire_date
FROM employees
WHERE department_id IN (SELECT department_id FROM employees
							WHERE first_name LIKE '%Clara%')
	AND first_name NOT LIKE '%Clara%'
ORDER BY full_name;

/*10.display the employee number, name( first name and last name ) and job
title for all employees whose salary is smaller than any salary of those 
employees whose job title is MK_MAN.*/
SELECT CONCAT(first_name,' ',last_name) full_name, e.hire_date, j.job_title, salary
FROM employees e
	JOIN jobs j ON e.job_id = j.job_id
WHERE salary < ANY (SELECT salary FROM employees WHERE job_id LIKE '%MK_MAN%');

/*11.display the employee number, name( first name and last name ) and job
title for all employees whose salary is more than any average salary of any
department.*/
SELECT CONCAT(first_name,' ',last_name) full_name, e.hire_date, j.job_title, salary
FROM employees e
	JOIN jobs j ON e.job_id = j.job_id
GROUP BY department_id
HAVING (salary - AVG(salary)) > 0;
-- WHERE salary > ANY (SELECT AVG(salary) FROM employees GROUP BY department_id);

/*12.display the department id and the total salary for those departments
which contains at least two employees.*/
SELECT department_id, SUM(salary) total_salary
FROM employees
GROUP BY department_id
HAVING COUNT(department_id) >= 2;

/*13.display the employee id, name ( first name and last name ), salary and
the SalaryStatus column with a title HIGH and LOW respectively for those employees
whose salary is more than and less than the average salary of all employees.*/
SELECT CONCAT(first_name,' ',last_name) full_name, salary,
	CASE
		WHEN salary > (SELECT AVG(salary) FROM employees) THEN 'High'
        ELSE 'Low' END salary_status
FROM employees;

/*14.which employees have a manager who works for a department based in the US.*/
SELECT employee_id, CONCAT(first_name,' ',last_name) full_name
FROM employees
WHERE manager_id IN (SELECT employee_id FROM employees e
						JOIN departments d ON e.department_id = d.department_id
                        JOIN locations l ON d.location_id = l.location_id
					WHERE country_id = 'US');

/*15.Get the details of employees who are managers.*/
SELECT * 
FROM employees
WHERE employee_id IN (SELECT manager_id FROM employees);

/*16.display the full name,email, and designation for all those employees 
who was hired after the employee whose ID is 165.*/
SELECT CONCAT(first_name,' ',last_name) full_name, email, job_title
FROM employees e
	JOIN jobs j ON e.job_id = j.job_id
WHERE hire_date > (SELECT hire_date FROM employees WHERE employee_id = 165);

/*17.display the the details of those departments which max salary is 7000
or above for those employees who already done one or more jobs.*/
SELECT * 
FROM departments
WHERE department_id IN (SELECT department_id FROM job_history jh
						JOIN jobs j ON jh.job_id = j.job_id
                        WHERE max_salary >= 7000);

/*18.display the full name (first and last name) of manager who is supervising
4 or more employees.*/
SELECT CONCAT(first_name,' ',last_name) full_name
FROM employees
GROUP BY manager_id
HAVING COUNT(employee_id) >= 4;

/*19.display the details of the current job for those employees who worked
as a Sales Representative in the past.*/
SELECT	j.job_id, j.job_title, jh.start_date, jh.end_date, d.department_id, 
		d.department_name, j.min_salary, j.max_salary, l.city,
        d.manager_id
FROM job_history jh
	JOIN jobs j ON jh.job_id = j.job_id
    JOIN departments d ON jh.department_id = d.department_id
    JOIN locations l ON d.location_id = l.location_id
WHERE employee_id = (SELECT employee_id from job_history WHERE job_id LIKE '%s%rep%')
ORDER BY start_date DESC
LIMIT 1;

/*20.display all the infromation about those employees who earn second lowest salary
of all the employees.*/
SELECT *
FROM employees
WHERE employee_id 
ORDER BY salary ASC
LIMIT 1,2; 


