# ***For MyReports Data Fields only - Create the EvaluationKIT User & Course files for upload***

# Author: Aaron G. Baca, UNM/IT, 1/14/15

# Merge Student Demographics
setwd("C:\\Aaron\\CIO\\Student Technology Survey Spring 2015")
CourseCheck <- read.csv("Final Upload w Demographics.csv", header = TRUE, stringsAsFactors=FALSE)
InstructorCheck <- read.csv("Class_List_GAH (AllStudentsOneCourse).csv", header = TRUE, stringsAsFactors=FALSE)
chK <- merge(CourseCheck, InstructorCheck, by = "NetID")
write.csv(chK, file = "Student Merge demographics plus campus.csv")

# Load and Merge Data from EvalKIT for final course & instructor check
setwd("C:\\Aaron\\IDEA\\IAWG\\EvaluationKit\\Pilot 1\\Spring 2015\\College of Arts and Sciences\\W C F Biology")
CourseCheck <- read.csv("Upload_Course_Data.csv", header = TRUE, stringsAsFactors=FALSE)
InstructorCheck <- read.csv("Upload_Faculty_User_Data.csv", header = TRUE, stringsAsFactors=FALSE)
chK <- merge(CourseCheck, InstructorCheck, by = "COURSEUNIQUEID")
write.csv(chK, file = "EvalKIT_Course_Instructor_Chk_UploadData.csv")

# CUSTOM MERGE
setwd("C:\\Aaron\\IDEA\\IAWG\\EvaluationKit\\Pilot 1\\Spring 2015\\W Public Administration\\ITVPE and ITVE Courses")
CourseCheck <- read.csv("Class_List_GAH (All Students).csv", header = TRUE, stringsAsFactors=FALSE)
InstructorCheck <- read.csv("CRNKey.csv", header = TRUE, stringsAsFactors=FALSE)
chK <- merge(CourseCheck, InstructorCheck, by = "COURSE_REFERENCE_NUMBER")
write.csv(chK, file = "PADM ITVPE and ITVE Courses.csv")

# Load and Merge Data from EvalKIT for final course & instructor check
setwd("C:\\Aaron\\IDEA\\IAWG\\EvaluationKit\\Pilot 1\\Spring 2015\\W C F ASM")
CourseCheck <- read.csv("CourseExport.csv", header = TRUE, stringsAsFactors=FALSE)
InstructorCheck <- read.csv("UserExport.csv", header = TRUE, stringsAsFactors=FALSE)
chK <- merge(CourseCheck, InstructorCheck, by = "CourseUniqueID")
write.csv(chK, file = "EvalKIT_Course_Instructor_Chk_ExportedData.csv")

# Purpose: to prep EvalKIT upload data extracted from the Extended Learning ClassList query in MyReports
# Please install the R stringr app, if you have not done so already > install.packages("stringr")
# Please install the R xlsReadWrite package if you have not done so already > install.packages("WriteXLS")

#Note: this program creates an Upload_Course_Data.csv file which creates courses in EvalKIT
#Note: this program creates a Upload_Student_User_Data.csv file which creates Users, both Student and Faculty, in EvalKIT

# Call the stringr library
library(stringr)

# Call the xls conversion libraries
library(WriteXLS)

# Please set the R working directory to where your MyReports data and R programs are located
# Replace "C:/Aaron/MyReports/...." path below with the path to your files
#setwd("/Users/aaronbaca/Documents/Pilot 1/Intercession Data for Spring Summer 2015")
#setwd("/Users/aaronbaca/Documents/Pilot 1/Spring 2015/College of Arts and Sciences/W C F Spanish and Portuguese")
#setwd("/Users/aaronbaca/Documents/Pilot 1/Summer 2015/6-1 thru 6-6 Courses")
#setwd("/Users/aaronbaca/Documents/Pilot 1/Summer 2015/6-1_thru_6-12_Courses")
setwd("/Users/aaronbaca/Documents/Pilot 1/Intercession Data for Spring Summer 2015/COUN")



#setwd("C:\\Aaron\\IDEA\\IAWG\\EvaluationKit\\Pilot 1\\Spring 2015\\College of Arts and Sciences\\C F S Chemistry")


# Read in the MyReports data, i.e. the Class_List_GAH.csv (1H Classes All.csv) file
# Note: you must use the following fields from the MyReports EL classList query: 
# - Course Information Window -
#    ACADEMIC_PERIOD_CODE, SUBJECT,  COURSE_NUMBER, SECTION_NUMBER,  COURSE_REFERENCE_NUMBER, COURSE_TITLE, SUB_ACADEMIC_PERIOD,
#    PRIMARY_INSTRUCTOR_EMAIL,	PRIMARY_INSTRUCTOR_FIRST_NAME, PRIMARY_INSTRUCTOR_LAST_NAME, PRIMARY_INSTRUCTOR_NETID,
#    COURSE_DEPARTMENT_CODE,	INST_DELIVERY_MODE_CODE, INST_DELIVERY_MODE_DESC, CIP_CODE, COURSE_COLLEGE_CODE, 
#    COURSE_COLLEGE_DESC,	CAMPUS_CODE, CAMPUS_DESC, 
# - Scheduling Information Window -
#    START_DATE, END_DATE, MONDAY_IND, TUESDAY_IND,	WEDNESDAY_IND, THURSDAY_IND, FRIDAY_IND, SATURDAY_IND,
#    SUNDAY_IND,	ACTUAL_ENROLLMENT, MEETING_DAYS, MEETING_TIME, SCHEDULE_TYPE_DESC, 
# - Personal Information Window -
#    STUDENT_NAME, CONFIDENTIALITY_IND, BANNER_ID,	STUDENT_NETID, EMAIL_ADDRESS, REGISTRATION_STATUS_DESC,	PROGRAM_CLASSIFICATION

# Below replace the "Class_List_GAH (All Classes No Students)" file name with whatever Student Apps provides for classes
MyReportsDat <- read.csv("Class_List_GAH (5).csv", header = TRUE, stringsAsFactors=FALSE)

####### Remove 1H courses for end of semester processing SUB_ACADEMIC_PERIOD
#MyReportsDat <- subset(MyReportsDat, (str_sub(MyReportsDat$SUB_ACADEMIC_PERIOD)!="1H") )

# Subset out non-participating campuses, colleges, departments and faculty below, for MAIN campus only

# No Evaluations for these types of classes
#MyReportsDat <- subset(MyReportsDat, (str_sub(MyReportsDat$TITLE_SHORT_DESC)!="Dissertation"))
#MyReportsDat <- subset(MyReportsDat, (str_sub(MyReportsDat$TITLE_SHORT_DESC)!="Master's Thesis"))
#MyReportsDat <- subset(MyReportsDat, (str_sub(MyReportsDat$TITLE_SHORT_DESC)!="Masters Thesis"))
#MyReportsDat <- subset(MyReportsDat, (str_sub(MyReportsDat$TITLE_SHORT_DESC)!="Master s Thesis"))
#MyReportsDat <- subset(MyReportsDat, (str_sub(MyReportsDat$TITLE_SHORT_DESC)!="Master's Project"))
#MyReportsDat <- subset(MyReportsDat, (str_sub(MyReportsDat$TITLE_SHORT_DESC)!="Problems"))
#MyReportsDat <- subset(MyReportsDat, (str_sub(MyReportsDat$TITLE_SHORT_DESC)!="Undergraduate Problems"))


# CRN file using column A containing only the CRNs that are participating in the use of EvalKIT
CRNKey <- read.csv("CRNKey.csv", header = TRUE, stringsAsFactors=FALSE)

# Count CRNKey rows to compare at the end of prog. as warning if any are missing
crnrows <- nrow(CRNKey)

# Merge the Depts. requested with the MyReports queried data, *comment out next line if no CRNKey is used
tmp <- merge(MyReportsDat, CRNKey, by = "COURSE_REFERENCE_NUMBER")

# Set number of rows variable for the Data.Frame
numrows <- nrow(tmp) 
# Set number of columns variable for the Data.Frame to use in algorithms below
numcols <- ncol(tmp)

# Add leading zeros to the COURSE_SECTION_NUMBER field to form complete three digit length, as MyReports strips leading zeros
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

# Create the COURSEUNIQUEID field for both User files and theCourse files and 
tmp$COURSEUNIQUEID <- do.call(paste, c(tmp[c("COURSE_REFERENCE_NUMBER",  "ACADEMIC_PERIOD")], sep = ""))


# Create Student USER File with the following fields: ***************************************************************************
# USERTYPEID (4)  COURSEUNIQUEID (CRN+TermCode)	FIRSTNAME/LASTNAME (FULL_NAME_LFMI)	EMAIL (EMAIL_ADDRESS)	USERNAME (NetID)

#***Create the USERTYPEID field for the UserFile for Students
tmp$USERTYPEID <- "4"

#Remove Dropped or Waitlisted Students using REGISTRATION_STATUS_DESC field 
tmp <- subset(tmp, (str_sub(tmp$REGISTRATION_STATUS_DESC, 1,4)!="Drop") )
tmp <- subset(tmp, (str_sub(tmp$REGISTRATION_STATUS_DESC, 1,15)!="Drop with Grade") )
tmp <- subset(tmp, (str_sub(tmp$REGISTRATION_STATUS_DESC, 1,11)!="Drop/Delete") )
tmp <- subset(tmp, (str_sub(tmp$REGISTRATION_STATUS_DESC, 1,4)!="Wait") )
tmp <- subset(tmp, (str_sub(tmp$REGISTRATION_STATUS_DESC, 1,9)!="Cancelled") )

# Reasign field names for STUDENT User file
n <- 1
while(n <= numcols) {
  CN <- names(tmp)[n]
  if (CN == "NETID") {
    names(tmp)[n] <- "USERNAME"
  }  
  if (CN == "EMAIL_ADDRESS") {
    names(tmp)[n] <- "EMAIL"
  } 
  n <- n+1
} 

# Parse out Student First and Last Name from FULL_NAME_LFMI
#firstname <- strsplit(tmp$FULL_NAME_LFMI, ",")
# tmp$FirstName <- FirstName
# Write the Student User data to file
tmp$firstname <- sapply(strsplit(tmp$FULL_NAME_LFMI, ","), "[[", 2)
tmp$lastname <- str_extract(tmp$FULL_NAME_LFMI, "[a-zA-Z0-9]{1,40}")

# Remove records with blank USERNAMEs/NetIDs, is primarity for Gallup
tmp <- subset(tmp, (str_sub(tmp$USERNAME, 1,4)!=".") )

# Create stu file so that I can remove all unnecessary fields before writing Upload_Student_User_Data.csv to disk
stu <- tmp

# Remove any duplicate student recoreds
tmp <- unique(tmp)

#### Find all Student records where INSTRUCTION_DELIVERY_MODE == 'ITVPE' and == 'ITVE'
# and where course number and instructor NetID are the same, then assign Parent ITVPE CRN to all child records




#### For Students records that have less < 3 students for the same course with the same professor, make all the CRNs 
# the same for all the sections. I.E. roll-up Non-ITV courses that contain less than 3 students with same prof. and course #



# Write the Student detailed User data to file
write.csv(tmp, file = "Detailed_Student_User_Data.csv")



# Remove all fields not required by EvalKIT before writing Student upload file
stu$COURSE_REFERENCE_NUMBER <- NULL
stu$ACADEMIC_PERIOD <- NULL
stu$Academic.Period.Desc <- NULL
stu$SUB_ACADEMIC_PERIOD <- NULL
stu$SUB_ACADEMIC_PERIOD_DESC <- NULL
stu$CAMPUS <- NULL
stu$CAMPUS_DESC <- NULL
stu$COLLEGE <- NULL
stu$COLLEGE_DESC <- NULL
stu$DEPARTMENT <- NULL
stu$DEPARTMENT_DESC <- NULL
stu$SUBJECT <- NULL
stu$COURSE_NUMBER <- NULL
stu$COURSE_SECTION_NUMBER <- NULL
stu$TITLE_SHORT_DESC <- NULL
stu$TITLE_LONG_DESC <- NULL
stu$INSTRUCTION_DELIVERY_MODE <- NULL
stu$INSTRUCTION_DELIVERY_MODE_DESC <- NULL
stu$PRIMARY_INSTRUCTOR_FIRST_NAME <- NULL
stu$PRIMARY_INSTRUCTOR_LAST_NAME <- NULL
stu$PRIMARY_INSTRUCTOR_EMAIL <- NULL
stu$PRIMARY_PRIMARY_INSTRUCTOR_ID <- NULL
stu$PRIMARY_INSTRUCTOR_NETID <- NULL
stu$PRIMARY_MAX_CREDITS <- NULL
stu$PRIMARY_CIP_CODE <- NULL
stu$PRIMARY_COURSE_GROUP <- NULL
stu$SCHEDULE_TYPE_DESC <- NULL
stu$MEETING_DAYS <- NULL
stu$MEETING_TIME <- NULL
stu$BUILDING <- NULL
stu$ROOM <- NULL
stu$START_DATE <- NULL
stu$END_DATE <- NULL
stu$ACTUAL_ENROLLMENT <- NULL
stu$MAXIMUM_ENROLLMENT <- NULL
stu$Program.Classification.Desc <- NULL
stu$PROGRAM_CLASSIFICATION <- NULL
stu$REGISTRATION_STATUS_DESC <- NULL
stu$Student.Level.Desc <- NULL
stu$Major.Desc <- NULL
stu$College.Desc <- NULL
stu$CONFIDENTIALITY_IND <- NULL
stu$FULL_NAME_LFMI <- NULL
stu$PRIMARY_INSTRUCTOR_ID <- NULL
stu$MAX_CREDITS <- NULL
stu$CIP_CODE <- NULL
stu$COURSE_GROUP <- NULL
stu$ID <- NULL
stud$CURRENT_AGE <- NULL
stud$GENDER_DESC <- NULL
stud$IPEDS_VALUES_DESC <- NULL
stud$COUNTY_DESC <- NULL
stud$CITY <- NULL
stud$STATE_PROVINCE <- NULL
stud$NATION_DESC <- NULL

# Remove any duplicate student recoreds
stu <- unique(stu)

# Write the Student User data to file
write.csv(stu, file = "Upload_Student_User_Data.csv")


# Create Faculty USER File with the following fields: ******************************************************************************
# USERTYPEID (3)  COURSEUNIQUEID (CRN+TermCode)  FIRSTNAME (PRIMARY_INSTRUCTOR_FIRST_NAME/Secondary_Instructor_First_Name)	
# LASTNAME (PRIMARY_INSTRUCTOR_LAST_NAME/Secondary_Instructor_Last_Name)	
# EMAIL (PRIMARY_INSTRUCTOR_EMAIL/Secondary_Instructor_Email)	USERNAME (PRIMARY_INSTRUCTOR_NETID/Secondary_Instructor_NetID)

# Drop student fields that conflict with faculty data processing
tmp$USERNAME <- NULL
tmp$USERTYPEID <- NULL
tmp$EMAIL <- NULL
tmp$firstname <- NULL
tmp$lastname <- NULL
tmp$ID <- NULL
tmp$Program.Classification.Desc <- NULL
tmp$PROGRAM_CLASSIFICATION <- NULL
tmp$REGISTRATION_STATUS_DESC <- NULL
tmp$Student.Level.Desc <- NULL
tmp$Major.Desc <- NULL
tmp$College.Desc <- NULL
tmp$CONFIDENTIALITY_IND <- NULL
tmp$FULL_NAME_LFMI <- NULL


# Set number of rows variable for the Data.Frame
numrows <- nrow(tmp) 
# Set number of columns variable for the Data.Frame to use in algorithms below
numcols <- ncol(tmp)

#***Create the USERTYPEID field for the UserFile for faculty
tmp$USERTYPEID <- "3"

# Reasign field names for FACULTY User file
n <- 1
while(n <= numcols) {
  CN <- names(tmp)[n]
  if (CN == "TITLE_LONG_DESC") {
    names(tmp)[n] <- "TITLE"
  }  
  if (CN == "PRIMARY_INSTRUCTOR_EMAIL") {
    names(tmp)[n] <- "EMAIL"
  } 
  if (CN == "PRIMARY_INSTRUCTOR_FIRST_NAME") { 
    names(tmp)[n] <- "FirstName"
  } 
  if (CN == "PRIMARY_INSTRUCTOR_LAST_NAME") {
    names(tmp)[n] <- "LastName"
  } 
  if (CN == "PRIMARY_INSTRUCTOR_NETID") {
    names(tmp)[n] <- "UserName"
  } 
  n <- n+1
} 

# Remove unique student fields
tmp$NATION_DESC <- NULL    				
tmp$CURRENT_AGE <- NULL
tmp$GENDER_DESC <- NULL
tmp$IPEDS_VALUES_DESC <- NULL
tmp$COUNTY_DESC <- NULL
tmp$CITY <- NULL
tmp$STATE_PROVINCE <- NULL

# Remove dups before writing record
tmp <- unique(tmp)

# Write the faculty detailed data to file
write.csv(tmp, file = "Detailed_Faculty_User_Data.csv")

# Create fac file so that I can remove all unnecessary fields before writing Upload_Faculty_User_Data.csv to disk
fac <- tmp

#Remove extraneous fields before writing the Upload_Faculty_User_Data file
fac$COURSE_REFERENCE_NUMBER <- NULL
fac$ACADEMIC_PERIOD <- NULL
fac$Academic.Period.Desc <- NULL
fac$SUB_ACADEMIC_PERIOD <- NULL
fac$SUB_ACADEMIC_PERIOD_DESC <- NULL
fac$CAMPUS <- NULL
fac$CAMPUS_DESC <- NULL
fac$COLLEGE <- NULL
fac$COLLEGE_DESC <- NULL
fac$DEPARTMENT <- NULL
fac$DEPARTMENT_DESC <- NULL
fac$SUBJECT <- NULL
fac$COURSE_NUMBER <- NULL
fac$COURSE_SECTION_NUMBER <- NULL
fac$TITLE_SHORT_DESC <- NULL
fac$TITLE_LONG_DESC <- NULL
fac$INSTRUCTION_DELIVERY_MODE <- NULL
fac$INSTRUCTION_DELIVERY_MODE_DESC <- NULL
fac$PRIMARY_INSTRUCTOR_FIRST_NAME <- NULL
fac$PRIMARY_INSTRUCTOR_LAST_NAME <- NULL
fac$PRIMARY_INSTRUCTOR_EMAIL <- NULL
fac$PRIMARY_PRIMARY_INSTRUCTOR_ID <- NULL
fac$PRIMARY_INSTRUCTOR_NETID <- NULL
fac$PRIMARY_MAX_CREDITS <- NULL
fac$PRIMARY_CIP_CODE <- NULL
fac$PRIMARY_COURSE_GROUP <- NULL
fac$SCHEDULE_TYPE_DESC <- NULL
fac$MEETING_DAYS <- NULL
fac$MEETING_TIME <- NULL
fac$BUILDING <- NULL
fac$ROOM <- NULL
fac$START_DATE <- NULL
fac$END_DATE <- NULL
fac$ACTUAL_ENROLLMENT <- NULL
fac$MAXIMUM_ENROLLMENT <- NULL
fac$Program.Classification.Desc <- NULL
fac$PROGRAM_CLASSIFICATION <- NULL
fac$REGISTRATION_STATUS_DESC <- NULL
fac$Student.Level.Desc <- NULL
fac$Major.Desc <- NULL
fac$College.Desc <- NULL
fac$CONFIDENTIALITY_IND <- NULL
fac$FULL_NAME_LFMI <- NULL
fac$PRIMARY_INSTRUCTOR_ID <- NULL
fac$TITLE <- NULL
fac$MAX_CREDITS <- NULL
fac$CIP_CODE <- NULL
fac$COURSE_GROUP <- NULL
fac$NATION_DESC <- NULL    				
fac$CURRENT_AGE <- NULL
fac$GENDER_DESC <- NULL
fac$IPEDS_VALUES_DESC <- NULL
fac$COUNTY_DESC <- NULL
fac$CITY <- NULL
fac$STATE_PROVINCE <- NULL
fac$REGISTRATION_STATUS_DATE <- NULL

# Drop dups after student fields are removed
fac <- unique(fac)

# Write the faculty User data to file
write.csv(fac, file = "Upload_Faculty_User_Data.csv")



# Create COURSE file for upload into EvalKIT *******************************************************************************************
# TITLE  CODE  COURSEUNIQUEID

# Set number of rows variable for the Data.Frame
numrows <- nrow(tmp) 
# Set number of columns variable for the Data.Frame to use in algorithms below
numcols <- ncol(tmp)

# Remove course records for BIOL 499, 551, 599, 651, 699 as they are not to be evaluated


# Create the CODE field for the Course File
tmp$CODE <- do.call(paste, c(tmp[c("SUBJECT",  "COURSE_NUMBER",  "COURSE_SECTION_NUMBER")], sep = " "))

# Reasign field names for FACULTY User file
# TITLE is created above
# COURSEUniqueID is created above as well

#***Assign Branch/College/Dept. Hierarchies!!! 
n <- 1
while(n <= numrows) {
  if (tmp$DEPARTMENT_DESC[n]=="Mathematics Statistics" & tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.Mathematics/Statistics"} 
  if (tmp$DEPARTMENT_DESC[n]=="Mathematics Statistics" & tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.Mathematics/Statistics"} 
  
  if (tmp$DEPARTMENT_DESC[n]=="Biology" & tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.Biology"} 
  if (tmp$DEPARTMENT_DESC[n]=="Biology" & tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.Biology"} 
  
  if (tmp$DEPARTMENT_DESC[n]=="School Architecture Planning" && tmp$SUBJECT[n]=="ARCH" && tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.SchoolofArchitectureandPlanning.Architecture"} 
  if (tmp$DEPARTMENT_DESC[n]=="School Architecture Planning" && tmp$SUBJECT[n]=="ARCH" && tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.SchoolofArchitectureandPlanning.Architecture"} 
  
  if (tmp$DEPARTMENT_DESC[n]=="School Architecture Planning" && tmp$SUBJECT[n]=="CRP" && tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.SchoolofArchitectureandPlanning.CommunityandRegionalPlanning"} 
  if (tmp$DEPARTMENT_DESC[n]=="School Architecture Planning" && tmp$SUBJECT[n]=="CRP" && tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.SchoolofArchitectureandPlanning.CommunityandRegionalPlanning"} 
  
  if (tmp$DEPARTMENT_DESC[n]=="Provost Branch Campuses" && tmp$SUBJECT[n]=="ENVS" && tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.EarthandPlanetarySciences"}
  if (tmp$DEPARTMENT_DESC[n]=="Provost Branch Campuses" && tmp$SUBJECT[n]=="ENVS" && tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.EarthandPlanetarySciences"}
  
  if (tmp$DEPARTMENT_DESC[n]=="English" && tmp$SUBJECT[n]=="ENGL" && tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.English"}
  if (tmp$DEPARTMENT_DESC[n]=="English" && tmp$SUBJECT[n]=="ENGL" && tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.English"}
  
  if (tmp$DEPARTMENT_DESC[n]=="Psychology" & tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.Psychology"}
  if (tmp$DEPARTMENT_DESC[n]=="Psychology" & tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.Psychology"}
  
  if (tmp$DEPARTMENT_DESC[n]=="Sociology" & tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.Sociology"}
  if (tmp$DEPARTMENT_DESC[n]=="Sociology" & tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.Sociology"}
  
  if (tmp$DEPARTMENT_DESC[n]=="AS Economics" & tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.Economics"}
  if (tmp$DEPARTMENT_DESC[n]=="AS Economics" & tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.Economics"}
  
  if (tmp$DEPARTMENT_DESC[n]=="Philosophy" & tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.Philosophy"}
  if (tmp$DEPARTMENT_DESC[n]=="Philosophy" & tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.Philosophy"}
  
  if (tmp$DEPARTMENT_DESC[n]=="Communication Journalism" && tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.CommunicationandJournalism"}
  if (tmp$DEPARTMENT_DESC[n]=="Communication Journalism" && tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.CommunicationandJournalism"}
  
  if (tmp$DEPARTMENT_DESC[n]=="Music" & tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.CollegeofFineArts.Music"}
  if (tmp$DEPARTMENT_DESC[n]=="Music" & tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.CollegeofFineArts.Music"}
  
  if (tmp$DEPARTMENT_DESC[n]=="Art Art History" & tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.CollegeofFineArts.ArtandArtHistory"}
  if (tmp$DEPARTMENT_DESC[n]=="Art Art History" & tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.CollegeofFineArts.ArtandArtHistory"}
  
  if (tmp$DEPARTMENT_DESC[n]=="Mathematics Statistics" & tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.Mathematics/Statistics"}
  if (tmp$DEPARTMENT_DESC[n]=="Mathematics Statistics" & tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.Mathematics/Statistics"}
  
  if (tmp$DEPARTMENT_DESC[n]=="AS Biology" && tmp$SUBJECT[n]=="BIOL" && tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.Biology"}
  if (tmp$DEPARTMENT_DESC[n]=="AS Biology" && tmp$SUBJECT[n]=="BIOL" && tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.Biology"}
  
  if (tmp$DEPARTMENT_DESC[n]=="AS American Studies" & tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.AmericanSudies"}
  if (tmp$DEPARTMENT_DESC[n]=="AS American Studies" & tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.AmericanSudies"}
  
  if (tmp$SUBJECT[n]=="MGMT" & tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.ASM(AndersonSchoolofManagement)"}
  if (tmp$SUBJECT[n]=="MGMT" & tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.ASM(AndersonSchoolofManagement)"}
  
  if (tmp$DEPARTMENT_DESC[n]=="History" && tmp$SUBJECT[n]=="HIST" && tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.History"
    tmp <- subset(tmp, (str_sub(tmp$COURSE_NUMBER)!="699") )
    tmp <- subset(tmp, (str_sub(tmp$COURSE_NUMBER)!="697") )
    tmp <- subset(tmp, (str_sub(tmp$COURSE_NUMBER)!="599") )
    tmp <- subset(tmp, (str_sub(tmp$COURSE_NUMBER)!="496") )
    tmp <- subset(tmp, (str_sub(tmp$COURSE_NUMBER)!="493") )
    tmp <- subset(tmp, (str_sub(tmp$COURSE_NUMBER)!="494") )  }
  
  if (tmp$DEPARTMENT_DESC[n]=="History" && tmp$SUBJECT[n]=="HIST" && tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.History"}
  
  if (tmp$DEPARTMENT_DESC[n]=="Chem && Biological Engineering" && tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.SchoolofEngineering.ChemicalandBiologicalEngineering"}
  if (tmp$DEPARTMENT_DESC[n]=="Chem && Biological Engineering" && tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.SchoolofEngineering.ChemicalandBiologicalEngineering"}
  
  if (tmp$DEPARTMENT_DESC[n]=="Civil Engineering Civil Engr" & tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.SchoolofEngineering.CivilEngineering"}
  if (tmp$DEPARTMENT_DESC[n]=="Civil Engineering Civil Engr" & tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.SchoolofEngineering.CivilEngineering"}
  
  if (tmp$DEPARTMENT_DESC[n]=="Electrical Computer Engr" & tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.SchoolofEngineering.ElectricalandComputerEngineering"}
  if (tmp$DEPARTMENT_DESC[n]=="Electrical Computer Engr" & tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.SchoolofEngineering.ElectricalandComputerEngineering"}
  
  if (tmp$DEPARTMENT_DESC[n]=="SOE Mechanical Engineering" & tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.SchoolofEngineering.MechanicalEngineering"}
  if (tmp$DEPARTMENT_DESC[n]=="SOE Mechanical Engineering" & tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.SchoolofEngineering.MechanicalEngineering"}
  
  if (tmp$DEPARTMENT_DESC[n]=="Nuclear Engineering" & tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.SchoolofEngineering.NuclearEngineering"}
  if (tmp$DEPARTMENT_DESC[n]=="Nuclear Engineering" & tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.SchoolofEngineering.NuclearEngineering"}
  
  if (tmp$DEPARTMENT_DESC[n]=="NSMS Nano Science & Micro Syst" & tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.SchoolofEngineering.NanoscienceandMicrosystems"}
  if (tmp$DEPARTMENT_DESC[n]=="NSMS Nano Science & Micro Syst" & tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.SchoolofEngineering.NanoscienceandMicrosystems"}
  
  if (tmp$SUBJEC[n]=="BME" & tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.SchoolofEngineering.BiomedicalEngineering"}
  if (tmp$SUBJEC[n]=="BME" & tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.SchoolofEngineering.BiomedicalEngineering"}
  
  if (tmp$SUBJEC[n]=="ENG" & tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.SchoolofEngineering.Engineering"}
  if (tmp$SUBJEC[n]=="ENG" & tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.SchoolofEngineering.Engineering"}
  
  if (tmp$DEPARTMENT_DESC[n]=="Computer Science" & tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.SchoolofEngineering.ComputerScience"}
  if (tmp$DEPARTMENT_DESC[n]=="Computer Science" & tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.SchoolofEngineering.ComputerScience"}
  
  if (tmp$DEPARTMENT_DESC[n]=="Foreign Languages Literatures" & tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.ForeignLanguagesandLiterature"}
  if (tmp$DEPARTMENT_DESC[n]=="Foreign Languages Literatures" & tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.ForeignLanguagesandLiterature"}
  if (tmp$SUBJECT[n]=="RUSS" & tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.ForeignLanguagesandLiterature"}
  
  if (tmp$DEPARTMENT_DESC[n]=="AS CHMS Program" & tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.ChicanaandChicanoStudies"}
  if (tmp$DEPARTMENT_DESC[n]=="AS CHMS Program" & tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.ChicanaandChicanoStudies"}
  
  if (tmp$SUBJECT[n]=="PADM" & tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.SchoolofPublicAdministration"}
  if (tmp$SUBJECT[n]=="PADM" & tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.SchoolofPublicAdministration"}
  if (tmp$SUBJECT[n]=="PADM" && tmp$INSTRUCTION_DELIVERY_MODE[n]=="ITVPE" && tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.SchoolofPublicAdministration"}
  if (tmp$SUBJECT[n]=="PADM" && tmp$INSTRUCTION_DELIVERY_MODE[n]=="ITVE" && tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.SchoolofPublicAdministration"}
  
  if (tmp$SUBJECT[n]=="GEOG" & tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.Geography"} 
  if (tmp$SUBJECT[n]=="GEOG" & tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.Geography"} 
    
  if (tmp$DEPARTMENT_DESC[n]=="Spanish Portuguese" & tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.SpanishPortuguese"}
  if (tmp$DEPARTMENT_DESC[n]=="Spanish Portuguese" & tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.SpanishPortuguese"}
  
  if (tmp$DEPARTMENT_DESC[n]=="Lang Literacy Sociocultural LL" & tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.CollegeofEducation.LanguageLiteracyandSocioculturalStudies"}
  if (tmp$DEPARTMENT_DESC[n]=="Lang Literacy Sociocultural LL" & tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.CollegeofEducation.LanguageLiteracyandSocioculturalStudies"}
  
  if (tmp$DEPARTMENT_DESC[n]=="Teacher Education" & tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.CollegeofEducation.Teacher Education"}
  if (tmp$DEPARTMENT_DESC[n]=="Teacher Education" & tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.CollegeofEducation.Teacher Education"}
  
  if (tmp$SUBJECT[n]=="COUN" & tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.CollegeofEducation.IndividualFamilyandCommunityEducation"}
  if (tmp$SUBJECT[n]=="COUN" & tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.CollegeofEducation.IndividualFamilyandCommunityEducation"}
  
  if (tmp$DEPARTMENT_DESC[n]=="AS Linguistics" & tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.Linguistics"}
  if (tmp$DEPARTMENT_DESC[n]=="AS Linguistics" & tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.Linguistics"}
  
  if (tmp$DEPARTMENT_DESC[n]=="Chemistry" & tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.ChemistryandChemicalBiology"}
  if (tmp$DEPARTMENT_DESC[n]=="Chemistry" & tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.ChemistryandChemicalBiology"}
  
  if (tmp$DEPARTMENT_DESC[n]=="African American Studies" & tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.AfricanaStudies"}
  if (tmp$DEPARTMENT_DESC[n]=="African American Studies" & tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.AfricanaStudies"}
  
  if (tmp$DEPARTMENT_DESC[n]=="AS American Studies" & tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.AmericanStudies"}
  if (tmp$DEPARTMENT_DESC[n]=="AS American Studies" & tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.AmericanStudies"}
  
  if (tmp$SUBJECT[n]=="LAIS" & tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.HonorsCollege"} 
  if (tmp$SUBJECT[n]=="LAIS" & tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.HonorsCollege"} 
  
  if (tmp$SUBJECT[n]=="UNIV" & tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.UniversityCollege"} 
  if (tmp$SUBJECT[n]=="UNIV" & tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.UniversityCollege"} 
  
  if (tmp$SUBJECT[n]=="INTS" & tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.InternationalStudies"} 
  if (tmp$SUBJECT[n]=="INTS" & tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.InternationalStudies"} 
  
  if (tmp$SUBJECT[n]=="MSST" & tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.MuseumStudies"} 
  if (tmp$SUBJECT[n]=="MSST" & tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.MuseumStudies"} 
  
  if (tmp$SUBJECT[n]=="PCST" & tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.PeaceStudies"} 
  if (tmp$SUBJECT[n]=="PCST" & tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.PeaceStudies"} 
  
  if (tmp$SUBJECT[n]=="HED" & tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.CollegeofEducation.HealthEducation"}
  if (tmp$SUBJECT[n]=="HED" & tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.CollegeofEducation.HealthEducation"}
  
  if (tmp$SUBJECT[n]=="PEP" & tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.CollegeofEducation.PhysicalEdProfessional"}
  if (tmp$SUBJECT[n]=="PEP" & tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.CollegeofEducation.PhysicalEdProfessional"}
  
  if (tmp$SUBJECT[n]=="PENP" & tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.CollegeofEducation.PhysicalEdNon-Professional"}
  if (tmp$SUBJECT[n]=="PENP" & tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.CollegeofEducation.PhysicalEdNon-Professional"}
  
  if (tmp$CAMPUS[n]=="GA") {
      tmp$NodePath[n] <- "University.BranchCampuses.Gallup"} 
  if (tmp$CAMPUS[n]=="EG") {
    tmp$NodePath[n] <- "University.BranchCampuses.Gallup"} 
  if (tmp$CAMPUS[n]=="LA") {
      tmp$NodePath[n] <- "University.BranchCampuses.LosAlamos"} 
  if (tmp$CAMPUS[n]=="TA") {
      tmp$NodePath[n] <- "University.BranchCampuses.Taos"} 
  if (tmp$CAMPUS[n]=="VA") {
      tmp$NodePath[n] <- "University.BranchCampuses.Valencia"} 
  if (tmp$CAMPUS[n]=="EW") {
    tmp$NodePath[n] <- "University.BranchCampuses.UNMWest"} 
  n <- n+1
}  

# Write the detailed Course file
write.csv(tmp, file = "Detailed_Course_Data.csv")

# Drop all fields except: TITLE, CODE, and COURSEUniqueID
tmp$COURSE_REFERENCE_NUMBER <- NULL
tmp$ACADEMIC_PERIOD <- NULL
tmp$Academic.Period.Desc <- NULL
tmp$SUB_ACADEMIC_PERIOD <- NULL
tmp$SUB_ACADEMIC_PERIOD_DESC <- NULL
tmp$CAMPUS <- NULL
tmp$CAMPUS_DESC <- NULL
tmp$COLLEGE <- NULL
tmp$COLLEGE_DESC <- NULL
tmp$DEPARTMENT <- NULL
tmp$DEPARTMENT_DESC <- NULL
tmp$SUBJECT <- NULL
tmp$COURSE_NUMBER <- NULL
tmp$COURSE_SECTION_NUMBER <- NULL
tmp$TITLE_SHORT_DESC <- NULL
tmp$TITLE_LONG_DESC <- NULL
tmp$INSTRUCTION_DELIVERY_MODE <- NULL
tmp$INSTRUCTION_DELIVERY_MODE_DESC <- NULL
tmp$PRIMARY_INSTRUCTOR_FIRST_NAME <- NULL
tmp$PRIMARY_INSTRUCTOR_LAST_NAME <- NULL
tmp$PRIMARY_INSTRUCTOR_EMAIL <- NULL
tmp$PRIMARY_PRIMARY_INSTRUCTOR_ID <- NULL
tmp$PRIMARY_INSTRUCTOR_NETID <- NULL
tmp$PRIMARY_MAX_CREDITS <- NULL
tmp$PRIMARY_CIP_CODE <- NULL
tmp$PRIMARY_COURSE_GROUP <- NULL
tmp$SCHEDULE_TYPE_DESC <- NULL
tmp$MEETING_DAYS <- NULL
tmp$MEETING_TIME <- NULL
tmp$BUILDING <- NULL
tmp$ROOM <- NULL
tmp$START_DATE <- NULL
tmp$END_DATE <- NULL
tmp$ACTUAL_ENROLLMENT <- NULL
tmp$MAXIMUM_ENROLLMENT <- NULL
tmp$Program.Classification.Desc <- NULL
tmp$PROGRAM_CLASSIFICATION <- NULL
tmp$REGISTRATION_STATUS_DESC <- NULL
tmp$Student.Level.Desc <- NULL
tmp$Major.Desc <- NULL
tmp$College.Desc <- NULL
tmp$CONFIDENTIALITY_IND <- NULL
tmp$FULL_NAME_LFMI <- NULL	
tmp$LastName <- NULL
tmp$FirstName <- NULL
tmp$EMAIL <- NULL
tmp$PRIMARY_INSTRUCTOR_ID <- NULL
tmp$MAX_CREDITS <- NULL
tmp$CIP_CODE <- NULL
tmp$COURSE_GROUP <- NULL
tmp$USERTYPEID <- NULL
tmp$UserName <- NULL
tmp$NATION_DESC <- NULL  					
tmp$CURRENT_AGE <- NULL
tmp$GENDER_DESC <- NULL
tmp$IPEDS_VALUES_DESC <- NULL
tmp$COUNTY_DESC <- NULL
tmp$CITY <- NULL
tmp$STATE_PROVINCE <- NULL
tmp$REGISTRATION_STATUS_DATE <- NULL


# Drop dups before writing records
tmp <- unique(tmp)

# Write the final Course File for upload to EvalKIT
write.csv(tmp, file = "Upload_Course_Data.csv")

# Compare row and issue warning if not equal, as it could mean lost course records
ULCDrows <- nrow(tmp)
if (ULCDrows != crnrows) {
  print("Note that number of unique CRNs in Course Upload File do not match number of CRNs in the CRNKey file.")
}



#************************************************************************************************************************
#************************************************************************************************************************
  
  
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



