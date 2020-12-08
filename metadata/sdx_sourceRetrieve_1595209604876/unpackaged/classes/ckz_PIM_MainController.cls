public with sharing class ckz_PIM_MainController {

    @AuraEnabled
    public static Map<String, Object> checkRecordId(String recordId) {

        Map<String, Object> responseMap = new Map<String, Object>();

        Boolean isProduct = false;

        System.debug('recordId: ' + recordId);

        if(recordId != null && recordId.equals('') == false) {
            isProduct = isRecordIdProductId(recordId);
        }

        responseMap.put('recordId', recordId);
        responseMap.put('isProduct', isProduct);

        return responseMap;

    }

    private static Boolean isRecordIdProductId(String recordId) {

        Boolean isProduct = false;

        try {
           List<ccrz__E_Product__c> objList = [Select 
           Id, 
           Name 
           from ccrz__E_Product__c where Id = :recordId];

            if(objList != null && objList.size() > 0) {

                isProduct = true;
            }

        } catch (Exception e) {
           
        }

        return isProduct;
    }

    // Originally in ckz_PIM_ProductChooserController
    @AuraEnabled
    public static Map<String, Object> fetchProductData(String recordId) {

        Map<String, Object> productDataMap = new Map<String, Object>();

        System.debug('recordId: ' + recordId);

        Map<String, Object> productDetails = getProductObjData(recordId);

        if(productDetails == null) {
            productDataMap.put('errorMsg', 'Product could not be found');
        }
        else {
            productDataMap.put('productDetails', productDetails);

            // Get product price list data

            List<Object> priceListEntries = getPriceListObjData(recordId);

            productDataMap.put('priceListEntries', priceListEntries);

            // Get product media data

            List<Object> productMediaEntries = getProductMediaObjData(recordId);

            productDataMap.put('productMediaEntries', productMediaEntries);

            // Get product category data

            List<Object> productCategoryEntries = getProductCategoryObjData(recordId);

            productDataMap.put('productCategoryEntries', productCategoryEntries);

            // Get product spec data

            List<Object> productSpecEntries = getProductSpecObjData(recordId);

            productDataMap.put('productSpecEntries', productSpecEntries);

            // Get related product data

            List<Object> relatedProductEntries = getRelatedProductObjData(recordId);

            productDataMap.put('relatedProductEntries', relatedProductEntries);

        }

        return productDataMap;

    }

    private static Map<String, Object> getProductObjData(String recordId) {

        Map<String, Object> productDetails = null;

        try {
            ccrz__E_Product__c obj = [Select
                    Id,
                    Name,
                    ccrz__SKU__c,
                    ccrz__ShortDescRT__c,
                    ccrz__LongDescRT__c,
                    ccrz__ProductStatus__c,
                    ccrz__SEOTitle__c,
                    ccrz__Storefront__c,
                    ccrz__ProductType__c,
                    ccrz__UnitOfMeasure__c,
                    ccrz__StartDate__c,
                    ccrz__EndDate__c
            from ccrz__E_Product__c where Id = :recordId];

            if(obj != null) {

                productDetails = new Map<String, Object>();

                productDetails.put('sfid', obj.Id);
                productDetails.put('name', obj.Name);
                productDetails.put('sku', obj.ccrz__SKU__c);
                productDetails.put('shortDesc', obj.ccrz__ShortDescRT__c);
                productDetails.put('longDesc', obj.ccrz__LongDescRT__c);
                productDetails.put('status', obj.ccrz__ProductStatus__c);
                productDetails.put('seoTitle', obj.ccrz__SEOTitle__c);
                productDetails.put('selectedStorefronts', obj.ccrz__Storefront__c);
                productDetails.put('productType', obj.ccrz__ProductType__c);
                productDetails.put('uom', obj.ccrz__UnitOfMeasure__c);
                productDetails.put('startDate', obj.ccrz__StartDate__c);
                productDetails.put('endDate', obj.ccrz__EndDate__c);
            }

        } catch (Exception e) {

        }

        return productDetails;
    }

    private static List<Object> getPriceListObjData(String recordId) {

        List<Object> entries = new List<Object>();


        List<ccrz__E_PriceListItem__c> objList = [Select Id, Name,
                ccrz__Pricelist__c,
                ccrz__Price__c,
                ccrz__StartDate__c,
                ccrz__EndDate__c
        from ccrz__E_PriceListItem__c where ccrz__Product__c = :recordId];

        if(objList != null && objList.size() > 0) {

            for(ccrz__E_PriceListItem__c obj : objList) {

                Map<String, Object> entry = new Map<String, Object>();

                entry.put('sfid', obj.Id);
                entry.put('priceList', obj.ccrz__Pricelist__c);
                entry.put('price', obj.ccrz__Price__c);
                entry.put('startDate', obj.ccrz__StartDate__c);
                entry.put('endDate', obj.ccrz__EndDate__c);

                entries.add(entry);
            }

        }

        return entries;

    }

    private static List<Object> getProductMediaObjData(String recordId) {
        List<Object> entries = new List<Object>();

        List<ccrz__E_ProductMedia__c> objList = [Select Id, Name,
                ccrz__Enabled__c,
                ccrz__MediaType__c,
                ccrz__ProductMediaSource__c,
                ccrz__Sequence__c,
                ccrz__Locale__c,
                ccrz__URI__c,
                ccrz__StaticResourceName__c,
                ccrz__FilePath__c,
                ccrz__StartDate__c,
                ccrz__EndDate__c
        from ccrz__E_ProductMedia__c where ccrz__Product__c = :recordId];

        if(objList != null && objList.size() > 0) {

            for(ccrz__E_ProductMedia__c obj : objList) {

                Map<String, Object> entry = new Map<String, Object>();

                entry.put('sfid', obj.Id);
                entry.put('enabled', obj.ccrz__Enabled__c);
                entry.put('mediaType', obj.ccrz__MediaType__c);
                entry.put('mediaSource', obj.ccrz__ProductMediaSource__c);
                entry.put('sequence', obj.ccrz__Sequence__c);
                entry.put('locale', obj.ccrz__Locale__c);
                entry.put('uri', obj.ccrz__URI__c);
                entry.put('staticResourceName', obj.ccrz__StaticResourceName__c);
                entry.put('filePath', obj.ccrz__FilePath__c);
                entry.put('startDate', obj.ccrz__StartDate__c);
                entry.put('endDate', obj.ccrz__EndDate__c);

                entries.add(entry);
            }

        }

        return entries;

    }

    private static List<Object> getProductCategoryObjData(String recordId) {
        List<Object> entries = new List<Object>();

        List<ccrz__E_ProductCategory__c> objList = [Select Id, Name,
                ccrz__Category__r.Name,
                ccrz__Category__c,
                ccrz__Sequence__c,
                ccrz__StartDate__c,
                ccrz__EndDate__c
        from ccrz__E_ProductCategory__c where ccrz__Product__c = :recordId];

        if(objList != null && objList.size() > 0) {

            for(ccrz__E_ProductCategory__c obj : objList) {

                Map<String, Object> entry = new Map<String, Object>();

                entry.put('sfid', obj.Id);
                entry.put('categoryId', obj.ccrz__Category__c);
                entry.put('sequence', obj.ccrz__Sequence__c);
                entry.put('startDate', obj.ccrz__StartDate__c);
                entry.put('endDate', obj.ccrz__EndDate__c);
                entry.put('categoryName', obj.ccrz__Category__r.Name);

                entries.add(entry);
            }

        }

        return entries;

    }

    private static List<Object> getProductSpecObjData(String recordId) {
        List<Object> entries = new List<Object>();

        List<ccrz__E_ProductSpec__c> objList = [Select Id, Name,
                ccrz__Product__r.Name,
                ccrz__Spec__r.Name,
                ccrz__Spec__c,
                ccrz__SpecValue__c
        from ccrz__E_ProductSpec__c where ccrz__Product__c = :recordId
        order by ccrz__Spec__r.ccrz__Sequence__c, ccrz__Spec__r.Name];

        if(objList != null && objList.size() > 0) {

            for(ccrz__E_ProductSpec__c obj : objList) {

                Map<String, Object> entry = new Map<String, Object>();

                entry.put('sfid', obj.Id);
                entry.put('specId', obj.ccrz__Spec__c);
                entry.put('productSpecValue', obj.ccrz__SpecValue__c);
                entry.put('specName', obj.ccrz__Spec__r.Name);

                entries.add(entry);
            }

        }

        return entries;

    }

    private static List<Object> getRelatedProductObjData(String recordId) {
        List<Object> entries = new List<Object>();

        List<ccrz__E_RelatedProduct__c> objList = [Select Id, Name,
                ccrz__RelatedProduct__r.Name,
                ccrz__RelatedProduct__r.ccrz__SKU__c,
                ccrz__Enabled__c,
                ccrz__RelatedProductType__c,
                ccrz__Sequence__c,
                ccrz__RelatedProduct__c,
                ccrz__StartDate__c,
                ccrz__EndDate__c
        from ccrz__E_RelatedProduct__c where ccrz__Product__c = :recordId];

        if(objList != null && objList.size() > 0) {

            for(ccrz__E_RelatedProduct__c obj : objList) {

                Map<String, Object> entry = new Map<String, Object>();

                entry.put('sfid', obj.Id);
                entry.put('enabled', obj.ccrz__Enabled__c);
                entry.put('productType', obj.ccrz__RelatedProductType__c);
                entry.put('sequence', obj.ccrz__Sequence__c);
                entry.put('relatedProductId', obj.ccrz__RelatedProduct__c);
                entry.put('startDate', obj.ccrz__StartDate__c);
                entry.put('endDate', obj.ccrz__EndDate__c);
                entry.put('relatedProductName', obj.ccrz__RelatedProduct__r.Name);
                entry.put('relatedProductSku', obj.ccrz__RelatedProduct__r.ccrz__SKU__c);

                entries.add(entry);
            }

        }

        return entries;

    }

}