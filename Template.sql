-- 1. Find all information about all departments.
SELECT * 
FROM Addresses, Departments, Employees, EmployeesProjects, Projects, Towns

-- 2. Find all department names.
SELECT Departments.Name
FROM Departments

-- 3. Find the salary of each employee.
SELECT Employees.Salary
FROM Employees

-- 4. Write a SQL to find the full name of each employee. 
--       Hint: Full name is constructed by joining first, middle and last name.
SELECT (Employees.FirstName + ' ' + Employees.MiddleName + ' ' + Employees.LastName) AS FullName
FROM Employees

-- 5. Find all different employee salaries.
SELECT DISTINCT Employees.Salary
FROM Employees

-- 6. Find all information about the employees whose job title is "Sales Representative" or "Sales Manager".
SELECT *
FROM Employees
WHERE JobTitle = 'Sales Representative'
OR JobTitle = 'Sales Manager'

-- 7. Find the names of all employees whose first name starts with "SA".
SELECT *
FROM Employees
WHERE FirstName
LIKE 'SA%'

-- 8. Find the names of all employees whose last name contains "ei".
SELECT *
FROM Employees
WHERE LastName
Like '%ei%'

-- 9. Find the salary of all employees whose salary is in the range [20000…30000].
SELECT *
FROM Employees
WHERE Salary
BETWEEN 20000 AND 30000

-- 10. Find the names of all employees whose salary is 25000, 14000, 12500 or 23600.
SELECT Employees.FirstName
FROM Employees
WHERE Salary IN (25000, 14000, 12500, 23600)

-- 11. Find all employees that do not have manager.
SELECT *
FROM Employees
WHERE ManagerID IS NULL

-- 12. Find all employees that have salary more than 50000. Order them in decreasing order by salary.
SELECT *
FROM Employees
WHERE Salary > 50000
ORDER BY Salary DESC

-- 13. Find the top 5 best paid employees.
SELECT TOP 5 *
FROM Employees
WHERE Salary > 50000
-- ORDER BY Salary -- DESC - Show different output

-- 14. Find all employees along with their address. Use inner join with ON clause.
SELECT Employees.FirstName, Addresses.AddressText -- Show only two columns
FROM Employees 
INNER JOIN Addresses
ON Employees.AddressID = Addresses.AddressID

-- 15. Find all employees and their address. Use equijoins (conditions in the WHERE clause).
SELECT * -- Show all columns
FROM Employees, Addresses
WHERE Employees.AddressID = Addresses.AddressID

-- 16. Find all employees along with their manager.
SELECT Employees.FirstName, Employees.ManagerID
FROM Employees

-- 17. Find all employees, along with their manager's address. 
--       Hint: Join Employees AS e, Employees AS m and Addresses.
SELECT Employees.FirstName + ' ' + Employees.LastName Employee, Addresses.AddressText
FROM Employees, Addresses
LEFT JOIN Employees m 
ON m.EmployeeID = Addresses.AddressText

-- 18. Find all departments and all town names as a single list. 
--       Hint: Use UNION (https://www.w3schools.com/sql/sql_union.asp)
SELECT Departments.Name 
FROM Departments
UNION
SELECT Towns.Name 
FROM Towns

-- 19. Write a SQL query that lists the name of each employee along with the name of their manager.
--       Hint: Use RIGHT OUTER JOIN (https://www.w3schools.com/sql/sql_join_right.asp). Rewrite the query using LEFT OUTER JOIN.
--             The expected result after using RIGHT OUTER JOIN is shown below.
SELECT e.FirstName + ' ' + e.LastName Employee,
m.FirstName + ' ' + m.LastName Manager
FROM Employees e
LEFT JOIN Employees m 
ON m.EmployeeID = e.ManagerID
ORDER BY Manager

-- | Employee                 | Manager            |
-- | ------------------------ | ------------------ |
-- | Ken Sanchez              | NULL               |
-- | Martin Kulov             | NULL               |
-- | George Denchev           | NULL               |
-- | Ovidiu Cracium           | Roberto Tamburello |
-- | Michael Sullivan         | Roberto Tamburello |
-- | Sharon Salavaria         | Roberto Tamburello |
-- | Dylan Miller             | Roberto Tamburello |
-- | Rob Walters              | Roberto Tamburello |
-- | Gail Erickson            | Roberto Tamburello |
-- | Jossef Goldberg          | Roberto Tamburello |
-- | Kevin Brown              | David Bradley      |
-- | Sariya Harnpadoungsataya | David Bradley      |
-- | Jill Williams            | David Bradley      |
-- | Mary Gibson              | David Bradley      |
-- | Terry Eminhizer          | David Bradley      |

-- 20. Find the names of all employees who were hired between 1995 and 2005 and are part of the "Sales" or "Finance" departments.
SELECT Employees.FirstName, Employees.HireDate, Departments.Name
FROM Employees, Departments
WHERE Departments.Name IN ('Sales', 'Finance') 
AND YEAR(HireDate) >= 1995
AND YEAR(HireDate) < 2005

-- 21. Find the names and salaries of the employees that take the minimal salary in the company.
--       Hint: Use a nested SELECT statement.
SELECT Employees.FirstName, Employees.Salary
FROM Employees
WHERE Salary IN (
	SELECT MIN(Salary)
	FROM Employees )

SELECT CONCAT(e.FirstName, ' ', e.LastName) AS EmployeesName, Salary
FROM Employees e
WHERE Salary = 
    (SELECT MIN(Salary) FROM Employees)

DECLARE @MinSalary int = (SELECT MIN(Salary) FROM Employees)
SELECT CONCAT(e.FirstName, ' ', e.LastName) AS EmployeesName, Salary
FROM Employees e
WHERE Salary = @MinSalary

-- 22. Find the names and salaries of the employees that have a salary that is up to 10% higher than the minimal salary for the company.
SELECT Employees.FirstName, Employees.Salary
FROM Employees
WHERE Salary >
    (SELECT (MIN(Salary) + MIN(Salary) * 0.1) FROM Employees)
	ORDER BY Salary

DECLARE @NeededSalary int = (SELECT (MIN(Salary) + MIN(Salary) * 0.1) FROM Employees)
SELECT CONCAT(e.FirstName, ' ', e.LastName), Salary
FROM Employees e
WHERE Salary > @NeededSalary
ORDER BY Salary

-- 23. Find the full name, salary and department of the employees that take the minimal salary in their department.
--       Hint: Use a nested SELECT statement.
SELECT (Employees.FirstName + ' ' + Employees.MiddleName + ' ' + Employees.LastName) AS FullName, Salary, JobTitle
FROM Employees
WHERE Salary IN (
	SELECT MIN(Salary)
	FROM Employees )

SELECT CONCAT(e.FirstName, ' ', e.LastName), e.Salary, d.Name
FROM Employees e 
JOIN Departments d
    ON e.DepartmentID = d.DepartmentID
WHERE Salary =
    (SELECT MIN(Salary) FROM Employees emp
    WHERE emp.DepartmentID = d.DepartmentID)
ORDER BY Salary

-- 24. Find the number of employees and average salary for each department.
--       Hint: The expected result is shown below.
SELECT d.Name, COUNT(e.EmployeeId) as EmployeeCount, ROUND (AVG(Salary), 2) AS AverageSalary
FROM Employees e 
JOIN Departments d
    ON e.DepartmentID = d.DepartmentID
GROUP BY d.Name
ORDER BY AverageSalary DESC

-- | Department                 | Employees | Average Salary |
-- | -------------------------- | --------- | -------------- |
-- | Executive                  | 2         | 92800.00       |
-- | Research and Development   | 6         | 45133.00       |
-- | Engineering                | 6         | 40167.00       |
-- | Information Services       | 10        | 34180.00       |
-- | Sales                      | 18        | 29989.00       |
-- | Tool Design                | 4         | 27150.00       |
-- | Finance                    | 10        | 23930.00       |
-- | Purchasing                 | 12        | 18983.00       |
-- | Production Control         | 6         | 18683.00       |
-- | Human Resources            | 6         | 18017.00       |
-- | Quality Assurance          | 7         | 17543.00       |
-- | Document Control           | 5         | 14400.00       |
-- | Production                 | 179       | 14163.00       |
-- | Marketing                  | 8         | 14063.00       |
-- | Facilities and Maintenance | 7         | 13057.00       |
-- | Shipping and Receiving     | 6         | 10867.00       |

-- 25. Find the average salary in the "Sales" department.
SELECT AVG(Employees.Salary) AS AvarageSalary
FROM Employees
WHERE DepartmentID IN (
	SELECT DepartmentID
	FROM Departments
	WHERE Departments.Name = 'Sales' )

SELECT ROUND(AVG(e.Salary), 2)
FROM Employees e 
JOIN Departments d
    ON e.DepartmentID = d.DepartmentID
WHERE d.Name = 'Sales'

-- 26. Find the number of employees in the "Sales" department.
SELECT COUNT(Employees.FirstName) AS Employees
FROM Employees
WHERE DepartmentID IN (
	SELECT DepartmentID
	FROM Departments
	WHERE Departments.Name = 'Sales' )

SELECT COUNT(e.EmployeeID) AS Employees
FROM Employees e 
JOIN Departments d
    ON e.DepartmentID = d.DepartmentID
	WHERE d.Name = 'Sales'

-- 27. Find the number of all employees that have a manager.
SELECT COUNT(FirstName)
FROM Employees
WHERE ManagerID IS NOT NULL

SELECT COUNT(e.ManagerID)
FROM Employees e 

-- 28. Find the number of all employees that have no manager.
SELECT COUNT(FirstName)
FROM Employees
WHERE ManagerID IS NULL

SELECT COUNT(e.EmployeeID)
FROM Employees e 
WHERE e.ManagerID IS NULL

-- 29. Find all employees along with their manager. For employees without a manager display the value "(shef4e)".
SELECT e.FirstName + ' ' + e.LastName Employee, 
ISNULL(m.FirstName, ' ') + ' ' + ISNULL(m.LastName, 'shef4e') Manager
FROM Employees e
LEFT JOIN Employees m 
ON m.EmployeeID = e.ManagerID
ORDER BY Manager

SELECT CONCAT(e.FirstName, ' ', e.LastName) as [EmployeeName],
       ISNULL(m.FirstName + ' ' +  m.LastName, 'shef4e') as [ManagerName]
FROM Employees e 
LEFT JOIN Employees m
    ON e.ManagerID = m.EmployeeID

-- 30. Find all departments and the average salary for each of them.
SELECT Employees.JobTitle, AVG(Salary) AS AverageSalary
FROM Employees
GROUP BY JobTitle

SELECT d.Name, ROUND(AVG(e.Salary), 2) AS AverageSalary
FROM Employees e 
JOIN Departments d
    ON e.DepartmentID = d.DepartmentID
GROUP BY d.Name
ORDER BY AVG(e.Salary)

-- 31. Find the number of employees in each town's department. The result table should have 3 columns - Town, Department and Employees Count. 
--       Hint: The expected table has 85 rows. The first 12 rows are shown below.
SELECT t.Name AS Town, d.Name AS Department, COUNT(e.EmployeeId) as EmployeeCount -- Town, Department and Count
FROM Employees e 
JOIN Departments d
    ON e.DepartmentID = d.DepartmentID
JOIN Addresses a
    ON e.AddressID = a.AddressID
JOIN Towns t
    ON t.TownID = a.TownID
GROUP BY d.Name, t.Name
ORDER BY t.Name, EmployeeCount DESC

SELECT COUNT(e.EmployeeId) as EmployeeCount, d.Name -- Count and Department
FROM Employees e 
JOIN Departments d
    ON e.DepartmentID = d.DepartmentID
GROUP BY d.Name
    --- UNION
SELECT COUNT(e.EmployeeId) as EmployeeCount, t.Name -- Count and Town
FROM Employees e 
JOIN Addresses a
    ON e.AddressID = a.AddressID
JOIN Towns t
    ON a.TownID = t.TownID
GROUP BY t.Name

-- | Town	    | Department	                | Employees Count |
-- | ---------- | ----------------------------- | --------------- |
-- | Bellevue	| Production	                | 22              |
-- | Bellevue	| Purchasing	                | 5               |
-- | Bellevue	| Production Control	        | 2               |
-- | Bellevue	| Marketing	                    | 2               |
-- | Bellevue	| Engineering	                | 1               |
-- | Bellevue	| Human Resources	            | 1               |
-- | Bellevue	| Information Services	        | 1               |
-- | Bellevue	| Research and Development	    | 1               |
-- | Bellevue	| Sales	                        | 1               |
-- | Berlin	    | Sales	                        | 1               |
-- | Bordeaux	| Sales	                        | 1               |

-- 32. Display the first and last name of all managers with exactly 5 employees. 
SELECT  CONCAT(e.FirstName, ' ', e.LastName) as [ManagerName],
        COUNT(e.EmployeeID) as [EmployeesCount]
FROM Employees e 
JOIN Employees emp
    ON emp.ManagerID = e.EmployeeID
GROUP BY e.EmployeeID, e.FirstName, e.LastName
HAVING COUNT(e.EmployeeID) = 5

-- 33. Find the minimal and average employee salary for each department.
SELECT Departments.Name, MIN(Employees.Salary) AS MinSalary, AVG(Employees.Salary) AS AvgSalary
FROM Departments, Employees
GROUP BY Departments.Name

-- 34. Find the town with most employees.
SELECT TOP 1 Towns.Name, COUNT(Addresses.AddressID) AS MaxPeople
FROM Addresses
INNER JOIN Towns
ON Addresses.TownID = Towns.TownID
GROUP BY Towns.Name
ORDER BY COUNT(*) DESC