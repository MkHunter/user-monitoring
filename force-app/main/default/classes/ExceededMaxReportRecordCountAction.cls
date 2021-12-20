global class ExceededMaxReportRecordCountAction {
  @InvocableMethod(label='Get Reports surpassing the MAX # Records' description='Used to Notify to User the Reports that exceeds the maximum number of records' category='Report')
  global static List<ExceededMaxReportRecordCountActionResult> getExceededReportList() { //
        // Recover metadata of reports that are beign tracked
        List<Report_Alert_Max_Register_Number__mdt> limitedReportsMeta = [SELECT MasterLabel, Max_Value__c FROM Report_Alert_Max_Register_Number__mdt];
        Map<String, Decimal> mapReportNameMaxTracked  = (Map<String, Decimal>)Collection.of(limitedReportsMeta).mapBy(Report_Alert_Max_Register_Number__mdt.MasterLabel, Report_Alert_Max_Register_Number__mdt.Max_Value__c);
        List<String> listReportNameTracked  = new List<String>(mapReportNameMaxTracked.keySet());

        List<Report> reports = [SELECT Id, Name FROM Report];

        System.debug('listReportNameTracked ->'+listReportNameTracked+'\nreports ->'+reports);

        // Get Id of reports that matches the List of names that are being tracked
        List<Report> trackedReports = (List<Report>)Collection.of(reports).filter(Report.Name).isIn(listReportNameTracked).get();

        List<ExceededMaxReportRecordCountActionResult> excededRegistersReport = new List<ExceededMaxReportRecordCountActionResult>();
        for( Report report : trackedReports){
            String reportName = report.Name;
            String reportId = report.Id;

            Decimal maxReportRecords = mapReportNameMaxTracked.get(reportName);
            Integer reportRecordCount = getReportRecordCount(reportId);

            ExceededMaxReportRecordCountActionResult result = new ExceededMaxReportRecordCountActionResult();
            result.reportID = reportId;
            result.reportName = reportName;
            result.report = report;
            result.exceedsMaximum = reportRecordCount>maxReportRecords;

            // Add it to the list
            excededRegistersReport.add(result);

            System.debug('\nReportID ->'+reportId+'\nMaxReportRecords ->'+maxReportRecords+'\n ReportName ->'+reportName+'\nReportRecordCount ->'+reportRecordCount+'\nSENDS EMAIL?: '+result.exceedsMaximum);
        }
        System.debug('LIST OF REPORTS THAT EXCEEDED THE MAX REGISTER COUNT -> \n'+excededRegistersReport);
        return excededRegistersReport;
  }

  public static Integer getReportRecordCount(Id id){
    // Run the report
    Reports.ReportResults results = Reports.ReportManager.runReport(id, true);
    // Get the fact map from the report results
    Reports.ReportFactWithDetails factDetails = (Reports.ReportFactWithDetails)results.getFactMap().get('T!T');
    // Return the row count
    return factDetails.getRows().size();
  }
/*
  global class ConvertLeadActionRequest {
    @InvocableVariable()
    global ID userId;
  }
    class ConvertLeadActionException extends Exception {}
*/
  global class ExceededMaxReportRecordCountActionResult {
    @InvocableVariable
    global ID reportID;

    @InvocableVariable
    global String reportName;

    @InvocableVariable
    global Report report;

    @InvocableVariable
    global boolean exceedsMaximum;
  }
}