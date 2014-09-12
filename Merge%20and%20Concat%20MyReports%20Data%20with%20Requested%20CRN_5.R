# Author: Aaron G. Baca, UNM/IT, 7/21/14
# Purpose: to prep IDEA Online data extracted from the Extended Learning ClassList query in MyReports
# Please install the R stringr app, if you have not done so already > install.packages("stringr")
# Please install the R xlsReadWrite package if you have not done so already > install.packages("WriteXLS")

# Important! In line 106 below, please change "idea" to your NetID as that gets tacked onto an @unm.edu domain as 
# an email address for student records that contain blank NetIDs

# Call the stringr library
library(stringr)

# Call the xls conversion libraries
library(WriteXLS)

# Please set the R working directory to where your MyReports data and R programs are located
# Replace "C:/Aaron/MyReports/...." path below with the path to your files
setwd("C:\\Aaron\\IDEA\\IDEA Online Project\\Taos201480")


# Read in the MyReports data, i.e. the Class_List_GAH-4.csv files
# Note: you must use the following fields from the MyReports EL classList query: 
# - Course Information Window -
#    ACADEMIC_PERIOD_CODE, SUBJECT,	COURSE_NUMBER, SECTION_NUMBER,	COURSE_REFERENCE_NUMBER, COURSE_TITLE,
#    PRIMARY_INSTRUCTOR_EMAIL,	PRIMARY_INSTRUCTOR_FIRST_NAME, PRIMARY_INSTRUCTOR_LAST_NAME, PRIMARY_INSTRUCTOR_NETID,
#    COURSE_DEPARTMENT_CODE,	INST_DELIVERY_MODE_CODE, INST_DELIVERY_MODE_DESC, CIP_CODE, COURSE_COLLEGE_CODE, 
#    COURSE_COLLEGE_DESC,	CAMPUS_CODE, CAMPUS_DESC, 
# - Scheduling Information Window -
#    START_DATE, END_DATE, MONDAY_IND, TUESDAY_IND,	WEDNESDAY_IND, THURSDAY_IND, FRIDAY_IND, SATURDAY_IND,
#    SUNDAY_IND,	ACTUAL_ENROLLMENT, MEETING_DAYS, MEETING_TIME, SCHEDULE_TYPE_DESC, 
# - Personal Information Window -
#    STUDENT_NAME, CONFIDENTIALITY_IND, BANNER_ID,	STUDENT_NETID, EMAIL_ADDRESS, REGISTRATION_STATUS_DESC,	PROGRAM_CLASSIFICATION

# Replace the "Class_List_GAH-4.csv" file name with your .csv filename from MyReports EL classList query
MyReportsDat <- read.csv("Class_List_GAH_AllClassesAllStudents.csv", header = TRUE, stringsAsFactors=FALSE)

# Read in the file containing requested CRNs
# Setup a master CRN file using column A containing only the CRN that you want to merge data for
CRNDat <- read.csv("CRNKey.csv", header = TRUE, stringsAsFactors=FALSE)

# Merge the CRNs requested with the MyReports queried data
tmp <- merge(MyReportsDat, CRNDat, by = "COURSE_REFERENCE_NUMBER")

# Write the merged data to file for record
write.csv(tmp, file = "AllRawMergedData.csv")

# Add leading zeros to the COURSE_SECTION_NUMBER field to form complete three digit length, as MyReports strips leading zeros
numrows <- nrow(tmp) # Set number of rows variable for the Data.Frame

n <- 1
while(n <= numrows) {
  if (as.numeric(tmp$COURSE_SECTION_NUMBER[n])<=9) {
    #tmp$COURSE_SECTION_NUMBER[n] <-  sprintf("%2s",tmp$COURSE_SECTION_NUMBER[n])
    (str_sub(tmp$COURSE_SECTION_NUMBER[n], -2,-2) <- "00") 
  } 
  if (as.numeric(tmp$COURSE_SECTION_NUMBER[n])<=99 && as.numeric(tmp$COURSE_SECTION_NUMBER[n])>=10) {
    #tmp$COURSE_SECTION_NUMBER[n] <-  sprintf("%2s",tmp$COURSE_SECTION_NUMBER[n])
    (str_sub(tmp$COURSE_SECTION_NUMBER[n], -3,-3) <- "0") 
  } 
  #print(tmp$COURSE_SECTION_NUMBER[n])
  n <- n+1
}  


# Create the ExternalID field, and then add a dot between the last two fields in the 'numrows' while loop
tmp$ExternalID <- do.call(paste, c(tmp[c("ACADEMIC_PERIOD",	"SUBJECT",	"COURSE_NUMBER",	"COURSE_SECTION_NUMBER", "COURSE_REFERENCE_NUMBER"
)], sep = " "))

# Add "." to ExternalID field. In Excel formula to add ".""=LEFT(AP2,15)&"."&RIGHT(AP2,5)"

n <- 1
while(n <= numrows) {
  sprintf("%-6s", tmp$ExternalID[n])
  (str_sub(tmp$ExternalID[n], -6,-6) <- ".") 
  n <- n+1
}

n <- 1
while(n <= numrows) {
  tmp$ExternalID[n] <- gsub(" ","", tmp$ExternalID[n] , fixed=TRUE)
  n <- n+1
}


# Set number of columns variable for the Data.Frame
numcols <- ncol(tmp)

# If INSTRUCTION_DELIVERY_MODE field is blank, make it a 'F2F' class
n <- 1
while(n <= numrows) {
  if (tmp$INSTRUCTION_DELIVERY_MODE[n]==".") {
    tmp$INSTRUCTION_DELIVERY_MODE[n] <- "F2F" }
  n <- n+1
}

# Create the CourseNumber field
tmp$CourseNumber <- do.call(paste, c(tmp[c("INSTRUCTION_DELIVERY_MODE",  "SUBJECT",	"COURSE_NUMBER",	"COURSE_SECTION_NUMBER", "COURSE_REFERENCE_NUMBER"
)], sep = "."))

# Create the RespondentExternalID field
tmp$RespondentExternalID <- do.call(paste, c(tmp[c("NETID")], sep = ""))

# Set blank NetIDs to "idea" so that idea@unm.edu can be alerted when student evaluations go out
n <- 1
while(n <= numrows) {
  if (tmp$RespondentExternalID[n]==".") {
    tmp$RespondentExternalID[n] <- "idea"} 
  n <- n+1
}

# Create the RespondentName field
tmp$RespondentName <- do.call(paste, c(tmp[c("FULL_NAME_LFMI")], sep = ""))

# Create the RespondentEmail field
tmp$RespondentEmail <- do.call(paste, c(tmp[c("RespondentExternalID")], sep = ""))

# Add the domain to the RespondentEmail field
tmp$RespondentEmail <- do.call(paste, c(tmp[c("RespondentExternalID")], "@unm.edu", sep = ""))

# Extract the first four characters of the MEETING_TIME field to create a new TimeClassBegins field
tmp$TimeClassBegins <- str_sub(tmp$MEETING_TIME,1, 4)

# Reasign field names
n <- 1
while(n <= numcols) {
  CN <- names(tmp)[n]
   if (CN == "TITLE_SHORT_DESC") {
     names(tmp)[n] <- "CourseTitle"
   }  
  if (CN == "INSTRUCTION_DELIVERY_MODE") {
    names(tmp)[n] <- "InstructionType"
  }  
  if (CN == "PRIMARY_INSTRUCTOR_EMAIL") {
    names(tmp)[n] <- "InstructorEmail"
  } 
  if (CN == "PRIMARY_INSTRUCTOR_FIRST_NAME") {
    names(tmp)[n] <- "FirstName"
  } 
  if (CN == "PRIMARY_INSTRUCTOR_LAST_NAME") {
    names(tmp)[n] <- "LastName"
  } 
  if (CN == "MEETING_DAYS") {
    names(tmp)[n] <- "DaysClassMeets"
  }  
  if (CN == "CIP_CODE") {
    names(tmp)[n] <- "DisciplineCode"
  } 
  n <- n+1
} 

# Fix Discipline Codes
n <- 1
while(n < numrows) {
  DC <- tmp$DisciplineCode[n]
   if (tmp$DisciplineCode[n]=="1101") {
     tmp$DisciplineCode[n] <- "1100"} 
   if (tmp$DisciplineCode[n]=="1513") {
     tmp$DisciplineCode[n] <- "4801"} 
   if (tmp$DisciplineCode[n]=="1601") {
     tmp$DisciplineCode[n] <- "1600"} 
   if (tmp$DisciplineCode[n]=="1616") {
     tmp$DisciplineCode[n] <- "1600"} 
   if (tmp$DisciplineCode[n]=="3802") {
     tmp$DisciplineCode[n] <- "3900"} 
   if (tmp$DisciplineCode[n]=="4201") {
     tmp$DisciplineCode[n] <- "4207"} 
   if (tmp$DisciplineCode[n]=="5401") {
     tmp$DisciplineCode[n] <- "4508"} 
   if (tmp$DisciplineCode[n]=="2401") {
     tmp$DisciplineCode[n] <- "2400"} 
   if (tmp$DisciplineCode[n]=="0301") {
     tmp$DisciplineCode[n] <- "0300"}
   if (tmp$DisciplineCode[n]=="1512") {
     tmp$DisciplineCode[n] <- "5212"}
   if (tmp$DisciplineCode[n]=="5138") {
     tmp$DisciplineCode[n] <- "5111"}
   if (tmp$SUBJECT[n]=="ACAM") {
     tmp$DisciplineCode[n] <- "9901"} 
   if (tmp$SUBJECT[n]=="AENG") {
     tmp$DisciplineCode[n] <- "9902"} 
   n <- n+1
}

# Setup variable capture, and field creation for IFstartDate
createifstartdate <- function()
{
l <- 0
n <- 0
while(n < 1 ){
  while(l < 1) {
     tmp$IFstartDate <- readline("Please enter the date (mm/dd/yy) that you wish to start or begin the FIF invitations:") 
     ifelse (tmp$IFstartDate != "", l <- 1, NA) 
  }   
  tmp$IFstartDate <- as.Date(tmp$IFstartDate, "%m/%d/%y")
  print(tmp$IFstartDate[1])
  ckdatesYN <- readline("Is the FIF start date correct: yes/no?")
  if (ckdatesYN == "yes") {
    n <- 1} else { if (ckdatesYN == "no") 
      l <- 0
  }  
 }
# Write the modified field and file to disk so they can be compressed in XML format by the XML Creator app
write.csv(tmp, file = "FinalMergedData1.csv")
createifenddate()
}


# Setup variable capture, and field creation for IFendDate 
createifenddate <- function()
{
a <- 0
b <- 0
while(b < 1 ){
  while(a < 1) {
    tmp$IFendDate <- readline("Please enter the date (mm/dd/yy) that you wish to close or end the FIF invitations:") 
    ifelse (tmp$IFendDate != "", a <- 1, NA) 
  }   
  tmp$IFendDate <- as.Date(tmp$IFendDate, "%m/%d/%y")
  print(tmp$IFendDate[1])
  ckdatesYN <- readline("Is the FIF end date correct: yes/no?")
  if (ckdatesYN == "yes") {
    b <- 1} else { if (ckdatesYN == "no") 
      a <- 0
  }  
 }
# Write the modified fields and file to disk so they can be compressed in XML format by the XML Creator app
write.csv(tmp, file = "FinalMergedData2.csv")
createifreminderfrequency()
}


# Setup variable capture, and field creation for IFreminderFrequency
createifreminderfrequency <- function()
{
  c <- 0
  d <- 0
  while(d < 1 ){
    while(c < 1) {
      tmp$IFreminderFrequency <- readline("Please enter the frequency of days that you wish to email faculty FIF invitations:") 
      ifelse (tmp$IFreminderFrequency != "", c <- 1, NA) 
    }   
    tmp$IFreminderFrequency <- as.numeric(tmp$IFreminderFrequency, "99")
    print(tmp$IFreminderFrequency[1])
    ckdatesYN <- readline("Is the frequency of days that you wish to email faculty invitations correct: yes/no?")
    if (ckdatesYN == "yes") {
      d <- 1} else { if (ckdatesYN == "no") 
        c <- 0
      }  
  }
  # Write the modified fields and file to disk 
  write.csv(tmp, file = "FinalMergedData3.csv")
  createrfstartdate()
}


# Setup variable capture, and field creation for RFstartDate
createrfstartdate <- function()
{
  l <- 0
  n <- 0
  while(n < 1 ){
    while(l < 1) {
      tmp$RFstartDate <- readline("Please enter the date (mm/dd/yy) that you wish to start or begin Student evaluations:") 
      ifelse (tmp$RFstartDate != "", l <- 1, NA) 
    }   
    tmp$RFstartDate <- as.Date(tmp$RFstartDate, "%m/%d/%y")
    print(tmp$RFstartDate[1])
    ckdatesYN <- readline("Is the Student survey start date correct: yes/no?")
    if (ckdatesYN == "yes") {
      n <- 1} else { if (ckdatesYN == "no") 
        l <- 0
      }  
  }
  # Write the modified fields and file to disk 
  write.csv(tmp, file = "FinalMergedData4.csv")
  createrfenddate()
}


# Setup variable capture, and field creation for RFendDate
createrfenddate <- function()
{
  l <- 0
  n <- 0
  while(n < 1 ){
    while(l < 1) {
      tmp$RFendDate <- readline("Please enter the date (mm/dd/yy) that you wish to stop Student evaluations:") 
      ifelse (tmp$RFendDate != "", l <- 1, NA) 
    }   
    tmp$RFendDate <- as.Date(tmp$RFendDate, "%m/%d/%y")
    print(tmp$RFendDate[1])
    ckdatesYN <- readline("Is the Student survey stop date correct: yes/no?")
    if (ckdatesYN == "yes") {
      n <- 1} else { if (ckdatesYN == "no") 
        l <- 0
      }  
  }
  # Write the modified field and file to disk 
  write.csv(tmp, file = "FinalMergedData5.csv")
  createrfreminderfrequency()
}


# Setup variable capture, and field creation for RFreminderFrequency
createrfreminderfrequency <- function()
{
  c <- 0
  d <- 0
  while(d < 1 ){
    while(c < 1) {
      tmp$RFreminderFrequency <- readline("Please enter how often, in days, that you wish to remind students, via email, about IDEA surveys:") 
      ifelse (tmp$RFreminderFrequency != "", c <- 1, NA) 
    }   
    tmp$RFreminderFrequency <- as.numeric(tmp$RFreminderFrequency, "99")
    print(tmp$RFreminderFrequency[1])
    ckdatesYN <- readline("Is the frequency of days that you wish to email students correct: yes/no?")
    if (ckdatesYN == "yes") {
      d <- 1} else { if (ckdatesYN == "no") 
        c <- 0
      }  
  }
  # Write the modified field and file to disk 
  write.csv(tmp, file = "FinalMergedData6.csv")
  mydata1 = read.csv("FinalMergedData1.csv", header=T)
  mydata2 = read.csv("FinalMergedData2.csv", header=T)
  mydata3 = read.csv("FinalMergedData3.csv", header=T)
  mydata4 = read.csv("FinalMergedData4.csv", header=T)
  mydata5 = read.csv("FinalMergedData5.csv", header=T)
  mydata6 = read.csv("FinalMergedData6.csv", header=T)
  
  XML_CreatorReadyData <- merge(mydata1, mydata2)
  XML_CreatorReadyData2 <- merge(XML_CreatorReadyData, mydata3)
  XML_CreatorReadyData3 <- merge(XML_CreatorReadyData2, mydata4)
  XML_CreatorReadyData4 <- merge(XML_CreatorReadyData3, mydata5)
  XML_CreatorReadyData5 <- merge(XML_CreatorReadyData4, mydata6)

  
  # Write the final merged file data to disk
  write.csv(XML_CreatorReadyData5, file = "XML_CreatorReadyData8.csv")

}

createifstartdate()





