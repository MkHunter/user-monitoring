/*
*   Author: Miguel Ernesto López Malacón
*   Description:- Case Trigger Handler Test
*   Created:- 20/12/2021
*   Last Updated:- 27/12/2021
*/
@isTest
public class CaseTriggerHandlerTest extends TriggerHandler {
    static String startingStatus;
    static Account accTest;
    static Contact contactTest;
    static Case caseTest;
    static EmailMessage email;
    static String contactEmail;
    static boolean isEscalated = false;
    static String emailToAddress;
    static String caseSolution = 'Yip Yipp';
    
    static void init(){
        startingStatus = 'New';
        contactEmail = 'beforeupdatecase@test.com';

        accTest = new Account(Name='TestBeforeUpdateCaseToClose Account');
        insert accTest;
        contactTest = new Contact(FirstName='TestBeforeUpdateCaseToClose', LastName='Contact', Email=contactEmail, AccountId=accTest.Id);
        insert contactTest;
        caseTest = new Case(AccountId=accTest.Id, ContactId=contactTest.Id, Status=startingStatus, Origin='Email', Case_Solution__c=caseSolution, IsEscalated=isEscalated);
        insert caseTest;
        
        email = new EmailMessage(FromAddress = contactEmail, FromName = 'TestBeforeUpdateCaseToClose Contact', ToAddress = emailToAddress, Subject = 'TestBeforeUpdateCaseToClose', TextBody = 'Accepted', ParentId = caseTest.Id);
        insert email;
    }
    /**
    * ------------ POSITIVE TEST CASES ------------
    *
    * /
    
    /**
     * Positive test case 1: If a Case Status is set to Closed Successfully then...
     **/ 
    @isTest static void TestBeforeUpdateCaseToClose() {
        isEscalated = false;
        caseSolution = 'Yip Yipp';
        init();

        Test.startTest();
        emailToAddress = contactEmail;
        caseTest.Status='Closed';
        //update caseTest;
        Database.SaveResult result = Database.update(caseTest);
        Test.stopTest();

        // Verify
        // In this case the update should have been stopped by the trigger,
        // so verify that we got back an error.
        System.assert(!result.isSuccess());
        System.assert(result.getErrors().size() > 0);
        System.assertEquals('ERROR: SLA should not be scalated.',result.getErrors()[0].getMessage());
    }

    @isTest static void TestBeforeUpdateCaseToCloseSLA() {
        isEscalated = false;
        caseSolution = 'Yip Yipp';
        isEscalated = true;
        init();

        Test.startTest();
        emailToAddress = contactEmail;
        caseTest.Status='Closed';
        //update caseTest;
        Database.SaveResult result = Database.update(caseTest);
        Test.stopTest();

        // Verify 
        // In this case the update should have been stopped by the trigger,
        // so verify that we got back an error.
        System.assert(!result.isSuccess());
        System.assert(result.getErrors().size() > 0);
        System.assertEquals('ERROR: SLA should not be scalated.',result.getErrors()[0].getMessage());
    }

    @isTest static void TestBeforeUpdateCaseToCloseCaseSolution() {
        isEscalated = false;
        caseSolution = '';
        init();

        Test.startTest();
        emailToAddress = contactEmail;
        caseTest.Status='Closed';
        //update caseTest;
        Database.SaveResult result = Database.update(caseTest);
        Test.stopTest();

        // Verify 
        // In this case the update should have been stopped by the trigger,
        // so verify that we got back an error.
        System.assert(!result.isSuccess());
        System.assert(result.getErrors().size() > 0);
        System.assertEquals('ERROR: You have to specify a case solution in order to close this case.',result.getErrors()[0].getMessage());
    }
}