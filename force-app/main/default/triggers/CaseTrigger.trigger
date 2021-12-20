/* 
    Last Edited by Miguel López ~ 20/12/21
*/
trigger CaseTrigger on Case (before insert) {
    new CaseTriggerHandler().run();
}
