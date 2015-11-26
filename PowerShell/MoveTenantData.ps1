$db_user = "user"
$db_password = "pwd"
$serverFrom = "server1"
$serverTo = "server2"
$databaseFrom = "Shard1"
$databaseTo = "Shard2"

$tenantId = "guid-1234"

$TableNames = ("dbo.Table1", "dbo.Table2")

# Copy to databaseTo
foreach($d in $TableNames){

    $dbQuery = "select * from $d where TenantId = '$tenantId'";

    $dataTable = Invoke-Sqlcmd -ServerInstance $serverFrom -Database $databaseFrom -Username $db_user -Password $db_password -Query $dbQuery;

    $connectionString = "Server = $serverTo; Database = $databaseTo; User ID = $db_user; Password = $db_password;"

    $bulkCopy = new-object ("Data.SqlClient.SqlBulkCopy") $connectionString;
    $bulkCopy.DestinationTableName = $d;

    if ($dataTable -ne $null)
    {
        $bulkCopy.WriteToServer($dataTable);
    }
}

# Remove from databaseFrom
[array]::Reverse($TableNames)

foreach($d in $TableNames){

    $deleteQuery = "delete from $d where TenantId = '$tenantId'";

    $dataTable = Invoke-Sqlcmd -ServerInstance $serverFrom -Database $databaseFrom -Username $db_user -Password $db_password -Query $deleteQuery;
}
