targetScope = 'managementGroup'

metadata name = 'ALZ Bicep - Management Group Diagnostic Settings'
metadata description = 'Module used to set up Diagnostic Settings for Management Groups'

@sys.description('Log Analytics Workspace Resource ID.')
param parLogAnalyticsWorkspaceResourceId string

@sys.description('Set Parameter to true to Opt-out of deployment telemetry')
param parTelemetryOptOut bool = false

// Customer Usage Attribution Id
var varCuaid = '5d17f1c2-f17b-4426-9712-0cd2652c4435'

resource mgDiagSet 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'toLa'
  properties: {
    workspaceId: '/subscriptions/a1c49950-1900-406e-8f64-09ab4e0fc86a/resourceGroups/rg-we-p-andor-logging-001/providers/Microsoft.OperationalInsights/workspaces/hutt-log-analytics'
    logs: [
      {
        category: 'Administrative'
        enabled: true
      }
      {
        category: 'Policy'
        enabled: true
      }
    ]
  }
}

// Optional Deployment for Customer Usage Attribution
module modCustomerUsageAttribution '../../CRML/customerUsageAttribution/cuaIdManagementGroup.bicep' = if (!parTelemetryOptOut) {
  #disable-next-line no-loc-expr-outside-params //Only to ensure telemetry data is stored in same location as deployment. See https://github.com/Azure/ALZ-Bicep/wiki/FAQ#why-are-some-linter-rules-disabled-via-the-disable-next-line-bicep-function for more information
  name: 'pid-${varCuaid}-${uniqueString(deployment().location)}'
  params: {}
}
