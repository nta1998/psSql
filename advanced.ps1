# Install-Module SimplySql

Import-Module SimplySql

# Define connection parameters
$server = "localhost"
$database = "test"
$username = "root"
$password = "123456789"
$DEPT =  "DEPT"
$EMPLOYEES = "EMPLOYEES"

function configUP{
    param (
        [string]$variableName,
        [string]$newValue
    )
    $variableName = $newValue
}
    
function getData{

    $param = Read-Host "Enter the date parameter (YYYY-MM-DD):"
    Write-Host ""
    $query = "SELECT $DEPT.name AS 'department name', $EMPLOYEES.name AS 'worker name', $EMPLOYEES.Hiredate
            FROM $DEPT
            JOIN $EMPLOYEES ON DEPT.id = $EMPLOYEES.DeptId
            WHERE $EMPLOYEES.Hiredate > '$param'
            ORDER BY $DEPT.name ASC, $EMPLOYEES.Hiredate DESC;"
    return $query
}
function addNewEMPLOYEES {
    $table = Read-Host "Choose a name for the table "
    $query = "CREATE TABLE $table (
        id INT PRIMARY KEY,
        name VARCHAR(255),
        Sal DECIMAL(10, 2),
        Hiredate DATETIME,
        DeptId INT,
        FOREIGN KEY (DeptId) REFERENCES $DEPT(id)
      );"
    configUP($table,$EMPLOYEES)
        return $query
}
function addNewDataEMPLOYEES {
    $table = Read-Host "The table name to add the data"
    $numOfData = Read-Host "How much data items would you like to add to the table?"
    $data = ""
    for ($i = 0; $i -lt $numOfData; $i++) {
        $id = Read-Host "Select an ID for a piece of data"
        $name = Read-Host "Select an NAME for a piece of data"
        $Sal = Read-Host "Select an SAL for a piece of data"
        Write-Host "Select an HIREDATE for a piece of data in the next format dd-mm-yyyy"
        $day = Read-Host "Enter an DAY"
        $month = Read-Host "Enter an MONTH"
        $year = Read-Host "Enter an YEAR"
        $Hiredate =("$year-$month-$day")
        $DeptId = Read-Host "Select an DEPID for a piece of data"
        $end = ","
        if($i+1 -eq $numOfData){
            $end = ";"
        }
        $data += "($id,'$name',$Sal,'$Hiredate',$DeptId)"+$end
        Write-Host $data
    }
    $query = "INSERT INTO $table (id, name, Sal, Hiredate, DeptId) VALUES
            $data
        "
    return $query
}
function addNewDEPT {
    $table = Read-Host "Choose a name for the DEPT table "
    $query = "CREATE TABLE $table (
            id INT PRIMARY KEY,
            name VARCHAR(255)
        );"
    configUP($table,$DEPT)
    return $query
}
function addNewDataDEPT {
    $table = Read-Host "The table to add the data"
    $numOfData = Read-Host "How much data items would you like to add to the table?"
    $data = ""
    for ($i = 0; $i -lt $numOfData; $i++) {
        $id = Read-Host "Select an ID for a piece of data"
        $name = Read-Host "Select an NAME for a piece of data"
        $end = ","
        if($i+1 -eq $numOfData){
            $end = ";"
        }
        $data += "($id,'$name')"+$end
        Write-Host $data
    }
    $query = "INSERT INTO $table (id, name) VALUES
            $data
        "
        return $query
}
try {
    # Create a connection string
    $connectionString = "server=$server;database=$database;user id=$username;password=$password;"

    # Create a MySqlConnection object
    $connection = New-Object MySql.Data.MySqlClient.MySqlConnection($connectionString)
    while ($true) {
        
        Write-Host "(1) - To add new DEPT db "
        Write-Host "(2) - To add new data to DEPT db"
        Write-Host "(3) - To add new EMPLOYEES db "
        Write-Host "(4) - To add new data to EMPLOYEES db "
        Write-Host "(5) - Get join data from sql "
        $param = Read-Host 


        if($param -like "1"){
            $query = addNewDEPT
        }
        elseif ($param -like "2") {
            $query = addNewDataDEPT
        }
        elseif ($param -like "3") {
            $query = addNewEMPLOYEES
        }
        elseif ($param -like "4") {
            $query = addNewDataEMPLOYEES
        }
        elseif ($param -like "5") {
            $query = getData
        }
        $connection.Open()
        $command = New-Object MySql.Data.MySqlClient.MySqlCommand($query, $connection)
        $result = $command.ExecuteReader()
        $connection.Close()
        Write-Host $result
    

        if ($result){
            Write-Host "all doen" 
        }else {
            Write-Host "Error: $($_.Exception.Message)"   
        }
    }
}
catch {
    Write-Host "Error: $($_.Exception.Message)"
}
finally {
    $connection.Close()
}