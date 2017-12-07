# ***Use For Reconciling Missing Departments That May Have Been Added Late by Departments - run Before Student Surveys are Released***
# Author: Aaron G. Baca, UNM/IT, 7/7/17

# Step 1. Export Selected or Export All, Courses from your EvaluationKIT project, that you want to test for missing courses;
# Step 2. Upldate line '35,' below, with the exact name of the Exported file - save it as .csv file;
# Step 3. Make sure your 'setwd' path on line 32 is correct for your PC, i.e. place all files in this one folder;
# Step 4. Update lines xx thru xx with the unique hierarchies from all of your departments;
# Step 5. Obtain a fresh MyReports query, save as .csv file and make sure file name matches on line 54 and line 231 below;
# Step 6. Make a CancelledCourses.csv file listing all of the CRN from Courses that have been omitted, highlighted in red, by department admins;
# Step 7. Run this program;
# Step 8. View the newly generated MissingCourses file to see a possible list of courses that were added late to Banner.  

#install.packages("doParallel")
#library(doParallel)
#library(parallel)

#install.packages("foreach")
#library(foreach)

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
setwd("/Users/aaronbaca/Documents/EvaluationKIT/Summer 2017/TestDeptReconcil")

# Read-in the User Export file from EvalKIT, where this program adds newly enrolled students and sets an unenroll flag of '1' to students who have dropped courses
CourseExportDat <- read.csv("CourseExport_2017SummerCourses.csv", header = TRUE, stringsAsFactors=FALSE)

# Remove the following fields from the UserExport_'ProjectName'.csv" file: 
CourseExportDat$a <- NULL
CourseExportDat$CustomQuestionEnd <- NULL
CourseExportDat$CustomQuestionStart <- NULL
CourseExportDat$InstructorCourseLevelEnd <- NULL
CourseExportDat$InstructorCourseLevelStart <- NULL
CourseExportDat$AdminCourseLevelEnd <- NULL
CourseExportDat$AdminCourseLevelStart <- NULL
CourseExportDat$AdminLevelEnd <- NULL
CourseExportDat$AdminLevelStart <- NULL
CourseExportDat$SurveyEnd <- NULL
CourseExportDat$SurveyStart <- NULL
CourseExportDat$crossListUniqueID <- NULL
CourseExportDat$Code <- NULL
CourseExportDat$Title <- NULL

# Read in the MyReports data, i.e. the Class_List_GAH.csv file
# Below replace the "Class_List_GAH (**),csv" file name with the MyReports file name that contains all student/course data
MyReportsDat <- read.csv("Class_List_GAH (22).csv", header = TRUE, stringsAsFactors=FALSE)

#Remove Dropped or Waitlisted Students using REGISTRATION_STATUS_DESC field 
MyReportsDat <- subset(MyReportsDat, (str_sub(MyReportsDat$REGISTRATION_STATUS_DESC, 1,4)!="Drop") )
MyReportsDat <- subset(MyReportsDat, (str_sub(MyReportsDat$REGISTRATION_STATUS_DESC, 1,15)!="Drop with Grade") )
MyReportsDat <- subset(MyReportsDat, (str_sub(MyReportsDat$REGISTRATION_STATUS_DESC, 1,11)!="Drop/Delete") )
MyReportsDat <- subset(MyReportsDat, (str_sub(MyReportsDat$REGISTRATION_STATUS_DESC, 1,4)!="Wait") )
MyReportsDat <- subset(MyReportsDat, (str_sub(MyReportsDat$REGISTRATION_STATUS_DESC, 1,9)!="Cancelled") )

# Remove unnecessary records and fields
# Remove Faculty records that do not have NetIDs and flag them by writing them to a file
MyReportsDat <- subset(MyReportsDat, MyReportsDat$PRIMARY_INSTRUCTOR_NETID != ".")
# Remove student records that do not have NetIDs and flag them by writing them to a file
MyReportsDat <- subset(MyReportsDat, MyReportsDat$NETID != ".")

# Remove non-participating departments out of MyReportsDat
MyReportsDat <- subset(MyReportsDat, (str_sub(MyReportsDat$COLLEGE_DESC)!="College of Pharmacy"))
MyReportsDat <- subset(MyReportsDat, (str_sub(MyReportsDat$COLLEGE_DESC)!="School of Law"))
MyReportsDat <- subset(MyReportsDat, (str_sub(MyReportsDat$SUBJECT)!="ISEP"))
MyReportsDat <- subset(MyReportsDat, (str_sub(MyReportsDat$SUBJECT)!="NSE"))
MyReportsDat <- subset(MyReportsDat, (str_sub(MyReportsDat$SUBJECT)!="AFAS"))
#MyReportsDat <- subset(MyReportsDat, (str_sub(MyReportsDat$SUBJECT)!="MDVL"))
MyReportsDat <- subset(MyReportsDat, (str_sub(MyReportsDat$SUBJECT)!="MLSL"))
MyReportsDat <- subset(MyReportsDat, (str_sub(MyReportsDat$SUBJECT)!="BIOM"))
MyReportsDat <- subset(MyReportsDat, (str_sub(MyReportsDat$SUBJECT)!="PAST"))
MyReportsDat <- subset(MyReportsDat, (str_sub(MyReportsDat$SUBJECT)!="PT"))
MyReportsDat <- subset(MyReportsDat, (str_sub(MyReportsDat$SUBJECT)!="OCTH"))
MyReportsDat <- subset(MyReportsDat, (str_sub(MyReportsDat$SUBJECT)!="NUCM"))
MyReportsDat <- subset(MyReportsDat, (str_sub(MyReportsDat$SUBJECT)!="MEDL"))

# Remove History courses that department says are not to be evaluated, if they exist
MyReportsDat <- MyReportsDat[!(MyReportsDat$DEPARTMENT_DESC=="History" & MyReportsDat$SUBJECT=="HIST" & MyReportsDat$CAMPUS=="ABQ" & str_sub(MyReportsDat$COURSE_NUMBER)=="699") , ]
MyReportsDat <- MyReportsDat[!(MyReportsDat$DEPARTMENT_DESC=="History" & MyReportsDat$SUBJECT=="HIST" & MyReportsDat$CAMPUS=="ABQ" & str_sub(MyReportsDat$COURSE_NUMBER)=="697") , ]
MyReportsDat <- MyReportsDat[!(MyReportsDat$DEPARTMENT_DESC=="History" & MyReportsDat$SUBJECT=="HIST" & MyReportsDat$CAMPUS=="ABQ" & str_sub(MyReportsDat$COURSE_NUMBER)=="599") , ]
MyReportsDat <- MyReportsDat[!(MyReportsDat$DEPARTMENT_DESC=="History" & MyReportsDat$SUBJECT=="HIST" & MyReportsDat$CAMPUS=="ABQ" & str_sub(MyReportsDat$COURSE_NUMBER)=="496") , ]
MyReportsDat <- MyReportsDat[!(MyReportsDat$DEPARTMENT_DESC=="History" & MyReportsDat$SUBJECT=="HIST" & MyReportsDat$CAMPUS=="ABQ" & str_sub(MyReportsDat$COURSE_NUMBER)=="493") , ]
MyReportsDat <- MyReportsDat[!(MyReportsDat$DEPARTMENT_DESC=="History" & MyReportsDat$SUBJECT=="HIST" & MyReportsDat$CAMPUS=="ABQ" & str_sub(MyReportsDat$COURSE_NUMBER)=="494") , ]

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

# Create the COURSEUNIQUEID field to identify courses across both tables 
MyReportsDat$CourseUniqueID <- do.call(paste, c(MyReportsDat[c("COURSE_REFERENCE_NUMBER", "ACADEMIC_PERIOD")], sep = ""))

# Remove Unecessary Field data from the MyReports table to help speed processing along
MyReportsDat$COURSE_REFERENCE_NUMBER <-NULL
MyReportsDat$ACADEMIC_PERIOD <- NULL
MyReportsDat$Academic.Period.Desc <- NULL
MyReportsDat$SUB_ACADEMIC_PERIOD <- NULL
MyReportsDat$SUB_ACADEMIC_PERIOD_DESC <- NULL
#MyReportsDat$CAMPUS <- NULL
MyReportsDat$CAMPUS_DESC <- NULL
MyReportsDat$COLLEGE <- NULL
MyReportsDat$COLLEGE_DESC <- NULL
MyReportsDat$DEPARTMENT <- NULL
#MyReportsDat$DEPARTMENT_DESC <- NULL
#MyReportsDat$SUBJECT <- NULL
#MyReportsDat$COURSE_NUMBER <- NULL
MyReportsDat$COURSE_SECTION_NUMBER <- NULL
#MyReportsDat$TITLE_LONG_DESC <- NULL
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
MyReportsDat$College.Desc <- NULL
MyReportsDat$CONFIDENTIALITY_IND <- NULL
MyReportsDat$FULL_NAME_LFMI <- NULL
MyReportsDat$PRIMARY_INSTRUCTOR_ID <- NULL
MyReportsDat$MAX_CREDITS <- NULL
MyReportsDat$CIP_CODE <- NULL
MyReportsDat$COURSE_GROUP <- NULL
MyReportsDat$ID <- NULL
MyReportsDat$REGISTRATION_STATUS_DESC <- NULL
MyReportsDat$EMAIL_ADDRESS <- NULL
MyReportsDat$NETID <- NULL

MyReportsDat <- unique(MyReportsDat)

MyReportsDat$NodePath <- ""

#***Assign Branch/College/Dept. hierarchies so that non-matching hierarchies can be removed. Figure out whether to run this against a project or against 
#individuals dept. lists..???

MyReportsDat[MyReportsDat$DEPARTMENT_DESC == "Mathematics Statistics" & MyReportsDat$CAMPUS == "ABQ", "NodePath"] <- "University.CollegeofArts&Sciences.Mathematics/Statistics"
MyReportsDat[MyReportsDat$DEPARTMENT_DESC == "Mathematics Statistics" & MyReportsDat$CAMPUS == "EA", "NodePath"] <- "University.CollegeofArts&Sciences.Mathematics/Statistics"

MyReportsDat[MyReportsDat$SUBJECT == "ANTH" & MyReportsDat$CAMPUS == "ABQ", "NodePath"] <- "University.CollegeofArts&Sciences.Anthropology"
MyReportsDat[MyReportsDat$SUBJECT == "ANTH" & MyReportsDat$CAMPUS == "EA", "NodePath"] <- "University.CollegeofArts&Sciences.Anthropology"

MyReportsDat[MyReportsDat$SUBJECT == "RELG" & MyReportsDat$CAMPUS == "ABQ", "NodePath"] <- "University.CollegeofArts&Sciences.ReligiousStudies"
MyReportsDat[MyReportsDat$SUBJECT == "RELG" & MyReportsDat$CAMPUS == "EA", "NodePath"] <- "University.CollegeofArts&Sciences.ReligiousStudies"

MyReportsDat[MyReportsDat$SUBJECT == "SHS" & MyReportsDat$CAMPUS == "ABQ", "NodePath"] <- "University.CollegeofArts&Sciences.SpeechandHearingSciences"
MyReportsDat[MyReportsDat$SUBJECT == "SHS" & MyReportsDat$CAMPUS == "EA", "NodePath"] <- "University.CollegeofArts&Sciences.SpeechandHearingSciences"

MyReportsDat[MyReportsDat$DEPARTMENT_DESC == "Biology" & MyReportsDat$CAMPUS == "ABQ", "NodePath"] <- "University.CollegeofArts&Sciences.Biology"
MyReportsDat[MyReportsDat$DEPARTMENT_DESC == "Biology" & MyReportsDat$CAMPUS == "EA", "NodePath"] <- "University.CollegeofArts&Sciences.Biology"

MyReportsDat[MyReportsDat$SUBJECT == "HMHV" & MyReportsDat$CAMPUS == "ABQ", "NodePath"] <- "University.CollegeofArts&Sciences.Interdisciplinary.HMHV"
MyReportsDat[MyReportsDat$SUBJECT == "HMHV" & MyReportsDat$CAMPUS == "EA", "NodePath"] <- "University.CollegeofArts&Sciences.Interdisciplinary.HMHV"

MyReportsDat[MyReportsDat$SUBJECT == "LTAM" && MyReportsDat$DEPARTMENT_DESC == "*Interdisciplinary: A.S." && MyReportsDat$CAMPUS=="ABQ", "NodePath"] <- "University.CollegeofArts&Sciences.Interdisciplinary.LTAM"
MyReportsDat[MyReportsDat$SUBJECT == "LTAM" && MyReportsDat$DEPARTMENT_DESC == "*Interdisciplinary: A.S." && MyReportsDat$CAMPUS=="EA", "NodePath"] <- "University.CollegeofArts&Sciences.Interdisciplinary.LTAM"

MyReportsDat[MyReportsDat$SUBJECT == "ASCP" && MyReportsDat$DEPARTMENT_DESC == "*Interdisciplinary: A.S." && MyReportsDat$CAMPUS=="ABQ", "NodePath"] <- "University.CollegeofArts&Sciences.Interdisciplinary.ASCP"
MyReportsDat[MyReportsDat$SUBJECT == "ASCP" && MyReportsDat$DEPARTMENT_DESC == "*Interdisciplinary: A.S." && MyReportsDat$CAMPUS=="EA", "NodePath"] <- "University.CollegeofArts&Sciences.Interdisciplinary.ASCP"

MyReportsDat[MyReportsDat$SUBJECT == "ARSC" && MyReportsDat$DEPARTMENT_DESC == "*Interdisciplinary: A.S." && MyReportsDat$CAMPUS=="ABQ", "NodePath"] <- "University.CollegeofArts&Sciences.Interdisciplinary.ARSC"
MyReportsDat[MyReportsDat$SUBJECT == "ARSC" && MyReportsDat$DEPARTMENT_DESC == "*Interdisciplinary: A.S." && MyReportsDat$CAMPUS=="EA", "NodePath"] <- "University.CollegeofArts&Sciences.Interdisciplinary.ARSC"

MyReportsDat[MyReportsDat$SUBJECT == "MSST" && MyReportsDat$DEPARTMENT_DESC == "*Interdisciplinary: A.S." && MyReportsDat$CAMPUS=="ABQ", "NodePath"] <- "University.CollegeofArts&Sciences.Interdisciplinary.MSST"
MyReportsDat[MyReportsDat$SUBJECT == "MSST" && MyReportsDat$DEPARTMENT_DESC == "*Interdisciplinary: A.S." && MyReportsDat$CAMPUS=="EA", "NodePath"] <- "University.CollegeofArts&Sciences.Interdisciplinary.MSST"

MyReportsDat[MyReportsDat$SUBJECT == "BIOC" & MyReportsDat$CAMPUS == "ABQ", "NodePath"] <- "University.SchoolofMedicine.BiochemistryandMolecularBiology"
MyReportsDat[MyReportsDat$SUBJECT == "BIOC" & MyReportsDat$CAMPUS == "EA", "NodePath"] <- "University.SchoolofMedicine.BiochemistryandMolecularBiology"
  
MyReportsDat[MyReportsDat$SUBJECT == "SUST" && MyReportsDat$DEPARTMENT_DESC == "*Interdisciplinary: A.S." && MyReportsDat$CAMPUS=="ABQ", "NodePath"] <- "University.CollegeofArts&Sciences.Interdisciplinary.SUST"
MyReportsDat[MyReportsDat$SUBJECT == "SUST" && MyReportsDat$DEPARTMENT_DESC == "*Interdisciplinary: A.S." && MyReportsDat$CAMPUS=="EA", "NodePath"] <- "University.CollegeofArts&Sciences.Interdisciplinary.SUST"

MyReportsDat[MyReportsDat$SUBJECT == "MDVL" && MyReportsDat$DEPARTMENT_DESC == "*Interdisciplinary: A.S." && MyReportsDat$CAMPUS=="ABQ", "NodePath"] <- "University.CollegeofFineArts.Interdisciplinary.MDVL"
MyReportsDat[MyReportsDat$SUBJECT == "MDVL" && MyReportsDat$DEPARTMENT_DESC == "*Interdisciplinary: A.S." && MyReportsDat$CAMPUS=="EA", "NodePath"] <- "University.CollegeofFineArts.Interdisciplinary.MDVL"

MyReportsDat[MyReportsDat$SUBJECT == "IFDM" && MyReportsDat$DEPARTMENT_DESC == "*Interdisciplinary: Fine Arts" && MyReportsDat$CAMPUS=="ABQ", "NodePath"] <- "University.CollegeofFineArts.CinematicArts.IFDM"
MyReportsDat[MyReportsDat$SUBJECT == "IFDM" && MyReportsDat$DEPARTMENT_DESC == "*Interdisciplinary: Fine Arts" && MyReportsDat$CAMPUS=="EA", "NodePath"] <- "University.CollegeofFineArts.CinematicArts.IFDM"

MyReportsDat[MyReportsDat$SUBJECT == "IFDM" && MyReportsDat$DEPARTMENT_DESC == "*Interdisciplinary: Fine Arts" && MyReportsDat$CAMPUS=="ABQ", "NodePath"] <- "University.CollegeofFineArts.CinematicArts.IFDM"
MyReportsDat[MyReportsDat$SUBJECT == "IFDM" && MyReportsDat$DEPARTMENT_DESC == "*Interdisciplinary: Fine Arts" && MyReportsDat$CAMPUS=="EA", "NodePath"] <- "University.CollegeofFineArts.CinematicArts.IFDM"

MyReportsDat[MyReportsDat$SUBJECT == "FA" && MyReportsDat$DEPARTMENT_DESC == "*Interdisciplinary: Fine Arts" && MyReportsDat$CAMPUS=="ABQ", "NodePath"] <- "University.CollegeofFineArts.Interdisciplinary.FA"
MyReportsDat[MyReportsDat$SUBJECT == "FA" && MyReportsDat$DEPARTMENT_DESC == "*Interdisciplinary: Fine Arts" && MyReportsDat$CAMPUS=="EA", "NodePath"] <- "University.CollegeofFineArts.Interdisciplinary.FA"

MyReportsDat[MyReportsDat$SUBJECT == "FA" && MyReportsDat$DEPARTMENT_DESC == "*Interdisciplinary: Fine Arts" && MyReportsDat$CAMPUS=="ABQ" && str_detect(MyReportsDat$TITLE_LONG_DESC, "Management"), "NodePath"] <- "University.CollegeofFineArts.CinematicArts.ArtsManagement"
MyReportsDat[MyReportsDat$SUBJECT == "FA" && MyReportsDat$DEPARTMENT_DESC == "*Interdisciplinary: Fine Arts" && MyReportsDat$CAMPUS=="EA" && str_detect(MyReportsDat$TITLE_LONG_DESC, "Management"), "NodePath"] <- "University.CollegeofFineArts.CinematicArts.ArtsManagement"

  # Special Hierarchy assignments for Cinematic Arts FA 284 Experiencing the Arts & FA 365 Soc Media Arts Marketing
MyReportsDat[MyReportsDat$SUBJECT == "FA" && MyReportsDat$DEPARTMENT_DESC == "*Interdisciplinary: Fine Arts" && MyReportsDat$CAMPUS=="ABQ" && MyReportsDat$COURSE_NUMBER== "284", "NodePath"] <- "University.CollegeofFineArts.CinematicArts.ArtsManagement"
MyReportsDat[MyReportsDat$SUBJECT == "FA" && MyReportsDat$DEPARTMENT_DESC == "*Interdisciplinary: Fine Arts" && MyReportsDat$CAMPUS=="EA" && MyReportsDat$COURSE_NUMBER== "284", "NodePath"] <- "University.CollegeofFineArts.CinematicArts.ArtsManagement"
MyReportsDat[MyReportsDat$SUBJECT == "FA" && MyReportsDat$DEPARTMENT_DESC == "*Interdisciplinary: Fine Arts" && MyReportsDat$CAMPUS=="ABQ" && MyReportsDat$COURSE_NUMBER== "365", "NodePath"] <- "University.CollegeofFineArts.CinematicArts.ArtsManagement"
MyReportsDat[MyReportsDat$SUBJECT == "FA" && MyReportsDat$DEPARTMENT_DESC == "*Interdisciplinary: Fine Arts" && MyReportsDat$CAMPUS=="EA" && MyReportsDat$COURSE_NUMBER== "365", "NodePath"] <- "University.CollegeofFineArts.CinematicArts.ArtsManagement"
  
MyReportsDat[MyReportsDat$SUBJECT == "BME" && MyReportsDat$DEPARTMENT_DESC == "*Interdisciplinary:Engineering" && MyReportsDat$CAMPUS=="ABQ", "NodePath"] <- "University.SchoolofEngineering.Interdisciplinary.BME"
MyReportsDat[MyReportsDat$SUBJECT == "BME" && MyReportsDat$DEPARTMENT_DESC == "*Interdisciplinary:Engineering" && MyReportsDat$CAMPUS=="EA", "NodePath"] <- "University.SchoolofEngineering.Interdisciplinary.BME"

MyReportsDat[MyReportsDat$SUBJECT == "ECOP" && MyReportsDat$DEPARTMENT_DESC == "*Interdisciplinary:Engineering" && MyReportsDat$CAMPUS=="ABQ", "NodePath"] <- "University.SchoolofEngineering.Interdisciplinary.ECOP"
MyReportsDat[MyReportsDat$SUBJECT == "ECOP" && MyReportsDat$DEPARTMENT_DESC == "*Interdisciplinary:Engineering" && MyReportsDat$CAMPUS=="EA", "NodePath"] <- "University.SchoolofEngineering.Interdisciplinary.ECOP"

MyReportsDat[MyReportsDat$SUBJECT == "ENG" && MyReportsDat$DEPARTMENT_DESC == "*Interdisciplinary:Engineering" && MyReportsDat$CAMPUS=="ABQ", "NodePath"] <- "University.SchoolofEngineering.Interdisciplinary.ENG"
MyReportsDat[MyReportsDat$SUBJECT == "ENG" && MyReportsDat$DEPARTMENT_DESC == "*Interdisciplinary:Engineering" && MyReportsDat$CAMPUS=="EA", "NodePath"] <- "University.SchoolofEngineering.Interdisciplinary.ENG"

MyReportsDat[MyReportsDat$SUBJECT == "PCST" && MyReportsDat$DEPARTMENT_DESC == "*Interdisciplinary: A.S." && MyReportsDat$CAMPUS=="ABQ", "NodePath"] <- "University.CollegeofArts&Sciences.Interdisciplinary.PCST"
MyReportsDat[MyReportsDat$SUBJECT == "PCST" && MyReportsDat$DEPARTMENT_DESC == "*Interdisciplinary: A.S." && MyReportsDat$CAMPUS=="EA", "NodePath"] <- "University.CollegeofArts&Sciences.Interdisciplinary.PCST"

MyReportsDat[MyReportsDat$SUBJECT == "INTS" && MyReportsDat$DEPARTMENT_DESC == "*Interdisciplinary: A.S." && MyReportsDat$CAMPUS=="ABQ", "NodePath"] <- "University.CollegeofArts&Sciences.Interdisciplinary.INTS"
MyReportsDat[MyReportsDat$SUBJECT == "INTS" && MyReportsDat$DEPARTMENT_DESC == "*Interdisciplinary: A.S." && MyReportsDat$CAMPUS=="EA", "NodePath"] <- "University.CollegeofArts&Sciences.Interdisciplinary.INTS"

MyReportsDat[MyReportsDat$SUBJECT == "POLS" & MyReportsDat$CAMPUS == "ABQ", "NodePath"] <- "University.CollegeofArts&Sciences.PoliticalScience"
MyReportsDat[MyReportsDat$SUBJECT == "POLS" & MyReportsDat$CAMPUS == "EA", "NodePath"] <- "University.CollegeofArts&Sciences.PoliticalScience"
  
MyReportsDat[MyReportsDat$SUBJECT == "NVSC" & MyReportsDat$CAMPUS == "ABQ", "NodePath"] <- "University.NavalScience"
MyReportsDat[MyReportsDat$SUBJECT == "NVSC" & MyReportsDat$CAMPUS == "EA", "NodePath"] <- "University.NavalScience"

MyReportsDat[MyReportsDat$SUBJECT == "OILS" & MyReportsDat$CAMPUS == "ABQ", "NodePath"] <- "University.CollegeofUniversityLibraries&LearningSciences.Organization,InformationandLearningSciences"
MyReportsDat[MyReportsDat$SUBJECT == "OILS" & MyReportsDat$CAMPUS == "EA", "NodePath"] <- "University.CollegeofUniversityLibraries&LearningSciences.Organization,InformationandLearningSciences"

MyReportsDat[MyReportsDat$SUBJECT == "UHON" & MyReportsDat$CAMPUS == "ABQ", "NodePath"] <- "University.HonorsCollege"
MyReportsDat[MyReportsDat$SUBJECT == "UHON" & MyReportsDat$CAMPUS == "EA", "NodePath"] <- "University.HonorsCollege"

MyReportsDat[MyReportsDat$DEPARTMENT_DESC == "School Architecture Planning" && MyReportsDat$CAMPUS == "ABQ" && MyReportsDat$SUBJECT=="ARCH", "NodePath"] <- "University.SchoolofArchitectureandPlanning.Architecture"
MyReportsDat[MyReportsDat$DEPARTMENT_DESC == "School Architecture Planning" && MyReportsDat$CAMPUS == "EA" && MyReportsDat$SUBJECT=="ARCH", "NodePath"] <- "University.SchoolofArchitectureandPlanning.Architecture"

MyReportsDat[MyReportsDat$DEPARTMENT_DESC == "School Architecture Planning" && MyReportsDat$CAMPUS == "ABQ" && MyReportsDat$SUBJECT=="CRP", "NodePath"] <- "University.SchoolofArchitectureandPlanning.CommunityandRegionalPlanning"
MyReportsDat[MyReportsDat$DEPARTMENT_DESC == "School Architecture Planning" && MyReportsDat$CAMPUS == "EA" && MyReportsDat$SUBJECT=="CRP", "NodePath"] <- "University.SchoolofArchitectureandPlanning.CommunityandRegionalPlanning"

MyReportsDat[MyReportsDat$DEPARTMENT_DESC == "School Architecture Planning" && MyReportsDat$CAMPUS == "ABQ" && MyReportsDat$SUBJECT=="LA", "NodePath"] <- "University.SchoolofArchitectureandPlanning.LandscapeArchitecture"
MyReportsDat[MyReportsDat$DEPARTMENT_DESC == "School Architecture Planning" && MyReportsDat$CAMPUS == "EA" && MyReportsDat$SUBJECT=="LA", "NodePath"] <- "University.SchoolofArchitectureandPlanning.LandscapeArchitecture"

MyReportsDat[MyReportsDat$DEPARTMENT_DESC == "Earth & Planetary Sciences" && MyReportsDat$CAMPUS == "ABQ" && MyReportsDat$SUBJECT=="ENVS", "NodePath"] <- "University.CollegeofArts&Sciences.EarthandPlanetarySciences"
MyReportsDat[MyReportsDat$DEPARTMENT_DESC == "Earth & Planetary Sciences" && MyReportsDat$CAMPUS == "EA" && MyReportsDat$SUBJECT=="ENVS", "NodePath"] <- "University.CollegeofArts&Sciences.EarthandPlanetarySciences"

MyReportsDat[MyReportsDat$SUBJECT == "EPS" & MyReportsDat$CAMPUS == "ABQ", "NodePath"] <- "University.CollegeofArts&Sciences.EarthandPlanetarySciences"
MyReportsDat[MyReportsDat$SUBJECT == "EPS" & MyReportsDat$CAMPUS == "EA", "NodePath"] <- "University.CollegeofArts&Sciences.EarthandPlanetarySciences"
  
MyReportsDat[MyReportsDat$SUBJECT == "NTSC" & MyReportsDat$CAMPUS == "ABQ", "NodePath"] <- "University.CollegeofArts&Sciences.EarthandPlanetarySciences"
MyReportsDat[MyReportsDat$SUBJECT == "NTSC" & MyReportsDat$CAMPUS == "EA", "NodePath"] <- "University.CollegeofArts&Sciences.EarthandPlanetarySciences"

MyReportsDat[MyReportsDat$SUBJECT == "WMST" & MyReportsDat$CAMPUS == "ABQ", "NodePath"] <- "University.CollegeofArts&Sciences.WomenStudies"
MyReportsDat[MyReportsDat$SUBJECT == "WMST" & MyReportsDat$CAMPUS == "EA", "NodePath"] <- "University.CollegeofArts&Sciences.WomenStudies"

MyReportsDat[MyReportsDat$DEPARTMENT_DESC == "English" && MyReportsDat$CAMPUS == "ABQ" && MyReportsDat$SUBJECT=="ENGL", "NodePath"] <- "University.CollegeofArts&Sciences.English"
MyReportsDat[MyReportsDat$DEPARTMENT_DESC == "English" && MyReportsDat$CAMPUS == "EA" && MyReportsDat$SUBJECT=="ENGL", "NodePath"] <- "University.CollegeofArts&Sciences.English"

MyReportsDat[MyReportsDat$DEPARTMENT_DESC == "English" && MyReportsDat$CAMPUS == "ABQ" && MyReportsDat$SUBJECT=="ENGL", "NodePath"] <- "University.CollegeofArts&Sciences.English"
MyReportsDat[MyReportsDat$DEPARTMENT_DESC == "English" && MyReportsDat$CAMPUS == "EA" && MyReportsDat$SUBJECT=="ENGL", "NodePath"] <- "University.CollegeofArts&Sciences.English"

MyReportsDat[MyReportsDat$DEPARTMENT_DESC == "Psychology" && MyReportsDat$CAMPUS == "ABQ" && MyReportsDat$SUBJECT=="ENGL", "NodePath"] <- "University.CollegeofArts&Sciences.Psychology"
MyReportsDat[MyReportsDat$DEPARTMENT_DESC == "Psychology" && MyReportsDat$CAMPUS == "EA" && MyReportsDat$SUBJECT=="ENGL", "NodePath"] <- "University.CollegeofArts&Sciences.Psychology"

MyReportsDat[MyReportsDat$DEPARTMENT_DESC == "Sociology" && MyReportsDat$CAMPUS == "ABQ" && MyReportsDat$SUBJECT=="ENGL", "NodePath"] <- "University.CollegeofArts&Sciences.Sociology"
MyReportsDat[MyReportsDat$DEPARTMENT_DESC == "Sociology" && MyReportsDat$CAMPUS == "EA" && MyReportsDat$SUBJECT=="ENGL", "NodePath"] <- "University.CollegeofArts&Sciences.Sociology"

MyReportsDat[MyReportsDat$DEPARTMENT_DESC == "AS Economics" && MyReportsDat$CAMPUS == "ABQ" && MyReportsDat$SUBJECT=="ENGL", "NodePath"] <- "University.CollegeofArts&Sciences.Economics"
MyReportsDat[MyReportsDat$DEPARTMENT_DESC == "AS Economics" && MyReportsDat$CAMPUS == "EA" && MyReportsDat$SUBJECT=="ENGL", "NodePath"] <- "University.CollegeofArts&Sciences.Economics"

MyReportsDat[MyReportsDat$DEPARTMENT_DESC == "Philosophy" && MyReportsDat$CAMPUS == "ABQ" && MyReportsDat$SUBJECT=="ENGL", "NodePath"] <- "University.CollegeofArts&Sciences.Philosophy"
MyReportsDat[MyReportsDat$DEPARTMENT_DESC == "Philosophy" && MyReportsDat$CAMPUS == "EA" && MyReportsDat$SUBJECT=="ENGL", "NodePath"] <- "University.CollegeofArts&Sciences.Philosophy"

MyReportsDat[MyReportsDat$DEPARTMENT_DESC == "Communication Journalism" && MyReportsDat$CAMPUS == "ABQ" && MyReportsDat$SUBJECT=="ENGL", "NodePath"] <- "University.CollegeofArts&Sciences.CommunicationandJournalism"
MyReportsDat[MyReportsDat$DEPARTMENT_DESC == "Communication Journalism" && MyReportsDat$CAMPUS == "EA" && MyReportsDat$SUBJECT=="ENGL", "NodePath"] <- "University.CollegeofArts&Sciences.CommunicationandJournalism"

MyReportsDat[MyReportsDat$DEPARTMENT_DESC == "Music" && MyReportsDat$CAMPUS == "ABQ" && MyReportsDat$SUBJECT=="ENGL", "NodePath"] <- "University.CollegeofFineArts.Music"
MyReportsDat[MyReportsDat$DEPARTMENT_DESC == "Music" && MyReportsDat$CAMPUS == "EA" && MyReportsDat$SUBJECT=="ENGL", "NodePath"] <- "University.CollegeofFineArts.Music"

MyReportsDat[MyReportsDat$SUBJECT == "DANC" && MyReportsDat$CAMPUS == "ABQ", "NodePath"] <- "University.CollegeofFineArts.TheatreandDance"
MyReportsDat[MyReportsDat$SUBJECT == "DANC" && MyReportsDat$CAMPUS == "EA", "NodePath"] <- "University.CollegeofFineArts.TheatreandDance"

MyReportsDat[MyReportsDat$SUBJECT == "THEA" && MyReportsDat$CAMPUS == "ABQ", "NodePath"] <- "University.CollegeofFineArts.TheatreandDance"
MyReportsDat[MyReportsDat$SUBJECT == "THEA" && MyReportsDat$CAMPUS == "EA", "NodePath"] <- "University.CollegeofFineArts.TheatreandDance"

MyReportsDat[MyReportsDat$DEPARTMENT_DESC == "Art Art History" && MyReportsDat$CAMPUS == "ABQ", "NodePath"] <- "University.CollegeofFineArts.ArtandArtHistory"
MyReportsDat[MyReportsDat$DEPARTMENT_DESC == "Art Art History" && MyReportsDat$CAMPUS == "EA", "NodePath"] <- "University.CollegeofFineArts.ArtandArtHistory"

MyReportsDat[MyReportsDat$DEPARTMENT_DESC == "Media Arts" && MyReportsDat$CAMPUS == "ABQ", "NodePath"] <- "University.CollegeofFineArts.CinematicArts.MediaArts"
MyReportsDat[MyReportsDat$DEPARTMENT_DESC == "Media Arts" && MyReportsDat$CAMPUS == "EA", "NodePath"] <- "University.CollegeofFineArts.CinematicArts.MediaArts"

MyReportsDat[MyReportsDat$DEPARTMENT_DESC == "Mathematics Statistics" && MyReportsDat$CAMPUS == "ABQ", "NodePath"] <- "University.CollegeofArts&Sciences.Mathematics/Statistics"
MyReportsDat[MyReportsDat$DEPARTMENT_DESC == "Mathematics Statistics" && MyReportsDat$CAMPUS == "EA", "NodePath"] <- "University.CollegeofArts&Sciences.Mathematics/Statistics"

MyReportsDat[MyReportsDat$DEPARTMENT_DESC == "AS Biology" && MyReportsDat$CAMPUS == "ABQ" && MyReportsDat$SUBJECT=="BIOL", "NodePath"] <- "University.CollegeofArts&Sciences.Biology"
MyReportsDat[MyReportsDat$DEPARTMENT_DESC == "AS Biology" && MyReportsDat$CAMPUS == "EA" && MyReportsDat$SUBJECT=="BIOL", "NodePath"] <- "University.CollegeofArts&Sciences.Biology"

MyReportsDat[MyReportsDat$DEPARTMENT_DESC == "AS American Studies" && MyReportsDat$CAMPUS == "ABQ", "NodePath"] <- "University.CollegeofArts&Sciences.AmericanSudies"
MyReportsDat[MyReportsDat$DEPARTMENT_DESC == "AS American Studies" && MyReportsDat$CAMPUS == "EA", "NodePath"] <- "University.CollegeofArts&Sciences.AmericanSudies"

MyReportsDat[MyReportsDat$SUBJECT == "MGMT" && MyReportsDat$CAMPUS == "ABQ", "NodePath"] <- "UniversityofNewMexico-AndersonSchoolofManagement"
MyReportsDat[MyReportsDat$SUBJECT == "MGMT" && MyReportsDat$CAMPUS == "EA", "NodePath"] <- "UniversityofNewMexico-AndersonSchoolofManagement"
MyReportsDat[MyReportsDat$SUBJECT == "MGMT" && MyReportsDat$CAMPUS == "EW", "NodePath"] <- "UniversityofNewMexico-AndersonSchoolofManagement.UNMWest"

MyReportsDat[MyReportsDat$SUBJECT == "DEHY" && MyReportsDat$CAMPUS == "ABQ", "NodePath"] <- "University.SchoolofMedicine.DentalHygiene"
MyReportsDat[MyReportsDat$SUBJECT == "DEHY" && MyReportsDat$CAMPUS == "EA", "NodePath"] <- "University.SchoolofMedicine.DentalHygiene"

MyReportsDat[MyReportsDat$SUBJECT == "EMS" && MyReportsDat$CAMPUS == "ABQ", "NodePath"] <- "University.SchoolofMedicine.EmergencyMedicine"
MyReportsDat[MyReportsDat$SUBJECT == "EMS" && MyReportsDat$CAMPUS == "EA", "NodePath"] <- "University.SchoolofMedicine.EmergencyMedicine"

MyReportsDat[MyReportsDat$DEPARTMENT_DESC == "History" && MyReportsDat$CAMPUS == "ABQ" && MyReportsDat$SUBJECT=="HIST", "NodePath"] <- "University.CollegeofArts&Sciences.History"
MyReportsDat[MyReportsDat$DEPARTMENT_DESC == "History" && MyReportsDat$CAMPUS == "EA" && MyReportsDat$SUBJECT=="HIST", "NodePath"] <- "University.CollegeofArts&Sciences.History"

MyReportsDat[MyReportsDat$DEPARTMENT_DESC == "Chem & Biological Engineering" && MyReportsDat$CAMPUS == "ABQ" , "NodePath"] <- "University.SchoolofEngineering.ChemicalandBiologicalEngineering"
MyReportsDat[MyReportsDat$DEPARTMENT_DESC == "Chem & Biological Engineering" && MyReportsDat$CAMPUS == "EA" , "NodePath"] <- "University.SchoolofEngineering.ChemicalandBiologicalEngineering"

MyReportsDat[MyReportsDat$DEPARTMENT_DESC == "Civil Engineering Civil Engr" && MyReportsDat$CAMPUS == "ABQ" , "NodePath"] <- "University.SchoolofEngineering.CivilEngineering"
MyReportsDat[MyReportsDat$DEPARTMENT_DESC == "Civil Engineering Civil Engr" && MyReportsDat$CAMPUS == "EA" , "NodePath"] <- "University.SchoolofEngineering.CivilEngineering"

MyReportsDat[MyReportsDat$DEPARTMENT_DESC == "Electrical Computer Engr" && MyReportsDat$CAMPUS == "ABQ" , "NodePath"] <- "University.SchoolofEngineering.ElectricalandComputerEngineering"
MyReportsDat[MyReportsDat$DEPARTMENT_DESC == "Electrical Computer Engr" && MyReportsDat$CAMPUS == "EA" , "NodePath"] <- "University.SchoolofEngineering.ElectricalandComputerEngineering"
MyReportsDat[MyReportsDat$DEPARTMENT_DESC == "Electrical Computer Engr" && MyReportsDat$CAMPUS == "ELA" , "NodePath"] <- "University.SchoolofEngineering.ElectricalandComputerEngineering"

MyReportsDat[MyReportsDat$DEPARTMENT_DESC == "SOE Mechanical Engineering" && MyReportsDat$CAMPUS == "ABQ" , "NodePath"] <- "University.SchoolofEngineering.MechanicalEngineering"
MyReportsDat[MyReportsDat$DEPARTMENT_DESC == "SOE Mechanical Engineering" && MyReportsDat$CAMPUS == "EA" , "NodePath"] <- "University.SchoolofEngineering.MechanicalEngineering"

MyReportsDat[MyReportsDat$DEPARTMENT_DESC == "Nuclear Engineering" && MyReportsDat$CAMPUS == "ABQ" , "NodePath"] <- "University.SchoolofEngineering.NuclearEngineering"
MyReportsDat[MyReportsDat$DEPARTMENT_DESC == "Nuclear Engineering" && MyReportsDat$CAMPUS == "EA" , "NodePath"] <- "University.SchoolofEngineering.NuclearEngineering"

MyReportsDat[MyReportsDat$DEPARTMENT_DESC == "NSMS Nano Science & Micro Syst" && MyReportsDat$CAMPUS == "ABQ" , "NodePath"] <- "University.SchoolofEngineering.NanoscienceandMicrosystems"
MyReportsDat[MyReportsDat$DEPARTMENT_DESC == "NSMS Nano Science & Micro Syst" && MyReportsDat$CAMPUS == "EA" , "NodePath"] <- "University.SchoolofEngineering.NanoscienceandMicrosystems"

MyReportsDat[MyReportsDat$DEPARTMENT_DESC == "Computer Science" && MyReportsDat$CAMPUS == "ABQ" , "NodePath"] <- "University.SchoolofEngineering.ComputerScience"
MyReportsDat[MyReportsDat$DEPARTMENT_DESC == "Computer Science" && MyReportsDat$CAMPUS == "EA" , "NodePath"] <- "University.SchoolofEngineering.ComputerScience"


  
  
  
  if (MyReportsDat$DEPARTMENT_DESC[n]=="Computer Science" & MyReportsDat$CAMPUS[n]=="ABQ") {
    MyReportsDat$NodePath[n] <- "University.SchoolofEngineering.ComputerScience"}
  if (MyReportsDat$DEPARTMENT_DESC[n]=="Computer Science" & MyReportsDat$CAMPUS[n]=="EA") {
    MyReportsDat$NodePath[n] <- "University.SchoolofEngineering.ComputerScience"}
  
  if (MyReportsDat$DEPARTMENT_DESC[n]=="Foreign Languages Literatures" & MyReportsDat$CAMPUS[n]=="ABQ") {
    MyReportsDat$NodePath[n] <- "University.CollegeofArts&Sciences.ForeignLanguagesandLiterature"}
  if (MyReportsDat$DEPARTMENT_DESC[n]=="Foreign Languages Literatures" & MyReportsDat$CAMPUS[n]=="EA") {
    MyReportsDat$NodePath[n] <- "University.CollegeofArts&Sciences.ForeignLanguagesandLiterature"}
  if (MyReportsDat$SUBJECT[n]=="RUSS" && MyReportsDat$DEPARTMENT_DESC[n]=="*Interdisciplinary: A.S." && MyReportsDat$CAMPUS[n]=="ABQ") {
    MyReportsDat$NodePath[n] <- "University.CollegeofArts&Sciences.Interdisciplinary.RUSS"}
  
  if (MyReportsDat$DEPARTMENT_DESC[n]=="AS CHMS Program" & MyReportsDat$CAMPUS[n]=="ABQ") {
    MyReportsDat$NodePath[n] <- "University.CollegeofArts&Sciences.ChicanaandChicanoStudies"}
  if (MyReportsDat$DEPARTMENT_DESC[n]=="AS CHMS Program" & MyReportsDat$CAMPUS[n]=="EA") {
    MyReportsDat$NodePath[n] <- "University.CollegeofArts&Sciences.ChicanaandChicanoStudies"}
  
  if (MyReportsDat$SUBJECT[n]=="PADM" & MyReportsDat$CAMPUS[n]=="ABQ") {
    MyReportsDat$NodePath[n] <- "University.CollegeofArts&Sciences.PublicAdministration"}
  if (MyReportsDat$SUBJECT[n]=="PADM" & MyReportsDat$CAMPUS[n]=="EA") {
    MyReportsDat$NodePath[n] <- "University.CollegeofArts&Sciences.PublicAdministration"}
  if (MyReportsDat$SUBJECT[n]=="PADM" & MyReportsDat$CAMPUS[n]=="ESF") {
    MyReportsDat$NodePath[n] <- "University.CollegeofArts&Sciences.PublicAdministration"}
  if (MyReportsDat$SUBJECT[n]=="PADM" && MyReportsDat$INSTRUCTION_DELIVERY_MODE[n]=="ITVPE" && MyReportsDat$CAMPUS[n]=="ABQ") {
    MyReportsDat$NodePath[n] <- "University.CollegeofArts&Sciences.PublicAdministration"}
  if (MyReportsDat$SUBJECT[n]=="PADM" && MyReportsDat$INSTRUCTION_DELIVERY_MODE[n]=="ITVE" && MyReportsDat$CAMPUS[n]=="ABQ") {
    MyReportsDat$NodePath[n] <- "University.CollegeofArts&Sciences.PublicAdministration"}
  
  if (MyReportsDat$SUBJECT[n]=="GEOG" & MyReportsDat$CAMPUS[n]=="ABQ") {
    MyReportsDat$NodePath[n] <- "University.CollegeofArts&Sciences.Geography"} 
  if (MyReportsDat$SUBJECT[n]=="GEOG" & MyReportsDat$CAMPUS[n]=="EA") {
    MyReportsDat$NodePath[n] <- "University.CollegeofArts&Sciences.Geography"} 
  
  if (MyReportsDat$DEPARTMENT_DESC[n]=="Spanish Portuguese" & MyReportsDat$CAMPUS[n]=="ABQ") {
    MyReportsDat$NodePath[n] <- "University.CollegeofArts&Sciences.SpanishPortuguese"}
  if (MyReportsDat$DEPARTMENT_DESC[n]=="Spanish Portuguese" & MyReportsDat$CAMPUS[n]=="EA") {
    MyReportsDat$NodePath[n] <- "University.CollegeofArts&Sciences.SpanishPortuguese"}
  
  if (MyReportsDat$DEPARTMENT_DESC[n]=="Lang Literacy Sociocultural LL" & MyReportsDat$CAMPUS[n]=="ABQ") {
    MyReportsDat$NodePath[n] <- "University.CollegeofEducation.LanguageLiteracyandSocioculturalStudies"}
  if (MyReportsDat$DEPARTMENT_DESC[n]=="Lang Literacy Sociocultural LL" & MyReportsDat$CAMPUS[n]=="EA") {
    MyReportsDat$NodePath[n] <- "University.CollegeofEducation.LanguageLiteracyandSocioculturalStudies"}
  
  if (MyReportsDat$DEPARTMENT_DESC[n]=="Teacher Education" & MyReportsDat$CAMPUS[n]=="ABQ") {
    MyReportsDat$NodePath[n] <- "University.CollegeofEducation.TeacherEducation"}
  if (MyReportsDat$DEPARTMENT_DESC[n]=="Teacher Education" & MyReportsDat$CAMPUS[n]=="EA") {
    MyReportsDat$NodePath[n] <- "University.CollegeofEducation.TeacherEducation"}
  
  if (MyReportsDat$SUBJECT[n]=="EDPY" & MyReportsDat$CAMPUS[n]=="ABQ") {
    MyReportsDat$NodePath[n] <- "University.CollegeofEducation.EducationalPsychology"}
  if (MyReportsDat$SUBJECT[n]=="EDPY" & MyReportsDat$CAMPUS[n]=="EA") {
    MyReportsDat$NodePath[n] <- "University.CollegeofEducation.EducationalPsychology"}
  
  if (MyReportsDat$SUBJECT[n]=="SPCD" & MyReportsDat$CAMPUS[n]=="ABQ") {
    MyReportsDat$NodePath[n] <- "University.CollegeofEducation.EducationalSpecialties"}
  if (MyReportsDat$SUBJECT[n]=="SPCD" & MyReportsDat$CAMPUS[n]=="EA") {
    MyReportsDat$NodePath[n] <- "University.CollegeofEducation.EducationalSpecialties"}
  
  if (MyReportsDat$SUBJECT[n]=="COUN" & MyReportsDat$CAMPUS[n]=="ABQ") {
    MyReportsDat$NodePath[n] <- "University.CollegeofEducation.IndividualFamilyandCommunityEducation"}
  if (MyReportsDat$SUBJECT[n]=="COUN" & MyReportsDat$CAMPUS[n]=="EA") {
    MyReportsDat$NodePath[n] <- "University.CollegeofEducation.IndividualFamilyandCommunityEducation"}
  
  if (MyReportsDat$SUBJECT[n]=="ECME" & MyReportsDat$CAMPUS[n]=="ABQ") {
    MyReportsDat$NodePath[n] <- "University.CollegeofEducation.IndividualFamilyandCommunityEducation"}
  if (MyReportsDat$SUBJECT[n]=="ECME" & MyReportsDat$CAMPUS[n]=="EA") {
    MyReportsDat$NodePath[n] <- "University.CollegeofEducation.IndividualFamilyandCommunityEducation"}
  
  if (MyReportsDat$SUBJECT[n]=="NUTR" & MyReportsDat$CAMPUS[n]=="ABQ") {
    MyReportsDat$NodePath[n] <- "University.CollegeofEducation.IndividualFamilyandCommunityEducation"}
  if (MyReportsDat$SUBJECT[n]=="NUTR" & MyReportsDat$CAMPUS[n]=="EA") {
    MyReportsDat$NodePath[n] <- "University.CollegeofEducation.IndividualFamilyandCommunityEducation"}
  
  if (MyReportsDat$SUBJECT[n]=="FS" & MyReportsDat$CAMPUS[n]=="ABQ") {
    MyReportsDat$NodePath[n] <- "University.CollegeofEducation.IndividualFamilyandCommunityEducation"}
  if (MyReportsDat$SUBJECT[n]=="FS" & MyReportsDat$CAMPUS[n]=="EA") {
    MyReportsDat$NodePath[n] <- "University.CollegeofEducation.IndividualFamilyandCommunityEducation"}
  
  if (MyReportsDat$SUBJECT[n]=="FCS" & MyReportsDat$CAMPUS[n]=="ABQ") {
    MyReportsDat$NodePath[n] <- "University.CollegeofEducation.IndividualFamilyandCommunityEducation"}
  if (MyReportsDat$SUBJECT[n]=="FCS" & MyReportsDat$CAMPUS[n]=="EA") {
    MyReportsDat$NodePath[n] <- "University.CollegeofEducation.IndividualFamilyandCommunityEducation"}
  
  if (MyReportsDat$SUBJECT[n]=="IFCE" & MyReportsDat$CAMPUS[n]=="ABQ") {
    MyReportsDat$NodePath[n] <- "University.CollegeofEducation.IndividualFamilyandCommunityEducation"}
  if (MyReportsDat$SUBJECT[n]=="IFCE" & MyReportsDat$CAMPUS[n]=="EA") {
    MyReportsDat$NodePath[n] <- "University.CollegeofEducation.IndividualFamilyandCommunityEducation"}
  
  if (MyReportsDat$DEPARTMENT_DESC[n]=="AS Linguistics" & MyReportsDat$CAMPUS[n]=="ABQ") {
    MyReportsDat$NodePath[n] <- "University.CollegeofArts&Sciences.Linguistics"}
  if (MyReportsDat$DEPARTMENT_DESC[n]=="AS Linguistics" & MyReportsDat$CAMPUS[n]=="EA") {
    MyReportsDat$NodePath[n] <- "University.CollegeofArts&Sciences.Linguistics"}
  
  if (MyReportsDat$DEPARTMENT_DESC[n]=="Chemistry" & MyReportsDat$CAMPUS[n]=="ABQ") {
    MyReportsDat$NodePath[n] <- "University.CollegeofArts&Sciences.ChemistryandChemicalBiology"}
  if (MyReportsDat$DEPARTMENT_DESC[n]=="Chemistry" & MyReportsDat$CAMPUS[n]=="EA") {
    MyReportsDat$NodePath[n] <- "University.CollegeofArts&Sciences.ChemistryandChemicalBiology"}
  
  if (MyReportsDat$DEPARTMENT_DESC[n]=="African American Studies" & MyReportsDat$CAMPUS[n]=="ABQ") {
    MyReportsDat$NodePath[n] <- "University.CollegeofArts&Sciences.AfricanaStudies"}
  if (MyReportsDat$DEPARTMENT_DESC[n]=="African American Studies" & MyReportsDat$CAMPUS[n]=="EA") {
    MyReportsDat$NodePath[n] <- "University.CollegeofArts&Sciences.AfricanaStudies"}
  
  if (MyReportsDat$DEPARTMENT_DESC[n]=="AS American Studies" & MyReportsDat$CAMPUS[n]=="ABQ") {
    MyReportsDat$NodePath[n] <- "University.CollegeofArts&Sciences.AmericanStudies"}
  if (MyReportsDat$DEPARTMENT_DESC[n]=="AS American Studies" & MyReportsDat$CAMPUS[n]=="EA") {
    MyReportsDat$NodePath[n] <- "University.CollegeofArts&Sciences.AmericanStudies"}
  
  if (MyReportsDat$SUBJECT[n]=="LAIS" & MyReportsDat$CAMPUS[n]=="ABQ") {
    MyReportsDat$NodePath[n] <- "University.HonorsCollege"} 
  if (MyReportsDat$SUBJECT[n]=="LAIS" & MyReportsDat$CAMPUS[n]=="EA") {
    MyReportsDat$NodePath[n] <- "University.HonorsCollege"} 
  
  if (MyReportsDat$SUBJECT[n]=="UNIV" & MyReportsDat$CAMPUS[n]=="ABQ") {
    MyReportsDat$NodePath[n] <- "University.UniversityCollege"} 
  if (MyReportsDat$SUBJECT[n]=="UNIV" & MyReportsDat$CAMPUS[n]=="EA") {
    MyReportsDat$NodePath[n] <- "University.UniversityCollege"} 
  
  if (MyReportsDat$SUBJECT[n]=="WR" & MyReportsDat$CAMPUS[n]=="ABQ") {
    MyReportsDat$NodePath[n] <- "University.UniversityCollege.WaterResources"} 
  if (MyReportsDat$SUBJECT[n]=="WR" & MyReportsDat$CAMPUS[n]=="EA") {
    MyReportsDat$NodePath[n] <- "University.UniversityCollege.WaterResources"} 
  
  if (MyReportsDat$SUBJECT[n]=="ACAD" & MyReportsDat$CAMPUS[n]=="ABQ") {
    MyReportsDat$NodePath[n] <- "University.UniversityCollege.UCAdvisementCenter"} 
  if (MyReportsDat$SUBJECT[n]=="ACAD" & MyReportsDat$CAMPUS[n]=="EA") {
    MyReportsDat$NodePath[n] <- "University.UniversityCollege.UCAdvisementCenter"} 
  
  if (MyReportsDat$SUBJECT[n]=="NATV" & MyReportsDat$CAMPUS[n]=="ABQ") {
    MyReportsDat$NodePath[n] <- "University.UniversityCollege.NativeAmericanStudies"} 
  if (MyReportsDat$SUBJECT[n]=="NATV" & MyReportsDat$CAMPUS[n]=="EA") {
    MyReportsDat$NodePath[n] <- "University.UniversityCollege.NativeAmericanStudies"} 

  if (MyReportsDat$SUBJECT[n]=="ASTR" & MyReportsDat$CAMPUS[n]=="ABQ") {
    MyReportsDat$NodePath[n] <- "University.CollegeofArts&Sciences.PhysicsandAstronomy"} 
  if (MyReportsDat$SUBJECT[n]=="ASTR" & MyReportsDat$CAMPUS[n]=="EA") {
    MyReportsDat$NodePath[n] <- "University.CollegeofArts&Sciences.PhysicsandAstronomy"} 
  
  if (MyReportsDat$SUBJECT[n]=="PHYC" & MyReportsDat$CAMPUS[n]=="ABQ") {
    MyReportsDat$NodePath[n] <- "University.CollegeofArts&Sciences.PhysicsandAstronomy"} 
  if (MyReportsDat$SUBJECT[n]=="PHYC" & MyReportsDat$CAMPUS[n]=="EA") {
    MyReportsDat$NodePath[n] <- "University.CollegeofArts&Sciences.PhysicsandAstronomy"} 
  
  if (MyReportsDat$SUBJECT[n]=="HED" & MyReportsDat$CAMPUS[n]=="ABQ") {
    MyReportsDat$NodePath[n] <- "University.CollegeofEducation.HealthEducation"}
  if (MyReportsDat$SUBJECT[n]=="HED" & MyReportsDat$CAMPUS[n]=="EA") {
    MyReportsDat$NodePath[n] <- "University.CollegeofEducation.HealthEducation"}
  
  if (MyReportsDat$SUBJECT[n]=="PEP" & MyReportsDat$CAMPUS[n]=="ABQ") {
    MyReportsDat$NodePath[n] <- "University.CollegeofEducation.PhysicalEdProfessional"}
  if (MyReportsDat$SUBJECT[n]=="PEP" & MyReportsDat$CAMPUS[n]=="EA") {
    MyReportsDat$NodePath[n] <- "University.CollegeofEducation.PhysicalEdProfessional"}
  
  if (MyReportsDat$SUBJECT[n]=="PENP" & MyReportsDat$CAMPUS[n]=="ABQ") {
    MyReportsDat$NodePath[n] <- "University.CollegeofEducation.PhysicalEdNon-Professional"}
  if (MyReportsDat$SUBJECT[n]=="PENP" & MyReportsDat$CAMPUS[n]=="EA") {
    MyReportsDat$NodePath[n] <- "University.CollegeofEducation.PhysicalEdNon-Professional"}
  
  if (MyReportsDat$SUBJECT[n]=="NURS" & MyReportsDat$CAMPUS[n]=="ABQ") {
    MyReportsDat$NodePath[n] <- "University.CollegeofNursing"}
  if (MyReportsDat$SUBJECT[n]=="NURS" & MyReportsDat$CAMPUS[n]=="EA") {
    MyReportsDat$NodePath[n] <- "University.CollegeofNursing"}
  
  # This is to assign a Hiearchy to 'College of Population Health' courses. If other "PH" subjects end up using EvalKIT, this code will have to be changed
  if (MyReportsDat$SUBJECT[n]=="PH" & MyReportsDat$CAMPUS[n]=="ABQ") {
    MyReportsDat$NodePath[n] <- "University.SchoolofMedicine.CollegeofPopulationHealth"}
  if (MyReportsDat$SUBJECT[n]=="PH" & MyReportsDat$CAMPUS[n]=="EA") {
    MyReportsDat$NodePath[n] <- "University.SchoolofMedicine.CollegeofPopulationHealth"}
  
  if (MyReportsDat$SUBJECT[n]=="RADS" & MyReportsDat$CAMPUS[n]=="ABQ") {
    MyReportsDat$NodePath[n] <- "University.SchoolofMedicine.Radiology"}
  if (MyReportsDat$SUBJECT[n]=="RADS" & MyReportsDat$CAMPUS[n]=="EA") {
    MyReportsDat$NodePath[n] <- "University.SchoolofMedicine.Radiology"}
  
  if (MyReportsDat$SUBJECT[n]=="NUCM" & MyReportsDat$CAMPUS[n]=="ABQ") {
    MyReportsDat$NodePath[n] <- "University.SchoolofMedicine.Radiology"}
  if (MyReportsDat$SUBJECT[n]=="NUCM" & MyReportsDat$CAMPUS[n]=="EA") {
    MyReportsDat$NodePath[n] <- "University.SchoolofMedicine.Radiology"}
  
  if (MyReportsDat$CAMPUS[n]=="GA") {
    MyReportsDat$NodePath[n] <- "University.BranchCampuses.Gallup"} 
  if (MyReportsDat$CAMPUS[n]=="EG") {
    MyReportsDat$NodePath[n] <- "University.BranchCampuses.Gallup"} 
  if (MyReportsDat$CAMPUS[n]=="LA") {
    MyReportsDat$NodePath[n] <- "University.BranchCampuses.LosAlamos"} 
  if (MyReportsDat$CAMPUS[n]=="TA") {
    MyReportsDat$NodePath[n] <- "University.BranchCampuses.Taos"} 
  if (MyReportsDat$CAMPUS[n]=="ET") {
    MyReportsDat$NodePath[n] <- "University.BranchCampuses.TaosBachelorsGraduate"} 
  if (MyReportsDat$CAMPUS[n]=="TAM") {
    MyReportsDat$NodePath[n] <- "University.BranchCampuses.TaosMora"} 
  if (MyReportsDat$CAMPUS[n]=="TAQ") {
    MyReportsDat$NodePath[n] <- "University.BranchCampuses.TaosQuesta"} 
  if (MyReportsDat$CAMPUS[n]=="VA") {
    MyReportsDat$NodePath[n] <- "University.BranchCampuses.Valencia"} 
  if (MyReportsDat$CAMPUS[n]=="EW") {
    MyReportsDat$NodePath[n] <- "University.BranchCampuses.UNMWest"} 
  if (MyReportsDat$CAMPUS[n]=="EF") {
    MyReportsDat$NodePath[n] <- "University.BranchCampuses.SanJuanBachelorsGraduate"} 
  n <- n+1
}  




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
Drops2Delete <- merge(AllDrops, CourseExportDat, by=c("Username", "CourseUniqueID"))
rm(AllDrops)
Drops2Delete$Unenroll <- "1"
Drops2Delete <- unique(Drops2Delete)

# Remove extraneous fields
Drops2Delete$EMAIL_ADDRESS <- NULL
Drops2Delete$REGISTRATION_STATUS_DESC <- NULL

# ---End of determining which drops to remove from EvalKIT

# Now, we know who to delete/remove for student drops, i.e. all those in the Drops2Delete table/file
# So, now we can figure out how to find newly enrolled students 
# Drops have already been removed from the MyReportsDat table, now let's remove them from CourseExportDat table
# But first, let's remove all course records, from the MyReports table, that do not match what's in the UserExport file
CRNsOnlyCourseExportDat <- CourseExportDat
CRNsOnlyCourseExportDat$UserTypeID <- NULL
CRNsOnlyCourseExportDat$FirstName <- NULL
CRNsOnlyCourseExportDat$LastName <- NULL
CRNsOnlyCourseExportDat$Email <- NULL
CRNsOnlyCourseExportDat$Username <- NULL
CRNsOnlyCourseExportDat$Unenroll <- NULL

#Just save the Unique CRNs (Courses) to be used to pull records from MyReportDat
CRNsOnlyCourseExportDat <- unique(CRNsOnlyCourseExportDat)

# Next, remove drops from the CourseExportDat table and crosslist what's left for difference table that reveals the newly enrolled students
MyReportsDat <- merge(MyReportsDat, CRNsOnlyCourseExportDat, by="CourseUniqueID")

#sapply(MyReportsDat, mode)
#sapply(CourseExportDat, mode)
# Make CourseUniqueID field numeric
MyReportsDat$CourseUniqueID <- as.numeric(MyReportsDat$CourseUniqueID)

#MyReports: CourseUniqueID  Username	EMAIL_ADDRESS	REGISTRATION_STATUS_DESC
MyReportsMyReportsDat <- MyReportsDat
MyReportsMyReportsDat$EMAIL_ADDRESS <- NULL
MyReportsMyReportsDat$REGISTRATION_STATUS_DESC <- NULL

# Remove these fields to compare apples with apples: row.names  UserTypeID	CourseUniqueID	FirstName	LastName	Email	Username	Unenroll
UserExportMyReportsDat <- CourseExportDat
UserExportMyReportsDat$row.names <- NULL
UserExportMyReportsDat$UserTypeID <- NULL
UserExportMyReportsDat$FirstName <- NULL
UserExportMyReportsDat$LastName <- NULL
UserExportMyReportsDat$Unenroll <- NULL
UserExportMyReportsDat$Email <- NULL
rownames(UserExportMyReportsDat) <- c()

# Now, the difference between UserExportMyReportsDat and MyReportsMyReportsDat should be the newly enrolled students that we want to upload

# Extract the newly enrolled students from MyReportsMyReportsDat
#NewEnrollmentsDat <- setdiff(MyReportsMyReportsDat, UserExportMyReportsDat)
#install.packages("sqldf")
#library(sqldf) 
#NewEnrollmentsDat <- sqldf(SELECT * FROM UserExportMyReportsDat EXCEPT SELECT * FROM MyReportsMyReportsDat) 
#NewEnrollmentsDat <- subset(MyReportsMyReportsDat, subset=!(UserExportMyReportsDat$CourseUniqueID!=MyReportsMyReportsDat$CourseUniqueID&&UserExportMyReportsDat$Username!=MyReportsMyReportsDat$Username))
#write.csv(MyReportsMyReportsDat, file = "MyReportsMyReportsDat.csv")
#write.csv(UserExportMyReportsDat, file = "UserExportMyReportsDat.csv")

NewEnrollmentsDat <- rbind(MyReportsMyReportsDat, UserExportMyReportsDat)
New2Add <- NewEnrollmentsDat[!(duplicated(NewEnrollmentsDat) | duplicated(NewEnrollmentsDat, fromLast = TRUE)), ]

# Remove records where Username is blank
New2Add <- subset(New2Add, (str_sub(New2Add$Username, 1,4)!=".") )

# Merge drops table with adds table and write file to upload to project
New2Add <- merge(New2Add, MyReportsDat, by=c("Username", "CourseUniqueID"))

# Add the following field/header name to the CourseExportDat file: Unenroll
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
rm(MyReportsMyReportsDat)
rm(NewEnrollmentsDat)
rm(CourseExportDat)
rm(UserExportMyReportsDat)
rm(CRNsOnlyCourseExportDat)

# User Export headers:     UserTypeID  CourseUniqueID	FirstName	LastName	Email	Username	Unenroll
# Drops to Delete headers: Username  CourseUniqueID	UserTypeID	FirstName	LastName	Email	Unenroll
# New 2 Add headers: Username UserTypeID CourseUniqueID	Email	Unenroll Missing: FirstName  LastName 
New2Add$UserTypeID <- "4"

# Reload the MyReportsDat file to grab and parse the matching student names
MyReportsDatAll <- read.csv("Class_List_GAH (19).csv", header = TRUE, stringsAsFactors=FALSE) 

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








