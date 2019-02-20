/*@author  : Kumaresan Manickam
* @purpose : This is the controller for 'DisplayProdcutInformation' lightning component which is having its aua enabled utility methods to pull the product information for th associated case's contact record based on the contact's home country & product field values.
* @date    : 02/08/2019
*/
public class DisplayProductInformationController {
    //Inner class which holds the prodcut information to display
    Public class ProductInfo{
        @auraEnabled
        Public string productName {get; set;}
        @auraEnabled
        Public Id productId {get; set;}
        @auraEnabled
        Public Decimal productBasePrice {get; set;}
        @auraEnabled
        Public string productCountry {get; set;}
        @auraEnabled
        Public string productATMFeePercent {get; set;}
        @auraEnabled
        Public Decimal productCardReplacementFee {get; set;}
        
        Public ProductInfo(String productName,Decimal productBasePrice,String productCountry,Id productId){
           this.productName=productName;
           this.productBasePrice=productBasePrice;
           this.productCountry=productCountry;       
           this.productId=productId;
        }
    }
    
    //Method which retrives the prodcut information based on the 'Home country'(Here its configured in price book) field & product field of associated contact.
    @auraEnabled
    public static ProductInfo getAssociatedProductInfo(Id caseId){
        List<Case> caseInfo=[Select id,contactId,contact.product__c,contact.home_country__c from case where Id=:caseId];
        if(!caseInfo.isEmpty()){
            PricebookEntry productPriceBook=[Select Id,Pricebook2Id,Pricebook2.name,Pricebook2.Id,IsActive,Name,Product2Id,Product2.Name,Product2.ATM_Fee_in_other_currencies_DE__c,Product2.ATM_Fee_in_other_currencies_ES__c, Product2.ATM_Fee_in_other_currencies_FR__c, Product2.ATM_Fee_in_other_currencies_IT__c, Product2.ATM_Fee_in_other_currencies_UK__c, Product2.Card_Replacement_Cost_DE__c,Product2.Card_Replacement_Cost_ES__c, Product2.Card_Replacement_Cost_FR__c, Product2.Card_Replacement_Cost_IT__c, Product2.Card_Replacement_Cost_UK__c,UnitPrice from PricebookEntry where Pricebook2.name=:caseInfo[0].contact.home_country__c AND Product2Id=:caseInfo[0].contact.product__c Limit 1];//SOQL to pull the right pricebookentry record based on the home country.,
            
            ProductInfo p=new ProductInfo(productPriceBook.Product2.Name,productPriceBook.UnitPrice,caseInfo[0].contact.home_country__c,productPriceBook.Product2.Id);            
            
            //conditionally check the contact's home country to get the right atm fee & card replacement charges from product record.
            if(caseInfo[0].contact.home_country__c =='DE'){
                p.productATMFeePercent=(productPriceBook.Product2.ATM_Fee_in_other_currencies_DE__c != null && productPriceBook.Product2.ATM_Fee_in_other_currencies_DE__c != 0) ? string.ValueOf(productPriceBook.Product2.ATM_Fee_in_other_currencies_DE__c)+'%' : 'Free';
            	p.productCardReplacementFee=productPriceBook.Product2.Card_Replacement_Cost_DE__c;
            }
            else if(caseInfo[0].contact.home_country__c =='FR'){
                p.productATMFeePercent=(productPriceBook.Product2.ATM_Fee_in_other_currencies_FR__c != null && productPriceBook.Product2.ATM_Fee_in_other_currencies_FR__c != 0) ? string.ValueOf(productPriceBook.Product2.ATM_Fee_in_other_currencies_FR__c)+'%' : 'Free';
            	p.productCardReplacementFee=productPriceBook.Product2.Card_Replacement_Cost_FR__c;
            }
            else if(caseInfo[0].contact.home_country__c =='ES'){
                p.productATMFeePercent=(productPriceBook.Product2.ATM_Fee_in_other_currencies_ES__c != null && productPriceBook.Product2.ATM_Fee_in_other_currencies_ES__c != 0) ? string.ValueOf(productPriceBook.Product2.ATM_Fee_in_other_currencies_ES__c)+'%' : 'Free';
            	p.productCardReplacementFee=productPriceBook.Product2.Card_Replacement_Cost_ES__c;
            }
            else if(caseInfo[0].contact.home_country__c =='IT'){
                p.productATMFeePercent=(productPriceBook.Product2.ATM_Fee_in_other_currencies_IT__c != null && productPriceBook.Product2.ATM_Fee_in_other_currencies_IT__c != 0) ? string.ValueOf(productPriceBook.Product2.ATM_Fee_in_other_currencies_IT__c)+'%' : 'Free';
            	p.productCardReplacementFee=productPriceBook.Product2.Card_Replacement_Cost_IT__c;
            }
            else if(caseInfo[0].contact.home_country__c =='UK'){
                p.productATMFeePercent=(productPriceBook.Product2.ATM_Fee_in_other_currencies_UK__c != null && productPriceBook.Product2.ATM_Fee_in_other_currencies_UK__c != 0) ? string.ValueOf(productPriceBook.Product2.ATM_Fee_in_other_currencies_UK__c)+'%' : 'Free';
            	p.productCardReplacementFee=productPriceBook.Product2.Card_Replacement_Cost_UK__c;
            }
            return p;
        }     
        return null;
    }
}
