#This results in a memory error 
db<-"//nyodska01/cbwide/Arvi Data Share/Data Science/CrossProg12.accdb"
con2<-odbcConnectAccess2007(db)
sqlTables(con2, tableType = "TABLE")$TABLE_NAME
Xprogr12<-sqlFetch(con2,"Xprog12")

#this doesnt work either
wb <- "//nyodska01/cbwide/Arvi Data Share/Data Science/AI_LatLon.xls"
con2 <- odbcConnectExcel2007(wb)

#Nor this
library(RODBC)
myconn <-odbcConnectAccess(""//nyodska01/cbwide/Arvi Data Share/Data Science/CrossProg12")
crimedat <- sqlFetch(myconn, Xprog12)


/*This works--reads data in as tables */
AILatLon = read.csv("//nyodska01/cbwide/Arvi Data Share/Data Science/OtherFilesasCSV/AI_LatLon.csv")
EnrollmentbyAI = read.csv("//nyodska01/cbwide/Arvi Data Share/Data Science/OtherFilesasCSV/Enrollment by AI.csv")
sat_tc = read.csv("//nyodska01/cbwide/Arvi Data Share/Data Science/OtherFilesasCSV/sat_tc_vol_fy13.csv")
TCid = read.csv("//nyodska01/cbwide/Arvi Data Share/Data Science/OtherFilesasCSV/TC_ID to AI_cd.csv")
PSAT_Agg= read.csv("//nyodska01/cbwide/Arvi Data Share/Data Science/PSAT_Agg_by_AIcode.csv")
State= read.csv("//nyodska01/cbwide/Arvi Data Share/Data Science/StateLookup.csv")

#This changes the column name so we can merge
names(Merge1)[7]<-"StateCode"

#Merging tables
Merge1<-merge(AILatLon,PSAT_Agg, by.x="AI.NUM", by.y="AiCode", all.x=TRUE)  
Merge2<-merge(Merge1, State, by="StateCode")


#Noticed that there are some duplicates of T center id i.e. same id with both active and inactive.  Here we remove inactive
NewTCid<-TCid[which (TCid$ACTIVE_IND=="Y"), ]

#old Merge3
Merge3<-merge(Merge2, TCid, by.x="AI.NUM", by.y="CENTER_AI_CD") #8206
  Merge3<-merge(Merge2, TCid, by.x="AI.NUM", by.y="TEST_CENTER_ID") #535 -wasnt sure what mapped to what, not using this

#New Merge3
Merge3<-merge(Merge2, NewTCid, by.x="AI.NUM", by.y="CENTER_AI_CD", all.x=TRUE)

#write data to file
write.csv(Merge3,file="C:/Projects/OptimumLocation/MergedData.csv")
