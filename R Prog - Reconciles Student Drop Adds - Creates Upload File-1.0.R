# ***Use For Reconciling Student Drops and Adds Before Student Surveys are Released***
# Author: Aaron G. Baca, UNM/IT, 6/12/17

# Step 1. Download the 'UserExport_2017SummerCourses' from your EvaluationKIT project, that you want to update drop/add student info to;
# Step 2. Upldate line '24' with the exact name of the 'Export All Project Users' file;
# Step 3. Make sure your 'setwd' path on line 21 is correct for your PC, i.e. place all files in this one folder;
# Step 4. Obtain a fresh MyReports query, save as .csv file and make sure file name matches on line 42 and line 231 below;
# Step 5. Run this program;
# Step 6. Save the two 'New2Add' and 'Drops2Delete' files as .xls or .xlsx format and upload into your Project under 'Users/Data Import' tabs.  

#install.packages("stringr")
library(stringr)

#install.packages("compare")
#library(compare)
# Call the xls conversion libraries
#install.packages("WriteXLS")
#library(WriteXLS)

# Please set the R working directory to where your MyReports data and R programs are located
# Replace "/Users/aaronbaca/Documents/EvaluationKIT/...." path below with the path to your files
# Add "C://path//path" for Windows based R package
#setwd("/Users/aaronbaca/Documents/EvaluationKIT/Summer 2017/TestEnrollmentReconciliation")
#setwd("/Users/aaronbaca/Documents/EvaluationKIT/Fall 2017/Group A Student Reconcile Ethan")
#setwd("/Users/aaronbaca/Documents/EvaluationKIT/Fall 2017/Group B Student Reconcile Connor")
setwd("/Users/aaronbaca/Documents/EvaluationKIT/Fall 2017/Group C Student Reconcile Amrita")

# Read-in the User Export file from EvalKIT, where this program adds newly enrolled students and sets an unenroll flag of '1' to students who have dropped courses
UserExportDat <- read.csv("UserExport_2017FallCourses-GroupC.csv", header = TRUE, stringsAsFactors=FALSE)

# Remove all Instructor records, i.e. Type = 3
UserExportDat <- subset(UserExportDat, UserExportDat$UserTypeID == "4")

# Remove the following fields from the UserExport_'ProjectName'.csv" file: 
UserExportDat$CAMPUS <- NULL
UserExportDat$CAMPUS_DESC <- NULL
UserExportDat$COURSE_REFERENCE_NUMBER <- NULL
UserExportDat$F1 <- NULL

# Add the following field/header name to the UserExportDat file: Unenroll
UserExportDat$Unenroll <- ""

# Read in the MyReports data, i.e. the Class_List_GAH.csv file
# Below replace the "Class_List_GAH (**),csv" file name with the MyReports file name that contains all student/course data
MyReportsDat <- read.csv("Class_List_GAH (11).csv", header = TRUE, stringsAsFactors=FALSE)

# Create the COURSEUNIQUEID field to identify courses across both tables 
MyReportsDat$CourseUniqueID <- do.call(paste, c(MyReportsDat[c("COURSE_REFERENCE_NUMBER", "ACADEMIC_PERIOD")], sep = ""))

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

# Make the field header names match for like field name processing
n <- 1
while(n <= numcols) {
  CN <- names(MyReportsDat)[n]
  if (CN == "NETID") {
    names(MyReportsDat)[n] <- "Username"
  }  
#  if (CN == "COURSEUNIQUEID") {
#    names(MyReportsDat)[n] <- "CourseUniqueID"
#  } 
  n <- n+1
} 

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

# ---End of determining which drops to remove from EvalKIT

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

#Just save the Unique CRNs (Courses) to be used to pull records from MyReportDat
CRNsOnlyUserExportDat <- unique(CRNsOnlyUserExportDat)

# Next, remove drops from the UserExportDat table and crosslist what's left for difference table that reveals the newly enrolled students
MyReportsDat <- merge(MyReportsDat, CRNsOnlyUserExportDat, by="CourseUniqueID")

#sapply(MyReportsDat, mode)
#sapply(UserExportDat, mode)
# Make CourseUniqueID field numeric
MyReportsDat$CourseUniqueID <- as.numeric(MyReportsDat$CourseUniqueID)

#MyReports: CourseUniqueID  Username	EMAIL_ADDRESS	REGISTRATION_STATUS_DESC
MyReportsTmp <- MyReportsDat
MyReportsTmp$EMAIL_ADDRESS <- NULL
MyReportsTmp$REGISTRATION_STATUS_DESC <- NULL

# Remove these fields to compare apples with apples: row.names  UserTypeID	CourseUniqueID	FirstName	LastName	Email	Username	Unenroll
UserExportTmp <- UserExportDat
UserExportTmp$row.names <- NULL
UserExportTmp$UserTypeID <- NULL
UserExportTmp$FirstName <- NULL
UserExportTmp$LastName <- NULL
UserExportTmp$Unenroll <- NULL
UserExportTmp$Email <- NULL
rownames(UserExportTmp) <- c()

# Now, the difference between UserExportTmp and MyReportsTmp should be the newly enrolled students that we want to upload
NewEnrollmentsDat <- rbind(MyReportsTmp, UserExportTmp)
New2Add <- NewEnrollmentsDat[!(duplicated(NewEnrollmentsDat) | duplicated(NewEnrollmentsDat, fromLast = TRUE)), ]

# Remove records where Username is blank
New2Add <- subset(New2Add, (str_sub(New2Add$Username, 1,4)!=".") )

# Merge drops table with adds table and write file to upload to project
New2Add <- merge(New2Add, MyReportsDat, by=c("Username", "CourseUniqueID"))

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
MyReportsDatAll <- read.csv("Class_List_GAH (8).csv", header = TRUE, stringsAsFactors=FALSE) 

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

#Columns New2Add: row.names  Username	CourseUniqueID	Email	Unenroll	UserTypeID	REGISTRATION_STATUS_DESC	firstname	lastname
rownames(New2Add) <- c()
New2Add$REGISTRATION_STATUS_DESC <- NULL
write.csv(New2Add, file = "New2Add.csv")








