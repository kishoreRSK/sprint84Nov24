/*************************************************************************************************
* Name:        Batch_3060_CommonLogic
* Author:      Suryanarayan Mishra
* Date:        21 Dec 2021
* Description: Batch to send 30 days email and 60 days task.
*              Covering 4 sub scenarios.(Account & EC object).
* ****************************************************************z******************************/
global class Batch_3060_CommonLogic implements Database.Batchable<sObject>, Database.Stateful {
    
    map<id,string> errMsgMap = new map<id,string>();
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        id accRecTypeContractorID = Global_Utility_Constants.RECORD_TYPE_ID_PA_CONTRACTOR;
        //system.debug('accRecTypeContractorID---->'+accRecTypeContractorID);
        String query;
        query = 'select id, Status__c,Date_Attended_BELAY_101__c,Date_Stamp_for_3060_Email__c,No_of_Engagements_BE__c,Hold_Status__c,Status_Moves_from_On_Hold_to_None__c,Belay_101_Email__c,X30_60_Belay_Term_Transition_Email__c,X30_60_False_Start_Email__c,X30_60_On_Hold_Email__c,';
        query +='Hold_End_Date__c,Last_Hold_End_Date__c,Availability__c,Total_No_Engagements_Served__c,Rollup_of_Weekly_Engagement_Hours__c,No_of_Engagements_for_3060_email__c,Rollup_of_Monthly_Engagement_Hours__c,OwnerId,RecordTypeId,PersonEmail from account ';
        query +='where RecordTypeId =\'' + accRecTypeContractorID + '\'';
        query +=' AND Status__c = \'Contractor\'';
        query +=' AND No_of_Engagements_for_3060_email__c = 0';
        query +=' AND (Hold_Status__c = NULL OR Status_Moves_from_On_Hold_to_None__c = True)';
        query +=' AND Rollup_of_Monthly_Engagement_Hours__c  = 0';
        query +=' AND Date_Stamp_for_3060_Email__c != NULL';
        system.debug('Query---->'+Database.query(query));
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<Account> perAccList) {
        
        //Variable declaration Section.
        List<Account> accList = new List<Account> ();
        List<Task> tskList = new List<Task>();
        List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
        List<Account> accEmailList = new List<Account>();
        
        //Change the custom lable to set the from email....
        OrgWideEmailAddress owea = [select Id,DisplayName, Address 
                                    from OrgWideEmailAddress 
                                    where Address = : system.label.UID_FromEmail
                                    LIMIT 1];  
        
        EmailTemplate templateBelay101 = [Select id 
                                          from EmailTemplate 
                                          where name = '30 Day Check in - Post BELAY 101'];
       
        EmailTemplate templateGeneric = [Select id 
                                              from EmailTemplate 
                                              where name = '30 Day Check In - Generic'];
        
        //system.debug('perAccList--->'+perAccList);
        //building map to get EC of Corresponding Acc
        
        DateTime dt = Datetime.now();                         
        for(Account acc : perAccList) 
        {
             //Scenario 1: Eng served = 0 - 5288 - ticket
            if (acc.Date_Attended_BELAY_101__c != NULL &&
                acc.Status__c == 'Contractor' &&
                acc.No_of_Engagements_for_3060_email__c == 0 &&    
                string.isEmpty(acc.Hold_Status__c) == true && 
                acc.Total_No_Engagements_Served__c == 0 )
            {
                system.debug('1>>'+acc.Id);
                system.debug('2>>'+acc.Date_Stamp_for_3060_Email__c);
                system.debug('3>>'+acc.Date_Attended_BELAY_101__c);
                //Scenario 1.1: Zero EC Record - Date Attended BELAY 101
                
                //Scenario 1.1.1: For 30 days difference send email
                if(acc.Date_Stamp_for_3060_Email__c != NULL && acc.Date_Stamp_for_3060_Email__c.daysBetween(system.today()) == 30)
                {
                   
                    system.debug('Total = 0 condition achieved>>'+acc.Id);
                    //Mail1
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    List<String> sendTo = new List<String>();
                    sendTo.add(acc.PersonEmail);
                    mail.setToAddresses(sendTo);
                    //Salesforce limitation to set setTargetObjectId to contact id to use whatId for merge fields.
                    mail.setTargetObjectId(Global_Utility_Constants.USERID_TECH_CONTACT); 
                    mail.setTreatTargetObjectAsRecipient(false);
                    mail.setOrgWideEmailAddressId(owea.Id);
                    mail.setReplyTo('greer.ferguson@belaysolutions.com');
                    mail.setSaveAsActivity(false);
                    mail.setWhatId(acc.Id);
                    mail.setTemplateID(templateBelay101.Id);
                    
                    //system.debug('mail101>>'+mail);
                    mailList.add(mail);
                    ///system.debug('mailList101>>'+mailList);
                    
                    //Multiselect Picklist Funtionality 
                    String newMonth = dt.format('MMMM');
                    String privMonth = acc.Belay_101_Email__c;
                    if(acc.Belay_101_Email__c != NULL)
                    {
                        acc.Belay_101_Email__c = privMonth + ';' +newMonth;
                        accEmailList.add(acc);
                    }
                    else
                    {
                        acc.Belay_101_Email__c = newMonth;
                        accEmailList.add(acc);
                    }
                    
                    
                    
                    //Task in 30 days (New Requirement)
                    Task tsk = new Task();
                    tsk.ActivityDate = system.today();
                    tsk.Subject = '30 Day Check In Email - BELAY 101';
                    tsk.Status = 'Completed';
                    tsk.Priority = 'Normal';
                    tsk.WhatId = acc.ID;
                    tsk.OwnerId = Global_Utility_Constants.USERID_GREER_FERGUSON;
                    tskList.add(tsk);
                    
                }
                else if(acc.Date_Stamp_for_3060_Email__c != NULL && acc.Date_Stamp_for_3060_Email__c.daysBetween(system.today()) == 60)
                {
                    //Scenario 1.1.2: For 60 days difference create task      
                    system.debug('1.1.2>>'+acc.Id);
                    Task tsk = new Task();
                    tsk.ActivityDate = system.today();
                    tsk.Subject = '30/60 - BELAY 101';
                    tsk.Status = 'Open';
                    tsk.Priority = 'Normal';
                    tsk.Directions__c = 'Contractor has not been placed in an engagement since attending BELAY 101 60 days ago. Please evaluate for termination';
                    //tsk.WhatId = '0017g0000qqqbmZAAR';//acc.ID;
                    tsk.WhatId = acc.ID;
                    //tsk.OwnerId = Global_Utility_Constants.USERID_KELSEY_MCKERNIE;
                    tsk.OwnerId = Global_Utility_Constants.USERID_GREER_FERGUSON;
                    tskList.add(tsk);
                }
                
                
            } 
            else if(
                //Scenario 2: Eng served > 0 - 5288 - ticket
                acc.Date_Attended_BELAY_101__c != NULL &&
                acc.Status__c == 'Contractor' &&
                acc.No_of_Engagements_for_3060_email__c == 0 &&    
                string.isEmpty(acc.Hold_Status__c) == true && 
                acc.Total_No_Engagements_Served__c > 0)
                
            {
                
                system.debug('4>>'+acc.Id);
                system.debug('5>>'+acc.Date_Stamp_for_3060_Email__c);
                system.debug('6>>'+acc.Date_Attended_BELAY_101__c);
                if(acc.Date_Stamp_for_3060_Email__c != NULL && acc.Date_Stamp_for_3060_Email__c.daysBetween(system.today()) == 30)
                {
                    system.debug('Total > 0 condition achieved>>'+acc.Id);
                    //EMAIL4
                    system.debug('Case2.2---->'); 
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setTemplateID(templateGeneric.Id);
                    List<String> sendTo = new List<String>();
                    sendTo.add(acc.PersonEmail);
                    mail.setToAddresses(sendTo);
                    //mail.setTargetObjectId(acc.OwnerId);
                    mail.setTargetObjectId(Global_Utility_Constants.USERID_TECH_CONTACT);
                    mail.setTreatTargetObjectAsRecipient(false);
                    mail.setOrgWideEmailAddressId(owea.Id);
                    mail.setReplyTo('greer.ferguson@belaysolutions.com');
                    mail.setWhatId(acc.Id);
                    mail.setSaveAsActivity(false);
                    
                    mailList.add(mail);
                    
                    //Multiselect Picklist Funtionality 
                    String newMonth = dt.format('MMMM');
                    String privMonth = acc.X30_60_On_Hold_Email__c;
                    if(acc.X30_60_On_Hold_Email__c != NULL)
                    {
                        acc.X30_60_On_Hold_Email__c = privMonth + ';' +newMonth;
                        accEmailList.add(acc);
                    }
                    else
                    {
                        acc.X30_60_On_Hold_Email__c = newMonth;
                        accEmailList.add(acc);
                    }
                    
                    //Task in 30 days (New Requirement)
                    Task tsk = new Task();
                    tsk.ActivityDate = system.today();
                    tsk.Subject = '30 Day Check In Email - Generic';
                    tsk.Status = 'Completed';
                    tsk.Priority = 'Normal';
                    tsk.WhatId = acc.ID;
                    tsk.OwnerId = Global_Utility_Constants.USERID_GREER_FERGUSON;
                    tskList.add(tsk);
                    
                }
                else if (acc.Date_Stamp_for_3060_Email__c != NULL && acc.Date_Stamp_for_3060_Email__c.daysBetween(system.today()) == 60)
                {
                    //Send 60 days Task
                    system.debug('Case2.3---->');
                    Task tsk = new Task();
                    tsk.ActivityDate = system.today();
                    tsk.Subject = '60 Day Post - Hold Follow Up';
                    tsk.Status = 'Open';
                    tsk.Priority = 'Normal';
                    tsk.Directions__c ='Contractor has not been placed in an engagement since their Contract Hold ended 60 days ago. Please evaluate for termination';
                    tsk.WhatId = acc.ID;
                    //tsk.OwnerId = Global_Utility_Constants.USERID_KELSEY_MCKERNIE;
                    tsk.OwnerId = Global_Utility_Constants.USERID_GREER_FERGUSON;
                    tskList.add(tsk);
                    
                }
            }
            
        }
        system.debug('mailList--->'+mailList);
        if(!mailList.isEmpty()) { 
            Messaging.sendEmail(mailList,false);
            //system.debug('mailList--->'+mailList);
        }
        //Email CheckBox Functionality
        if(!accEmailList.isEmpty()) { 
            update accEmailList;
            system.debug('accEmailList--->'+accEmailList);
        }
        
        system.debug('TaskList--->'+tskList);
        if (!tskList.isEmpty()) { 
            //insert tskList (partial insert allowed);
            Database.SaveResult[] srList = Database.insert(tskList,false);
            
            //for (Database.SaveResult sr : srList){
            for(Integer i=0;i<srList.size();i++){
                
                //system.debug('suc--->'+srList.get(i).isSuccess());
                if (srList.get(i).isSuccess()){
                    system.debug('Record ID : '+srList.get(i).getId());
                }
                else{
                    Database.Error error = srList.get(i).getErrors().get(0);
                    string failedDML = error.getMessage();
                    errMsgMap.put(tskList.get(i).WhatId,failedDML);
                    system.debug('Related Acc ID>>'+tskList.get(i).WhatId);
                }
                
            }
            //system.debug('errMsgMap0--->'+errMsgMap);
        }
    }
    
    global void finish(Database.BatchableContext bc) {
        
        //Set the EMAIL ID, where to send the error table.Where the task insert failed in execute method.
        Id logEmailReceiver3060Id = system.label.UID_LogEmailReceiver3060;
        
        if(!errMsgMap.isEmpty()){
            
            List<Messaging.SingleEmailMessage> mailListFinal = new List<Messaging.SingleEmailMessage>();
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setTargetObjectId(logEmailReceiver3060Id);
            mail.setSubject('Batch Job id :' + bc.getJobId());
            mail.setSaveAsActivity(false);
            
            String htmlBody = '';
            
            //open table..
            htmlBody = '<table border="1" style="border-collapse: collapse"><caption>Apex job failed for Below records - 3060 Task Creation</caption><tr><th>Related AccountId</th><th>Task Error</th></tr>';            
            
            String strErrMsg = '';
            for (Id objId : errMsgMap.keyset()){
                htmlBody += '<tr><td>' + objId + '</td><td>' + errMsgMap.get(objId) + '</td></tr>';
            }
            //close table...
            htmlBody += '</table>';            
            mail.setHtmlBody(htmlBody);
            mailListFinal.add(mail);
            //system.debug('mailListFinal--->'+mailListFinal);
            
            if(!mailListFinal.isEmpty()) { 
                Messaging.sendEmail(mailListFinal,false);
            }
        }
        
    }
    
}