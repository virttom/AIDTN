# AIDTN
Automation of IOMETER Deployment and Treatment for Nutanix : 

This project's objective is to deploy + configure + synthetize results of an IOMETER configuration for HCI testing. It rely on several studies / methodologies from NUTANIX PERFORMANCE TEAM which can be found THERE :

http://next.nutanix.com/t5/Nutanix-Connect-Blog/Configuring-Iometer-Performance-Tests-on-Nutanix-the-Right-Way/ba-p/13255
and here : 
https://www.derekseaman.com/2014/10/running-iometer-nutanix.html

Autom-action list :
- action : [tier] : status : [goal] : comment ------------

explanation of this kind of Workload Breakdown Structure : 
- action : module / function / script that should be written to automate action.
- tier : tier1 is urgent to tier3 will be done... well one day
- status : TBS (To Be Scripted) | partially means partially scripted (in term of functionnalities) | realse 
- goal : what's that for ? 
- comment : do I really need to comment this ? 

1. generate ovf : [tier = 3] : status = TBS : [goal  = ] : comment : .  

2. deploy ovf : [tier = 3] : status = TBS : [goal  = ] : comment : .  

3. configure ovf : [tier = 2] : status = partially : [goal  = hdd / IP configuration after ovf deployment] : comment : script HDD-IOMETER create HDD / CONTROLLER for this configuration.  

4. execute script : [tier = 3] : status = TBS : [goal  = ] : comment : . 

5. collect log : [tier = 3] : status = TBS : [goal  = ] : comment : . 

6. data extraction by IOMETER : [tier = 3] : status = TBS : [goal  = ] : comment : . 

7. consolidate extraction in 1 file : [tier = 3] : status = TBS : [goal  = ] : comment : . 


And One day it will be unified, one script to rule them all ! 
