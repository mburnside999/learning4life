public class GilmoreLabs_FlowTileGridController 
{
    @AuraEnabled
    public static List<Task> getData(List<string> lstInput, String strObjectName, String strSubjectTemplate, String strDescriptionTemplate) 
    {
        List<Task> objItems = new List<Task>();
        integer counter = 1;
        TimeZone tz = UserInfo.getTimeZone();
        
        //See if we are simply showing text (no objects)
        if (String.isBlank(strObjectName))
        {
            for (String currentVal : lstInput)
            {
                Task newItem = new Task();
                newItem.Subject = currentVal;
                newItem.CallDurationInSeconds = counter;
                newItem.CallObject = currentVal;
                objItems.add(newItem);
                counter++;
            }
            return objItems;
        }
        
        //Else we need to get the object(s)
        List<ID> myIDs = new List<ID>();
        for (string currentID : lstInput)
        {
            if (String.isNotBlank(currentID))
            {
                myIDs.add(currentID);
            }
        }
        string objFields = '';
        Map<String,Schema.SObjectField> mfields = Schema.getGlobalDescribe().get(strObjectName).getDescribe().fields.getMap();
        for( integer i=0; i < mfields.values().size()-1; i++ )
        {
            objFields += mfields.values()[i].getDescribe().getName() + ', ';
        }
        objFields += mfields.values()[ mfields.values().size() - 1 ].getDescribe().getName();
        List<SObject> sobjItems = database.query('SELECT ' + objFields + ' FROM ' + strObjectName + ' WHERE ID IN: myIDs');
        for (sObject currentObject : sobjItems)
        {
            Task newItem = new Task();
            newItem.Subject = strSubjectTemplate;
            newItem.Description = strDescriptionTemplate;
            newItem.CallDurationInSeconds = counter;
            newItem.CallObject = currentObject.Id;
            
            //Peform the merge operation
            for (SObjectField field: mfields.values()) 
            {
                // Passed in object has the field
                string fieldName = field.getDescribe().getName();
                try
                {
                    Schema.DisplayType fieldType = field.getDescribe().getType();
                    string matchString = '{' + fieldName + '}';
                    if (currentObject.get(fieldName) == null)
                    {
                        newItem.Subject = newItem.Subject.replace(matchString, '');
                        newItem.Description = newItem.Description.replace(matchString, '');
                    }
                    else if (fieldType == Schema.DisplayType.DATETIME)
                    {
                        system.debug('formatting to tz: ' + tz.getDisplayName());
                        newItem.Subject = newItem.Subject.replace(matchString, ((datetime)currentObject.get(fieldName)).format('EEE MMM d h:mmaaa', tz.getID()));
                        newItem.Description = newItem.Description.replace(matchString, ((datetime)currentObject.get(fieldName)).format('EEE MMM d h:mmaaa', tz.getID()));
                    }
                    else
                    {
                        //system.debug('fieldNameeee '+fieldName);
                        newItem.Subject = newItem.Subject.replace(matchString, String.valueOf(currentObject.get(fieldName)));
                        newItem.Description = newItem.Description.replace(matchString, String.valueOf(currentObject.get(fieldName)));
                    }           
                }
                catch (Exception ex)
                {
                    
                }
            }
            
            objItems.add(newItem);
            counter++;
        }
        
        return objItems;
    }
}