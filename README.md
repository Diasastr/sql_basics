# Інструкція з налаштування PostgreSQL та роботи з базою даних

Цей README файл містить інструкції щодо встановлення PostgreSQL через Chocolatey, створення бази даних, додавання таблиць і запитів до них.

## Встановлення PostgreSQL

1. **Встановлення Chocolatey:**


   Відкрийте PowerShell як адміністратор і виконайте наступну команду:
```shell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
```


2. **Встановлення PostgreSQL через Chocolatey:**
Після встановлення Chocolatey, виконайте команду:
```shell
choco install postgresql
```


Перезапустіть PowerShell або командний рядок, щоб оновити env. variables.

## Налаштування PostgreSQL

1. **Перевірка встановлення PostgreSQL:**

   
Виконайте команду в командному рядку:
```shell
psql --version
```

Це повинно показати встановлену версію PostgreSQL.

2. **Створення нового користувача (за потреби):**
Якщо потрібно створити нового користувача, виконайте:

```shell
CREATE ROLE username LOGIN PASSWORD 'password';
```

Замініть `username` та `password` на бажані значення.

## Робота з базою даних

### Створення бази даних та таблиць

1. **Підключення до PostgreSQL (я замінила в конфігі метод нв траст доя спрощення):**
```shell
psql -U postgres
```

2. **Створення бази даних:**
```sql
CREATE DATABASE companydb;
```


3. **Перехід до бази даних:**
```sql
\c companydb
```

4. **Створення таблиць:**
```sql
CREATE TABLE Employees (
EmployeeID int PRIMARY KEY,
FirstName varchar(50),
LastName varchar(50),
Position varchar(50),
Email varchar(100)
);
CREATE TABLE Projects (
ProjectID int PRIMARY KEY,
ProjectName varchar(100),
StartDate date,
EndDate date,
ProjectManagerID int,
FOREIGN KEY (ProjectManagerID) REFERENCES Employees(EmployeeID)
);
CREATE TABLE Tasks (
TaskID int PRIMARY KEY,
ProjectID int,
TaskName varchar(100),
Description text,
DueDate date,
AssignedToID int,
Status varchar(20),
FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID),
FOREIGN KEY (AssignedToID) REFERENCES Employees(EmployeeID)
);
```

### Додавання даних до таблиць
```sql
INSERT INTO Employees (EmployeeID, FirstName, LastName, Position, Email) VALUES
(1, 'John', 'Doe', 'Manager', 'john.doe@example.com'),
(2, 'Jane', 'Doe', 'Developer', 'jane.doe@example.com'),
(3, 'Alice', 'Smith', 'Designer', 'alice.smith@example.com'),
(4, 'Bob', 'Brown', 'Analyst', 'bob.brown@example.com'),
(5, 'Charlie', 'Davis', 'Tester', 'charlie.davis@example.com');
```
etc...


## SQL-запити

### Запит для виведення всіх проектів з працівниками, які ними керують

Цей запит об'єднує таблиці `Projects` та `Employees` для відображення назв проектів та імен менеджерів, які ними керують.

```sql
SELECT 
    p.ProjectName, 
    e.FirstName || ' ' || e.LastName AS ManagerName
FROM 
    Projects p
JOIN 
    Employees e ON p.ProjectManagerID = e.EmployeeID;
```
### Запит для виведення всіх завдань конкретного проекту разом з працівниками, яким призначено ці завдання

Цей запит використовується для отримання переліку завдань конкретного проекту з іменами працівників, які відповідають за ці завдання. Наприклад, для проекту 'Project Alpha'.

```sql
SELECT 
    t.TaskName, 
    e.FirstName || ' ' || e.LastName AS AssignedEmployee
FROM 
    Tasks t
JOIN 
    Employees e ON t.AssignedToID = e.EmployeeID
WHERE 
    t.ProjectID = (SELECT ProjectID FROM Projects WHERE ProjectName = 'Project Alpha');
```


### Обчислення та виведення середнього та максимального терміну виконання завдань усіх проєктів

Цей запит використовується для обчислення середнього та максимального терміну виконання всіх завдань в базі даних, виходячи з дат початку проектів і кінцевих термінів завдань.

```sql
SELECT 
    AVG(t.DueDate - p.StartDate) AS AverageDuration, 
    MAX(t.DueDate - p.StartDate) AS MaximumDuration
FROM 
    Tasks t
JOIN 
    Projects p ON t.ProjectID = p.ProjectID;
```


### Створення та тестування backup-файлу

#### Створення backup:
```shell
pg_dump -U postgres companydb > companydb_backup.sql
```

#### Тестування backup:
```shell
createdb -U postgres testdb
psql -U postgres testdb < companydb_backup.sql
```





