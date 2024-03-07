import pandas as pd

# Read the CSV file
currprogs_data = pd.read_csv("./LFLCurrProgs.csv")
origprogs_data = pd.read_csv("./REL_PROG_CATALOG.csv")

currsds_data = pd.read_csv("./LFLCurrSD.csv")
origsds_data = pd.read_csv("./REL_SD_CATALOG.csv")

currobj_data = pd.read_csv("./LFLCurrObj.csv")
origobj_data = pd.read_csv("./REL_OBJ_CATALOG.csv")

currprogs_data = currprogs_data.fillna('')
origprogs_data = origprogs_data.fillna('')

currsds_data = currsds_data.fillna('')
origsds_data = origsds_data.fillna('')

currobj_data = currobj_data.fillna('')
origobj_data = origobj_data.fillna('')


#print (currprogs_data.head())
#print (origprogs_data.head())

print ('PROGS')
print('original')
print(origprogs_data.shape)
print('current')
print(currprogs_data.shape)
df=pd.concat([currprogs_data,origprogs_data]).drop_duplicates(keep=False) 
print ('PROG difference')
print (df.shape)
print(df)
df.to_csv('REPAIRprog.csv', index=False)  

print ('SDs')
print('original')
print(origsds_data.shape)
print('current')
print(currsds_data.shape)
df=pd.concat([currsds_data,origsds_data]).drop_duplicates(keep=False) 
print ('SD difference')
print (df.shape)
print(df)
df.to_csv('REPAIRsd.csv', index=False)  


print ('OBJs')
print('original')
print(origobj_data.shape)
print('current')
print(currobj_data.shape)
df=pd.concat([currobj_data,origobj_data]).drop_duplicates(keep=False) 
print ('OBJ difference')
print (df.shape)
print(df)
df.to_csv('REPAIRobj.csv', index=False)  


