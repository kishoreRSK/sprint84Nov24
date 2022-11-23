@isTest
public class ContractorMatchingController_Test {
    
    @isTest(SeeAllData=true)
    static  void test() {
        test.startTest();

        UserRole role = [SELECT Id FROM UserRole WHERE DeveloperName = 'SFDC_Developer' LIMIT 1];
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'last',
            Email = 'cube@dev.com',
            Username = 'cube@dev.com' + System.currentTimeMillis(),
            CompanyName = 'Cube84',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            Disable_Automations__c = true,
            UserRoleId = role.Id,
            LocaleSidKey = 'en_US');
        
        User taco = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'CR'].Id,
            LastName = 'coordinator',
            Email = 'cube@test.com',
            Username = 'cube@test.com' + System.currentTimeMillis(),
            CompanyName = 'BELAY',
            Title = 'Placement Coordinator',
            Alias = 'abcle',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            Disable_Automations__c = true,
            UserRoleId = role.Id,
            LocaleSidKey = 'en_US'); 
        list<User> finalUList = new list<User>();           
        finalUList.add(u);           
        finalUList.add(taco);
        insert finalUList;
        
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Contractor').getRecordTypeId();
        
        User testUser = [SELECT Id, Username, UserRoleId FROM User WHERE Profile.Name = 'CR' AND IsActive=true LIMIT 1];
        
        Id recordTypeId2 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Client').getRecordTypeId();
        //testgit
        System.runAs(new user(ID = UserInfo.getUserID())){
            Account clientAcc = new Account(Name='Test',Business_Level_new__c='For-Profit',RecordTypeId=recordTypeId2);
            insert clientAcc;
            
            System.RunAs(u) {
                Account acc = new Account(FirstName = 'TestCommuy2', LastName='Test',Status__c='Contractor',
                                          Contractor_Service_Line__c='Bookkeeper',RecordTypeId=recordTypeId,
                                          //Availability__c = true , 
                                          PersonEmail = 'abfc@cube84.com', 
                                          Total_Hours_Desired_Monthly__c = '65', Computer_Preference__pc = 'No Preference',
                                          Date_Last_Placed__c = system.today()+50,
                                          Test_Record3__c = False
                                         );
                insert acc;
                
                
                Contact con = new Contact (FirstName = 'TestCommunity2' , LastName = 'Test Contact 1', AccountId = clientAcc.Id, Role_Title__c = 'CEO', Email = 'abc@cube84.com');
                insert con;
                
                Opportunity opp = new Opportunity (Name = 'Test Opporunity 1', Client_Contact__c = con.Id, StageName = 'Qualification', Service_Line_new__c = 'Virtual Assistant', CloseDate = Date.today(), Business_Level__c = 'For-Profit');
                insert opp;
                
                Account accc = [SELECT Id, FirstName FROM Account WHERE FirstName = 'TestCommuy2' LIMIT 1];
                
                Engagement__c engage = new Engagement__c(Name='Test',Client__c=clientAcc.Id,TACO__c = taco.Id,Lead_Delegated_Virtually__c=false,Contractor__c = accc.Id,  Opportunity__c = opp.Id,Monthly_Hours_of_Engagement__c = 65,CSC__c = u.id);
                insert engage;
                //Hours_new__c='22 hours/month',
                Job_Opening__c job = new Job_Opening__c(Category__c='Bookkeeper',
                                                        Status__c ='Active - P',
                                                        Other_Tasks_Projects_new__c = 'test',
                                                        Exp_Acc_Payroll_Apps_Used_by_client__c = 'ADP',
                                                        Preferred_Contractor_Time_Zone__c='No Preference',
                                                        Industry_Experience__c='Agriculture',
                                                        Preferred_Computer__c='No Preference', 
                                                        Anticipated_Tasks_Projects__c = 'Project Management',
                                                        Engagement_Name__c= engage.Id,
                                                        Win__c = 'test',
                                                        Web_Social_Media_Tasks_Projects__c ='CSS',
                                                        General_Apps_Used_by_Client__c = 'Box',
                                                        Task_Project_Mngmt_Apps_Used_by_Client__c = 'Slack',
                                                        Church_Management_Apps_Used_by_Client__c = 'Elvanto',
                                                        CRM_Apps_Used_by_Client__c = 'SalesForce', 
                                                        Email_Platform_Used_by_Client__c = 'Yahoo' ,
                                                        Social_Media_Apps_Used_by_Client__c = 'Buffer',
                                                        Website_Platforms_Used_by_Client__c = 'WordPress', 
                                                        Anticipating_Growth_within_90_Days__c = true,
                                                        Client_Time_Zone__c='Eastern Time',
                                                        Good_to_Know__c = 'test',
                                                        Other_AppsToolsPrograms_UsedbyClient_new__c = 'test',
                                                        Placement_Status__c=' Initial - Placement', 
                                                        Growth__c='Test',
                                                        Job_ID__c = 'cube 84',
                                                        TACO__c = taco.id
                                                       );
                
                insert job; 
                
                ContractorMatchingController.ContractorMatchingWrapper a = ContractorMatchingController.getMatchingContractors(job.Id);
                ContractorMatchingController.ContractorMatchingWrapper b = ContractorMatchingController.getFilteredContractors(job.Id, 'Central Time', 'No Preference','Agriculture', true, true, true, true);
                List<String> selectedAccounts = new List<String>();
                selectedAccounts.add(accc.Id);
                String id = job.Id;
                ContractorMatchingController.createApplication(id, selectedAccounts);
                test.stopTest();
            }
        }
    }
}