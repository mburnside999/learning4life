public class generateAccounts {
    
  //Mikes test
    public static void go(integer count) {
        List < Account > accts = new List < Account > ();
        for (integer i = 1; i <= count; i++) {
            Account a = new Account();
            a.name = 'Account-' + i;
            a.billingstreet=i+' High St';
            a.billingcity='Melbourne';
            a.billingpostalcode='3000';
            a.billingstate='Victoria';
            a.billingcountry='Australia';
            
            
            accts.add(a);
        }
        insert accts;
    }

}