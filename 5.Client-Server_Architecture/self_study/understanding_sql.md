# Study: SQL Basics


This documentation was created to help you understand the basic SQL commands, thus, enabling you to perform essential database operations which includes displaying, creating, deleting, selecting, and inserting data. 

## 1. SHOW:

### What's it for?
SHOW is a query usedto communicate to your database it tells your database to reveal what's hiding inside it (and the level of information this query reveals depnds on your specifications).

### How to use it:
```sql
SHOW {DATABASES | TABLES | COLUMNS FROM table_name};
```

Try these example phrases:
- To see all your databases:
  ```sql
  SHOW DATABASES;
  ```
- To view all tables in your current database:
  ```sql
  SHOW TABLES;
  ```
- To reveal the columns in a specific table:
  ```sql
  SHOW COLUMNS FROM <tableName>;
  ```

## 2. CREATE: 

### What is this query for?
CREATE is the query that helps you make new databases or tables.

### How to use it:
- To spin up a new database:
  ```sql
  CREATE DATABASE database_name;
  ```
- To spin into existence, a new table:
  ```sql
  CREATE TABLE table_name (
      column1_name data_type constraints,
      column2_name data_type constraints,
      ...
  );
  ```

## 3. DROP: 

### What is this query for?
DROP is the query you use when you want to make databases or tables disappear completely. Use with caution!

### How to use it:
- To vanish a database:
  ```sql
  DROP DATABASE database_name;
  ```
- To make a table disappear (delete):
  ```sql
  DROP TABLE table_name;
  ```


## 4. SELECT: 

### What is this query for?
SELECT is the query that helps you find and look at specific pieces of data.

### How to use it:
```sql
SELECT column1, column2, ...
FROM table_name
WHERE condition;
```

Let us try it out in a few examples:
- View all data from the employees table:
  ```sql
  SELECT * FROM employees;
  ```
- Call forth only names and positions:
  ```sql
  SELECT name, position FROM employees;
  ```
- Find all the managers (for example):
  ```sql
  SELECT name, salary FROM employees WHERE position = 'Manager';
  ```

## 5. INSERT: 
### What is this query used for?
INSERT is the query that helps you add new rows of data to your tables.

### How to use it:
```sql
INSERT INTO table_name (column1, column2, ...)
VALUES (value1, value2, ...);
```

Take a look at these examples :
- Add a new employee to the table:
  ```sql
  INSERT INTO employees (id, name, position, salary)
  VALUES (1, 'Emmanuel Okose', 'An Exceptional I.T bro', 750000000.00);
  ```
- Adding multiple employees at once:
  ```sql
  INSERT INTO employees (id, name, position, salary)
  VALUES
  (2, 'user 2', 'user2_position', 80000.00),
  (3, 'user 3', 'user3_position', 70000.00);
  ```

## Conclusion

Congratulations if you made it this far.
This documentation targets the goal of helping you (the reader) learn some powerful SQL queries. With these queries - SHOW, CREATE, DROP, SELECT, and INSERT in your amazing toolkit, you are empowered to manage any databse (relating to mysql) in any way you want.


