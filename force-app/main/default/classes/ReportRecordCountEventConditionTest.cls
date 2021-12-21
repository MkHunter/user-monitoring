/*
*   Author: Miguel Ernesto López Malacón
*   Description:- Case Trigger Handler Test
*   Created:- 16/12/2021
*   Last Updated:- 17/12/2021
*/
@isTest
public class ReportRecordCountEventConditionTest {

   /**
    * ------------ POSITIVE TEST CASES ------------
    ** /
    
    /**
     * Positive test case 1: If a ReportEvent has more RowsProcessed than the maximum 
     * recovered from the metadata, then the evaluate method of our policy's Apex should return true.
     **/ 
    static testMethod void testReportEventPositiveTestCase() {
        Report_Alert_Max_Register_Number__mdt reportMeta = [SELECT MasterLabel, Max_Value__c FROM Report_Alert_Max_Register_Number__mdt LIMIT 1];
        System.debug(reportMeta);
        if (reportMeta != null) {
            ReportEvent testEvent = new ReportEvent();
            testEvent.Name = reportMeta.MasterLabel;
            testEvent.RowsProcessed = reportMeta.Max_Value__c+1;
            
            // test that the Apex returns true for this event
            ReportMaxRecordCountEventCondition eventCondition = new ReportMaxRecordCountEventCondition();
            System.debug(testEvent);
            System.assert(eventCondition.evaluate(testEvent));
        }
    }
    
    /**
      * ------------ NEGATIVE TEST CASES ------------
      **/
    
    /**
     * Negative test case 1: If an event is a type other than ReportEvent
     * then the evaluate method of our policy's Apex should return false.
     **/
    static testMethod void testOtherEventObject() {
        LoginEvent loginEvent = new LoginEvent();
        ReportMaxRecordCountEventCondition  eventCondition = new ReportMaxRecordCountEventCondition();
        System.assertEquals(false, eventCondition.evaluate(loginEvent));   
    }

    /**
     * Negative test case 2: If an event is null, then the evaluate method of our policy's
     * Apex should return false.
     **/
    static testMethod void testNullEventObject() {
        ReportMaxRecordCountEventCondition eventCondition = new ReportMaxRecordCountEventCondition();
        System.assertEquals(false, eventCondition.evaluate(null));   
    } 

    /**
     * Negative test case 3: If an event has a null RowsProcessed value, then the evaluate method 
     * of our policy's Apex should return false.
     **/
    static testMethod void testNullRowsProcessed() {
        Report_Alert_Max_Register_Number__mdt reportMeta = [SELECT MasterLabel, Max_Value__c FROM Report_Alert_Max_Register_Number__mdt LIMIT 1];
        if (reportMeta != null) {
            ReportEvent testEvent = new ReportEvent();
            testEvent.Name = reportMeta.MasterLabel;
            testEvent.RowsProcessed = null;

            ReportMaxRecordCountEventCondition  eventCondition = new ReportMaxRecordCountEventCondition();
            System.assertEquals(false, eventCondition.evaluate(testEvent));
        }  
    } 
}