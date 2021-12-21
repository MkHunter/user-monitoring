/**
 * Author: Miguel Ernesto López
*   Description:- A Multi-purpose utility class
*   Created:- 20/11/2021
 **/
public class SFDCUtils {
    // Returns a List<String> containing the Picklists Options
    public static List<String> getValuesFromPicklist(SObjectField field){
        List<Schema.PicklistEntry> fieldOptions = field.getDescribe().getPicklistValues();
        List<String> options = new List<String>();
        for (Schema.PicklistEntry opt : fieldOptions) {
            options.add(opt.getValue()); // Turns it into String
        }
        return options;
    }

    // TODO: Make it so you receive a SObject instead of a String
    // Returns a Map of List<String> containing the Picklists Options for each Picklist field inside an Object
    public static Map<SObjectField, List<String>> getPicklistFieldsValuesFromObject(String objName){
        //String objName = (String) obj.get('Name');
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