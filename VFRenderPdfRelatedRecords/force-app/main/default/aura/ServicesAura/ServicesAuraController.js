({
    doInit : function(component, event, helper) {
		helper.recordTypeHelper(component);
	},

    handleOpen : function(component, event, helper) {
        var a = component.get("v.recordTypeName");
        a = a.replace(' ', '_');
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
          "url": "/apex/ServicePageAura?currentRecordId=" + component.get("v.recordId") + "&currentTypeName=" + a + "&startdate=" + component.get("v.startDate") + "&enddate=" + component.get("v.endDate")
        });
        urlEvent.fire();
    },
})
