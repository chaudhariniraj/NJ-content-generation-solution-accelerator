// ============================================================================
// Token Usage Workbook (standalone deployment)
// ----------------------------------------------------------------------------
// Provisions the "Token Usage" Application Insights workbook that visualises
// LLM_Token_Usage_Summary / LLM_Agent_Token_Usage / LLM_Model_Token_Usage
// custom events emitted by the Content Generation Solution Accelerator
// orchestrator.
//
// This template is deployed independently of the main solution so it can
// target an existing Application Insights instance that lives in a different
// resource group (or subscription) from the rest of the accelerator.
//
// Scope: resourceGroup (the workbook resource is created in the resource
// group passed to the deployment command - it does NOT need to be the same
// resource group as the Application Insights instance).
// ============================================================================

targetScope = 'resourceGroup'

@description('Optional. Full resource ID of the Application Insights instance the workbook should query. Leave as the default ("Azure Monitor") to deploy an unbound workbook and pick the App Insights instance later from the Azure portal. Re-deploy with a real resource ID to (re)bind the workbook to a specific App Insights instance.')
param applicationInsightsResourceId string = 'Azure Monitor'

@description('Optional. Stable name used for the workbook. Keep the default to allow re-deployments to update the SAME workbook even when applicationInsightsResourceId changes. Override only if you want multiple independent copies in the same resource group.')
param workbookName string = guid(resourceGroup().id, 'token-usage-workbook')

@description('Optional. Azure region for the workbook resource. Defaults to the resource group location.')
param location string = resourceGroup().location

@description('Optional. Display name shown in the Azure portal workbook gallery.')
param displayName string = 'Token Usage'

@description('Optional. Tags applied to the workbook resource.')
param tags object = {}

resource tokenUsageWorkbook 'Microsoft.Insights/workbooks@2023-06-01' = {
  name: workbookName
  location: location
  tags: tags
  kind: 'shared'
  properties: {
    displayName: displayName
    category: 'workbook'
    sourceId: applicationInsightsResourceId
    version: 'Notebook/1.0'
    serializedData: loadTextContent('../dashboards/token-usage-workbook.json')
  }
}

@description('Resource ID of the deployed workbook.')
output workbookResourceId string = tokenUsageWorkbook.id

@description('Name (GUID) of the deployed workbook.')
output workbookName string = tokenUsageWorkbook.name
