/*
*   Author: Miguel Ernesto López Malacón
*   Description:- Case Trigger Handler
*   Created:- 20/12/2021
*   Last Updated:- 20/12/2021
*/
public class CaseTriggerHandler extends TriggerHandler {
    private List<Case> newCaseList;

    public CaseTriggerHandler() {
        this.newCaseList= Trigger.New;
    }

    public override void beforeUpdate(){
        onCaseClosed();
    }

    private void onCaseClosed(){
        for (Case caseObj : newCaseList) {
            String caseStatus = caseObj.Status;
            Boolean caseIsEscalated = caseObj.IsEscalated;
            String caseSolution = caseObj.Case_Solution__c;
                
            if(caseStatus == 'Closed'){
                if(caseIsEscalated){
                    caseObj.addError('SLA should not be scalated.');
                }
                if (caseSolution == null) {
                    caseObj.addError('You have to specify a case solution in order to close this case.');
                }
            }
        }
    }
}