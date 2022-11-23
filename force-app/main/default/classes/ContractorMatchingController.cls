public with sharing class ContractorMatchingController { 

    /* This method fetches the matching Contractors for a particular Job Opening Recordddd */
    @AuraEnabled(cacheable=true)
    Public Static ContractorMatchingWrapper getMatchingContractors(String currentRecordId) {
    Job_Opening__c currentRecord = new Job_Opening__c();
    User userRecord = new User();
    List<ContractorWeightageWrapper> matchingContractorsList = new List<ContractorWeightageWrapper>();
    ContractorMatchingWrapper cmWrapper = new ContractorMatchingWrapper();
    
    userRecord = [Select Id, Placed_in_last_2_weeks__c From User Where Id =:UserInfo.getUserId()];
    
    
    currentRecord = [Select Category__c, Hours_new__c, Preferred_Contractor_Time_Zone__c, Preferred_Computer__c, Industry_Experience__c,
    Anticipated_Tasks_Projects__c, Web_Social_Media_Tasks_Projects__c, General_Apps_Used_by_Client__c,
    Exp_Acc_Payroll_Apps_Used_by_client__c, Task_Project_Mngmt_Apps_Used_by_Client__c, Church_Management_Apps_Used_by_Client__c,
    CRM_Apps_Used_by_Client__c, Email_Platform_Used_by_Client__c, Social_Media_Apps_Used_by_Client__c,
    Website_Platforms_Used_by_Client__c, Anticipating_Growth_within_90_Days__c, Engagement_Name__r.Business_Level_Engagement__c, Placed_in_last_2_weeks__c, Passed_Spanish_Assessment__c,Longer_Than_3_Months__c,Longer_Than_6_Months__c  
    from Job_Opening__c where id =: currentRecordId];
    if(currentRecord != null) {
    matchingContractorsList = findMatchingContractors(currentRecord.Category__c, currentRecord.Hours_new__c, currentRecord.Preferred_Contractor_Time_Zone__c, 
                                        currentRecord.Preferred_Computer__c, currentRecord.Industry_Experience__c,currentRecord.Industry_Experience__c, currentRecord.Anticipated_Tasks_Projects__c, 
                                        currentRecord.Web_Social_Media_Tasks_Projects__c, currentRecord.General_Apps_Used_by_Client__c, 
                                        currentRecord.Exp_Acc_Payroll_Apps_Used_by_client__c, currentRecord.Task_Project_Mngmt_Apps_Used_by_Client__c, 
                                        currentRecord.Church_Management_Apps_Used_by_Client__c, currentRecord.CRM_Apps_Used_by_Client__c, 
                                        currentRecord.Email_Platform_Used_by_Client__c, currentRecord.Social_Media_Apps_Used_by_Client__c, 
                                        currentRecord.Website_Platforms_Used_by_Client__c, currentRecord.Anticipating_Growth_within_90_Days__c,
                                        currentRecord.Engagement_Name__r.Business_Level_Engagement__c, userRecord.Placed_in_last_2_weeks__c, currentRecord.Passed_Spanish_Assessment__c, currentRecord.Longer_Than_3_Months__c, currentRecord.Longer_Than_6_Months__c);
    } 
    cmWrapper.jobServiceLine = currentRecord.Category__c;
    cmWrapper.jobAvailableHours = currentRecord.Hours_new__c;
    cmWrapper.jobTimeZone = currentRecord.Preferred_Contractor_Time_Zone__c;
    cmWrapper.jobComputerPreference = currentRecord.Preferred_Computer__c;
    cmWrapper.jobPlacedInLastTwoWeeks = userRecord.Placed_in_last_2_weeks__c;
    cmWrapper.matchingContractors = matchingContractorsList;
    return cmWrapper;
    }
    
    
    
    /* This method fetches the matching Contractors for a particular Job Opening Record based on the filter selection*/
    @AuraEnabled
    Public Static ContractorMatchingWrapper getFilteredContractors(String currentRecordId, String jobTimeZoneBE, String jobPreferredComputer, String jobIndustryBE, Boolean placedLast, Boolean passedSpanish, Boolean Served3Months, Boolean Served6Months) {
    Job_Opening__c currentRecord = new Job_Opening__c();
    User userRecord = new User();
    List<ContractorWeightageWrapper> matchingContractorsList = new List<ContractorWeightageWrapper>();
    ContractorMatchingWrapper cmWrapper = new ContractorMatchingWrapper();
    
    userRecord = [Select Id, Placed_in_last_2_weeks__c From User Where Id =:UserInfo.getUserId()];
    
    
    currentRecord = [Select Category__c, Hours_new__c, Preferred_Contractor_Time_Zone__c, Industry_Experience__c, 
    Anticipated_Tasks_Projects__c, Web_Social_Media_Tasks_Projects__c, General_Apps_Used_by_Client__c,
    Exp_Acc_Payroll_Apps_Used_by_client__c, Task_Project_Mngmt_Apps_Used_by_Client__c, Church_Management_Apps_Used_by_Client__c,
    CRM_Apps_Used_by_Client__c, Email_Platform_Used_by_Client__c, Social_Media_Apps_Used_by_Client__c,
    Website_Platforms_Used_by_Client__c, Anticipating_Growth_within_90_Days__c, Engagement_Name__r.Business_Level_Engagement__c, Placed_in_last_2_weeks__c   
    from Job_Opening__c where id =: currentRecordId];
    if(currentRecord != null) {
    matchingContractorsList = findMatchingContractors(currentRecord.Category__c, currentRecord.Hours_new__c, jobTimeZoneBE, jobPreferredComputer, jobIndustryBE,
                                        currentRecord.Industry_Experience__c, currentRecord.Anticipated_Tasks_Projects__c, 
                                        currentRecord.Web_Social_Media_Tasks_Projects__c, currentRecord.General_Apps_Used_by_Client__c, 
                                        currentRecord.Exp_Acc_Payroll_Apps_Used_by_client__c, currentRecord.Task_Project_Mngmt_Apps_Used_by_Client__c, 
                                        currentRecord.Church_Management_Apps_Used_by_Client__c, currentRecord.CRM_Apps_Used_by_Client__c, 
                                        currentRecord.Email_Platform_Used_by_Client__c, currentRecord.Social_Media_Apps_Used_by_Client__c, 
                                        currentRecord.Website_Platforms_Used_by_Client__c, currentRecord.Anticipating_Growth_within_90_Days__c, currentRecord.Engagement_Name__r.Business_Level_Engagement__c, placedLast, passedSpanish, Served3Months, Served6Months);
    
    
    if(userRecord.Placed_in_last_2_weeks__c != placedLast) {
    userRecord.Placed_in_last_2_weeks__c = placedLast;
    update userRecord;
    }         
                           
    
    // if(currentRecord.Placed_in_last_2_weeks__c != placedLast) {
    //     currentRecord.Placed_in_last_2_weeks__c = placedLast;
    //     update currentRecord;
    // }
    } 
    
    cmWrapper.jobServiceLine = currentRecord.Category__c;
    cmWrapper.jobAvailableHours = currentRecord.Hours_new__c;
    cmWrapper.jobTimeZone = currentRecord.Preferred_Contractor_Time_Zone__c;
    cmWrapper.jobComputerPreference = jobPreferredComputer;
    cmWrapper.jobPlacedInLastTwoWeeks = userRecord.Placed_in_last_2_weeks__c;
    cmWrapper.matchingContractors = matchingContractorsList;
    return cmWrapper;
    }
    
    /* This method is called internally to find the matching contractors based on matching criteria */
    Public static List<ContractorWeightageWrapper> findMatchingContractors(String jobCategory, String jobHours, String jobTimeZoneBE, String jobPreferredComputer, String jobIndustryBE, String jobIndustry, 
                                                    String jobAnticipatedTask, String jobWebSMTask, String jobGeneralApp, String jobExpApp, String jobProjectMgmtApp, 
                                                    String jobChurchApp, String jobCrmApp, String jobEmailApp, String jobSocialMediaApp, String jobWebsiteApp, Boolean anticipatingGrowth, String jobBusinessLevel,
                                                    Boolean placedLast, Boolean passedSpanish, Boolean Served3Months, Boolean Served6Months)
    {
    String LabelValue = System.Label.Served_Months;
    List<Account> availableContractors = new List<Account>();
    List<ContractorWeightageWrapper> matchingContractorList = new List<ContractorWeightageWrapper>();
    ContractorWeightageWrapper contractorWithWeightage = new ContractorWeightageWrapper();
    List<String> iMatchedList = new List<String>();
    List<String> taskMatchedList = new List<String>();
    List<String> toolsMatchedList = new List<String>();
    String[] jobIndustryArray = jobIndustry.split(';');
    List<String> jobTaskArray = new List<String>();
    List<String> generalArray = new List<String>();
    List<String> expenseArray = new List<String>();
    List<String> taskProjectArray = new List<String>();
    List<String> churchArray = new List<String>();
    List<String> crmArray = new List<String>();
    List<String> emailArray = new List<String>();
    List<String> socialMediaArray = new List<String>();
    List<String> websiteArray = new List<String>();
    List<String> microsoftArray = new List<String>();
    List<String> taskJOList = new List<String>();
    List<Contractor_Matching_Weightage_Scores__c> cmScores = Contractor_Matching_Weightage_Scores__c.getall().values();
    List<Contractor_Matching_Hours_Range__c> jobHoursRange = Contractor_Matching_Hours_Range__c.getall().values();
    Boolean serviceLineMatched = false;
    Boolean hoursMatched = false;
    Boolean computerPreferenceMatched = false;
    Boolean timeZoneMatched = false;
    Boolean industryMatched = false;
    Boolean categoryMatched = false;
    Boolean placedLastMatched = true;
    Boolean spanishAssessed = true;
    Boolean monthsServed = true;
    Boolean checkPlaced45Days = false;
    String stJobOpeningTimeZone = '';
    String stContractorTimeZone = '';
    String stJobOpeningIndustry = '';
    String stContractorIndustry = '';
    String contractorHrsWt = '';
    String bkContractorPerferenceMatched = '';
    Integer iWeight = 0;
    Integer taskWeight = 0;
    Integer toolsWeight = 0;
    Integer growthWeight = 0;
    Integer bkContractorPerferenceWeight = 0;
    Integer jobHoursInt = 0;
    
    if(jobHours != null) {
    jobHoursInt = Integer.valueOf(jobHours.split(' ')[0]);
    }
    
    /*The below query fetches only the available contractors*/
    availableContractors = [Select id, name, Contractor_Service_Line__c, Additional_Service_Line__c, Third_Service_Line_if_applicable__c, 
        Availability__c, Available_Hours_Monthly__c, Time_Zone__c, Type_of_Computer__c, Currently_Being_Vetted__c,
        Avg_Performance_Rating__c, Contractor_Most_Recent_Kick_Off_Date__c, Date_Last_Placed__c, Industry_Experience__c, 
        General_Proficiency__c, Expense_Accounting_PayrollAppProficiency__c, Task_Project_Management_App_Proficiency__c,
        Church_Management_App_Proficiency__c, CRM_Proficiency_new__c, Email_Platform_Proficiency__c,
        Social_Media_Proficiency_new__c,Last_Placed_Days_Count__c, Placed_in_last_2_weeks__c, Website_Platform_Proficiency__c, Work_Experience__c,
         Web_Social_Media_Specific_Experience__c, BK_Client_Preference_new__c ,Passed_Spanish_Assessment__c,Longer_Than_3_Months__c,Longer_Than_6_Months__c
        from Account where IsPersonAccount = true and Status__c = 'Contractor' and Availability__c = true and test_record3__c = false];
    
    
    
    if(availableContractors != null && availableContractors.size() > 0) {
    for(Account contractor : availableContractors){
    //check if the contractor matches the Job Opening Category
    if((contractor.Contractor_Service_Line__c != null) && ( jobCategory == null || (jobCategory == contractor.Contractor_Service_Line__c || jobCategory == contractor.Additional_Service_Line__c || jobCategory == contractor.Third_Service_Line_if_applicable__c))){
    serviceLineMatched = true;
    }
    
    //check if the contractor matches the Job Opening Available Hours
    if((Integer.valueOf(contractor.Available_Hours_Monthly__c) - ( Integer.valueOf(jobHoursInt) - jobHoursRange[0].Hours__c )) >= 0) {
    hoursMatched = true;
    }
    
    //check if the contractor matches the Job Opening Computer Preference
    if((contractor.Type_of_Computer__c != null) && ( jobPreferredComputer == 'No Preference' || jobPreferredComputer == contractor.Type_of_Computer__c || contractor.Type_of_Computer__c == 'Both Mac and PC')){
    computerPreferenceMatched = true;
    }
    
    //check if the contractor matches the Job Opening Time Zone
    if(jobTimeZoneBE != null){
    stJobOpeningTimeZone = jobTimeZoneBE;
    } 
    if(contractor.Time_Zone__c != null) {
    stContractorTimeZone = contractor.Time_Zone__c;
    }
    if((contractor.Time_Zone__c != null) && ( jobTimeZoneBE == null || jobTimeZoneBE == 'No Preference' || (stJobOpeningTimeZone.containsIgnoreCase(stContractorTimeZone)) )){
    timeZoneMatched = true;
    }
    
    //check if the contractor matches the Job Opening Industry
    if(jobIndustryBE != null){
    System.debug(jobIndustryBE);
    stJobOpeningIndustry = jobIndustryBE;
    } 
    if(contractor.Industry_Experience__c != null) {
    System.debug(contractor.Industry_Experience__c);
    stContractorIndustry = contractor.Industry_Experience__c;
    }
    if(stContractorIndustry != null) {
    for(String s : stContractorIndustry.split(';')) {
    System.debug(s);
    if((contractor.Industry_Experience__c != null) && ( jobIndustryBE == null || jobIndustryBE == 'No Preference' || (stJobOpeningIndustry.containsIgnoreCase(s)) )) {
    System.debug('Inside for');
    industryMatched = true;
    }
    }
    }
    
    
    //check if the contractor is placed in the last two weeks
    if(placedLast != NULL && placedLast == true) {
    system.debug('IF@@@');
    //if(contractor.Date_Last_Placed__c <= system.today() - 14){
    if(contractor.Placed_in_last_2_weeks__c == false){
    system.debug('@@@'+contractor);
    placedLastMatched = true;
    } else {
    placedLastMatched = false;
    }
    }

    //check if contractor has passed Spanish assessment
    if(passedSpanish != NULL && passedSpanish == true) {
        system.debug('IF@@@');
        if(contractor.Passed_Spanish_Assessment__c == true){
        system.debug('@@@'+contractor);
        spanishAssessed = true;
        } else {
        spanishAssessed = false;
        } 
    }

    //check served 3  months
    if(Served3Months != NULL && Served3Months == true  && LabelValue == '3') {
        system.debug('IF@@@ contrractor served');
        if(contractor.Longer_Than_3_Months__c == true){ //custom label
        system.debug('@@@ con'+contractor);
        monthsServed = true;
        } else {
            monthsServed = false;
        } 
    }

    //check served 6 months
    if( Served6Months != NULL && Served6Months == true && LabelValue == '6') {
        system.debug('IF@@@ contrractor served');
        if(contractor.Longer_Than_6_Months__c == true ){ //custom label
        system.debug('@@@ con'+contractor);
        monthsServed = true;
        } else {
            monthsServed = false;
        } 
    }

    
   
    
    //check placed 45 days - ticekt 4766 -
    if((contractor.Contractor_Service_Line__c == 'Bookkeeper' && contractor.Last_Placed_Days_Count__c >= 45 ) || contractor.Contractor_Service_Line__c != 'Bookkeeper'){
    system.debug('@@@placed more than 45 days' +contractor);
    checkPlaced45Days = true;
    }
    else {
    checkPlaced45Days = false;
    }
    
    
    
    
    
    
    //Check if the contractor is a match for the job opening
    if(serviceLineMatched && hoursMatched && computerPreferenceMatched && timeZoneMatched && placedLastMatched && industryMatched && checkPlaced45Days &&  spanishAssessed && monthsServed){
    /* Calculate the weightages for the matched Contractor */
    
    // 1. Calculate Industry Weightage 
    if(jobIndustryArray.size() > 0 ){
    for(String jIndustry : jobIndustryArray) {
    if( !(jIndustry.containsIgnoreCase('none')) && contractor.Industry_Experience__c != null && contractor.Industry_Experience__c != '' && !((contractor.Industry_Experience__c).containsIgnoreCase('none')) && (contractor.Industry_Experience__c).containsIgnoreCase(jIndustry)) {
        iWeight = iWeight + Integer.valueOf(cmScores[0].Industry_Experience__c);
        iMatchedList.add(jIndustry);
    }
    }
    }
    
    // 2. Calculate Task/Project Weightage
    if(jobAnticipatedTask != null) {
    for(String s : jobAnticipatedTask.split(';')) {
    taskJOList.add(s);
    }
    }
    if(jobWebSMTask != null) {
    for(String s : jobWebSMTask.split(';')) {
    taskJOList.add(s);
    }
    }
    if(taskJOList != null && taskJOList.size() > 0) {
    for(String joTask : taskJOList) {
    if(!(joTask.containsIgnoreCase('none'))) {
        if( (contractor.Work_Experience__c != null && !((contractor.Work_Experience__c).containsIgnoreCase('none')) && (contractor.Work_Experience__c).containsIgnoreCase(joTask)) || (contractor.Web_Social_Media_Specific_Experience__c != null && !((contractor.Web_Social_Media_Specific_Experience__c).containsIgnoreCase('none')) && (contractor.Web_Social_Media_Specific_Experience__c).containsIgnoreCase(joTask)) ) {
            taskWeight = taskWeight + Integer.valueOf(cmScores[0].Work_Experience__c);
            taskMatchedList.add(joTask);
        }
    }
    }
    }
    
    // 3. Calculate Tools Weightage
    if(jobGeneralApp != null) {
    for(String s : jobGeneralApp.split(';')) {
    if( !(s.containsIgnoreCase('none')) && contractor.General_Proficiency__c != null && !((contractor.General_Proficiency__c).containsIgnoreCase('none')) && (contractor.General_Proficiency__c).containsIgnoreCase(s) ) {
        toolsWeight = toolsWeight + Integer.valueOf(cmScores[0].Tools_Exact_Match__c);
        toolsMatchedList.add(s);
        categoryMatched = true;
    }
    }
    if(categoryMatched) {
    toolsWeight = toolsWeight + Integer.valueOf(cmScores[0].Tools_Category_Match__c);
    }
    categoryMatched = false;
    }
    if(jobExpApp != null) {
    for(String s : jobExpApp.split(';')) {
    if( !(s.containsIgnoreCase('none')) && contractor.Expense_Accounting_PayrollAppProficiency__c != null && !((contractor.Expense_Accounting_PayrollAppProficiency__c).containsIgnoreCase('none')) && (contractor.Expense_Accounting_PayrollAppProficiency__c).containsIgnoreCase(s) ) {
        toolsWeight = toolsWeight + Integer.valueOf(cmScores[0].Tools_Exact_Match__c);
        toolsMatchedList.add(s);
        categoryMatched = true;
    }
    }
    if(categoryMatched) {
    toolsWeight = toolsWeight + Integer.valueOf(cmScores[0].Tools_Category_Match__c);
    }
    categoryMatched = false;
    }
    if(jobProjectMgmtApp != null) {
    for(String s : jobProjectMgmtApp.split(';')) {
    if( !(s.containsIgnoreCase('none')) && contractor.Task_Project_Management_App_Proficiency__c != null && !((contractor.Task_Project_Management_App_Proficiency__c).containsIgnoreCase('none')) && (contractor.Task_Project_Management_App_Proficiency__c).containsIgnoreCase(s) ) {
        toolsWeight = toolsWeight + Integer.valueOf(cmScores[0].Tools_Exact_Match__c);
        toolsMatchedList.add(s);
        categoryMatched = true;
    }
    }
    if(categoryMatched) {
    toolsWeight = toolsWeight + Integer.valueOf(cmScores[0].Tools_Category_Match__c);
    }
    categoryMatched = false;
    }
    if(jobChurchApp != null) {
    for(String s : jobChurchApp.split(';')) {
    if( !(s.containsIgnoreCase('none')) && contractor.Church_Management_App_Proficiency__c != null && !((contractor.Church_Management_App_Proficiency__c).containsIgnoreCase('none')) && (contractor.Church_Management_App_Proficiency__c).containsIgnoreCase(s) ) {
        toolsWeight = toolsWeight + Integer.valueOf(cmScores[0].Tools_Exact_Match__c);
        toolsMatchedList.add(s);
        categoryMatched = true;
    }
    }
    if(categoryMatched) {
    toolsWeight = toolsWeight + Integer.valueOf(cmScores[0].Tools_Category_Match__c);
    }
    categoryMatched = false;
    }
    if(jobCrmApp != null) { 
    for(String s : jobCrmApp.split(';')) {
    if( !(s.containsIgnoreCase('none')) && contractor.CRM_Proficiency_new__c != null && !((contractor.CRM_Proficiency_new__c).containsIgnoreCase('none')) && (contractor.CRM_Proficiency_new__c).containsIgnoreCase(s) ) {
        toolsWeight = toolsWeight + Integer.valueOf(cmScores[0].Tools_Exact_Match__c);
        toolsMatchedList.add(s);
        categoryMatched = true;
    }
    }
    if(categoryMatched) {
    toolsWeight = toolsWeight + Integer.valueOf(cmScores[0].Tools_Category_Match__c);
    }
    categoryMatched = false;
    }
    if(jobEmailApp != null) { 
    for(String s : jobEmailApp.split(';')) {
    if( !(s.containsIgnoreCase('none')) && contractor.Email_Platform_Proficiency__c != null && !((contractor.Email_Platform_Proficiency__c).containsIgnoreCase('none')) && (contractor.Email_Platform_Proficiency__c).containsIgnoreCase(s) ) {
        toolsWeight = toolsWeight + Integer.valueOf(cmScores[0].Tools_Exact_Match__c);
        toolsMatchedList.add(s);
        categoryMatched = true;
    }
    }
    if(categoryMatched) {
    toolsWeight = toolsWeight + Integer.valueOf(cmScores[0].Tools_Category_Match__c);
    }
    categoryMatched = false;
    }
    if(jobSocialMediaApp != null) {
    for(String s : jobSocialMediaApp.split(';')) {
    if( !(s.containsIgnoreCase('none')) && contractor.Social_Media_Proficiency_new__c != null && !((contractor.Social_Media_Proficiency_new__c).containsIgnoreCase('none')) && (contractor.Social_Media_Proficiency_new__c).containsIgnoreCase(s) ) {
        toolsWeight = toolsWeight + Integer.valueOf(cmScores[0].Tools_Exact_Match__c);
        toolsMatchedList.add(s);
        categoryMatched = true;
    }
    }
    if(categoryMatched) {
    toolsWeight = toolsWeight + Integer.valueOf(cmScores[0].Tools_Category_Match__c);
    }
    categoryMatched = false;
    }
    if(jobWebsiteApp != null) {
    for(String s : jobWebsiteApp.split(';')) {
    if( !(s.containsIgnoreCase('none')) && contractor.Website_Platform_Proficiency__c != null && !((contractor.Website_Platform_Proficiency__c).containsIgnoreCase('none')) && (contractor.Website_Platform_Proficiency__c).containsIgnoreCase(s) ) {
        toolsWeight = toolsWeight + Integer.valueOf(cmScores[0].Tools_Exact_Match__c);
        toolsMatchedList.add(s);
        categoryMatched = true;
    }
    }
    if(categoryMatched) {
    toolsWeight = toolsWeight + Integer.valueOf(cmScores[0].Tools_Category_Match__c);
    }
    categoryMatched = false;
    }
    
    // 4. Calculate Growth Weightage
    if(jobCategory == 'Virtual Assistant' || jobCategory == 'Social Media Manager' || jobCategory == 'Accounting Clerk' ) { 
    if(anticipatingGrowth) {
    if((Integer.valueOf(contractor.Available_Hours_Monthly__c) - Integer.valueOf(jobHoursInt)) >= 20) {
        growthWeight = growthWeight + Integer.valueOf(cmScores[0].Growth__c);
        contractorHrsWt = 'Additional Available Hours: ' + String.valueOf((Integer.valueOf(contractor.Available_Hours_Monthly__c) - Integer.valueOf(jobHoursInt)) + ' hours');
    }
    }
    } 
    
    // 5. Calculate Client Preference
    if(jobCategory == 'Bookkeeper' || jobCategory == 'Accounting Clerk' || jobCategory == 'CFO') { 
    if(contractor.BK_Client_Preference_new__c == 'For Profit Clients' && (jobBusinessLevel == 'For-Profit' || jobBusinessLevel == 'MLA/Enterprise')) {
    bkContractorPerferenceWeight = bkContractorPerferenceWeight + Integer.valueOf(cmScores[0].Client_Preference__c);
    bkContractorPerferenceMatched = contractor.BK_Client_Preference_new__c;
    } else if (contractor.BK_Client_Preference_new__c == 'Non Profit Clients' && jobBusinessLevel == 'Non-Profit/Church') {
    bkContractorPerferenceWeight = bkContractorPerferenceWeight + Integer.valueOf(cmScores[0].Client_Preference__c);
    bkContractorPerferenceMatched = contractor.BK_Client_Preference_new__c;
    } else if(contractor.BK_Client_Preference_new__c == 'No Preference') {
    bkContractorPerferenceWeight = bkContractorPerferenceWeight + Integer.valueOf(cmScores[0].Client_Preference__c);
    bkContractorPerferenceMatched = contractor.BK_Client_Preference_new__c;
    }
    }
    
    
    contractorWithWeightage = new ContractorWeightageWrapper();
    contractorWithWeightage.contractorId = contractor.id;
    contractorWithWeightage.contractorName = contractor.name;
    contractorWithWeightage.contractorHours = contractor.Available_Hours_Monthly__c;
    contractorWithWeightage.contractorBeingVetted = contractor.Currently_Being_Vetted__c;
    contractorWithWeightage.contractorDateLastPlaced = contractor.Date_Last_Placed__c;
    
    contractorWithWeightage.industryWeightage = iWeight;
    if(iWeight != 0) {
    contractorWithWeightage.matchedIndustryList = iMatchedList;
    } else {
    iMatchedList.add('No matching industries found');
    contractorWithWeightage.matchedIndustryList = iMatchedList;
    }
    
    contractorWithWeightage.taskWeightage = taskWeight;
    if(taskWeight != 0) {
    contractorWithWeightage.matchedTaskList = taskMatchedList;
    } else {
    taskMatchedList.add('No matching tasks found');
    contractorWithWeightage.matchedTaskList = taskMatchedList;
    }
    
    
    contractorWithWeightage.toolsWeightage = toolsWeight;
    if(toolsWeight != 0) {
    contractorWithWeightage.matchedToolsList = toolsMatchedList;
    } else {
    toolsMatchedList.add('No matching tools found');
    contractorWithWeightage.matchedToolsList = toolsMatchedList;
    }
    
    
    if(jobCategory == 'Virtual Assistant' || jobCategory == 'Social Media Manager' || jobCategory == 'Accounting Clerk') {
    contractorWithWeightage.growthWeightage = String.valueOf(growthWeight);
    if(growthWeight != 0) {
    contractorWithWeightage.contractorHoursWt = contractorHrsWt;
    } else {
    contractorWithWeightage.contractorHoursWt = 'No additional available hours';
    }
    
    } else {
    contractorWithWeightage.growthWeightage = '-';
    contractorWithWeightage.contractorHoursWt = 'NA';
    }
    
    if(jobCategory == 'Bookkeeper' || jobCategory == 'Accounting Clerk' || jobCategory == 'CFO') {
    contractorWithWeightage.bkContractorPerferenceWeightage = String.valueOf(bkContractorPerferenceWeight);
    if(bkContractorPerferenceWeight != 0) {
    contractorWithWeightage.bkContractorPerferenceMatchedList = bkContractorPerferenceMatched;
    } else {
    contractorWithWeightage.bkContractorPerferenceMatchedList = 'No matching client preference found';
    }
    
    } else {
    contractorWithWeightage.bkContractorPerferenceWeightage = '-';
    contractorWithWeightage.bkContractorPerferenceMatchedList = 'NA';
    }
    
    contractorWithWeightage.totalWeightageSum = iWeight + taskWeight + toolsWeight + growthWeight + bkContractorPerferenceWeight;
    
    matchingContractorList.add(contractorWithWeightage);
    
    }
    serviceLineMatched = false;
    computerPreferenceMatched = false;
    timeZoneMatched = false;
    industryMatched = false;
    hoursMatched = false;
    iWeight = 0;
    taskWeight = 0;
    toolsWeight = 0;
    growthWeight = 0;
    bkContractorPerferenceWeight = 0;
    iMatchedList = new List<String>();
    taskMatchedList = new List<String>();
    toolsMatchedList = new List<String>();
    taskJOList = new List<String>();
    contractorHrsWt = '';
    bkContractorPerferenceMatched = '';
    }
    }
    matchingContractorList.sort();
    system.debug('Result'+matchingContractorList);
    return matchingContractorList;
    }
    
    /* Create Job Applications with selected list of contractors */
    @AuraEnabled
    Public Static void createApplication(String currentRecordId, List<String>selectedAccounts) {
    List<Job_Application__c> applications = new List<Job_Application__c>();
    
    if(!selectedAccounts.isEmpty() && !String.isEmpty(currentRecordId)) {
    for(String contractor : selectedAccounts){
    Job_Application__c app = new Job_Application__c();
    app.Applicant_Name__c = contractor;
    app.Job_Opening_Name__c= currentRecordId;
    app.Status__c = 'Pre - Placement Text (PPT)';
    app.Why_are_you_a_good_fit_for_this_engageme__c = 'Application created by BELAY';
    app.How_will_you_fulfill_the_WIN__c = 'Application created by BELAY';
    applications.add(app);
    }
    if(!Test.isRunningTest()){
    insert applications;
    }
    
    }
    }
    
    
    /* Wrapper Class for contractors along with weightage information*/
    public class ContractorWeightageWrapper implements Comparable{
    @AuraEnabled
    public String contractorId{get;set;}
    @AuraEnabled
    public String contractorName{get;set;}
    @AuraEnabled
    public Decimal contractorHours{get;set;}
    @AuraEnabled
    public Boolean contractorBeingVetted{get;set;}
    @AuraEnabled
    public Date contractorDateLastPlaced{get;set;}
    @AuraEnabled
    public Integer industryWeightage{get;set;}
    @AuraEnabled
    public List<String> matchedIndustryList{get;set;}
    @AuraEnabled
    public Integer taskWeightage{get;set;}
    @AuraEnabled
    public List<String> matchedTaskList{get;set;}
    @AuraEnabled
    public Integer toolsWeightage{get;set;}
    @AuraEnabled
    public List<String> matchedToolsList{get;set;}
    @AuraEnabled
    public String growthWeightage{get;set;}
    @AuraEnabled
    public String contractorHoursWt{get;set;}
    @AuraEnabled
    public String bkContractorPerferenceWeightage{get;set;}
    @AuraEnabled
    public String bkContractorPerferenceMatchedList{get;set;}
    @AuraEnabled
    public Integer totalWeightageSum{get;set;}
    
    public Integer compareTo (Object compareTo) {
    ContractorWeightageWrapper cww = (ContractorWeightageWrapper)compareTo;
    Integer returnValue = 0;
    
    if (totalWeightageSum > cww.totalWeightageSum) {
    returnValue = -1;
    } else if (totalWeightageSum < cww.totalWeightageSum) {
    returnValue = 1;
    }
    return returnValue; 
    }
    }
    
    /* Wrapper Class with Job Opening data and matching list of contractors */
    public class ContractorMatchingWrapper {
    @AuraEnabled
    public String jobServiceLine{get;set;}
    @AuraEnabled
    public String jobAvailableHours{get;set;}
    @AuraEnabled
    public String jobTimeZone{get;set;}
    @AuraEnabled
    public String jobComputerPreference{get;set;}
    @AuraEnabled
    public Boolean jobPlacedInLastTwoWeeks{get;set;}
    @AuraEnabled
    public List<ContractorWeightageWrapper> matchingContractors{get;set;}
    
    }
    
    }