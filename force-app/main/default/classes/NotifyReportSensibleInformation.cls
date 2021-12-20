global class NotifyReportSensibleInformation implements TxnSecurity.EventCondition {
    public boolean evaluate(SObject event) {
        switch on event{
            when ReportEvent reportEvent {
                return evaluate(reportEvent);
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
    
    private boolean evaluate(ReportEvent reportEvent){
        // Recover metadata of reports that are beign tracked
        String columnNames = reportEvent.ColumnHeaders;

        List<Report_Alert_Sensible_Information__mdt> reportColumnMeta = [SELECT MasterLabel FROM Report_Alert_Sensible_Information__mdt];

            for (Report_Alert_Sensible_Information__mdt sensibleMetadata : reportColumnMeta) {
                String sensibleColumn = sensibleMetadata.MasterLabel;
                if (columnNames.contains(sensibleColumn)) {
                    return true;
                }
            }
        return false;
    }
}