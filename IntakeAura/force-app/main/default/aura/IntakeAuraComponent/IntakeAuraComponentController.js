({
    doInit : function(component, event, helper) {
        var fields = [];
       
        var fl = component.get("v.fields").replace(/\s+/g, '');
        console.log('1', fl);
        fl = fl.split(",");

        fl.forEach(function(f) {
            fields.push(f);
        });
        console.log(fields);
        component.set("v.fieldsDisplay", fl);
    },

    selectedLookupChanged:function(component, event, helper) { 
        var recordId = component.get("v.selectedLookUpRecord").value;
        component.set("v.selectedRecordId", recordId);
    },

    handleSuccessUpdate:function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "type": "success",
            "message": "The record has been updated successfully."
        });
    toastEvent.fire();
    },

    handleSuccessCreate:function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "type": "success",
            "message": "The record has been created successfully."
        });
    toastEvent.fire();
    },

    handleErrorUpdate:function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Error!",
            "type": "error",
            "message": "The record has not been updated."
        });
    toastEvent.fire();
    },

    handleErrorCreate:function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Error!",
            "type": "error",
            "message": "The record has not been created."
        });
    toastEvent.fire();
    }
})
