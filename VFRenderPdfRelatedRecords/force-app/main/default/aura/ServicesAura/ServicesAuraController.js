({
    doInit : function(component, event, helper) {
		helper.recordTypeHelper(component); // get all record types
	},

    handleOpen : function(component, event, helper) {
        var a = component.get("v.recordTypeName"); // get record type name
        a = a.replace(' ', '_'); // replace all spaces from record type name to set record type developer name
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
          "url": "/apex/ServicePageAura?currentRecordId=" + component.get("v.recordId") + "&currentTypeName=" + a + "&startdate=" + component.get("v.startDate") + "&enddate=" + component.get("v.endDate")
        }); // pass all parameters from component to url
        urlEvent.fire();
    },
})
