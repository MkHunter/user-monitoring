/*
*   Author: Miguel Ernesto López Malacón
*   Description:- Case Trigger Handler Test
*   Created:- 20/12/2021
*   Last Updated:- 28/12/2021
*/
trigger CaseTrigger on Case (after insert ,before update) {
    new CaseTriggerHandler().run();
}