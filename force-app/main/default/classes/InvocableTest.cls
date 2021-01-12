global with sharing class InvocableTest {
    
    @InvocableMethod(label='Mike Invocable method' description='Mikes invocable Method description')
    public static List<String> getStatusCountsBetweenDates (List<Requests> requests)   {
        
        // initialise our list of results
        
        List<String> result = new List<String>();
        
        String str='';
        
        DateTime starttime=requests[0].starttime;
        DateTime endtime=requests[0].endtime;
        Id clientId=requests[0].clientId;
      
        // execute a SOQL aggregate query
        AggregateResult[] groupedResults
            = [SELECT client__c, Objective__r.SD__r.Program__r.Name,status__c, count(id) 
               FROM Client_Objective__c 
               WHERE 
               client__c=:clientId and 
               status__c in ('ACQ','HLD','ABS','OBJ') and 
               lastmodifieddate > :starttime and lastmodifieddate <= :endtime  
               GROUP BY client__c,Objective__r.SD__r.Program__r.Name,status__c];
        
        System.debug(groupedResults);
        
        //hack to dedup progream names
        Set<String> programSet = new Set<String>();
        for (AggregateResult ar : groupedResults) {   
           programSet.add((String)ar.get('Name'));       
        }
        
        System.debug('No of programs='+programSet.size());
        
        if (programSet.size()>0){
        str+='<p>Total Number of Programs '+programSet.size()+ '</p>';
        // iterate through the aggregate set pulling out the fields we want and build our list -- default the "expr(0)"" refers to the first aggregation column
        }
        
        String oldpname='';
        
        for (AggregateResult ar : groupedResults)  {
            
            String statustext='';  
            String pname=(String)ar.get('Name');
            String status=(String)ar.get('Status__c');
            
            switch on status{
                when 'ACQ' {
                    statustext='Acquired';
                }
                when 'HLD'{
                    statustext='Held';
                    
                }
                when 'ABS'{
                    statustext='Absorbed';
                    
                }
                when 'OBJ'{
                    statustext='Current Objectives';
                    
                }
                when else {
                    statustext='????';
                }
            }
                       
            if (pname != oldpname) { // simulate a break report
                str+='<br/><p>Program: '+pname +'</p>'; 
            }
            str+='<p>Number '+statustext +' '+ar.get('expr0')+'</p>'; 
            
            oldpname=pname;
        }
        
        System.debug(str);
        
        // Flow now does the insert to the NDIS_Report__c object 
        //NDIS_Report__c ndr = new NDIS_Report__c();
        //ndr.client__c=clientId;
        //ndr.NDIS_Report__c=str;
        //insert ndr;
        
        result.add(str);
        return (result)  ; //return our list of results
    }
    
    global class Requests {
        
        @InvocableVariable
        global Id clientId;
        
        @InvocableVariable
        global DateTime starttime;
        
        @InvocableVariable
        global DateTime endtime;       
    }
    
    
}