# Install-Module SimplySql

Import-Module SimplySql
 
# Define connection parameters
$server = "localhost"
$database = "test"
$username = "root"
$password = "123456789"

# Create a connection string
$connectionString = "server=$server;database=$database;user id=$username;password=$password;"

# Create a MySqlConnection object
$connection = New-Object MySql.Data.MySqlClient.MySqlConnection($connectionString)

function addNewEMPLOYEES {
    $query = "CREATE TABLE EMPLOYEES (
        id INT PRIMARY KEY,
        name VARCHAR(255),
        Sal DECIMAL(10, 2),
        Hiredate DATETIME,
        DeptId INT,
        FOREIGN KEY (DeptId) REFERENCES DEPT(id)
      );"
    $command = New-Object MySql.Data.MySqlClient.MySqlCommand($query, $connection)
    $command.ExecuteReader()
}
function addNewDataEMPLOYEES {

    $query = "INSERT INTO EMPLOYEES (id, name, Sal, Hiredate, DeptId) VALUES
                (1, 'Employee 1', 1500.00, '2023-06-01 09:00:00', 1),
                (2, 'Employee 2', 2000.00, '2023-06-02 10:30:00', 1),
                (3, 'Employee 3', 1800.00, '2023-06-03 08:45:00', 2),
                (4, 'Employee 4', 1900.00, '2023-06-04 11:15:00', 2),
                (5, 'Employee 5', 1600.00, '2023-06-05 12:00:00', 3),
                (6, 'Employee 6', 1700.00, '2023-06-06 09:30:00', 3),
                (7, 'Employee 7', 2100.00, '2023-06-07 07:45:00', 1),
                (8, 'Employee 8', 2200.00, '2023-06-08 10:00:00', 1),
                (9, 'Employee 9', 1900.00, '2023-06-09 12:30:00', 2),
                (10, 'Employee 10', 1800.00, '2023-06-10 08:15:00', 3);
        "
        $command = New-Object MySql.Data.MySqlClient.MySqlCommand($query, $connection)
        $result = $command.ExecuteReader()
        Write-Host $result

}
function addNewDEPT {
    $query = "CREATE TABLE DEPT (
            id INT PRIMARY KEY,
            name VARCHAR(255)
        );"
    $command = New-Object MySql.Data.MySqlClient.MySqlCommand($query, $connection)
    $command.ExecuteReader()
}
function addNewDataDEPT {
 
    $query = "INSERT INTO DEPT (id, name) VALUES
            (1, 'division 1'),
            (2, 'division 2'),
            (3, 'division 3');
        "
    $command = New-Object MySql.Data.MySqlClient.MySqlCommand($query, $connection)
    $command.ExecuteReader()
}
function getData{

    $param = Read-Host "Enter the date parameter (YYYY-MM-DD):"
    Write-Host ""
    $query = "SELECT DEPT.name AS 'department name', EMPLOYEES.name AS 'worker name', EMPLOYEES.Hiredate
                FROM DEPT
                JOIN EMPLOYEES ON DEPT.id = EMPLOYEES.DeptId
                WHERE EMPLOYEES.Hiredate > '$param'
                ORDER BY DEPT.name ASC, EMPLOYEES.Hiredate DESC;"
    $command = New-Object MySql.Data.MySqlClient.MySqlCommand($query, $connection)
    $result = $command.ExecuteReader()
    while ($result.Read()) {
        $department = $result["department name"]
        $worker = $result["worker name"]
        $hiredate = $result["Hiredate"]
        
        Write-Host "Department: $department"
        Write-Host "Worker: $worker"
        Write-Host "Hiredate: $hiredate"
        Write-Host ""
    }
}
try {

    $connection.Open()
    addNewDEPT
    $connection.Close()
    $connection.Open()
    addNewDataDEPT
    $connection.Close()
    $connection.Open()
    addNewEMPLOYEES
    $connection.Close()
    $connection.Open()
    addNewDataEMPLOYEES
    $connection.Close()
    $connection.Open()
    getData

}
catch {
    Write-Host "Error: $($_.Exception.Message)"
}
finally {
    $connection.Close()
}
