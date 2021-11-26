({
    recordTypeHelper : function(component, event, helper) {
		var action = component.get('c.servicesRecordTypeList');
        action.setCallback(this, function(response){
            var state = response.getState();      
            if(state == "SUCCESS"){
                var result = response.getReturnValue();              
                component.set('v.recordTypeList',result);
            }
        });
        $A.enqueueAction(action);
	},
    
})
