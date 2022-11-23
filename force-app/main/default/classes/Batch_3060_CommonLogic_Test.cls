/*************************************************************************************************
* Name:        Batch_3060_CommonLogic_Test
* Author:      Suryanarayan Mishra
* Date:        23 Dec 2021
* Description: Test class for Batch_3060_CommonLogic
* ********************************************************************************************* */
@isTest
public with sharing class Batch_3060_CommonLogic_Test {
    
    @isTest
    static void test3060_1(){
        //Testtttt
        Id userRoleId = [SELECT Id FROM UserRole WHERE DeveloperName = 'SFDC_Developer' LIMIT 1].Id;
        Id profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        Id csProfileId = [SELECT Id FROM Profile WHERE Name = 'CR'].Id;
        
        User u = TestDataFactory_Utility.createGenUser(userRoleId, profileId, false);
        User taco = TestDataFactory_Utility.createGenUser(userRoleId, csProfileId, false);
        
        list<User> finalUList = new list<User>();           
        finalUList.add(u);           
        finalUList.add(taco);
        insert finalUList;
        
        System.runAs(u) {
            Id rtIdContractor = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Contractor').getRecordTypeId();
            
            Account persAcct = TestDataFactory_Utility.createPersonAccountOptional(rtIdContractor, false);            
            
            persAcct.RecordTypeId = Global_Utility_Constants.RECORD_TYPE_ID_PA_CONTRACTOR;
            persAcct.Status__c = 'Contractor';
            persAcct.Rollup_of_Weekly_Engagement_Hours__c = 0;
            persAcct.Hold_Status__c = '';
            persAcct.Date_Attended_BELAY_101__c = Date.today().addDays(-30);
            persAcct.No_of_Engagements_for_3060_email__c = 0;
            persAcct.Last_Hold_End_Date__c = NULL;
            //persAcct.Available__c = true;
            persAcct.Interested_in_serving_a_second_client__c = 'Yes';
            persAcct.Rollup_of_Monthly_Engagement_Hours__c = 0;
            persAcct.Total_No_Engagements_Served__c = 0;
            
            insert persAcct;
            
            Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Client').getRecordTypeId();
            
            Account acc = TestDataFactory_Utility.createAccount(recordTypeId);
            
            Contact con = TestDataFactory_Utility.createContact(acc.id);
            
            Engagement__c engagemnt = TestDataFactory_Utility.createEngagement(acc.Id, null, con.Id, u.Id, taco.Id);
            
            Job_Opening__c jo = TestDataFactory_Utility.createJobOpening(engagemnt.Id);
            
            Engagement_Contractor__c engContr = TestDataFactory_Utility.createECOptional(acc.Id, engagemnt.Id, jo.Id, false);
            
            engContr.Contractor_Engagement_Status__c = '';
            insert engContr;
            
            Test.startTest();
            
            //System.debug('before persAcct-->'+persAcct);
            
            //System.debug('persAcct-->'+[select id,RecordTypeId,Status__c,Number_Current_Engagements__c,
            //Hold_Status__c,Rollup_of_Weekly_Engagement_Hours__c,Available__c from Account where Id =: persAcct.Id]);
            
            Database.executeBatch(new Batch_3060_CommonLogic());
            
            //persAcct.Date_Attended_BELAY_101__c = Date.today().addDays(-60);
            //update persAcct;
            //Database.executeBatch(new Batch_3060_CommonLogic());
            
            Test.stopTest();     
        }
    }
    @isTest
    static void test3060_1b(){
        //Test
        Id userRoleId = [SELECT Id FROM UserRole WHERE DeveloperName = 'SFDC_Developer' LIMIT 1].Id;
        Id profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        Id csProfileId = [SELECT Id FROM Profile WHERE Name = 'CR'].Id;
        
        User u = TestDataFactory_Utility.createGenUser(userRoleId, profileId, false);
        User taco = TestDataFactory_Utility.createGenUser(userRoleId, csProfileId, false);
        
        list<User> finalUList = new list<User>();           
        finalUList.add(u);           
        finalUList.add(taco);
        insert finalUList;
        
        System.runAs(u) {
            Id rtIdContractor = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Contractor').getRecordTypeId();
            
            Account persAcct = TestDataFactory_Utility.createPersonAccountOptional(rtIdContractor, false);            
            
            persAcct.RecordTypeId = Global_Utility_Constants.RECORD_TYPE_ID_PA_CONTRACTOR;
            persAcct.Status__c = 'Contractor';
            persAcct.Rollup_of_Weekly_Engagement_Hours__c = 0;
            persAcct.Hold_Status__c = '';
            persAcct.Date_Attended_BELAY_101__c = Date.today().addDays(-30);
            persAcct.No_of_Engagements_for_3060_email__c = 0;
            persAcct.Last_Hold_End_Date__c = NULL;
            //persAcct.Available__c = true;
            persAcct.Interested_in_serving_a_second_client__c = 'Yes';
            persAcct.Rollup_of_Monthly_Engagement_Hours__c = 0;
            persAcct.Total_No_Engagements_Served__c = 2;
            
            insert persAcct;
            
            Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Client').getRecordTypeId();
            
            Account acc = TestDataFactory_Utility.createAccount(recordTypeId);
            
            Contact con = TestDataFactory_Utility.createContact(acc.id);
            
            Engagement__c engagemnt = TestDataFactory_Utility.createEngagement(acc.Id, null, con.Id, u.Id, taco.Id);
            
            Job_Opening__c jo = TestDataFactory_Utility.createJobOpening(engagemnt.Id);
            
            Engagement_Contractor__c engContr = TestDataFactory_Utility.createECOptional(acc.Id, engagemnt.Id, jo.Id, false);
            
            engContr.Contractor_Engagement_Status__c = '';
            insert engContr;
            
            Test.startTest();
            
            //System.debug('before persAcct-->'+persAcct);
            
            //System.debug('persAcct-->'+[select id,RecordTypeId,Status__c,Number_Current_Engagements__c,
            //Hold_Status__c,Rollup_of_Weekly_Engagement_Hours__c,Available__c from Account where Id =: persAcct.Id]);
            
            Database.executeBatch(new Batch_3060_CommonLogic());
            
            //persAcct.Date_Attended_BELAY_101__c = Date.today().addDays(-60);
            //update persAcct;
            //Database.executeBatch(new Batch_3060_CommonLogic());
            
            Test.stopTest();     
        }
    }
    @isTest
    static void test3060_2(){
        Id userRoleId = [SELECT Id FROM UserRole WHERE DeveloperName = 'SFDC_Developer' LIMIT 1].Id;
        Id profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        Id csProfileId = [SELECT Id FROM Profile WHERE Name = 'CR'].Id;
        
        User u = TestDataFactory_Utility.createGenUser(userRoleId, profileId, false);
        User taco = TestDataFactory_Utility.createGenUser(userRoleId, csProfileId, false);
        
        list<User> finalUList = new list<User>();           
        finalUList.add(u);           
        finalUList.add(taco);
        insert finalUList;
        
        System.runAs(u) {
            Id rtIdContractor = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Contractor').getRecordTypeId();
            
            Account persAcct = TestDataFactory_Utility.createPersonAccount(rtIdContractor);
            
            Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Client').getRecordTypeId();
            
            Account acc = TestDataFactory_Utility.createAccount(recordTypeId);
            
            Contact con = TestDataFactory_Utility.createContact(acc.id);
            
            Engagement__c engagemnt = TestDataFactory_Utility.createEngagement(persAcct.Id, null, con.Id, u.Id, taco.Id);
            
            Job_Opening__c jo = TestDataFactory_Utility.createJobOpening(engagemnt.Id);
            
            Engagement_Contractor__c engContr = TestDataFactory_Utility.createEngagementContractor(persAcct.Id, engagemnt.Id, jo.Id);
            engContr.Contractor_Engagement_Status__c = '';
            update engContr;
            
            Test.startTest();
            
            persAcct.RecordTypeId = Global_Utility_Constants.RECORD_TYPE_ID_PA_CONTRACTOR;
            persAcct.Status__c = 'Contractor';
            persAcct.No_of_Engagements_for_3060_email__c = 0;
            persAcct.Rollup_of_Weekly_Engagement_Hours__c = 0;
            persAcct.Hold_Status__c = NULL;
            persAcct.Date_Attended_BELAY_101__c = Date.today().addDays(-60); 
            persAcct.Last_Hold_End_Date__c = NULL;
            //persAcct.Available__c = true;
            persAcct.Interested_in_serving_a_second_client__c = 'Yes';
            persAcct.Rollup_of_Monthly_Engagement_Hours__c = 0;
            persAcct.Total_No_Engagements_Served__c = 0;
            
            update persAcct;
            
            Database.executeBatch(new Batch_3060_CommonLogic());
            
            Test.stopTest();
            
            
            
        }
    }
    
   
    
    @isTest
    static void test3060_4(){
        Id userRoleId = [SELECT Id FROM UserRole WHERE DeveloperName = 'SFDC_Developer' LIMIT 1].Id;
        Id profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
        Id csProfileId = [SELECT Id FROM Profile WHERE Name = 'CR'].Id;
        
        User u = TestDataFactory_Utility.createGenUser(userRoleId, profileId, false);
        User taco = TestDataFactory_Utility.createGenUser(userRoleId, csProfileId, false);
        
        list<User> finalUList = new list<User>();           
        finalUList.add(u);           
        finalUList.add(taco);
        insert finalUList;
        
        System.runAs(u) {
            Id rtIdContractor = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Contractor').getRecordTypeId();
            
            Account persAcct = TestDataFactory_Utility.createPersonAccount(rtIdContractor);
            
            Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Client').getRecordTypeId();
            
            Account acc = TestDataFactory_Utility.createAccount(recordTypeId);
            
            Contact con = TestDataFactory_Utility.createContact(acc.id);
            
            Engagement__c engagemnt = TestDataFactory_Utility.createEngagement(persAcct.Id, null, con.Id, u.Id, taco.Id);
            
            Job_Opening__c jo = TestDataFactory_Utility.createJobOpening(engagemnt.Id);
            
            Engagement_Contractor__c engContr = TestDataFactory_Utility.createEngagementContractor(persAcct.Id, engagemnt.Id, jo.Id);
            
            
            Test.startTest();
            
            engContr.Contractor_Engagement_Status__c = 'Transitioned - Not Active';
            engContr.End_Date__c = Date.today().addDays(-60);
            update engContr;
            
            persAcct.RecordTypeId = Global_Utility_Constants.RECORD_TYPE_ID_PA_CONTRACTOR;
            persAcct.Status__c = 'Contractor';
            persAcct.No_of_Engagements_for_3060_email__c = 0; 
            persAcct.Rollup_of_Weekly_Engagement_Hours__c = 0;
            persAcct.Hold_Status__c = NULL;
            persAcct.Date_Attended_BELAY_101__c = Date.today().addDays(-60);
            persAcct.Last_Hold_End_Date__c = NULL;
            //persAcct.Available__c = true;
            persAcct.Interested_in_serving_a_second_client__c = 'Yes';
            persAcct.Rollup_of_Monthly_Engagement_Hours__c = 0;
            persAcct.Total_No_Engagements_Served__c = 2;
            
            update persAcct;
            
            Database.executeBatch(new Batch_3060_CommonLogic());
            
            Test.stopTest();
            
            
            
        }
    }
    
   
    
    @isTest
    static void testSchedule_1(){
        //Schedule_Batch_3060_CommonLogic.execute();
        test.starttest();
        Schedule_Batch_3060_CommonLogic shObj = new Schedule_Batch_3060_CommonLogic ();   
        String chron = '0 0 11 * * ?';        
        system.schedule('Schedule3060', chron, shObj);
        test.stopTest();
    }
}