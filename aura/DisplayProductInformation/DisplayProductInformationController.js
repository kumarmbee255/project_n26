({
	doInit : function(component, event, helper) {
		var caseId = component.get("v.recordId");//get the case record id from context
        var getProductInfo = component.get("c.getAssociatedProductInfo");//invoke method to get the product information associated to case's contact record.
        getProductInfo.setParams({
            caseId : component.get("v.recordId")
        });
        
        getProductInfo.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var productInfo = response.getReturnValue();
                component.set("v.productInformation", response.getReturnValue());
            } 
            else{
                component.set("v.componentErrors",'No product information found.'); //display info to user in case of no product associated/found.
            }
        });        
         
        
        $A.enqueueAction(getProductInfo); 
	}
}) 
