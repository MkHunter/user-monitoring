/*
*   Author: Miguel Ernesto López Malacón
*   Description:- Case Trigger Handler Test
*   Created:- 20/12/2021
*   Last Updated:- 21/12/2021
*/
@isTest
public class CaseTriggerHandlerTest extends TriggerHandler {
    static String startingStatus;
    static Account accTest;
    static Contact contactTest;
    static Case caseTest;
    static EmailMessage email;
    static String contactEmail;

    static void init(){
        startingStatus = 'New';
        contactEmail = 'beforeupdatecase@test.com';

        accTest = new Account(Name='TestBeforeUpdateCaseToClose Account');
        contactTest = new Contact(FirstName='TestBeforeUpdateCaseToClose', LastName='Contact', Email=contactEmail, AccountId=accTest.Id);
        caseTest = new Case(AccountId=contactTest.AccountId , Status=startingStatus, Origin='Email', Contact=contactTest);

        insert accTest;
        insert contactTest;
        insert caseTest;
        
        email = new EmailMessage(FromAddress = contactEmail, FromName = 'TestBeforeUpdateCaseToClose Contact', ToAddress = contactEmail, Subject = 'TestBeforeUpdateCaseToClose', TextBody = 'Accepted', ParentId = caseTest.Id);
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
        init();

        Test.startTest();
        caseTest.Status='Closed';
        //update caseTest;
        Database.SaveResult result = Database.update(caseTest);
        Test.stopTest();

        //System.assertEquals(false, startingStatus == caseTest.Status);
        // Verify 
        // In this case the deletion should have been stopped by the trigger,
        // so verify that we got back an error.
        System.assert(!result.isSuccess());
        System.assert(result.getErrors().size() > 0);
        System.assertEquals('Accepted Message "ToAddress" does not correspond with ContactEmail of Case.',result.getErrors()[0].getMessage());
    }
}