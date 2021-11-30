({
    recordTypeHelper : function(component, event, helper) {
		var action = component.get('c.servicesRecordTypeList'); // get methdod of class
        action.setCallback(this, function(response){
            var state = response.getState();      
            if(state == "SUCCESS"){
                var result = response.getReturnValue(); // get all record types              
                component.set('v.recordTypeList',result); //  set all record types to component
            }
        });
        $A.enqueueAction(action);
	},
    
})
