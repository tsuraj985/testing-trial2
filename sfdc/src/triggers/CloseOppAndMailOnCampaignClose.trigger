trigger CloseOppAndMailOnCampaignClose on Campaign (after update) {
    if(Trigger.isAfter) {
        if(Trigger.isUpdate) {
            //Id Set of All Campaigns which have status before not completed and now status is completed.
            Set<Id> CampaignIdSet = new Set<Id>();
            Set<Id> CampaignOwnerIdSet = new Set<Id>();
            for (Campaign tempCamp : trigger.new) {
                if (Trigger.oldMap.get(tempCamp.Id).Status != 'Completed' && tempCamp.Status == 'Completed') {
                    CampaignIdSet.add(tempCamp.Id);
                    CampaignOwnerIdSet.add(tempCamp.OwnerId);
                } else {
                    return;
                }
            }
            System.debug('Emails = ' + CampaignOwnerIdSet);
            System.debug('CampaignIdSet --->>>>>>' + CampaignIdSet);
            
            //List of all Opportunities Related to above Campaigns
            List<Opportunity> OppList = [
                                    SELECT Name, HasOpportunityLineItem, Amount
                                    FROM Opportunity
                                    WHERE CampaignId =: CampaignIdSet
                                    AND StageName != 'Closed Won'
                                    AND StageName != 'Closed Lost'];
            System.debug('Opportunity List  --->>>>>>' + OppList);
            
            //List to be Updated
            List<Opportunity> OppListToBeUpdated = new List<Opportunity>();
            Integer NumOfOppClosedWon = 0;
            Integer NumOfOppClosedLost = 0;
            Double WonAmount = 0;
            
            for (Opportunity Opp : OppList) {
                if (opp.HasOpportunityLineItem) {
                    opp.StageName = 'Closed Won';
                    NumOfOppClosedWon++;
                    WonAmount += opp.Amount;
                    System.debug(opp.Name + ' is set to Closed Won');
                } else {
                    opp.StageName = 'Closed Lost';
                    NumOfOppClosedLost++;
                    System.debug(opp.Name + ' is set to Closed Lost');                    
                }
                OppListToBeUpdated.add(opp);
            }
            System.debug('--->>>>>Number of closed Won Opp ' + NumOfOppClosedWon);
            System.debug('--->>>>>Number of closed Lost Opp ' + NumOfOppClosedLost);
            System.debug('--->>>>>Amount of closed Won Opp ' + WonAmount);
            update OppListToBeUpdated;
            
            
            //To Send an Email
            List<User> allMails = [SELECT Email, FirstName, LastName
                                    FROM User
                                    WHERE Id IN: CampaignOwnerIdSet];
            System.debug('All Mails : ' + allMails);
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            List<String> toAddresses = new List<String>();
            String useremail;
            String firstName;
            String lastName;
            for (User usermail : allMails) {
                System.debug('User mail = ' + usermail.email);
                useremail = usermail.email;
                firstName = usermail.FirstName;
                lastName = usermail.LastName;
                toAddresses.add(useremail);
            }
            System.debug('Mails -->>>' + toAddresses);
            mail.setToAddresses(toAddresses);
            mail.setSenderDisplayName('Mr Apex Trigger');
            mail.setSubject('Campaign Details');
            Integer TotalNumOfOpp = NumOfOppClosedWon + NumOfOppClosedLost;
            mail.setHtmlBody('<style>th, td { border: 1px solid; border-collapse:collapse; padding: 10px;} </style>'
                                + 'Dear ' + firstName + ' ' + lastName +',<br /><br />'
                                + 'These are the changes made in the Campaign due to the closing:<br />' + 
                                + '<table>'
                                + '<tr>'
                                + '<th>Total Number Of Won Opportunities</th>'
                                + '<td style="background: green; color: white;">' + NumOfOppClosedWon + '</td>'
                                + '</tr>'
                                + '<tr>'
                                + '<th>Total Number Of Lost Opportunities</th>'
                                + '<td style="background: red; color: white;">' + NumOfOppClosedLost + '</td>'
                                + '</tr>'
                                + '<tr>'
                                + '<th>Total Amount Of Won Opportunities</th>'
                                + '<td style="background: gold; color: white;">$' + WonAmount + '</td>'
                                + '</tr>'
                                + '</table><br /><br /><br /><br /><br />'
                                + '<hr>'
                                + 'Regards<br />AnalogForce<br />Salesforce Team.'
                             );
            List<Messaging.SendEmailResult> results = Messaging.sendEmail(new Messaging.Email[] {mail});
            if(!results.get(0).isSuccess()) {
                System.debug('Failed mail ' + results.get(0).getErrors()[0].getMessage());
            } else {
                System.debug('Email Sent!');
            }
            
            
            
        }
    }
}