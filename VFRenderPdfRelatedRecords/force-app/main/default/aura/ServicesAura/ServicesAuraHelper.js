({
    recordTypeHelper : function(component, event, helper) {
		var action = component.get('c.servicesRecordTypeList');
        action.setCallback(this, function(response){
            var state = response.getState();      
            //alert('state ' + state);
            if(state == "SUCCESS"){
                var result = response.getReturnValue();
                //alert('result ' + JSON.stringify(result));                
                component.set('v.recordTypeList',result);
            }
        });
        $A.enqueueAction(action);
	},
    
})
