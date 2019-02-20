/*@author  : Kumaresan Manickam
* @purpose : Test class for batch job DisplayProductInformationController
* @date    : 03/07/2019
*/
@isTest
Private class DisplayProductInformationControllerTest{
   
   @TestSetup
   static void SetupTestdata(){
       
       product2 prod1 = new Product2(Name = 'Laptop X200', Family = 'Hardware');
       product2 prod2 = new Product2(Name = 'Laptop X201', Family = 'Hardware');
       insert new List<Product2>{prod1,prod2};
       
       Id pricebookId = Test.getStandardPricebookId();
       
       PricebookEntry standardPrice1 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod1.Id,UnitPrice = 10000, IsActive = true);
       PricebookEntry standardPrice2 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod2.Id,UnitPrice = 10001, IsActive = true);
       insert new List<PricebookEntry>{standardPrice1,standardPrice2};
       
       //create new pricebooks for different home countries we have.
       Pricebook2 customPB1 = new Pricebook2(Name='DE', isActive=true);
       Pricebook2 customPB2 = new Pricebook2(Name='FR', isActive=true);
       Pricebook2 customPB3 = new Pricebook2(Name='ES', isActive=true);
       Pricebook2 customPB4 = new Pricebook2(Name='IT', isActive=true);
       Pricebook2 customPB5 = new Pricebook2(Name='UK', isActive=true);
       insert new List<Pricebook2>{customPB1,customPB2,customPB3,customPB4,customPB5};
       
       //create new pricebook entries for products and pricebooks created
       PricebookEntry customPrice1 = new PricebookEntry(Pricebook2Id = customPB1.Id, Product2Id = prod1.Id,UnitPrice = 12000, IsActive = true);
       PricebookEntry customPrice2 = new PricebookEntry(Pricebook2Id = customPB2.Id, Product2Id = prod2.Id,UnitPrice = 12000, IsActive = true);
       PricebookEntry customPrice3 = new PricebookEntry(Pricebook2Id = customPB3.Id, Product2Id = prod1.Id,UnitPrice = 12000, IsActive = true);
       PricebookEntry customPrice4 = new PricebookEntry(Pricebook2Id = customPB4.Id, Product2Id = prod2.Id,UnitPrice = 12000, IsActive = true);
       PricebookEntry customPrice5 = new PricebookEntry(Pricebook2Id = customPB5.Id, Product2Id = prod1.Id,UnitPrice = 12000, IsActive = true);
       insert new List<PricebookEntry>{customPrice1,customPrice2,customPrice3,customPrice4,customPrice5};
       
       Account a=new Account(name='Test Account');
       insert a;
       
       List<Contact> contactListToinsert=new List<Contact>();
       //insert different contacts with diff home country and product associated
       Contact con1=new Contact(lastname='Test lastname1',email='sample1@gmail.com',Language__c='de',home_country__c='DE',Product__c=prod1.id); //contact with language 'de' with home country as 'DE'
       Contact con2=new Contact(lastname='Test lastname2',email='sample1@gmail.com',Language__c='de',home_country__c='FR',Product__c=prod2.id); //contact with language 'de' with home country as 'FR'
       Contact con3=new Contact(lastname='Test lastname3',email='sample1@gmail.com',Language__c='de',home_country__c='ES',Product__c=prod1.id); //contact with language 'de' with home country as 'ES'
       Contact con4=new Contact(lastname='Test lastname4',email='sample1@gmail.com',Language__c='de',home_country__c='IT',Product__c=prod2.id); //contact with language 'de' with home country as 'IT'
       Contact con5=new Contact(lastname='Test lastname5',email='sample1@gmail.com',Language__c='de',home_country__c='UK',Product__c=prod1.id); //contact with language 'de' with home country as 'UK'
       insert new List<Contact>{con1,con2,con3,con4,con5};
       
       //insert different cases with diff contacts associated
       Case cs1=new Case(contactId=con1.Id,subject='Test subject1',Origin='Email');
       Case cs2=new Case(contactId=con2.Id,subject='Test subject2',Origin='Email');
       Case cs3=new Case(contactId=con3.Id,subject='Test subject3',Origin='Email');
       Case cs4=new Case(contactId=con4.Id,subject='Test subject4',Origin='Email');
       Case cs5=new Case(contactId=con5.Id,subject='Test subject5',Origin='Email');
       Insert new List<Case>{cs1,cs2,cs3,cs4,cs5};       
   }
   
   //verify the test method returns the right product for contact with home country 'DE'
   testmethod static void VerifyProdcutInfoDE(){
       Case cs=[Select id from Case where subject='Test subject1']; //query case1 having contact 1 been set with home country as DE and product as prod 1
       DisplayProductInformationController.ProductInfo retrievedProduct=DisplayProductInformationController.getAssociatedProductInfo(cs.Id); //call the lightning method to fetch right product.
       Product2 prod1=[Select id from product2 where name='Laptop X200']; //query the inserted product for prod 1.
       system.assertEquals(prod1.id,retrievedProduct.productId);//valdiate the method returned product id matches with original inserted prod 1.
   }
   
   //verify the test method returns the right product for contact with home country 'FR'.
   testmethod static void VerifyProdcutInfoFR(){
       Case cs=[Select id from Case where subject='Test subject2']; //query case2 having contact2 been set with home country as FR and product as prod 2.
       DisplayProductInformationController.ProductInfo retrievedProduct=DisplayProductInformationController.getAssociatedProductInfo(cs.Id); //call the lightning method to fetch right product.
       Product2 prod2=[Select id from product2 where name='Laptop X201']; //query the inserted product for prod 2.
       system.assertEquals(prod2.id,retrievedProduct.productId);//valdiate the method returned product id matches with original inserted prod 2.
   }
   
   //verify the test method returns the right product for contact with home country 'ES'.
   testmethod static void VerifyProdcutInfoES(){
       Case cs=[Select id from Case where subject='Test subject3']; //query case3 having contact 3 been set with home country as ES and product as prod 1
       DisplayProductInformationController.ProductInfo retrievedProduct=DisplayProductInformationController.getAssociatedProductInfo(cs.Id); //call the lightning method to fetch right product.
       Product2 prod1=[Select id from product2 where name='Laptop X200']; //query the inserted product for prod 1.
       system.assertEquals(prod1.id,retrievedProduct.productId);//valdiate the method returned product id matches with original inserted prod 1.
   }
   
   //verify the test method returns the right product for contact with home country 'IT'.
   testmethod static void VerifyProdcutInfoIT(){
       Case cs=[Select id from Case where subject='Test subject4']; //query case4 having contact 4 been set with home country as IT and product as prod 2.
       DisplayProductInformationController.ProductInfo retrievedProduct=DisplayProductInformationController.getAssociatedProductInfo(cs.Id); //call the lightning method to fetch right product.
       Product2 prod2=[Select id from product2 where name='Laptop X201']; //query the inserted product for prod 2.
       system.assertEquals(prod2.id,retrievedProduct.productId);//valdiate the method returned product id matches with original inserted prod 2.
   }
   
   //verify the test method returns the right product for contact with home country 'UK'.
   testmethod static void VerifyProdcutInfoUK(){
       Case cs=[Select id from Case where subject='Test subject5']; //query case5 having contact 5 been set with home country as UK and product as prod 1
       DisplayProductInformationController.ProductInfo retrievedProduct=DisplayProductInformationController.getAssociatedProductInfo(cs.Id); //call the lightning method to fetch right product.
       Product2 prod1=[Select id from product2 where name='Laptop X200']; //query the inserted product for prod 1.
       system.assertEquals(prod1.id,retrievedProduct.productId);//valdiate the method returned product id matches with original inserted prod 1.
   }

}
