sfdx force:org:delete -u L4Lscratch4
sfdx shane:org:create --verbose --userprefix=mike --userdomain=l4ldemo.com -f config/project-scratch-def.json -d 30 -s -a L4Lscratch4

# install nebula logging and assign permissions
sfdx force:package:install -w 20 -r -p  04t5Y0000015lmOQAQ
sfdx force:user:permset:assign -n LoggerAdmin
sfdx force:user:permset:assign -n LoggerEndUser	
sfdx force:user:permset:assign -n LoggerLogCreator
sfdx force:user:permset:assign -n LoggerLogViewer

sfdx force:source:push --loglevel=debug
sfdx force:user:permset:assign -n L4LPS
sfdx shane:user:password:set -p sfdx1234 -g User -l User
sfdx force:org:open -p "/lightning/o/Contact/list?filterName=AllContacts"
sfdx force:apex:test:run --testlevel RunLocalTests
#sfdx force:user:create --setalias qa-user --definitionfile config/user-def.json
#sfdx shane:user:password:set -p sfdx1234 -g Mike -l DeHennin
#sfdx force:apex:execute -f ./config/apex/load.apex
sfdx texei:data:import --inputdir ./sfdx-out --targetusername L4Lscratch4