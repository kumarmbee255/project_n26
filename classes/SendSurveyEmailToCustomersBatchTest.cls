/*@author  : Kumaresan Manickam
* @purpose : Test class for batch job SendSurveyEmailToCustomersBatch
* @date    : 03/07/2019
*/
@isTest
Private class SendSurveyEmailToCustomersBatchTest{
      
   @TestSetup
   static void SetupTestdata(){
       Account a=new Account(name='Test Account');
       insert a;
       
       List<Contact> contactListToinsert=new List<Contact>();
       Contact con1=new Contact(lastname='Test lastname1',email='sample1@gmail.com',Language__c='de',Survey_Date__c=system.today()); //contact with language 'de' with today as survey date
       contactListToinsert.add(con1);
       
       Contact con2=new Contact(lastname='Test lastname2',email='sample2@gmail.com',Language__c='en',Survey_Date__c=system.today()); //contact with language 'en' with today as survey date
       contactListToinsert.add(con2);
       
       Contact con3=new Contact(lastname='Test lastname3',email='sample3@gmail.com',Language__c='en',Survey_Date__c=(system.today()+1)); //contact with language 'en' with tomorrow as survey date
       contactListToinsert.add(con3);
       
       insert contactListToinsert;
   }
   
   testmethod static void ValidateBatchjob(){
       Test.startTest();
           Database.ExecuteBatch(new SendSurveyEmailToCustomersBatch());
       Test.StopTest();
       
       List<Contact> contactsProcessed=[Select id from contact where Survey_Date__c=null];
       System.assertEquals(2,contactsProcessed.size());//Ensure the job process the 2 contact records which was having today as survey date.
   }

}
