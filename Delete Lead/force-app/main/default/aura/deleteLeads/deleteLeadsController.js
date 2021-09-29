({
    showToastAfterConfirmation: function(component, event, helper) {
        var resultsToast = $A.get("e.force:showToast");
        resultsToast.setParams({
            "title": "Starting the deletion of all Lead records.",
            "message": " This may take a while. You will receive an email once the deletion has finished"
        });
        resultsToast.fire();

        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
        
        var action = component.get("c.deleteLeads");
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state == 'SUCCESS') {
                console.log(state);
            }
            else{
                console.log(111);
            }
        });
        $A.enqueueAction(action);
    },
    
    closeWindow: function(component, event, helper) {
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    }

})
