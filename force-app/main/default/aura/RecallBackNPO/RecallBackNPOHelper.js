({
	showHideDiv : function(component,toShowDiv) {
        var showhide = component.find('showhide');
        if(toShowDiv){
           $A.util.removeClass(showhide,'slds-show');
           $A.util.addClass(showhide,'slds-hide'); 
        }
	}
})