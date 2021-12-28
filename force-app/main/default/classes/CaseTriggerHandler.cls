/*
*   Author: Miguel Ernesto López Malacón
*   Description:- Case Trigger Handler
*   Created:- 20/12/2021
*   Last Updated:- 28/12/2021
*/
public class CaseTriggerHandler extends TriggerHandler {
    private List<Case> newCaseList;

    public CaseTriggerHandler() {
        this.newCaseList= Trigger.New;
    }

    public override void afterInsert(){
        // TODO: This code should execute only when the status is In Progress
        // Create an Email Message
        for (Case caseObj : newCaseList) {
            String caseId = caseObj.Id;
            String caseContactEmail = caseObj.ContactEmail;
            String caseContactName = caseObj.Contact.Name;

            EmailMessage email = new EmailMessage(FromAddress = caseContactEmail,  ParentId = caseId, TextBody = 'Accepted', FromName = caseContactName, ToAddress = caseContactEmail, Subject = 'Successfully Created a Case');
            insert email;
        }
    }

    public override void beforeUpdate(){
        onCaseClosed();
    }

    private void onCaseClosed(){
        List<EmailMessage> allMessages = [SELECT Id, ParentId, ToAddress, TextBody FROM EmailMessage];

        for (Case caseObj : newCaseList) {
            String caseId = caseObj.Id;
            String caseStatus = caseObj.Status;
            Boolean caseIsEscalated = caseObj.IsEscalated;
            String caseSolution = caseObj.Case_Solution__c;
            String caseContactEmail = caseObj.ContactEmail;

            List<EmailMessage> msgsFromCase = (List<EmailMessage>)Collection.of(allMessages).filter(EmailMessage.ParentId).equals(caseId).get();
            List<EmailMessage> msgsBodyAccepted = (List<EmailMessage>)Collection.of(msgsFromCase).filter(EmailMessage.TextBody).contains('Accepted').get();
            List<String> msgsContactAddresses = (List<String>)Collection.of(msgsBodyAccepted).filter(EmailMessage.ToAddress).equals(caseContactEmail).listOf(EmailMessage.ToAddress);

            // When trying to update the case to Closed...
            if(caseStatus == 'Closed'){
                if(caseIsEscalated){
                    caseObj.addError('ERROR: SLA should not be scalated.');
                }
                if (caseSolution == null || caseSolution == '') {
                    caseObj.addError('ERROR: You have to specify a case solution in order to close this case.');
                }
                if (msgsFromCase.size() < 1) {
                    caseObj.addError('ERROR: EmailMessage not found attatched to your Case.');
                }else if (msgsBodyAccepted.size() < 1) {
                    caseObj.addError('ERROR: "Accepted" not found in attatched messages.');
                }else if (msgsBodyAccepted.size() != msgsContactAddresses.size()) {
                    caseObj.addError('ERROR: Accepted Message "ToAddress" does not correspond with ContactEmail of Case.');
                }
            }
        }
    }
}