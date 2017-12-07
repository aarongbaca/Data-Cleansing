# ***Use For Reconciling Student Drops and Adds Before Student Surveys are Released***
# Author: Aaron G. Baca, UNM/IT, 6/12/17

# Note that you must obtain a complete User export file from your EvaluationKIT project as well as an updated MyReports query for this to work
# Step 1. Download the 'UserExport_2017SummerCourses' from your EvaluationKIT project, that you want to update drop/add student info to;
# Step 2. Upldate line '24' with the exact name of the 'Export All Project Users' file;
# Step 3. Make sure your 'setwd' path on line 21 is correct for your PC, i.e. place all files in this one folder;
# Step 4. Obtain a fresh MyReports query, save as .csv file and make sure file name matches on line 42 and line 231 below;
# Step 5. Run this program;
# Step 6. Save the two 'New2Add' and 'Drops2Delete' files as .xls or .xlsx format and upload into your Project under 'Users/Data Import' tabs.  

#install.packages("stringr")
library(stringr)
#install.packages("stringi")
library(stringi)
#library(compare)
# Call the xls conversion libraries
#install.packages("WriteXLS")
library(WriteXLS)

# Please set the R working directory to where your MyReports data and R programs are located
# Replace "/Users/aaronbaca/Documents/EvaluationKIT/...." path below with the path to your files
# Add "C://path//path" for Windows based R package
#setwd("/Users/aaronbaca/Documents/EvaluationKIT/Summer 2017/TestEnrollmentReconciliation")
#setwd("/Users/aaronbaca/Documents/EvaluationKIT/Fall 2017/TestEnrollmentReconciliation")
#setwd("/Users/aaronbaca/Documents/EvaluationKIT/Fall 2017/Amrita/11-7 Request3")
setwd("/Users/aaronbaca/Documents/EvaluationKIT/Fall 2017/Group B Student Reconcile Connor")


# Read-in the User Export file from EvalKIT, where this program adds newly enrolled students and sets an unenroll flag of '1' to students who have dropped courses
UserExportDat <- read.csv("UserExport_2017FallCourses-GroupB.csv", header = TRUE, stringsAsFactors=FALSE)

# Remove all Instructor records, i.e. Type = 3
UserExportDat <- subset(UserExportDat, UserExportDat$UserTypeID == "4")

# Remove the following fields from the UserExportDat table: 
UserExportDat$CAMPUS <- NULL
UserExportDat$CAMPUS_DESC <- NULL
UserExportDat$COURSE_REFERENCE_NUMBER <- NULL
UserExportDat$F1 <- NULL

# Add the following field/header name to the UserExportDat file: Unenroll and leave eah field as blank
UserExportDat$Unenroll <- ""

# Read in the MyReports data, i.e. the Class_List_GAH.csv file
# Below replace the "Class_List_GAH (**),csv" file name with the MyReports file name that contains all student/course data
MyReportsDat <- read.csv("Class_List_GAH (12).csv", header = TRUE, stringsAsFactors=FALSE)

#--------------------------Course must be rolled-up as in the main R program so as not to exclude any student records, as some
# ------------------CourseUniqueIDs will be missing, i.e the ones that were rolled-up in the main R program previously
#--------------------------So, same process must be applied here to compare apples with apples, otherwise the drop add records 
#-------------------may not be accurate for courses that were rolled-up

# Remove non-participating departments out of MyReportsDat
MyReportsDat <- subset(MyReportsDat, (str_sub(MyReportsDat$COLLEGE_DESC)!="College of Pharmacy"))
MyReportsDat <- subset(MyReportsDat, (str_sub(MyReportsDat$COLLEGE_DESC)!="School of Law"))
MyReportsDat <- subset(MyReportsDat, (str_sub(MyReportsDat$SUBJECT)!="ISEP"))
MyReportsDat <- subset(MyReportsDat, (str_sub(MyReportsDat$SUBJECT)!="NSE"))
MyReportsDat <- subset(MyReportsDat, (str_sub(MyReportsDat$SUBJECT)!="AFAS"))
#MyReportsDat <- subset(MyReportsDat, (str_sub(MyReportsDat$SUBJECT)!="MDVL")) # Note that MDVL now partiicpates
MyReportsDat <- subset(MyReportsDat, (str_sub(MyReportsDat$SUBJECT)!="MLSL"))
MyReportsDat <- subset(MyReportsDat, (str_sub(MyReportsDat$SUBJECT)!="BIOM"))
MyReportsDat <- subset(MyReportsDat, (str_sub(MyReportsDat$SUBJECT)!="PAST"))
MyReportsDat <- subset(MyReportsDat, (str_sub(MyReportsDat$SUBJECT)!="PT"))
MyReportsDat <- subset(MyReportsDat, (str_sub(MyReportsDat$SUBJECT)!="OCTH"))
MyReportsDat <- subset(MyReportsDat, (str_sub(MyReportsDat$SUBJECT)!="NUCM"))
MyReportsDat <- subset(MyReportsDat, (str_sub(MyReportsDat$SUBJECT)!="MEDL"))

#Remove all main campus PHIL records where CAMPUS_DESC = Albuquerque/Main and add only ONL PHIL courses & Branch PHIL courses back into the main MyReportsDat data set
allPHILRecs <- subset(MyReportsDat, MyReportsDat$SUBJECT == "PHIL") # Copy All PHIL recs from main MyReportsDat to 'allPHILRecs'
MyReportsDat <- subset(MyReportsDat, MyReportsDat$SUBJECT != "PHIL") # Remove all PHIL recs from main 'MyReportsDat' 
saveBranchPHILRecs <- subset(allPHILRecs, allPHILRecs$CAMPUS_DESC != "Albuquerque/Main") # Save all Branch Campus Phil recs to 'saveBranchPHILRecs'
saveABQPHILRecs <- subset(allPHILRecs, allPHILRecs$CAMPUS_DESC == "Albuquerque/Main") # Save all ABQ Main Campus PHIL recs
saveABQPHILonlineRecs <- subset(saveABQPHILRecs, saveABQPHILRecs$INSTRUCTION_DELIVERY_MODE == "ONL") # Pull & save ABQ Onlin Main Campus PHIL recs to survey 
MyReportsDat = rbind(MyReportsDat, saveBranchPHILRecs, saveABQPHILonlineRecs)
rm(allPHILRecs)
rm(saveBranchPHILRecs)
rm(saveABQPHILonlineRecs)
rm(saveABQPHILRecs)

# Re-Set number of rows variable for the Data.Frame
#numrows <- nrow(MyReportsDat) 
# Set number of columns variable for the Data.Frame to use in algorithms below
numcols <- ncol(MyReportsDat)

# Add leading zeros to the COURSE_SECTION_NUMBER field to form complete three digit length, as MyReports strips leading zeros
MyReportsDat$COURSE_SECTION_NUMBER <- invisible(stri_pad_left(str=MyReportsDat$COURSE_SECTION_NUMBER, 2, pad="0"))
MyReportsDat$COURSE_SECTION_NUMBER <- invisible(stri_pad_left(str=MyReportsDat$COURSE_SECTION_NUMBER, 3, pad="0"))
#formatC(MyReportsDat$COURSE_SECTION_NUMBER, width = 2,flag = 0)
#formatC(MyReportsDat$COURSE_SECTION_NUMBER, width = 3,flag = 0)

# Reasign field names to match Export file
n <- 1
while(n <= numcols) {
  CN <- names(MyReportsDat)[n]
  if (CN == "NETID") {
    names(MyReportsDat)[n] <- "Username"
  }  
  if (CN == "EMAIL_ADDRESS") {
    names(MyReportsDat)[n] <- "Email"
  } 
  n <- n+1
} 

# Remove student records with blank USERNAMEs/NetIDs, is primarity for Gallup
MyReportsDat <- subset(MyReportsDat, (str_sub(MyReportsDat$Username, 1,4)!=".") )

# Remove any duplicate student recoreds
MyReportsDat <- unique(MyReportsDat)

#### Roll-up all records by Instructor by Course by Title, where INSTRUCTION_DELIVERY_MODE == 'ITVPE' and == 'ONL' Irespective of Campus!
# Note: all child ITV Course Reference Numbers must be included in the CRNKey file!
# and where course number, title, and instructor NetID are the same, then assign Parent ITVPE CRN to all child records including matching ONL courses

# 1st remove ITVPE and ONL course data into its own data subset
allITVPE <- subset(MyReportsDat, MyReportsDat$INSTRUCTION_DELIVERY_MODE == "ITVPE") # make a copy of all ITVPE course records
MyReportsDat <- subset(MyReportsDat, MyReportsDat$INSTRUCTION_DELIVERY_MODE != "ITVPE") # Remove all ITVPE courses from master MyReportsDat dataset
allONL <- subset(MyReportsDat, MyReportsDat$INSTRUCTION_DELIVERY_MODE == "ONL") # make a copy of ONL course records
MyReportsDat <- subset(MyReportsDat, MyReportsDat$INSTRUCTION_DELIVERY_MODE != "ONL") # Remove all ONL course records from the master MyReportsDat dataset
allITVPEONL = rbind(allITVPE, allONL) # combine ITVPE and ONL courses into one dataset
rm(allITVPE) # remove extraneous datasets no longer needed
rm(allONL)

# Remove any duplicate recoreds
allITVPEONL <- unique(allITVPEONL)

# Combine all ITVPE and ONL courses by Instructor, Course Number and Title
# Get unique CRNs from allITVPEONL to use for the next 'while' loop below
# uniqueCRNs <- subset(allITVPEONL, select = c(1))
# uniqueCRNs <- unique(uniqueCRNs)

# Get the number of rows for the unique CRNs to use for the master 'while' loop below
numUniqueCRNRows <- nrow(CRNKey) 

# Sort/index the data so ITVPE and ONL courses are grouped by instructor and course number
invisible(allITVPEONL[with(allITVPEONL, order(PRIMARY_INSTRUCTOR_NETID, COURSE_NUMBER, COURSE_SECTION_NUMBER, INSTRUCTION_DELIVERY_MODE_DESC)), ])

# Set number of rows variable for the Data.Frame and sub-while loops
numrows <- nrow(allITVPEONL) 

holdCRN <- NULL
#l <- 1
o <- 1
n <- 1
while(n <= numrows) { 
  holdnetid <- allITVPEONL$PRIMARY_INSTRUCTOR_NETID[n]
  holdCRN <- allITVPEONL$COURSE_REFERENCE_NUMBER[n]
  holdcampuscode <- allITVPEONL$CAMPUS[n]
  holdcampusdesc <- allITVPEONL$CAMPUS_DESC[n]
  holdcoursenumber <- allITVPEONL$COURSE_NUMBER[n]  
  holdtitle <- allITVPEONL$TITLE_SHORT_DESC[n]
  holdAP <- allITVPEONL$SUB_ACADEMIC_PERIOD_DESC[n]
  yesflag <- "no"
  o <- 1 
  while(o <= numrows) {                            # roll-up all courses by instructor, by course, by title, and by campus
    if (allITVPEONL$COURSE_REFERENCE_NUMBER[o] != holdCRN && allITVPEONL$SUB_ACADEMIC_PERIOD_DESC[o] == holdAP) {
      if (allITVPEONL$PRIMARY_INSTRUCTOR_NETID[o] == holdnetid && allITVPEONL$COURSE_NUMBER[o] == holdcoursenumber && allITVPEONL$TITLE_SHORT_DESC[o] == holdtitle) {
        allITVPEONL$COURSE_SECTION_NUMBER[o] <- "-ALL Online Sections" 
        allITVPEONL$COURSE_REFERENCE_NUMBER[o] <- holdCRN
        allITVPEONL$CAMPUS[o] <- holdcampuscode
        allITVPEONL$CAMPUS_DESC[o] <- holdcampusdesc
        yesflag <- "yes"
      }
    }
    o <- o+1
  }    
  # The following if and ifelse statements make sure that the original/parent records are assigned with 'All Online Sections' 
  if (yesflag=="yes") {allITVPEONL$COURSE_SECTION_NUMBER <- ifelse(allITVPEONL$COURSE_REFERENCE_NUMBER == holdCRN,"-All Online Sections",allITVPEONL$COURSE_SECTION_NUMBER)}
  n <- n+1
}  

# Remove any duplicate student recoreds
allITVPEONL <- unique(allITVPEONL)

# Write the Student User data to file to view test data was combined correctly and this file/code can be deleted later
write.csv(allITVPEONL, file = "SaveITVPEONLRecs.csv")

#***********************************************************



#### ROLL-UP All Music 'APMS' COURSES by INSTRUCTOR

# Remove APMS course data into its own data subset Note: APMS courses exist on Main Campus only
allAPMS <- subset(MyReportsDat, MyReportsDat$SUBJECT == "APMS") 
MyReportsDat <- subset(MyReportsDat, MyReportsDat$SUBJECT != "APMS") 

# Sort/index the data 
invisible(allAPMS[with(allAPMS, order(PRIMARY_INSTRUCTOR_NETID, COURSE_NUMBER, COURSE_SECTION_NUMBER)), ])

numrowsAPMS <- nrow(allAPMS)

holdCRN <- NULL
#l <- 1
o <- 1
n <- 1
while(n <= numrowsAPMS) { 
  holdnetid <- allAPMS$PRIMARY_INSTRUCTOR_NETID[n]
  holdCRN <- allAPMS$COURSE_REFERENCE_NUMBER[n]
  holdcoursenumber <- allAPMS$COURSE_NUMBER[n]  
  holdtitle <- allAPMS$TITLE_SHORT_DESC[n]
  yesflag <- "no"
  o <- 1 
  while(o <= numrowsAPMS) {                            # roll-up all courses by instructor, by course, by title, and by campus
    if (allAPMS$COURSE_REFERENCE_NUMBER[o] != holdCRN) {
      if (allAPMS$PRIMARY_INSTRUCTOR_NETID[o] == holdnetid) {
        allAPMS$COURSE_SECTION_NUMBER[o] <- "" 
        allAPMS$COURSE_REFERENCE_NUMBER[o] <- holdCRN
        allAPMS$TITLE_SHORT_DESC[o] <- " ALL APMS Classes Combined"
        yesflag <- "yes"
      }
    }
    o <- o+1
  }    
  # The following if and ifelse statements make sure that the original/parent records are assigned with 'All Online Sections' 
  if (yesflag=="yes") {allAPMS$COURSE_NUMBER <- ifelse(allAPMS$COURSE_REFERENCE_NUMBER == holdCRN," ALL APMS Courses Combined",allAPMS$COURSE_NUMBER)}
  if (yesflag=="yes") {allAPMS$TITLE_SHORT_DESC <- ifelse(allAPMS$COURSE_REFERENCE_NUMBER == holdCRN," ALL APMS Classes Combined",allAPMS$TITLE_SHORT_DESC)}
  if (yesflag=="yes") {allAPMS$COURSE_SECTION_NUMBER <- ifelse(allAPMS$COURSE_REFERENCE_NUMBER == holdCRN,"",allAPMS$COURSE_SECTION_NUMBER)}
  n <- n+1
}  

allAPMS <- unique(allAPMS)

# Write the combined APMS User data to file to view test data was combined correctly and this file/code can be deleted later
write.csv(allAPMS, file = "SaveallAPMSRecs.csv")

holdinstructor <- NULL
holdCRN <- NULL
holdcoursenumber <- NULL  
holdsection <- NULL

# Add extracted combined courses all back into the main 'MyReportsDat' dataset
MyReportsDat = rbind(allITVPEONL, allAPMS, MyReportsDat) # combine ITVPE and ONL courses into one dataset

# Remove any duplicate recoreds
MyReportsDat <- unique(MyReportsDat)

# Create the COURSEUNIQUEID field to identify courses across both tables 
MyReportsDat$CourseUniqueID <- do.call(paste, c(MyReportsDat[c("COURSE_REFERENCE_NUMBER", "ACADEMIC_PERIOD")], sep = ""))

# Let's save this data to a table to be used at the end of this program
MyReportsDatSav <- MyReportsDat

# Write the combined APMS User data to file to view test data was combined correctly and this file/code can be deleted later
write.csv(MyReportsDat, file = "SaveALLRecs.csv")

#--------------------------
#--------------------------
#--------------------------

# Remove Unecessary Field data from the MyReports table to help speed processing along
MyReportsDat$COURSE_REFERENCE_NUMBER <-NULL
MyReportsDat$TITLE_LONG_DESC <-NULL
MyReportsDat$ACADEMIC_PERIOD <- NULL
MyReportsDat$Academic.Period.Desc <- NULL
MyReportsDat$SUB_ACADEMIC_PERIOD <- NULL
MyReportsDat$SUB_ACADEMIC_PERIOD_DESC <- NULL
MyReportsDat$CAMPUS <- NULL
MyReportsDat$CAMPUS_DESC <- NULL
MyReportsDat$COLLEGE <- NULL
MyReportsDat$COLLEGE_DESC <- NULL
MyReportsDat$DEPARTMENT <- NULL
MyReportsDat$DEPARTMENT_DESC <- NULL
MyReportsDat$SUBJECT <- NULL
MyReportsDat$COURSE_NUMBER <- NULL
MyReportsDat$COURSE_SECTION_NUMBER <- NULL
MyReportsDat$TITLE_SHORT_DESC <- NULL
MyReportsDat$TITLE_SHORT_DESC <- NULL
MyReportsDat$INSTRUCTION_DELIVERY_MODE <- NULL
MyReportsDat$INSTRUCTION_DELIVERY_MODE_DESC <- NULL
MyReportsDat$PRIMARY_INSTRUCTOR_FIRST_NAME <- NULL
MyReportsDat$PRIMARY_INSTRUCTOR_LAST_NAME <- NULL
MyReportsDat$PRIMARY_INSTRUCTOR_EMAIL <- NULL
MyReportsDat$PRIMARY_PRIMARY_INSTRUCTOR_ID <- NULL
MyReportsDat$PRIMARY_INSTRUCTOR_NETID <- NULL
MyReportsDat$PRIMARY_MAX_CREDITS <- NULL
MyReportsDat$PRIMARY_CIP_CODE <- NULL
MyReportsDat$PRIMARY_COURSE_GROUP <- NULL
MyReportsDat$SCHEDULE_TYPE_DESC <- NULL
MyReportsDat$MEETING_DAYS <- NULL
MyReportsDat$MEETING_TIME <- NULL
MyReportsDat$BUILDING <- NULL
MyReportsDat$ROOM <- NULL
MyReportsDat$START_DATE <- NULL
MyReportsDat$END_DATE <- NULL
MyReportsDat$ACTUAL_ENROLLMENT <- NULL
MyReportsDat$MAXIMUM_ENROLLMENT <- NULL
MyReportsDat$Program.Classification.Desc <- NULL
MyReportsDat$PROGRAM_CLASSIFICATION <- NULL
MyReportsDat$Student.Level.Desc <- NULL
MyReportsDat$Major.Desc <- NULL
MyReportsDat$College.Desc <- NULL
MyReportsDat$CONFIDENTIALITY_IND <- NULL
MyReportsDat$FULL_NAME_LFMI <- NULL
MyReportsDat$PRIMARY_INSTRUCTOR_ID <- NULL
MyReportsDat$MAX_CREDITS <- NULL
MyReportsDat$CIP_CODE <- NULL
MyReportsDat$COURSE_GROUP <- NULL
MyReportsDat$ID <- NULL

# Set number of columns variable for the Data.Frame to use in algorithms below
numcols <- ncol(MyReportsDat)

# Extract student records from MyReportsDat where REGISTRATION_STATUS_DESC has a type of 'drop' code/desc for fast processing and bind all
# Catches the following conditions: "Drop," "Drop with Grade," "Drop/Delete," "Wait""Cancelled"
StudentDrop <- subset(MyReportsDat, (str_sub(MyReportsDat$REGISTRATION_STATUS_DESC, 1,4)=="Drop") )
StudentWait <- subset(MyReportsDat, (str_sub(MyReportsDat$REGISTRATION_STATUS_DESC, 1,4)=="Wait") )
StudentCancelled <- subset(MyReportsDat, (str_sub(MyReportsDat$REGISTRATION_STATUS_DESC, 1,9)=="Cancelled") )
AllDrops = rbind(StudentDrop, StudentWait, StudentCancelled)
# Remove the dropped students from MyReportsDat table
MyReportsDat <- subset(MyReportsDat, (str_sub(MyReportsDat$REGISTRATION_STATUS_DESC, 1,4)!="Drop") )
MyReportsDat <- subset(MyReportsDat, (str_sub(MyReportsDat$REGISTRATION_STATUS_DESC, 1,4)!="Wait") )
MyReportsDat <- subset(MyReportsDat, (str_sub(MyReportsDat$REGISTRATION_STATUS_DESC, 1,9)!="Cancelled") )
# Drop extraneious tables no longer needed
rm(StudentDrop)
rm(StudentWait)
rm(StudentCancelled)

# Remove any duplicate student recoreds
MyReportsDat <- unique(MyReportsDat)
Drops2Delete <- merge(AllDrops, UserExportDat, by=c("Username", "CourseUniqueID"))
rm(AllDrops)
Drops2Delete$Unenroll <- "1"
Drops2Delete <- unique(Drops2Delete)

# Remove extraneous fields
Drops2Delete$EMAIL_ADDRESS <- NULL
Drops2Delete$REGISTRATION_STATUS_DESC <- NULL

# Now, we know who to delete/remove for student drops, i.e. all those in the Drops2Delete table/file
# So, now we can figure out how to find newly enrolled students 
# Drops have already been removed from the MyReportsDat table, now let's remove them from UserExportDat table
# But first, let's remove all course records, from the MyReports table, that do not match what's in the UserExport file
CRNsOnlyUserExportDat <- UserExportDat
CRNsOnlyUserExportDat$UserTypeID <- NULL
CRNsOnlyUserExportDat$FirstName <- NULL
CRNsOnlyUserExportDat$LastName <- NULL
CRNsOnlyUserExportDat$Email <- NULL
CRNsOnlyUserExportDat$Username <- NULL
CRNsOnlyUserExportDat$Unenroll <- NULL

#Just save the Unique CRNs to be used to pull records from MyReportDat
CRNsOnlyUserExportDat <- unique(CRNsOnlyUserExportDat)

# Next, remove drops from the UserExportDat table and crosslist what left for difference table that reveals the newly enrolled students
MyReportsDat <- merge(MyReportsDat, CRNsOnlyUserExportDat, by="CourseUniqueID")

# Now, the difference between UserExportDat and MyReportsDat should be the newly enrolled students that we want to upload
#sapply(MyReportsDat, mode)
#sapply(UserExportDat, mode)
MyReportsDat$CourseUniqueID <- as.numeric(MyReportsDat$CourseUniqueID)

#MyReports: CourseUniqueID  Username	EMAIL_ADDRESS	REGISTRATION_STATUS_DESC
MyReportsTmp <- MyReportsDat
MyReportsTmp$EMAIL_ADDRESS <- NULL
MyReportsTmp$REGISTRATION_STATUS_DESC <- NULL

# row.names  UserTypeID	CourseUniqueID	FirstName	LastName	Email	Username	Unenroll
UserExportTmp <- UserExportDat
UserExportTmp$row.names <- NULL
UserExportTmp$UserTypeID <- NULL
UserExportTmp$FirstName <- NULL
UserExportTmp$LastName <- NULL
UserExportTmp$Unenroll <- NULL
UserExportTmp$Email <- NULL

# Extract the newly enrolled students from MyReportsTmp
NewEnrollmentsDat <- setdiff(MyReportsTmp, UserExportTmp)

# Merge drops table with adds table and write file to upload to project
New2Add <- merge(NewEnrollmentsDat, MyReportsDat, by=c("Username", "CourseUniqueID"))

# Remove records where Username is blank
New2Add <- subset(New2Add, (str_sub(New2Add$Username, 1,4)!=".") )

# Add the following field/header name to the UserExportDat file: Unenroll
New2Add$Unenroll <- ""
# Remove uncessary fields
# row.names  Username	CourseUniqueID	EMAIL_ADDRESS	REGISTRATION_STATUS_DESC	Unenroll
New2Add$REGISTRATION_STATUS_DESC <- NULL

# Set number of columns variable for the Data.Frame to use in algorithms below
numcols <- ncol(New2Add)
# Make the field header names match for like field name processing
n <- 1
while(n <= numcols) {
  CN <- names(New2Add)[n]
  if (CN == "EMAIL_ADDRESS") {
    names(New2Add)[n] <- "Email"
  }  
  n <- n+1
} 

# Close out unnessary tables
rm(MyReportsDat)
rm(MyReportsTmp)
rm(NewEnrollmentsDat)
rm(UserExportDat)
rm(UserExportTmp)
rm(CRNsOnlyUserExportDat)

# User Export headers:     UserTypeID  CourseUniqueID	FirstName	LastName	Email	Username	Unenroll
# Drops to Delete headers: Username  CourseUniqueID	UserTypeID	FirstName	LastName	Email	Unenroll
# New 2 Add headers: Username UserTypeID CourseUniqueID	Email	Unenroll Missing: FirstName  LastName 
New2Add$UserTypeID <- "4"

# Reload the MyReportsDat file to grab and parse the matching student names
MyReportsDatAll <- read.csv("Class_List_GAH (11).csv", header = TRUE, stringsAsFactors=FALSE) 

# Create the COURSEUNIQUEID field to identify courses across both tables 
MyReportsDatAll$CourseUniqueID <- do.call(paste, c(MyReportsDatAll[c("COURSE_REFERENCE_NUMBER", "ACADEMIC_PERIOD")], sep = ""))

numcols <- ncol(MyReportsDatAll)
# Make the field header names match for like field name processing
n <- 1
while(n <= numcols) {
  CN <- names(MyReportsDatAll)[n]
  if (CN == "NETID") {
    names(MyReportsDatAll)[n] <- "Username"
  }  
  n <- n+1
} 

# Remove unnecessary fields
MyReportsDatAll$COURSE_REFERENCE_NUMBER <-NULL
MyReportsDatAll$TITLE_LONG_DESC <-NULL
MyReportsDatAll$ACADEMIC_PERIOD <- NULL
MyReportsDatAll$Academic.Period.Desc <- NULL
MyReportsDatAll$SUB_ACADEMIC_PERIOD <- NULL
MyReportsDatAll$SUB_ACADEMIC_PERIOD_DESC <- NULL
MyReportsDatAll$CAMPUS <- NULL
MyReportsDatAll$CAMPUS_DESC <- NULL
MyReportsDatAll$COLLEGE <- NULL
MyReportsDatAll$COLLEGE_DESC <- NULL
MyReportsDatAll$DEPARTMENT <- NULL
MyReportsDatAll$DEPARTMENT_DESC <- NULL
MyReportsDatAll$SUBJECT <- NULL
MyReportsDatAll$COURSE_NUMBER <- NULL
MyReportsDatAll$COURSE_SECTION_NUMBER <- NULL
MyReportsDatAll$TITLE_SHORT_DESC <- NULL
MyReportsDatAll$TITLE_SHORT_DESC <- NULL
MyReportsDatAll$INSTRUCTION_DELIVERY_MODE <- NULL
MyReportsDatAll$INSTRUCTION_DELIVERY_MODE_DESC <- NULL
MyReportsDatAll$PRIMARY_INSTRUCTOR_FIRST_NAME <- NULL
MyReportsDatAll$PRIMARY_INSTRUCTOR_LAST_NAME <- NULL
MyReportsDatAll$PRIMARY_INSTRUCTOR_EMAIL <- NULL
MyReportsDatAll$PRIMARY_PRIMARY_INSTRUCTOR_ID <- NULL
MyReportsDatAll$PRIMARY_INSTRUCTOR_NETID <- NULL
MyReportsDatAll$PRIMARY_MAX_CREDITS <- NULL
MyReportsDatAll$PRIMARY_CIP_CODE <- NULL
MyReportsDatAll$PRIMARY_COURSE_GROUP <- NULL
MyReportsDatAll$SCHEDULE_TYPE_DESC <- NULL
MyReportsDatAll$MEETING_DAYS <- NULL
MyReportsDatAll$MEETING_TIME <- NULL
MyReportsDatAll$BUILDING <- NULL
MyReportsDatAll$ROOM <- NULL
MyReportsDatAll$START_DATE <- NULL
MyReportsDatAll$END_DATE <- NULL
MyReportsDatAll$ACTUAL_ENROLLMENT <- NULL
MyReportsDatAll$MAXIMUM_ENROLLMENT <- NULL
MyReportsDatAll$Program.Classification.Desc <- NULL
MyReportsDatAll$PROGRAM_CLASSIFICATION <- NULL
MyReportsDatAll$Student.Level.Desc <- NULL
MyReportsDatAll$Major.Desc <- NULL
MyReportsDatAll$College.Desc <- NULL
MyReportsDatAll$CONFIDENTIALITY_IND <- NULL
MyReportsDatAll$PRIMARY_INSTRUCTOR_ID <- NULL
MyReportsDatAll$MAX_CREDITS <- NULL
MyReportsDatAll$CIP_CODE <- NULL
MyReportsDatAll$COURSE_GROUP <- NULL
MyReportsDatAll$ID <- NULL
rownames(MyReportsDatAll) <- c()
rownames(Drops2Delete) <- c()
rownames(New2Add) <- c()

# Parse out Student First and Last Name from FULL_NAME_LFMI
MyReportsDatAll$firstname <- sapply(strsplit(MyReportsDatAll$FULL_NAME_LFMI, ","), "[", 2)
MyReportsDatAll$lastname <- str_extract(MyReportsDatAll$FULL_NAME_LFMI, "[a-zA-Z0-9]{1,40}")

# Cleanup MyReportsDatAll before merge
#	Username	REGISTRATION_STATUS_DESC	CourseUniqueID	firstname	lastname
MyReportsDatAll$FULL_NAME_LFMI <- NULL
MyReportsDatAll$EMAIL_ADDRESS <- NULL
#MyReportsDatAll$REGISTRATION_STATUS_DESC <- NULL


# Merge MyReportsDatAll with New2Add to get the first and last name fields
New2Add <- merge(New2Add, MyReportsDatAll, by=c("Username", "CourseUniqueID"))

New2Add <- unique(New2Add)
MyReportsDatAll <- unique(MyReportsDatAll)
Drops2Delete <- unique(Drops2Delete)
rownames(Drops2Delete) <- c()
write.csv(Drops2Delete, file = "Drops2Delete.csv")

#Columns New2Add: row.names  Username  CourseUniqueID	Email	Unenroll	UserTypeID	REGISTRATION_STATUS_DESC	firstname	lastname
rownames(New2Add) <- c()
New2Add$REGISTRATION_STATUS_DESC <- NULL
write.csv(New2Add, file = "New2Add.csv")

# Append the final two tables and save for uploadging to EvalKIT project 
# bad code - UploadDropsAdds <- merge(Drops2Delete, New2Add, by=c("Username", "CourseUniqueID"))





