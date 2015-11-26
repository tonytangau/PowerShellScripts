$SubscriptionName="Microsoft Partner Network"

Add-AzureAccount

Select-AzureSubscription -SubscriptionName $SubscriptionName

$db_user = "user"
$db_password = ConvertTo-SecureString -String "pwd" -AsPlainText -Force
$serverName = "server"

$credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $db_user, $db_password

#create a connection context
$serverContext = New-AzureSqlDatabaseServerContext -ServerName $serverName -Credential $credential

#Get-AzureSqlDatabase $serverContext –DatabaseName “HubShard1”

Remove-AzureSqlDatabase $serverContext –DatabaseName “HubShard1”

$S0 = Get-AzureSqlDatabaseServiceObjective $serverContext -ServiceObjectiveName "S0"

New-AzureSqlDatabase $serverContext –DatabaseName “HubShard1” -ServiceObjective $S0
