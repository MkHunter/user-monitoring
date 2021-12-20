// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

/*
List<LoginHistory> loginHistory = [Select LoginTime , SourceIp , LoginType , Status , Browser , Platform , Application , LoginUrl , LoginGeoId FROM LoginHistory];
String geoLocationId = loginHistory[0].LoginGeoId;
LoginGeo loginGeoData = [SELECT City, Country, CountryIso, CreatedById, CreatedDate, Id, IsDeleted, LastModifiedById, LastModifiedDate, Latitude, LoginTime, Longitude, PostalCode, Subdivision, SystemModstamp FROM LoginGeo WHERE Id = :geoLocationId LIMIT 1];
System.debug(loginGeoData);
*/

/*
// Obtener metadatos
Map<String, Report_Alert_Sensible_Information__mdt> sensibleColumns = Report_Alert_Sensible_Information__mdt.getAll();
String type = new List<String>(sensibleColumns.keySet())[0];
System.debug('SENSIBLE '+sensibleColumns.keySet());
System.debug('COLUMN NAME TO SEARCH:'+type);

//Obtener ID del Reporte
Report report = [SELECT Id FROM Report WHERE Name='Contact Report' LIMIT 1];
String reportId = (String)report.get('Id');

// Consultar Columnas del reporte
Reports.ReportResults results = Reports.ReportManager.runReport(reportId);
List<String> reportColumnNames = results.getReportMetadata().getDetailColumns();
System.debug('REPORT COLUMNS: ' + reportColumnNames);
System.debug('CONTAINS '+type+'?: ' + reportColumnNames.contains(type));
*/

// Obtener metadatos
//Map<Id, Report_Alert_Max_Register_Number__mdt> sensibleColumns = new Map<Id, Report_Alert_Max_Register_Number__mdt> ([SELECT MasterLabel, Max_Value__c FROM Report_Alert_Max_Register_Number__mdt]);
/* List<Report_Alert_Max_Register_Number__mdt> limitedReportsMetadata = [SELECT MasterLabel, Max_Value__c FROM Report_Alert_Max_Register_Number__mdt];
List<String> e = (List<String>) Collection.of(limitedReportsMetadata).listOf(Report_Alert_Max_Register_Number__mdt.MasterLabel);
List<Report> reports = [SELECT Id, Name FROM Report];
List<Id> limitedReportsIds = Collection.of(reports).filter(Report.Name).isIn(e);
 */

//List<ReportEvent> reports = [SELECT ColumnHeaders, Id, Name, NumberOfColumns, ReportId FROM ReportEvent];
//System.debug(reports);
[SELECT FROM User]