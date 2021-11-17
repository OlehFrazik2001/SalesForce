({
    init: function (cmp, event, helper) {
        cmp.set('v.columns', [
            {label: 'Name', fieldName: 'Name', type: 'text' ,editable: false},
            {label: 'Gender', fieldName: 'Gender__c', type: 'text' ,editable: true},
            {label: 'Age', fieldName: 'Age__c', type: 'text' ,editable: true},
            {label: 'SSN', fieldName: 'SSN__c', type: 'text' ,editable: true},


        ]);
        helper.fetchData(cmp,event, helper);
    },
    handleSaveEdition: function (cmp, event, helper) {
        var draftValues = event.getParam('draftValues');
        var action = cmp.get("c.updateIntakeMembers");
        action.setParams({"acc" : draftValues});
        action.setCallback(this, function(response) {
            var state = response.getState();
            $A.get('e.force:refreshView').fire();
            
        });
        $A.enqueueAction(action);
        
    },
})