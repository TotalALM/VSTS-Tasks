Set-Location $env:WebServerPath

$clusterUrl = "localhost"
$clusterPort = 19000
$PackagePath = "WebServerAppTypePkg.V1"
#$imageStoreConnectionString = "fabric:ImageStore"
$appPkgName = "WebServerAppTypePkg"
$appTypeName = "WebServerAppType"
$appTypeVersion1 = "1.0.0"
$appName = "fabric:/AWebServerApp"
$upgrade = true

$serviceTypeName = "WebServerServiceType"
$serviceName = $appName + "/AWebServerService"

# Connect PowerShell session to a cluster
Connect-ServiceFabricCluster -ConnectionEndpoint ${clusterUrl}:${clusterPort}

# Copy the application package V1 to the cluster
Copy-ServiceFabricApplicationPackage -ApplicationPackagePath ${PackagePath} -ImageStoreConnectionString $imageStoreConnectionString -ApplicationPackagePathInImageStore $appPkgName

# Register the application package's application type/version
Register-ServiceFabricApplicationType -ApplicationPathInImageStore $appPkgName

# After registering the package's app type/version, you can remove the package
Remove-ServiceFabricApplicationPackage -ImageStoreConnectionString $imageStoreConnectionString -ApplicationPackagePathInImageStore $appPkgName

# Create a named application from the registered app type/version
New-ServiceFabricApplication -ApplicationTypeName $appTypeName -ApplicationTypeVersion $appTypeVersion1 -ApplicationName $appName 

# Create a named service within the named app from the service's type
New-ServiceFabricService -ApplicationName $appName -ServiceTypeName $serviceTypeName -ServiceName $serviceName -Stateless -PartitionSchemeSingleton -InstanceCount 1

#if (${upgrade} == true)
#{
# Upgrade the application from V1 to V2
	#Start-ServiceFabricApplicationUpgrade -ApplicationName $appName -ApplicationTypeVersion $appTypeVersion2 -UnmonitoredAuto -UpgradeReplicaSetCheckTimeoutSec 100
#}