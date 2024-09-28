# SQL: - Documentation (Self Study)

## Introduction

__SQL (Structured Query Language) is the standard language for working with relational databases. It’s used to create, retrieve, update, and delete data within a database. This guide gives you the basics of SQL syntax and some of the most commonly used commands.__

## Basic Syntax

SQL commands follow a specific structure that defines what action to take. Let us quickly look at some core statements:

- __SELECT:__ Retrieves data from one or more tables.

```
SELECT column1, column2, ... FROM table_name;
```

- __INSERT:__ Adds new records to a table.

```
INSERT INTO table_name (column1, column2, ...) VALUES (value1, value2, ...);
```

- __UPDATE:__ Changes existing records in a table.

```
UPDATE table_name SET column1 = value1, column2 = value2, ... WHERE condition;
```

- __DELETE:__ Removes records from a table.

```
DELETE FROM table_name WHERE condition;
```

- __CREATE TABLE:__ Defines and creates a new table in the database.

```
CREATE TABLE table_name (
  column1 datatype,
  column2 datatype,
  ...
);
```

- __ALTER TABLE:__ Changes the structure of an existing table (add, remove, or modify columns).

```
ALTER TABLE table_name ADD column_name datatype;
```

- __DROP TABLE:__ Permanently deletes a table from the database.

```
DROP TABLE table_name;
```

## Commonly Used Commands

In addition to the basic structure, SQL has a lot of useful commands for managing and retrieving data. Here are some key ones:

- __SELECT:__ Fetches data from tables. You can choose which columns to retrieve and filter results with the `WHERE` clause.

```
SELECT * FROM employees;  -- Get all columns from the 'employees' table.
```

- __WHERE:__ Filters the data based on a specific condition.

```
SELECT * FROM employees WHERE department = 'HR';  -- Get employees from the 'HR' department.
```

- __ORDER BY:__ Sorts the result set in ascending or descending order based on a specified column.

```
SELECT * FROM employees ORDER BY salary DESC;  -- Sort employees by salary (highest first).
```

- __GROUP BY:__ Groups rows with similar values in a column, this makes it possible for you to do summary calculations.

```
SELECT department, COUNT(*) FROM employees GROUP BY department;  -- Count employees by department.
```

- __JOIN:__ Combines data from two or more tables based on a related column, useful for linking relational data.

```
SELECT employees.name, departments.name FROM employees JOIN departments ON employees.department_id = departments.id;  -- Link employee names with department names.
```

- __COUNT:__ Calculates the total number of rows in a result set.

```
SELECT COUNT(*) FROM employees;  -- Count how many employees there are.
```

- __SUM, AVG, MIN, MAX:__ These aggregate functions perform calculations on a set of values, like finding total salary (`SUM`), average salary (`AVG`), minimum salary (`MIN`), and maximum salary (`MAX`).

```
SELECT SUM(salary) FROM employees;  -- Calculate the total salary of all employees.
```

### Conclusion

This document guides you throuigh the basics for understanding SQL commands and syntax. The more you practice and explore, the deeper your understanding will become, this will help you greatly in managing one of the well known relational databases there is - MySQL.
