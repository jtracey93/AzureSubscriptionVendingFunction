using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

# Interact with query parameters or the body of the request.
$subscriptionDisplayName = $Request.Query.subscriptionDisplayName
$subscriptionBillingScope = $Request.Query.subscriptionBillingScope
$subscriptionOfferType = $Request.Query.subscriptionOfferType

if (-not $subscriptionDisplayName) {
    $subscriptionDisplayName = $Request.Body.subscriptionDisplayName
}

if (-not $subscriptionBillingScope) {
    $subscriptionBillingScope = $Request.Body.subscriptionBillingScope
}

if (-not $subscriptionOfferType) {
    $subscriptionOfferType = $Request.Body.subscriptionOfferType
}

## Show Azure PowerShell Logged In User Details
(Get-AzContext).Account

## Create Subscription Alias GUID 
$aliasGUID = New-Guid

Write-Host "Creating Azure Subscription with Display Name of: $subscriptionDisplayName, At Billing Scope of: $subscriptionBillingScope, And Subscription Offer Type Of: $subscriptionOfferType..."

## Create subscription
$subscription = New-AzSubscriptionAlias -AliasName "$aliasGUID" -SubscriptionName "$subscriptionDisplayName" -BillingScope "$subscriptionBillingScope" -Workload "$subscriptionOfferType"

## Get subscription ID
$subscriptionID = $subscription.Properties.SubscriptionID

Write-Host "Azure Subscription Created with ID of: $subscriptionID"

if ($subscriptionID) {
    $status = [HttpStatusCode]::OK
    $JSONResponse = @"
    {
        "subscriptionDisplayName": $subscriptionDisplayName,
        "subscriptionID": $subscriptionID,
        "subscriptionBillingScope": $subscriptionBillingScope,
        "subscriptionOfferType": $subscriptionOfferType
    }
"@
}
else {
    $status = [HttpStatusCode]::BadRequest
    $JSONResponse = "Azure Subscription creation failed, please check the Azure Functions logs!"
}

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = $status
        Body       = $JSONResponse
    })
