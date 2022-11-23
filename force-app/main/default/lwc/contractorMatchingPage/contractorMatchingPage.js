import { LightningElement ,api , wire, track } from 'lwc';
import JobOpening_OBJECT from '@salesforce/schema/Job_Opening__c';
import { getObjectInfo } from 'lightning/uiObjectInfoApi'
import { getPicklistValuesByRecordType } from 'lightning/uiObjectInfoApi';
import getMatchingContractors from '@salesforce/apex/ContractorMatchingController.getMatchingContractors';
import getfilteredContractors from '@salesforce/apex/ContractorMatchingController.getFilteredContractors';
import createApplication from '@salesforce/apex/ContractorMatchingController.createApplication';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import My_Resources  from '@salesforce/resourceUrl/BelaynewLogo';
import Served_Months from '@salesforce/label/c.Served_Months';
export default class ContractorMatchingPage extends NavigationMixin(LightningElement) {

    belayLogos = My_Resources;
    
   records;
   error;
   pcChangeValue;
   timeZoneValue;
   industryValue;
   contractors;
   computer;
   ServiceLine;
   timeText;
   Hours;
   checked;
   length;
   placedLastTwoWeeks;
   passedSpanishAssessment;
   servedLongerMonths;

   labelName = "Served Longer Than " +Served_Months+ " Months";
   
   

    @track computers;
    @track industries;
    @track navId = '';
    @track showfilter = false;
    @track showTable = false; //Used to render table after we get the data from apex controller    
    @track recordsToDisplay = []; //Records to be displayed on the page
    @track weightageHeader
    @track weightageContent = []; 
    @api preSelected = [];
    @track pageNo;
    @api recordId;
    selectAll = false
    loader = true
    isDisplayNoRecords = false
    openPopup = false
    openWeightage = false


    @wire(getObjectInfo, { objectApiName: JobOpening_OBJECT })
    objectInfo;

    @wire(getPicklistValuesByRecordType, {
        recordTypeId : '$objectInfo.data.defaultRecordTypeId',
        objectApiName : JobOpening_OBJECT
    })
        wiredRecordtypeValues({data, error}){
            if(data){
                this.timeZones = data.picklistFieldValues.Preferred_Contractor_Time_Zone__c.values;
                this.computers = data.picklistFieldValues.Preferred_Computer__c.values;
                this.industries = data.picklistFieldValues.Industry_Experience__c.values;
                this.showfilter = true;
            }
            if(error){
                console.log(error);
            }
        }
//test
    
    @wire(getMatchingContractors, { currentRecordId: '$recordId' })
    wiredContacts(value) {
        //// Hold on to the provisioned value so we can refresh it later.
    this.wiredActivities = value;
    // Destructure the provisioned value 
    const { data, error } = value;
        if (data) {
            this.records = data;
            this.contractors = data.matchingContractors;
            this.ServiceLine = data.jobServiceLine;
            this.Hours = data.jobAvailableHours;
            this.timeZone = data.jobTimeZone;
            this.computer = data.jobComputerPreference;
            this.placedLastTwoWeeks = data.jobPlacedInLastTwoWeeks;
            this.loader = false;
            if(this.contractors.length === 0){
                this.isDisplayNoRecords = true
            }
            this.showTable = true;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.loader = false;
            this.contractors = undefined;
        }
    }

    handlepcChange(event){
        this.pcChangeValue = event.detail.value;
    }
    handleChange(event){
        console.log(event.target);
        if(event.target.label == 'Placed in last 2 weeks')
        {
            this.placedLastTwoWeeks = event.target.checked;
            console.log('placedLastTwoWeeks '+ this.placedLastTwoWeeks);
        }
        
        if(event.target.label == 'Passed Spanish Assessment')
        {
            this.passedSpanishAssessment = event.target.checked;
            console.log('passedSpanishAssessment '+ this.passedSpanishAssessment);
        }
        if(event.target.name == 'ServedMonths')
        {
            this.servedLongerMonths = event.target.checked;
            console.log('servedLongerMonths '+ this.servedLongerMonths);
            console.log('check box clicked');
        }
    }
    selectallid(event){
        const checked = event.target.checked;
        if(checked){
        this.showTable = false
        this.selectAll = true

        this.preSelected = this.contractors.map(value => value.contractorId);
        // firing an child method
         this.template.querySelector("c-paginator").setRecordsToDisplay();
        
         setTimeout(() => {
            this.showTable = true;
        }, 100);
        
    
        }else{
            this.showTable = false
            this.selectAll = false
            this.preSelected = [];
            this.template.querySelector("c-paginator").setRecordsToDisplay();
            setTimeout(() => {
                this.showTable = true;
            }, 100);
        }
    }
    
    
    handdletick(event){
       const  rowId = event.target.dataset.id;
       const checked = event.target.checked;
        if(checked){
            this.preSelected.push(rowId);
        }else{
        this.preSelected.forEach(elem => {
             if(elem == rowId){
                const index = this.preSelected.indexOf(elem);
                this.preSelected.splice(index, 1);
            }
         });
    
    }
    }


    hanldePicklistValueChange(event){
        this.timeZoneValue = event.detail;
        
   }

    hanldeIndustryPicklistValueChange(event){
        this.industryValue = event.detail;
        
    }
    
   handleSearch(){
     if(this.pcChangeValue && this.timeZoneValue && this.placedLastTwoWeeks && this.industryValue){
        //alert ('1');
           this.showTable = false;
           this.loader = true
           this.contractors = undefined;
           getfilteredContractors({currentRecordId : this.recordId, jobTimeZoneBE :this.timeZoneValue, jobPreferredComputer : this.pcChangeValue, jobIndustryBE : this.industryValue, placedLast :this.placedLastTwoWeeks, passedSpanish: this.passedSpanishAssessment,Served3Months: this.servedLongerMonths, Served6Months: this.servedLongerMonths })
           .then(result => {
               this.contractors = result.matchingContractors;
               this.ServiceLine = result.jobServiceLine;
               this.Hours = result.jobAvailableHours;
               this.timeZone = result.jobTimeZone;
               this.computer = result.jobComputerPreference;
               this.placedLastTwoWeeks = result.jobPlacedInLastTwoWeeks;
               this.showTable = true;
               this.loader = false
           })
           .catch(error => {
               this.error = error;
           });

           }
    else if(this.pcChangeValue && this.timeZoneValue && this.placedLastTwoWeeks){
        //alert ('2');
           this.showTable = false;
           this.loader = true
           this.contractors = undefined;
           getfilteredContractors({currentRecordId : this.recordId, jobTimeZoneBE :this.timeZoneValue, jobPreferredComputer : this.pcChangeValue, jobIndustryBE : this.industryValue, placedLast :this.placedLastTwoWeeks, passedSpanish: this.passedSpanishAssessment,Served3Months: this.servedLongerMonths, Served6Months: this.servedLongerMonths })
           .then(result => {
               this.contractors = result.matchingContractors;
               this.ServiceLine = result.jobServiceLine;
               this.Hours = result.jobAvailableHours;
               this.timeZone = result.jobTimeZone;
               this.computer = result.jobComputerPreference;
               this.placedLastTwoWeeks = result.jobPlacedInLastTwoWeeks;
               this.showTable = true;
               this.loader = false
           })
           .catch(error => {
               this.error = error;
           });

           }
           else if(this.timeZoneValue && this.computer && this.placedLastTwoWeeks && this.industryValue){
            //alert ('3');
            this.showTable = false;
            this.contractors = undefined;
            getfilteredContractors({currentRecordId : this.recordId,jobTimeZoneBE :this.timeZoneValue, jobPreferredComputer : this.computer, jobIndustryBE : this.industryValue,placedLast :this.placedLastTwoWeeks, passedSpanish: this.passedSpanishAssessment, Served3Months: this.servedLongerMonths, Served6Months: this.servedLongerMonths})
            .then(result => {
                console.log(result)
                this.contractors = result.matchingContractors;
                this.ServiceLine = result.jobServiceLine;
                this.Hours = result.jobAvailableHours;
                this.timeZone = result.jobTimeZone;
                this.computer = result.jobComputerPreference;
                this.placedLastTwoWeeks = result.jobPlacedInLastTwoWeeks;
                this.showTable = true;
            })
            .catch(error => {
                console.log(error)
                this.error = error;
            });
            

           }
           else if(this.timeZoneValue && this.computer && this.placedLastTwoWeeks){
            //alert ('4');
            this.showTable = false;
            this.contractors = undefined;
            getfilteredContractors({currentRecordId : this.recordId,jobTimeZoneBE :this.timeZoneValue, jobPreferredComputer : this.computer, jobIndustryBE : this.industryValue,placedLast :this.placedLastTwoWeeks, passedSpanish: this.passedSpanishAssessment, Served3Months: this.servedLongerMonths, Served6Months: this.servedLongerMonths})
            .then(result => {
                console.log(result)
                this.contractors = result.matchingContractors;
                this.ServiceLine = result.jobServiceLine;
                this.Hours = result.jobAvailableHours;
                this.timeZone = result.jobTimeZone;
                this.computer = result.jobComputerPreference;
                this.placedLastTwoWeeks = result.jobPlacedInLastTwoWeeks;
                this.showTable = true;
            })
            .catch(error => {
                console.log(error)
                this.error = error;
            });
            

           }
           else if(this.pcChangeValue && this.timeZone && this.placedLastTwoWeeks && this.industryValue){
            //alert ('5');
            this.showTable = false;
            this.contractors = undefined;
            getfilteredContractors({currentRecordId : this.recordId, jobTimeZoneBE :this.timeZone, jobPreferredComputer : this.pcChangeValue, jobIndustryBE : this.industryValue,placedLast :this.placedLastTwoWeeks, passedSpanish: this.passedSpanishAssessment, Served3Months: this.servedLongerMonths, Served6Months: this.servedLongerMonths})
            .then(result => {
                this.contractors = result.matchingContractors;
                this.ServiceLine = result.jobServiceLine;
                this.Hours = result.jobAvailableHours;
                this.timeZone = result.jobTimeZone;
                this.computer = result.jobComputerPreference;
                this.placedLastTwoWeeks = result.jobPlacedInLastTwoWeeks;
                this.showTable = true;
            })
            .catch(error => {
                this.error = error;
            });    

        }

        else if(this.pcChangeValue && this.timeZone && this.placedLastTwoWeeks){
            //alert ('6');
            this.showTable = false;
            this.contractors = undefined;
            getfilteredContractors({currentRecordId : this.recordId, jobTimeZoneBE :this.timeZone, jobPreferredComputer : this.pcChangeValue, jobIndustryBE : this.industryValue,placedLast :this.placedLastTwoWeeks, passedSpanish: this.passedSpanishAssessment, Served3Months: this.servedLongerMonths, Served6Months: this.servedLongerMonths})
            .then(result => {
                this.contractors = result.matchingContractors;
                this.ServiceLine = result.jobServiceLine;
                this.Hours = result.jobAvailableHours;
                this.timeZone = result.jobTimeZone;
                this.computer = result.jobComputerPreference;
                this.placedLastTwoWeeks = result.jobPlacedInLastTwoWeeks;
                this.showTable = true;
            })
            .catch(error => {
                this.error = error;
            });    

        }

           else if(this.pcChangeValue && this.timeZoneValue && this.industryValue){
    //alert ('7');
           this.showTable = false;
           this.loader = true
           this.contractors = undefined;
           getfilteredContractors({currentRecordId : this.recordId, jobTimeZoneBE :this.timeZoneValue, jobPreferredComputer : this.pcChangeValue, jobIndustryBE : this.industryValue,placedLast :this.placedLastTwoWeeks, passedSpanish: this.passedSpanishAssessment, Served3Months: this.servedLongerMonths, Served6Months: this.servedLongerMonths })
           .then(result => {
               this.contractors = result.matchingContractors;
               this.ServiceLine = result.jobServiceLine;
               this.Hours = result.jobAvailableHours;
               this.timeZone = result.jobTimeZone;
               this.computer = result.jobComputerPreference;
               this.placedLastTwoWeeks = result.jobPlacedInLastTwoWeeks;
               this.showTable = true;
               this.loader = false
           })
           .catch(error => {
               this.error = error;
           });

           }
           else if(this.pcChangeValue && this.timeZoneValue ){
            //alert ('8');
                   this.showTable = false;
                   this.loader = true
                   this.contractors = undefined;
                   getfilteredContractors({currentRecordId : this.recordId, jobTimeZoneBE :this.timeZoneValue, jobPreferredComputer : this.pcChangeValue, jobIndustryBE : this.industryValue,placedLast :this.placedLastTwoWeeks, passedSpanish: this.passedSpanishAssessment, Served3Months: this.servedLongerMonths, Served6Months: this.servedLongerMonths })
                   .then(result => {
                       this.contractors = result.matchingContractors;
                       this.ServiceLine = result.jobServiceLine;
                       this.Hours = result.jobAvailableHours;
                       this.timeZone = result.jobTimeZone;
                       this.computer = result.jobComputerPreference;
                       this.placedLastTwoWeeks = result.jobPlacedInLastTwoWeeks;
                       this.showTable = true;
                       this.loader = false
                   })
                   .catch(error => {
                       this.error = error;
                   });
        
                   }
           else if(this.timeZoneValue && this.computer && this.industryValue){
            //alert ('9');
            this.showTable = false;
            this.contractors = undefined;
            getfilteredContractors({currentRecordId : this.recordId,jobTimeZoneBE :this.timeZoneValue, jobPreferredComputer : this.computer, jobIndustryBE : this.industryValue,placedLast :this.placedLastTwoWeeks, passedSpanish: this.passedSpanishAssessment, Served3Months: this.servedLongerMonths, Served6Months: this.servedLongerMonths})
            .then(result => {
                console.log(result)
                this.contractors = result.matchingContractors;
                this.ServiceLine = result.jobServiceLine;
                this.Hours = result.jobAvailableHours;
                this.timeZone = result.jobTimeZone;
                this.computer = result.jobComputerPreference;
                this.placedLastTwoWeeks = result.jobPlacedInLastTwoWeeks;
                this.showTable = true;
            })
            .catch(error => {
                console.log(error)
                this.error = error;
            });
            

           }

           else if(this.timeZoneValue && this.computer){
            //alert ('10');
            this.showTable = false;
            this.contractors = undefined;
            getfilteredContractors({currentRecordId : this.recordId,jobTimeZoneBE :this.timeZoneValue, jobPreferredComputer : this.computer, jobIndustryBE : this.industryValue,placedLast :this.placedLastTwoWeeks, passedSpanish: this.passedSpanishAssessment, Served3Months: this.servedLongerMonths, Served6Months: this.servedLongerMonths})
            .then(result => {
                console.log(result)
                this.contractors = result.matchingContractors;
                this.ServiceLine = result.jobServiceLine;
                this.Hours = result.jobAvailableHours;
                this.timeZone = result.jobTimeZone;
                this.computer = result.jobComputerPreference;
                this.placedLastTwoWeeks = result.jobPlacedInLastTwoWeeks;
                this.showTable = true;
            })
            .catch(error => {
                console.log(error)
                this.error = error;
            });
            

           }

           

        else if(this.pcChangeValue && this.timeZone && this.industryValue){
            //alert ('11');
            this.showTable = false;
            this.contractors = undefined;
            getfilteredContractors({currentRecordId : this.recordId, jobTimeZoneBE :this.timeZone, jobPreferredComputer : this.pcChangeValue, jobIndustryBE : this.industryValue,placedLast :this.placedLastTwoWeeks, passedSpanish: this.passedSpanishAssessment, Served3Months: this.servedLongerMonths, Served6Months: this.servedLongerMonths})
            .then(result => {
                this.contractors = result.matchingContractors;
                this.ServiceLine = result.jobServiceLine;
                this.Hours = result.jobAvailableHours;
                this.timeZone = result.jobTimeZone;
                this.computer = result.jobComputerPreference;
                this.placedLastTwoWeeks = result.jobPlacedInLastTwoWeeks;
                this.showTable = true;
            })
            .catch(error => {
                this.error = error;
            });    

        }
        else if(this.pcChangeValue && this.timeZone){
            //alert ('12');
            this.showTable = false;
            this.contractors = undefined;
            getfilteredContractors({currentRecordId : this.recordId, jobTimeZoneBE :this.timeZone, jobPreferredComputer : this.pcChangeValue, jobIndustryBE : this.industryValue,placedLast :this.placedLastTwoWeeks, passedSpanish: this.passedSpanishAssessment, Served3Months: this.servedLongerMonths, Served6Months: this.servedLongerMonths})
            .then(result => {
                this.contractors = result.matchingContractors;
                this.ServiceLine = result.jobServiceLine;
                this.Hours = result.jobAvailableHours;
                this.timeZone = result.jobTimeZone;
                this.computer = result.jobComputerPreference;
                this.placedLastTwoWeeks = result.jobPlacedInLastTwoWeeks;
                this.showTable = true;
            })
            .catch(error => {
                this.error = error;
            });    

        }
        else if(this.placedLastTwoWeeks || this.placedLastTwoWeeks == false && this.industryValue){
           // alert ('13');
            this.showTable = false;
            this.contractors = undefined;
            getfilteredContractors({currentRecordId : this.recordId, jobTimeZoneBE :this.timeZone, jobPreferredComputer : this.computer, jobIndustryBE : this.industryValue,placedLast :this.placedLastTwoWeeks, passedSpanish: this.passedSpanishAssessment, Served3Months: this.servedLongerMonths, Served6Months: this.servedLongerMonths})
            .then(result => {
                this.contractors = result.matchingContractors;
                this.ServiceLine = result.jobServiceLine;
                this.Hours = result.jobAvailableHours;
                this.timeZone = result.jobTimeZone;
                this.computer = result.jobComputerPreference;
                this.placedLastTwoWeeks = result.jobPlacedInLastTwoWeeks;
                this.showTable = true;
            })
            .catch(error => {
                this.error = error;
            });    

        }
        else if(this.placedLastTwoWeeks || this.placedLastTwoWeeks == false){
           // alert ('14');
            this.showTable = false;
            this.contractors = undefined;
            getfilteredContractors({currentRecordId : this.recordId, jobTimeZoneBE :this.timeZone, jobPreferredComputer : this.computer, jobIndustryBE : this.industryValue,placedLast :this.placedLastTwoWeeks, passedSpanish: this.passedSpanishAssessment, Served3Months: this.servedLongerMonths, Served6Months: this.servedLongerMonths})
            .then(result => {
                this.contractors = result.matchingContractors;
                this.ServiceLine = result.jobServiceLine;
                this.Hours = result.jobAvailableHours;
                this.timeZone = result.jobTimeZone;
                this.computer = result.jobComputerPreference;
                this.placedLastTwoWeeks = result.jobPlacedInLastTwoWeeks;
                this.showTable = true;
            })
            .catch(error => {
                this.error = error;
            });    

        }

        else if(this.industryValue){
           // alert ('15');
            this.showTable = false;
            this.contractors = undefined;
            getfilteredContractors({currentRecordId : this.recordId, jobTimeZoneBE :this.timeZone, jobPreferredComputer : this.computer, jobIndustryBE : this.industryValue,placedLast :this.placedLastTwoWeeks, passedSpanish: this.passedSpanishAssessment, Served3Months: this.servedLongerMonths, Served6Months: this.servedLongerMonths})
            .then(result => {
                this.contractors = result.matchingContractors;
                this.ServiceLine = result.jobServiceLine;
                this.Hours = result.jobAvailableHours;
                this.timeZone = result.jobTimeZone;
                this.computer = result.jobComputerPreference;
                this.placedLastTwoWeeks = result.jobPlacedInLastTwoWeeks;
                this.showTable = true;
            })
            .catch(error => {
                this.error = error;
            });    

        }
     }

     openModal(){
        if(this.preSelected.length !== 0){
         this.length = this.preSelected.length;
         this.openPopup = true;
        }else {
            const event = new ShowToastEvent({
                title: 'Warning',
                message: 'Select atleast one contractor to create job application',
                variant: 'Warning',
                mode: 'dismissable'
            });
            this.dispatchEvent(event);
        }
     }
    
     getIdVal(event){
        event.preventDefault();
        this.navId = event.target.dataset.id;
        this.navigateToViewPage();
    }

    // Navigate to View Job_Opening__c Record Page
    navigateToViewPage() {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.navId,
                objectApiName: 'Job_Opening__c',
                actionName: 'view'
            },
        })
       
    }

    handlePaginatorChange(event){
        this.recordsToDisplay = event.detail.recordsToDisplay;
    }

    handleReset(){
       eval("$A.get('e.force:refreshView').fire();");
    }

    closeModal(){
        this.openPopup = false
        this.showTable = false
        setTimeout(() => {
            this.showTable = true;
        }, 100);
    }
    
    deselectall(){
        this.preSelected = [];
        this.selectAll = false
        this.showTable = false
        setTimeout(() => {
            this.showTable = true;
        }, 100);

    }

    showWeightage(event){
        this.weightageContent = '';
        this.openWeightage = true
        this.weightageHeader = event.currentTarget.title;
        
        if(this.weightageHeader == 'Industry'){
           for(var i = 0; i < this.contractors.length; i++){
               if(this.contractors[i].contractorId == event.currentTarget.dataset.id){
               this.weightageContent = this.contractors[i].matchedIndustryList;
               }
           } 
        }else if(this.weightageHeader == 'Growth'){
                for(var i = 0; i < this.contractors.length; i++){
                    if(this.contractors[i].contractorId == event.currentTarget.dataset.id){
                       this.weightageContent = this.contractors[i].contractorHoursWt;
                }
        }
        }else if(this.weightageHeader == 'Tools'){
                 for(var i = 0; i < this.contractors.length; i++){
                     if(this.contractors[i].contractorId == event.currentTarget.dataset.id){
                        this.weightageContent = this.contractors[i].matchedToolsList;
                    }
                }
        }else if(this.weightageHeader == 'Work Experience'){
                for(var i = 0; i < this.contractors.length; i++){
                    if(this.contractors[i].contractorId == event.currentTarget.dataset.id){
                       this.weightageContent = this.contractors[i].matchedTaskList;
                       }
                }
        }else if(this.weightageHeader == 'Client Preference'){
            for(var i = 0; i < this.contractors.length; i++){
                if(this.contractors[i].contractorId == event.currentTarget.dataset.id){
                   this.weightageContent = this.contractors[i].bkContractorPerferenceMatchedList;
                   }
            }
        }
    }

    closeWeightage(){
        this.openWeightage = false
    }

    createApplications(){
        this.loader = true
        createApplication({ currentRecordId : this.recordId , selectedAccounts : this.preSelected})
        .then(result => {
            this.preSelected = [];
            this.openPopup = false;
            this.loader = false;
            const event = new ShowToastEvent({
                title: 'Success',
                message: 'Job applications created sucessfully',
                variant: 'Success',
                mode: 'dismissable'
            });
            this.dispatchEvent(event);
        })
        .catch(error => {
            this.error = error;
            const event = new ShowToastEvent({
                title: 'Error',
                message: 'Failed to create Job Applications',
                variant: 'Error',
                mode: 'dismissable'
            });
            this.dispatchEvent(event);
        }); 
    }
}