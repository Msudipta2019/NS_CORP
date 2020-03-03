public with sharing class NS_ExceptionUtility {
    
    public static void createExceptionRecord(Exception exp, String class_Name, String method_Name){
        Exception__c excep = new Exception__c();
        excep.Name = exp.getTypeName(); 
        excep.Class_Name__c = class_Name;
        excep.Method_Name__c = method_Name;
        if(exp.getMessage().length()<255){
      		excep.Description__c = exp.getMessage();
        }else{
           	excep.Description__c=  exp.getMessage().substring(0, 254);
        }        
        excep.Line_No__c = exp.getLineNumber();
        insert excep;
    }

}