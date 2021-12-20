global class ReportMaxRecordCountEventCondition implements TxnSecurity.EventCondition {
    public boolean evaluate(SObject event) {
        switch on event{
            when ReportEvent reportEvent {
                return evaluate(reportEvent.Name,reportEvent.RowsProcessed);
            }
            when null {
                // Don't take policy action when event is null
                return false;
            }
            when else{
                // Don't take policy action when event is not handled
                return false;
            }
        }
    }
    
    private boolean evaluate(String reportName, Decimal reportRecordCount){
        // Recover Metadata
        Report_Alert_Max_Register_Number__mdt reportMeta = [SELECT MasterLabel, Max_Value__c FROM Report_Alert_Max_Register_Number__mdt WHERE MasterLabel = :reportName LIMIT 1];
        if (reportMeta != null && reportRecordCount != null) {
            Decimal maxReportRecords = reportMeta.Max_Value__c;
            // In case the report count exceeds the maximum then 
            // Send notification
            return reportRecordCount>maxReportRecords;
        }
        return false;
    }
}