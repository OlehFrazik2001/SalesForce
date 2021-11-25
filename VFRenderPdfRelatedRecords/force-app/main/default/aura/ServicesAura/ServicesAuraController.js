({
    doInit : function(component, event, helper) {
		helper.recordTypeHelper(component);
	},

    handleOpenInNewWindow : function(component, event, helper) {
        var action = component.get("c.getServices1");
        console.log(component.get("v.recordTypeName"));
        action.setParams({ 
            recordTypeName : component.get("v.recordTypeName"),
            currentRecordId : component.get("v.currentRecordId"),
            startDate : component.get("v.startDate"),
            endDate : component.get("v.endDate")
        });
        console.log(component.get("v.startDate"));
        $A.enqueueAction(action);
         
        window.open('/apex/ServicePageAura', '_blank');
    },
})
