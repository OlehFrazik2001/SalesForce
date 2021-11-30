({
    doInit : function(component, event, helper) {
		helper.recordTypeHelper(component); // get all record types
	},

    handleOpen : function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
          "url": "/apex/ServicePageAura?currentRecordId=" + component.get("v.recordId") + "&selectedRecordType=" + component.get("v.recordTypeName") + "&startdate=" + component.get("v.startDate") + "&enddate=" + component.get("v.endDate")
        }); // pass all parameters from component to url
        urlEvent.fire();
    },
})
