/*
*	Author: Erick Cardona Soto Maynez
*	Description:- Utilities for SFDC
*	Created:- 21/12/2021
*	Last Updated:- 22/12/2021
*/

public with sharing class SFDCUtilities {
    
    /**
     * This method always returns an in this stile %String%
     *  @param text2Query   String to clear spaces/null 
     *  @return             String to enter the SOQL
     */
    public static String nullQueryChequer(String text2Query) {
        //If it's null or it has spaces return %
        if(text2Query == null){
            return '%';
        }
        
        String trimmedQuery = text2Query.trim();
        if(trimmedQuery.length() == 0){
            return '%';
        }
        
        return '%'+trimmedQuery+'%';
    }

    /**
     *  Given a Field, Returns a List<String> containing the Picklists Options
     *  @param field   SObjectField of Schema.DisplayType.PICKLIST
     *  @return        Map<SObjectField, List<String>>
    */
    public static List<String> getValuesFromPicklist(SObjectField field){
        List<Schema.PicklistEntry> fieldOptions = field.getDescribe().getPicklistValues();
        List<String> options = new List<String>();
        for (Schema.PicklistEntry opt : fieldOptions) {
            options.add(opt.getValue()); // Turns it into String
        }
        return options;
    }
    
    /**
     *  Given a SObject Name, Returns a Map<SObjectField, List<String>> containing the Picklists Options
     *  found for each Field of type Picklist
     *  @param objName   String of SObjectName
     *  @return          Map<SObjectField, List<String>>
    */
    // TODO: Make it so you receive a SObject instead of a String
    public static Map<SObjectField, List<String>> getPicklistFieldsValuesFromObject(String objName){
        Map<String,Schema.SObjectField> objectFields = Schema.getGlobalDescribe().get(objName).getDescribe().fields.getMap();
        Map<Schema.SObjectField, List<String>> picklistFieldOptions = new Map<SObjectField, List<String>>();
    
        for(Schema.SObjectField field : objectFields.values()){
            Schema.DescribeFieldResult fieldDesc = field.getDescribe();
            if(fieldDesc.getType() == Schema.DisplayType.PICKLIST){
                List<String> picklistOptions = getValuesFromPicklist(field);
                picklistFieldOptions.put(field, picklistOptions);
            }
        }
        return picklistFieldOptions;
    }
}