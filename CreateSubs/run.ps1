using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

# Interact with query parameters or the body of the request.
$subscriptionDisplayName = $Request.Query.subscriptionDisplayName
$subscriptionBillingScope = $Request.Query.subscriptionBillingScope
$subscriptionOfferType = $Request.Query.subscriptionOfferType
$subscriptionManagementGroupId = $Request.Query.subscriptionManagementGroupId

if (-not $subscriptionDisplayName) {
    $subscriptionDisplayName = $Request.Body.subscriptionDisplayName
}

if (-not $subscriptionBillingScope) {
    $subscriptionBillingScope = $Request.Body.subscriptionBillingScope
}

if (-not $subscriptionOfferType) {
    $subscriptionOfferType = $Request.Body.subscriptionOfferType
}

if (-not $subscriptionManagementGroupId) {
    $subscriptionManagementGroupId = $Request.Body.subscriptionManagementGroupId
}

## Show Azure PowerShell Logged In User Details
(Get-AzContext).Account

## Variables

$aliasGUID = New-Guid
$putURLBase = "/providers/Microsoft.Subscription/aliases/$aliasGUID"
$putURLAPIVersion = "/?api-version=2020-09-01"

## Create PUT URL From Above Variables

$putURLComplete = $putURLBase + $putURLAPIVersion

## Create Request Body Based On Whether Management Group ID Is Passed In Request Or Not

if (-not $subscriptionManagementGroupId) {
    
    $putRequestBody = @"
    {
        "properties": {
            "displayName": "$subscriptionDisplayName",
            "billingScope": "$subscriptionBillingScope",
            "workload": "$subscriptionOfferType"
        } 
    }
"@

## Create Subscription And Place Into Default Management Group, As None Specified In Request

Write-Host "Creating Azure Subscription via Alias of: $aliasGUID, Display Name of: $subscriptionDisplayName, At Billing Scope of: $subscriptionBillingScope, And Subscription Offer Type Of: $subscriptionOfferType"
$newSubcription = Invoke-AzRest -Path $putURLComplete -Method PUT -Payload $putRequestBody

} else {
    
    $putRequestBody = @"
    {
        "properties": {
            "displayName": "$subscriptionDisplayName",
            "billingScope": "$subscriptionBillingScope",
            "workload": "$subscriptionOfferType",
            "managementGroupId": "$subscriptionManagementGroupId"
        } 
    }
"@

## Create Subscription And Place Into Specified Management Group

Write-Host "Creating Azure Subscription via Alias of: $aliasGUID, Display Name of: $subscriptionDisplayName, At Billing Scope of: $subscriptionBillingScope, And Subscription Offer Type Of: $subscriptionOfferType, And placing in the following Management Group: $subscriptionManagementGroupId"
$newSubcription = Invoke-AzRest -Path $putURLComplete -Method PUT -Payload $putRequestBody

}

## Extract Subscription ID 
$parsedNewSubscription = $newSubcription.Content | ConvertFrom-Json
$newSubscriptionId = $parsedNewSubscription.properties.subscriptionId

Write-Host "Azure Subscription Created with ID of: $newSubscriptionId"

if ($newSubscriptionId) {
    $status = [HttpStatusCode]::OK
    $JSONResponse = @"
    {
        "subscriptionDisplayName": "$subscriptionDisplayName",
        "subscriptionID": "$newSubscriptionId",
        "subscriptionBillingScope": "$subscriptionBillingScope",
        "subscriptionOfferType": "$subscriptionOfferType",
        "subscriptionManagementGroupID": "$subscriptionManagementGroupId"
    }
"@
}
else {
    $status = [HttpStatusCode]::BadRequest
    $JSONResponse = "Azure Subscription creation failed, please check the Azure Function invocation logs!"
}

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = $status
        Body       = $JSONResponse
    })
