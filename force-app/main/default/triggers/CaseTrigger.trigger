/*
*   Author: Miguel Ernesto López Malacón
*   Description:- Case Trigger Handler Test
*   Created:- 20/12/2021
*   Last Updated:- 20/12/2021
*/
trigger CaseTrigger on Case (before insert) {
    new CaseTriggerHandler().run();
}