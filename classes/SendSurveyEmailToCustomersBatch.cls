/*@author  : Kumaresan Manickam
* @purpose : Batch job which is used to send survey link to users in their preferred language on the specific survey date.
* @date    : 02/07/2019
* @script to schedule this job: Databse.Execute(new SendSurveyEmailToCustomersBatch()); Schedule this batch job daily at end of the day as needed.
*/
Global class SendSurveyEmailToCustomersBatch implements Database.Batchable<sObject>, Database.Stateful {
     
     Map<String,Id> n26emailTemplatesMap;//Use Database.Stateful interface to maintain the variable state
     Id orgWideEmailAddressId;//Use Database.Stateful interface to maintain the variable state
     
    //constructor of the batch job which pulls the all valid email templates which is under 'N26 Email folder' & to pull the org wide email address.
     global SendSurveyEmailToCustomersBatch(){
         n26emailTemplatesMap=new Map<String,Id>();
         for(EmailTemplate template:[Select id,name,DeveloperName,folderId from EmailTemplate where folder.developername='N26_Email_Folder']){
             n26emailTemplatesMap.put(template.DeveloperName,template.Id);
         }
         List<OrgWideEmailAddress> orgWideEmailAddress=[SELECT Id, Address FROM OrgWideEmailAddress WHERE DisplayName='Do not Reply N26'];
         if(!orgWideEmailAddress.isEmpty())
             orgWideEmailAddressId=orgWideEmailAddress[0].Id;
     }
     
    //Start method which returns the contact records based on the survey date if it's today.
     global Database.QueryLocator start(Database.BatchableContext context) {
         return Database.getQueryLocator('Select id,firstname,Language__c,Survey_Date__c,Reason_for_last_survey_failure__c from contact where Survey_Date__c=today and Email!=null');
     }
     
    //Execute method which conditionally checks each contact and sends email to the users based on their preferred language.
     global void execute(Database.BatchableContext context, List<contact> customerList) {
         List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
         Map<Id,contact> customerMapToUpdate=new Map<Id,contact>();
         List<contact> customerListFailureList=new List<contact>();
         
         for(contact c:customerList){
             String templateName='Survey_Email_'+c.Language__c; //Email tempalte API name is formatted to use the valid language code to match with contact's language.
             if(n26emailTemplatesMap.containsKey(templateName) && n26emailTemplatesMap.get(templateName)!=null){
                 Messaging.SingleEmailMessage singleMail= new Messaging.SingleEmailMessage();
                 singleMail.setTemplateId(n26emailTemplatesMap.get(templateName));
                 singleMail.setTargetObjectId(c.Id);
                 singleMail.setSaveAsActivity(false);                 
                 singleMail.setOrgWideEmailAddressId(orgWideEmailAddressId); // Use Organization Wide Address
                 emails.add(singleMail);
                 
                 c.Survey_Date__c=null;//Blank survey date once its processed.
                 c.Reason_for_last_survey_failure__c ='';//Field used to store latest email failure in sending survey link
                 customerMapToUpdate.put(c.id,c);
             }
         }
         
         try{
            if(!emails.isEmpty()) {
                Messaging.reserveSingleEmailCapacity(emails.size());//Reserve the capacity for the upcoming email operations.

                Messaging.SendEmailResult[] emailResultList=Messaging.sendEmail(emails,false);//Set AllOrNone parameter on this method to 'False' to acheieve particial success. Store the result in result object to update its contact record with failures.
                for(Messaging.SendEmailResult r:emailResultList){
                    if(!r.isSuccess()){
                        for(Messaging.SendEmailError err:r.getErrors()){
                            if(err.getTargetObjectId()!=null && customerMapToUpdate.containsKey(err.getTargetObjectId()) && customerMapToUpdate.get(err.getTargetObjectId())!=null){
                                customerMapToUpdate.get(err.getTargetObjectId()).Survey_Date__c=System.today(); //Update the servey date back to the field, so that admin will determine the problem in laterpoint of time.
                                customerMapToUpdate.get(err.getTargetObjectId()).Reason_for_last_survey_failure__c+=err.getMessage(); //Update the conatct with failure info for debugging purpose.
                            }
                        }
                    }
                }
                
                if(customerMapToUpdate.values() != null && !customerMapToUpdate.values().isEmpty()){
                    update customerMapToUpdate.values();//Update contact records.
                }
            }
         }catch(Exception e){
             //Process this exception by sending an email in finish method if any.
            system.debug('###Unknown Exception in batch job SendSurveyEmailToCustomersBatch: '+e.getMessage()+'--Error Trace:'+e.getStackTraceString()); 
         }
     }
     
     global void finish(Database.BatchableContext context){}
}
