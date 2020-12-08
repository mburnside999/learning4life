public with sharing class ckz_PIM_CategoryTree {

    public ckz_PIM_CategoryTree() {
    }

    @AuraEnabled
    public static String getCategoryTree() {

        List<Category> categoryList = new List<Category>();

        Set<String> storefronts = new Set<String>();

        try {

            // Get all Storefronts defined

            System.debug('getting configs');
            List<AggregateResult> configs = [SELECT ccrz__Storefront__c FROM ccrz__E_Configuration__c GROUP BY ccrz__Storefront__c];

            System.debug('looping through results');
            for (AggregateResult ag : configs) {
                String storefrontName = (String)ag.get('ccrz__Storefront__c');
                if(storefrontName != 'Global') {
                    storefronts.add(storefrontName);
                }
            }

            System.debug('storefronts: ' + storefronts);

            // Create Map of Storefront -> root category ID
            Map<String, String> stftRootCatMap = new Map<String, String>();

            for(String stft : storefronts) {
                ccrz.ccContext ctx = new ccrz.ccContext();
                ctx.storefront = 'DefaultStore';
                ccrz.cc_CallContext.initContext(ctx);
                Map<String, Object> sfSettings = ccrz.cc_CallContext.storeFrontSettings;

                String rootCatId = (String)sfSettings.get('Root_Category_ID__c');

                stftRootCatMap.put(rootCatId, stft);
            }

            System.debug('sfRootCatMap: ' + stftRootCatMap);

            // Create a Map of all categories: SFID -> Category object

            List<ccrz__E_Category__c> categories = [SELECT Id, Name, ccrz__Sequence__c, ccrz__ParentCategory__c FROM ccrz__E_Category__c order by ccrz__Sequence__c];

            Map<String, ccrz__E_Category__c> categoryObjMap = new Map<String, ccrz__E_Category__c>();

            for(ccrz__E_Category__c cat : categories) {
                categoryObjMap.put(cat.Id, cat);
            }

            // Create a Map of categories by parent Id
            Map<String, List<ccrz__E_Category__c>> parentCategoryMap = new Map<String, List<ccrz__E_Category__c>>();

            for(ccrz__E_Category__c catObj : categories) {

                List<ccrz__E_Category__c> catObjList = null;

                if(catObj.ccrz__ParentCategory__c != null) {

                    if(parentCategoryMap.containsKey(catObj.ccrz__ParentCategory__c)) {
                        catObjList = parentCategoryMap.get(catObj.ccrz__ParentCategory__c);
                    }
                    else {
                        catObjList = new List<ccrz__E_Category__c>();
                    }

                    catObjList.add(catObj);

                    parentCategoryMap.put(catObj.ccrz__ParentCategory__c, catObjList);

                }
                
            }

            System.debug('parentCategoryMap: ' + JSON.serialize(parentCategoryMap));

            // Create a List of Categories
            // Root categories added first

            for(Id key : categoryObjMap.keySet()){

                ccrz__E_Category__c catObj = categoryObjMap.get(key);

                String catName = catObj.Name;

                if(stftRootCatMap.containsKey(catName)) {

                    System.debug('root category found: ' + catName + ' (' + catObj.ccrz__Sequence__c + ')');

                    String storefrontName = stftRootCatMap.get(catName);

                    Category category = new Category();

                    category.isRoot = true;

                    category.label = storefrontName;
                    category.name = catObj.Id;
                    category.sequence = catObj.ccrz__Sequence__c;
                    category.expanded = true;

                    categoryList.add(category);

                    getChildCategories(category, parentCategoryMap);
                }

            }

        } catch (Exception ex) {

            System.debug('error message: ' + ex.getMessage());
            System.debug('line number: ' + ex.getLineNumber());

        }

        //return categoryList;
        return JSON.serialize(categoryList);

    }

    public static void getChildCategories(Category category, Map<String, List<ccrz__E_Category__c>> parentCategoryMap) {

        System.debug('getChildCategories - category ' + category.label + ' / id = ' + category.name);

        List<ccrz__E_Category__c> categoryObjList = parentCategoryMap.get(category.name);

        if(categoryObjList != null) {

            System.debug('categoryObjList.size = ' + categoryObjList.size());

            for(ccrz__E_Category__c catObj : categoryObjList) {

                Category newCategory = new Category();

                newCategory.isRoot = false;
                newCategory.label = catObj.Name;
                newCategory.name = catObj.Id;
                newCategory.sequence = catObj.ccrz__Sequence__c;
                category.items.add(newCategory);

                getChildCategories(newCategory, parentCategoryMap);

            }

        }

    }

    public class Category {
        public Id name {get; set;}  // The category SFID
        public String label {get; set;}  // what is displayed to the user
        public boolean expanded {get; set;}

        public Boolean isRoot {get; set;}  // not needed
        public Decimal sequence {get; set;}  // not needed

        public List<Category> items {get; set;}

        public Category() {
            items = new List<Category>();
            expanded = false;
        }

    }

    @AuraEnabled
    public static List<String> getStorefrontSet() {

        System.debug('inside getStorefrontSet()');

        Set<String> storefronts = new Set<String>();
        List<String> storefrontList = new List<String>();

        try {
            System.debug('getting configs');
            List<AggregateResult> configs = [SELECT ccrz__Storefront__c FROM ccrz__E_Configuration__c GROUP BY ccrz__Storefront__c];

            System.debug('looping through results');
            for (AggregateResult ag : configs) {
                String storefrontName = (String)ag.get('ccrz__Storefront__c');
                if(storefrontName != 'Global') {
                    storefronts.add(storefrontName);
                }
            }

            storefrontList.addAll(storefronts);

            System.debug('storefrontList.size = ' + storefrontList.size());
        } catch (Exception ex) {

            System.debug('error message: ' + ex.getMessage());
            System.debug('line number: ' + ex.getLineNumber());

        }

        System.debug('exit getStorefrontSet()');

        //storefrontList.add('DefaultStore');

        return storefrontList;
    }
}