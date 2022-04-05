sfdx force:org:delete -u L4Lscratch
sfdx shane:org:create --verbose --userprefix=mike --userdomain=l4ldemo.com -f config/project-scratch-def.json -d 30 -s -a L4Lscratch 
sfdx force:source:push
sfdx force:user:permset:assign -n L4LPS
sfdx shane:user:password:set -p sfdx1234 -g User -l User
sfdx force:org:open -p "/lightning/o/Contact/list?filterName=AllContacts"
