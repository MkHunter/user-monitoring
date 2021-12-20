public Map<Id, Report> getNotificationList(List<Report> reports) {
        // Recover metadata of reports that are beign tracked
        //Map<Id, Report_Alert_Max_Register_Number__mdt> sensibleColumns = new Map<Id, Report_Alert_Max_Register_Number__mdt> ([SELECT MasterLabel, Max_Value__c FROM Report_Alert_Max_Register_Number__mdt]);
        List<Report_Alert_Max_Register_Number__mdt> limitedReportsMeta = [SELECT MasterLabel, Max_Value__c FROM Report_Alert_Max_Register_Number__mdt];
        Map<String, Decimal> mapReportNameMaxTracked  = (Map<String, Decimal>)Collection.of(limitedReportsMeta).mapBy(Report_Alert_Max_Register_Number__mdt.MasterLabel, Report_Alert_Max_Register_Number__mdt.Max_Value__c);
        List<String> listReportNameTracked  = new List<String>(mapReportNameMaxTracked.keySet());

        System.debug('listReportNameTracked ->'+listReportNameTracked+'\nreports ->'+reports);
        // Get Id of reports that matches the List of names that are being tracked
        List<Report> trackedReports = (List<Report>)Collection.of(reports).filter(Report.Name).isIn(listReportNameTracked).get();

        Map<Id, Report> excededRegistersReport = new Map<Id, Report>();
        for( Report report : trackedReports){
            String reportName = report.Name;
            String reportId = report.Id;

            Decimal maxReportRecords = mapReportNameMaxTracked.get(reportName);
            Integer reportRecordCount = getReportRecordCount(reportId);

            if (reportRecordCount>maxReportRecords) {
                excededRegistersReport.put(reportId, report);
            }
            System.debug('\nReportID ->'+reportId+'\n ReportName ->'+reportName+'\nReportRecordCount ->'+reportRecordCount+'\nSENDS EMAIL?: '+(reportRecordCount>maxReportRecords));
        }
        System.debug('LIST OF REPORTS THAT EXCEEDED THE MAX REGISTER COUNT -> \n'+excededRegistersReport);
        return excededRegistersReport;
        
}

public Integer getReportRecordCount(Id id){
    // Run the report
    Reports.ReportResults results = Reports.ReportManager.runReport(id, true);
    // Get the fact map from the report results
    Reports.ReportFactWithDetails factDetails = (Reports.ReportFactWithDetails)results.getFactMap().get('T!T');
    // Return the row count
    return factDetails.getRows().size();
}

getNotificationList([SELECT Id, Name FROM Report]);
