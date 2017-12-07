# ***For MyReports Data Fields only - Create the EvaluationKIT User & Course files for upload***
# Author: Aaron G. Baca, UNM/IT, 1/14/15

# Use RIO for import export of file types. See: https://cran.r-project.org/web/packages/rio/vignettes/rio.html for Import, Expoert and Convert examples
#install.packages("rio")
#library("rio")

######################### Merge Faculty Demographics for Lynda.unm.edu FY 16/17 ###################################
setwd("/Users/aaronbaca/Documents/Classroom Technologies/LyndaUsageReport")
usage <- read.csv("IndividualUsage_FY16-17.csv", header = TRUE, stringsAsFactors=FALSE)
demo <- read.csv("UniqueFacultyDemographics.csv", header = TRUE, stringsAsFactors=FALSE)
LyndaFacDemographics <- merge(usage, demo, by = "NetID")
write.csv(LyndaFacDemographics, file = "LyndaFacDemographics.csv")

######################### Merge Faculty Demographics for Lynda.unm.edu July 1st, 2017 thru Oct 24th, 2017 ###################################
setwd("/Users/aaronbaca/Documents/Classroom Technologies/LyndaUsageReport")
usage <- read.csv("IndividualUsage_1JUL2017-24OCT2017.csv", header = TRUE, stringsAsFactors=FALSE)
demo <- read.csv("UniqueFacultyDemographics.csv", header = TRUE, stringsAsFactors=FALSE)
LyndaFacDemographics <- merge(usage, demo, by = "NetID")
LyndaFacDemographics <- unique(LyndaFacDemographics)
write.csv(LyndaFacDemographics, file = "LyndaFacDemographics2017.csv")

######################### Merge Student Demographics for Lynda.unm.edu###################################
setwd("/Users/aaronbaca/Documents/Classroom Technologies/LyndaUsageReport")
### Merge four semester's worth of student NetIDs, then remove dups ###
semester1 <- read.csv("Class_List_GAH_StuDataSummer16-Reduced.csv", header = TRUE, stringsAsFactors=FALSE)
semester2 <- read.csv("Class_List_GAH_StuDataFall16-Reduced.csv", header = TRUE, stringsAsFactors=FALSE)
semester3 <- read.csv("Class_List_GAH_StuDataSpring17-Reduced.csv", header = TRUE, stringsAsFactors=FALSE)
semester4 <- read.csv("Class_List_GAH_StuDataSummer17-Reduced.csv", header = TRUE, stringsAsFactors=FALSE)
AllSemesters <- rbind(semester1, semester2, semester3, semester4)  
## Remove Academic Period Desc and PROGRAM_CLASSIFICATION ##
AllSemesters$Academic.Period.Desc <- NULL
AllSemesters$PROGRAM_CLASSIFICATION <- NULL
## Remove Dups ##
AllSemesters <- unique(AllSemesters)
write.csv(AllSemesters, file = "StudentsAll4Semesters.csv")
usage <- read.csv("IndividualUsage_FY16-17.csv", header = TRUE, stringsAsFactors=FALSE)
demo <- read.csv("StudentsAll4Semesters.csv", header = TRUE, stringsAsFactors=FALSE)
LyndaStuDemographics <- merge(usage, demo, by = "NetID")
write.csv(LyndaStuDemographics, file = "LyndaStuDemographics.csv")


######################### Merge Student Demographics for Lynda.unm.edu July 1st, 2017 thru Oct 24th, 2017 ###################################
setwd("/Users/aaronbaca/Documents/Classroom Technologies/LyndaUsageReport")
usage <- read.csv("IndividualUsage_1JUL2017-24OCT2017.csv", header = TRUE, stringsAsFactors=FALSE)
demo <- read.csv("StudentsAll4Semesters.csv", header = TRUE, stringsAsFactors=FALSE)
LyndaStuDemographics <- merge(usage, demo, by = "NetID")
write.csv(LyndaStuDemographics, file = "LyndaStuUsageDemographics2017.csv")


######################### Merge Student Demographics for SAPT Valencia Campus###################################
setwd("/Users/aaronbaca/Documents/EvaluationKIT/Spring 2017/SAPT/Valencia March")
NetIDs <- read.csv("NetIDs.csv", header = TRUE, stringsAsFactors=FALSE)
AllRecs <- read.csv("Class_List_GAH (9).csv", header = TRUE, stringsAsFactors=FALSE)
chK <- merge(NetIDs, AllRecs, by = "NetID")
write.csv(chK, file = "SAPTStudentsToEvaluateFrmValencia.csv")
# 1. write code to change all subject data to "SAPT"
# 2. create assign a new unique CRN key
# 3. run data through generic R code below...


#Compare data in files
#install.packages("compare")
#library(compare)
setwd("/Users/aaronbaca/Documents/Pilot 1/Fall 2015/Data Differences")
old19 <- read.csv("Class_List_GAH (19 Courses Only).csv", header = TRUE, stringsAsFactors=FALSE)
new21 <- read.csv("Class_List_GAH (21).csv", header = TRUE, stringsAsFactors=FALSE)
#compare (old19, new21, allowAll=TRUE)
diff2 <- new21[!(intersect(new21$COURSE_REFERENCE_NUMBER, old19$COURSE_REFERENCE_NUMBER)),]
write.csv(diff2, file = "NewCoursesAddedLatebyDepts.csv")

# Obtain CRNKey list of missing CRN course records then run this to grab missing courses:
#setwd("/Users/aaronbaca/Documents/Pilot 1/Fall 2015/Data Differences")
setwd("/Users/aaronbaca/Documents/Pilot 1/Fall 2015/New Courses in Banner 8-25-15")
NewCourses <- read.csv("Class_List_GAH (24).csv", header = TRUE, stringsAsFactors=FALSE)
MR_Key <- read.csv("CRNKey.csv", header = TRUE, stringsAsFactors=FALSE)
MC_Recs <- merge(NewCourses, MR_Key, by = "COURSE_REFERENCE_NUMBER")
write.csv(MC_Recs, file = "MissingCourses.csv")

setwd("/Users/aaronbaca/Documents/Pilot 1/Summer 2015/End 7-25/test ITVPE roll-up")
MyGraphDat <- read.csv("Class_List_GAH (14).csv", header = TRUE, stringsAsFactors=FALSE)
library(scatterplot3d)
with(MyGraphDat, {
  scatterplot3d(COURSE_SECTION_NUMBER, COURSE_REFERENCE_NUMBER, COURSE_NUMBER,        # x y and z axis
                color="blue", pch=19, # filled blue circles
                type="h",             # lines to the horizontal plane
                main="3-D Scatterplot Example 2",
                xlab="COURSE_SECTION_NUMBER",
                ylab="COURSE_REFERENCE_NUMBER",
                zlab="COURSE_NUMBER")
})

library(scatterplot3d)
with(MyGraphDat, {
  s3d <- scatterplot3d(COURSE_SECTION_NUMBER, COURSE_REFERENCE_NUMBER, COURSE_NUMBER,        # x y and z axis
                       color="blue", pch=19,        # filled blue circles
                       type="h",                    # vertical lines to the x-y plane
                       main="3-D Scatterplot Example 3",
                       xlab="COURSE_SECTION_NUMBER",
                       ylab="COURSE_REFERENCE_NUMBER",
                       zlab="COURSE_NUMBER")
  s3d.coords <- s3d$xyz.convert(COURSE_SECTION_NUMBER, COURSE_REFERENCE_NUMBER, COURSE_NUMBER) # convert 3D coords to 2D projection
  text(s3d.coords$x, s3d.coords$y,             # x and y coordinates
       labels=row.names(MyGraphDat),               # text to plot
       cex=.5, pos=4)           # shrink text 50% and place to right of points)
})

library(scatterplot3d)
# create column indicating point color
MyGraphDat$pcolor[MyGraphDat$COURSE_SECTION_NUMBER==1] <- "red"
MyGraphDat$pcolor[MyGraphDat$COURSE_SECTION_NUMBER==2] <- "blue"
MyGraphDat$pcolor[MyGraphDat$COURSE_SECTION_NUMBER==3] <- "darkgreen"
with(MyGraphDat, {
  s3d <- scatterplot3d(COURSE_SECTION_NUMBER, COURSE_REFERENCE_NUMBER, ACTUAL_ENROLLMENT,        # x y and z axis
                       color=pcolor, pch=19,        # circle color indicates no. of COURSE_SECTION_NUMBER
                       type="h", lty.hplot=2,       # lines to the horizontal plane
                       scale.y=.75,                 # scale y axis (reduce by 25%)
                       main="3-D Scatterplot Example 4",
                       xlab="COURSE_SECTION_NUMBER",
                       ylab="COURSE_REFERENCE_NUMBER",
                       zlab="ACTUAL_ENROLLMENT")
  s3d.coords <- s3d$xyz.convert(COURSE_SECTION_NUMBER, COURSE_REFERENCE_NUMBER, ACTUAL_ENROLLMENT)
  text(s3d.coords$x, s3d.coords$y,     # x and y coordinates
       labels=row.names(MyGraphDat),       # text to plot
       pos=4, cex=.5)                  # shrink text 50% and place to right of points)
  # add the legend
  legend("topleft", inset=.05,      # location and inset
         bty="n", cex=.5,              # suppress legend box, shrink text 50%
         title="Number of COURSE_SECTION_NUMBER",
         c("1", "2", "3"), fill=c("red", "blue", "darkgreen"))
})

# Merge DOJ survey students by Student ID
setwd("/Users/aaronbaca/Documents/Opinio/Elections/GPSA/Spring 2017")
NetIDKey <- read.csv("NetIDKey.csv", header = TRUE, stringsAsFactors=FALSE)
AllRecords <- read.csv("Class_List_GAH (2).csv", header = TRUE, stringsAsFactors=FALSE)
demographics <- merge(NetIDKey, AllRecords, by = "NetID")
demographics <- unique(demographics)
write.csv(demographics, file = "VoterDepts.csv")


# Merge Disparet Valencia Courses 9-2-15
setwd("/Users/aaronbaca/Documents/Pilot 1/Fall 2015/Valencia")
MissingCourses <- read.csv("LaurasUpdates.csv", header = TRUE, stringsAsFactors=FALSE)
AllRecords <- read.csv("AaronsOrigData.csv", header = TRUE, stringsAsFactors=FALSE)
chK <- merge(MissingCourses, AllRecords, by = "COURSE_REFERENCE_NUMBER")
write.csv(chK, file = "SeeIfNewDataIsCaptured.csv")


# Merge Missing Summer Courses
setwd("/Users/aaronbaca/Documents/Pilot 1/Summer 2015/Nursing")
MissingCourses <- read.csv("CRNKey_Missing.csv", header = TRUE, stringsAsFactors=FALSE)
AllRecords <- read.csv("Class_List_GAH (13).csv", header = TRUE, stringsAsFactors=FALSE)
chK <- merge(AllRecords, MissingCourses, by = "COURSE_REFERENCE_NUMBER")
write.csv(chK, file = "MissingNursingCoursesAllRecords.csv")

# Merge Student Demographics
setwd("C:\\Aaron\\CIO\\Student Technology Survey Spring 2015")
CourseCheck <- read.csv("Final Upload w Demographics.csv", header = TRUE, stringsAsFactors=FALSE)
InstructorCheck <- read.csv("Class_List_GAH (AllStudentsOneCourse).csv", header = TRUE, stringsAsFactors=FALSE)
chK <- merge(CourseCheck, InstructorCheck, by = "NetID")
write.csv(chK, file = "Student Merge demographics plus campus.csv")

# Load and Merge Data from EvalKIT for final course & instructor check
#setwd("C:\\Aaron\\IDEA\\IAWG\\EvaluationKit\\Pilot 1\\Spring 2015\\College of Arts and Sciences\\W C F Biology")
#setwd("/Users/aaronbaca/Documents/Pilot 1/Fall 2015/NURS - Aaron/End 12-19 Course data")
setwd("/Users/aaronbaca/Documents/Pilot 1/Fall 2015/Spanish Portuguese - Andrea")
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

# Carol Bernhard's request 10/5/17
setwd("/Users/aaronbaca/Documents/EvaluationKIT/Fall 2017/ReportRequestByCarolBernhard")
ResponseRates <- read.csv("ResponseRates7116-63017.csv", header = TRUE, stringsAsFactors=FALSE)
CRNKeyFile <- read.csv("CRNKey.csv", header = TRUE, stringsAsFactors=FALSE)
AllResponseRates <- merge(ResponseRates, CRNKeyFile, by = "COURSE_REFERENCE_NUMBER")
write.csv(AllResponseRates, file = "ResponseRatesOnlineCoursesJuly1-2016-June30-2017.csv")

# Load and Merge Data from EvalKIT for final course & instructor check
#setwd("C:\\Aaron\\IDEA\\IAWG\\EvaluationKit\\Pilot 1\\Spring 2015\\W C F ASM")
#setwd("/Users/aaronbaca/Documents/Pilot 1/Summer 2015/Nursing/7-25")
#setwd("/Users/aaronbaca/Documents/Pilot 1/Fall 2015/UNIV")
#setwd("/Users/aaronbaca/Documents/EvaluationKIT/Spring 2016/Courses that end in March/Nursing Courses end 3-2/clinical faculty student assignments")
#setwd("/Users/aaronbaca/Documents/EvaluationKIT/Spring 2016/Public Administration")
setwd("/Users/aaronbaca/Documents/EvaluationKIT/Spring 2016/Biology Andrea")
CourseCheck <- read.csv("CourseExport.csv", header = TRUE, stringsAsFactors=FALSE)
InstructorCheck <- read.csv("UserExport.csv", header = TRUE, stringsAsFactors=FALSE)
chK <- merge(CourseCheck, InstructorCheck, by = "CourseUniqueID")
write.csv(chK, file = "BiologySpring2016_1H_CourseEvals.csv")

# Merge student data for capstone by email field
#setwd("/Users/aaronbaca/Documents/Pilot 1/Summer 2015/Nursing/Missing Capstone 8-24/24332")
setwd("/Users/aaronbaca/Documents/Pilot 1/Fall 2015/NURS - Aaron/Late Assignments")
CourseCheck <- read.csv("Upload_Student_User_Data.csv", header = TRUE, stringsAsFactors=FALSE)
InstructorCheck <- read.csv("EV-Kit 201580 402L021 Faculty-Student Assignments.csv", header = TRUE, stringsAsFactors=FALSE)
chK <- merge(CourseCheck, InstructorCheck, by = "EMAIL")
write.csv(chK, file = "NewParsedOutStudentsByInstructorCapStone.csv")

# Purpose: to prep EvalKIT upload data extracted from the Extended Learning ClassList query in MyReports
# Please install the R stringr app, if you have not done so already > install.packages("stringr")
# Please install the R xlsReadWrite package if you have not done so already > install.packages("WriteXLS")

#Note: this program creates an Upload_Course_Data.csv file which creates courses in EvalKIT
#Note: this program creates a Upload_Student_User_Data.csv/Upload_Faculty_User_Data.csv files which creates Users, both Student and Faculty, in EvalKIT
#------------------------------------------------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------------------------------------------------

#View more lines in the Console
#options(max.print=20000)

# Call the stringr library
#install.packages("stringr")
library(stringr)
#install.packages("stringi")
library(stringi)

# Call the xls conversion libraries
#install.packages("WriteXLS")
library(WriteXLS)

# Please set the R working directory to where your MyReports data and R programs are located
# Replace "/Users/aaronbaca/Documents/EvaluationKIT/...." path below with the path to your files
# Important: only leave one 'set working directory command uncommented! 

#setwd("/Users/aaronbaca/Documents/EvaluationKIT/Spring 2017/RedoCBEinFall2017")
#setwd("/Users/aaronbaca/Documents/EvaluationKIT/Fall 2017/Ethan")
#setwd("/Users/aaronbaca/Documents/EvaluationKIT/Fall 2017/James/N1H_CRN_SEND")
#setwd("/Users/aaronbaca/Documents/EvaluationKIT/Fall 2017/Ethan/9-28-17Request")
#setwd("/Users/aaronbaca/Documents/EvaluationKIT/Fall 2017/TEST APMS for Donna")
#setwd("/Users/aaronbaca/Documents/EvaluationKIT/Fall 2017/Connor/Request10-5")
#setwd("/Users/aaronbaca/Documents/EvaluationKIT/Fall 2017/Amrita/10-10 Request 1")
#setwd("/Users/aaronbaca/Documents/EvaluationKIT/Fall 2017/Connor/AMST")
#setwd("/Users/aaronbaca/Documents/EvaluationKIT/Fall 2017/Connor/Gallup")
#setwd("/Users/aaronbaca/Documents/EvaluationKIT/Fall 2017/Connor/Taos")
#setwd("/Users/aaronbaca/Documents/EvaluationKIT/Fall 2017/Amrita/11-6 Request")
#setwd("/Users/aaronbaca/Documents/EvaluationKIT/Fall 2017/Ethan/11-7Request")
#setwd("/Users/aaronbaca/Documents/EvaluationKIT/Fall 2017/Amrita/11-7Request2")
#setwd("/Users/aaronbaca/Documents/EvaluationKIT/Fall 2017/Connor/11-7Request")
#setwd("/Users/aaronbaca/Documents/EvaluationKIT/Fall 2017/Test Mods In Rollup Code")
#setwd("/Users/aaronbaca/Documents/EvaluationKIT/Fall 2017/Amrita/StudentUpdates/CJ")
#setwd("/Users/aaronbaca/Documents/EvaluationKIT/Fall 2017/Amrita/StudentUpdates/CS")
#setwd("/Users/aaronbaca/Documents/EvaluationKIT/Fall 2017/Amrita/StudentUpdates/DEHY")
#setwd("/Users/aaronbaca/Documents/EvaluationKIT/Fall 2017/Amrita/StudentUpdates/EDPY")
#setwd("/Users/aaronbaca/Documents/EvaluationKIT/Fall 2017/Amrita/StudentUpdates/EMS")
#setwd("/Users/aaronbaca/Documents/EvaluationKIT/Fall 2017/Amrita/StudentUpdates/LAIS")
#setwd("/Users/aaronbaca/Documents/EvaluationKIT/Fall 2017/Amrita/StudentUpdates/ME")
#setwd("/Users/aaronbaca/Documents/EvaluationKIT/Fall 2017/Amrita/11-17Request")
#setwd("/Users/aaronbaca/Documents/EvaluationKIT/Fall 2017/Amrita/StudentUpdates/MSST")
#setwd("/Users/aaronbaca/Documents/EvaluationKIT/Fall 2017/Amrita/StudentUpdates/NATV")
#setwd("/Users/aaronbaca/Documents/EvaluationKIT/Fall 2017/Amrita/StudentUpdates/OILS")
#setwd("/Users/aaronbaca/Documents/EvaluationKIT/Fall 2017/Amrita/StudentUpdates/RADS")
#setwd("/Users/aaronbaca/Documents/EvaluationKIT/Fall 2017/Amrita/StudentUpdates/RELG")
setwd("/Users/aaronbaca/Documents/EvaluationKIT/Fall 2017/ProblemsNURS")


# Read in the MyReports data, i.e. the Class_List_GAH.csv (1H Classes All.csv) file
# Note: you must use the following fields from the MyReports EL classList query: 
# - Course Information Window -
#    ACADEMIC_PERIOD_CODE, SUBJECT,  COURSE_NUMBER, SECTION_NUMBER,  COURSE_REFERENCE_NUMBER, COURSE_TITLE, SUB_ACADEMIC_PERIOD,
#    PRIMARY_INSTRUCTOR_EMAIL,	PRIMARY_INSTRUCTOR_FIRST_NAME, PRIMARY_INSTRUCTOR_LAST_NAME, PRIMARY_INSTRUCTOR_NETID,
#    COURSE_DEPARTMENT_CODE,	INST_DELIVERY_MODE_CODE, INST_DELIVERY_MODE_DESC, CIP_CODE, COURSE_COLLEGE_CODE, 
#    COURSE_COLLEGE_DESC,	CAMPUS_CODE, CAMPUS_DESC, 
# - Scheduling Information Window -
#    START_DATE, END_DATE, ACTUAL_ENROLLMENT, MEETING_DAYS, MEETING_TIME, SCHEDULE_TYPE_DESC, 
# - Personal Information Window -
#    STUDENT_NAME, CONFIDENTIALITY_IND, BANNER_ID,	STUDENT_NETID, EMAIL_ADDRESS, REGISTRATION_STATUS_DESC

# Below replace the "Class_List_GAH (All Classes No Students)" file name with whatever Student Apps provides for classes in the MyReports query
MyReportsDat <- read.csv("Class_List_GAH (12).csv", header = TRUE, stringsAsFactors=FALSE)

# CRN file using column A containing only the CRNs that are participating in the use of EvalKIT
CRNKey <- read.csv("CRNKey.csv", header = TRUE, stringsAsFactors=FALSE)

# Count CRNKey rows to compare at the end of prog. as warning if any are missing
crnrows <- nrow(CRNKey)

# Merge the Depts. requested with the MyReports queried data, *comment out next line if no CRNKey is used
tmp <- merge(MyReportsDat, CRNKey, by = "COURSE_REFERENCE_NUMBER")

# Remove Faculty records that do not have NetIDs and flag them by writing them to a file
CoursesWithNoFacultyNetID <- subset(tmp, tmp$PRIMARY_INSTRUCTOR_NETID == ".")
# tmp <- subset(tmp, tmp$PRIMARY_INSTRUCTOR_NETID != ".")  # Don't pull courses with missing faculty NetIDs from the tmp dataset
if(nrow(CoursesWithNoFacultyNetID) != 0) {write.csv(CoursesWithNoFacultyNetID, file = "CoursesWithNoFacultyNetID.csv") }

# Remove student records that do not have NetIDs and flag them by writing them to a file
CoursesWithNoStudentNetID <- subset(tmp, tmp$NETID == ".")
#tmp <- subset(tmp, tmp$NETID != ".") # Don't pull courses with missing student NetIDs from the tmp dataset
if(nrow(CoursesWithNoStudentNetID) != 0) {write.csv(CoursesWithNoStudentNetID, file = "CoursesWithNoStudentNetID.csv") }


####### Remove 1H courses for end of semester processing SUB_ACADEMIC_PERIOD
#tmp <- subset(tmp, (str_sub(tmp$SUB_ACADEMIC_PERIOD)!="1H") )

# Note: Provost said to survey all course types!
# Subset out non-participating campuses, colleges, departments and faculty below, for MAIN campus only
# No Evaluations for these types of classes
#tmp <- subset(tmp, (str_sub(tmp$TITLE_SHORT_DESC)!="Dissertation"))
#tmp <- subset(tmp, (str_sub(tmp$TITLE_SHORT_DESC)!="Master's Thesis"))
#tmp <- subset(tmp, (str_sub(tmp$TITLE_SHORT_DESC)!="Masters Thesis"))
#tmp <- subset(tmp, (str_sub(tmp$TITLE_SHORT_DESC)!="Master s Thesis"))
#tmp <- subset(tmp, (str_sub(tmp$TITLE_SHORT_DESC)!="Master's Project"))
#tmp <- subset(tmp, (str_sub(tmp$TITLE_SHORT_DESC)!="Problems"))
#tmp <- subset(tmp, (str_sub(tmp$TITLE_SHORT_DESC)!="Undergraduate Problems"))

# Remove non-participating departments out of tmp
tmp <- subset(tmp, (str_sub(tmp$COLLEGE_DESC)!="College of Pharmacy"))
tmp <- subset(tmp, (str_sub(tmp$COLLEGE_DESC)!="School of Law"))
tmp <- subset(tmp, (str_sub(tmp$SUBJECT)!="ISEP"))
tmp <- subset(tmp, (str_sub(tmp$SUBJECT)!="NSE"))
tmp <- subset(tmp, (str_sub(tmp$SUBJECT)!="AFAS"))
#tmp <- subset(tmp, (str_sub(tmp$SUBJECT)!="MDVL"))
tmp <- subset(tmp, (str_sub(tmp$SUBJECT)!="MLSL"))
tmp <- subset(tmp, (str_sub(tmp$SUBJECT)!="BIOM"))
tmp <- subset(tmp, (str_sub(tmp$SUBJECT)!="PAST"))
tmp <- subset(tmp, (str_sub(tmp$SUBJECT)!="PT"))
tmp <- subset(tmp, (str_sub(tmp$SUBJECT)!="OCTH"))
tmp <- subset(tmp, (str_sub(tmp$SUBJECT)!="NUCM"))
tmp <- subset(tmp, (str_sub(tmp$SUBJECT)!="MEDL"))

#Remove all main campus PHIL records where CAMPUS_DESC = Albuquerque/Main and add only ONL PHIL courses & Branch PHIL courses back into the main tmp data set
allPHILRecs <- subset(tmp, tmp$SUBJECT == "PHIL") # Copy All PHIL recs from main tmp to 'allPHILRecs'
tmp <- subset(tmp, tmp$SUBJECT != "PHIL") # Remove all PHIL recs from main 'tmp' 
saveBranchPHILRecs <- subset(allPHILRecs, allPHILRecs$CAMPUS_DESC != "Albuquerque/Main") # Save all Branch Campus Phil recs to 'saveBranchPHILRecs'
saveABQPHILRecs <- subset(allPHILRecs, allPHILRecs$CAMPUS_DESC == "Albuquerque/Main") # Save all ABQ Main Campus PHIL recs
saveABQPHILonlineRecs <- subset(saveABQPHILRecs, saveABQPHILRecs$INSTRUCTION_DELIVERY_MODE == "ONL") # Pull & save ABQ Onlin Main Campus PHIL recs to survey 
tmp = rbind(tmp, saveBranchPHILRecs, saveABQPHILonlineRecs)
rm(allPHILRecs)
rm(saveBranchPHILRecs)
rm(saveABQPHILonlineRecs)
rm(saveABQPHILRecs)

#Remove all School of Medicine records except for Dental Hygiene, EMS and BIOC 
#allSchoolofMedRecs <- subset(tmp, tmp$COLLEGE_DESC == "School of Medicine")
#tmp <- subset(tmp, tmp$COLLEGE_DESC != "School of Medicine")
#saveDEHYRecs <- subset(allSchoolofMedRecs, allSchoolofMedRecs$SUBJECT == "DEHY")
#saveEMSRecs <- subset(allSchoolofMedRecs, allSchoolofMedRecs$SUBJECT == "EMS")
#saveBIOCRecs <- subset(allSchoolofMedRecs, allSchoolofMedRecs$SUBJECT == "BIOC")
#savePHRecs <- subset(allSchoolofMedRecs, allSchoolofMedRecs$SUBJECT == "PH")
#saveRADSRecs <- subset(allSchoolofMedRecs, allSchoolofMedRecs$SUBJECT == "RADS")
#tmp = rbind(tmp, saveDEHYRecs, saveEMSRecs, saveBIOCRecs, savePHRecs, saveRADSRecs)
#rm(saveEMSRecs)
#rm(saveDEHYRecs)
#rm(allSchoolofMedRecs)

#Remove only Campus ABQ History Recs, leave all others
#allHistoryRecs <- subset(tmp, tmp$SUBJECT == "HIST")
#tmp <- subset(tmp, tmp$SUBJECT != "HIST")
#RemoveABQHistoryRecs <- subset(allHistoryRecs, allHistoryRecs$CAMPUS != "ABQ")
#tmp = rbind(tmp, RemoveABQHistoryRecs)
#rm(allHistoryRecs)
#rm(RemoveABQHistoryRecs)

#tmp <- subset(tmp, tmp$SUBJECT != "HIST" & (tmp$CAMPUS != "ABQ" | tmp$CAMPUS != "EA"))
#tmp <- tmp[(tmp$SUBJECT != "HIST") & (tmp$CAMPUS != "ABQ"), ]
#my.data.frame <- data[(data$V1 > 2) & (data$V2 < 4), ]
#my.data.frame <- data[(data$V1 > 2) | (data$V2 < 4), ]

#Remove dual enrollment courses for Valencia
#allVA <- subset(tmp, tmp$CAMPUS == "VA") # Remove Valencia campus data into its own subset
#tmp <- subset(tmp, tmp$CAMPUS != "VA") # Delete all existing Valenica records from the main tmp data set
#rmdualenroll <- subset(allVA, allVA$COURSE_SECTION_NUMBER != "550")
#rmdualenroll <- subset(rmdualenroll, rmdualenroll$COURSE_SECTION_NUMBER != "551")
#rmdualenroll <- subset(rmdualenroll, rmdualenroll$COURSE_SECTION_NUMBER != "552")
#rmdualenroll <- subset(rmdualenroll, rmdualenroll$COURSE_SECTION_NUMBER != "553")
#rmdualenroll <- subset(rmdualenroll, rmdualenroll$COURSE_SECTION_NUMBER != "554")
#rmdualenroll <- subset(rmdualenroll, rmdualenroll$COURSE_SECTION_NUMBER != "555")
#rmdualenroll <- subset(rmdualenroll, rmdualenroll$COURSE_SECTION_NUMBER != "556")
#rmdualenroll <- subset(rmdualenroll, rmdualenroll$COURSE_SECTION_NUMBER != "557")
#rmdualenroll <- subset(rmdualenroll, rmdualenroll$COURSE_SECTION_NUMBER != "558")
#rmdualenroll <- subset(rmdualenroll, rmdualenroll$COURSE_SECTION_NUMBER != "559")
#tmp = rbind(tmp, rmdualenroll) # Throw the non-dual enrollment courses back into the main tmp data set
#rm(rmdualenroll)
#rm(allVA)

#Remove Dissertation, Advanced Research, and Problems courses for Anthropology Main Campus ***Needs to be tested on ANTH data!!!
#allANTH <- subset(tmp, tmp$CAMPUS == "ABQ" && tmp$SUBJECT == "ANTH")
#tmp <- subset(tmp, tmp$CAMPUS != "ABQ" && tmp$SUBJECT != "ANTH")
#rmdualenroll <- subset(allANTH, allANTH$COURSE_SECTION_NUMBER != "399")
#rmdualenroll <- subset(rmdualenroll, rmdualenroll$COURSE_SECTION_NUMBER != "497")
#rmdualenroll <- subset(rmdualenroll, rmdualenroll$COURSE_SECTION_NUMBER != "499")
#rmdualenroll <- subset(rmdualenroll, rmdualenroll$COURSE_SECTION_NUMBER != "597")
#rmdualenroll <- subset(rmdualenroll, rmdualenroll$COURSE_SECTION_NUMBER != "598")
#rmdualenroll <- subset(rmdualenroll, rmdualenroll$COURSE_SECTION_NUMBER != "599")
#rmdualenroll <- subset(rmdualenroll, rmdualenroll$COURSE_SECTION_NUMBER != "697")
#rmdualenroll <- subset(rmdualenroll, rmdualenroll$COURSE_SECTION_NUMBER != "698")
#rmdualenroll <- subset(rmdualenroll, rmdualenroll$COURSE_SECTION_NUMBER != "699")
#tmp = rbind(tmp, rmdualenroll)


# Re-Set number of rows variable for the Data.Frame
numrows <- nrow(tmp) 
# Set number of columns variable for the Data.Frame to use in algorithms below
numcols <- ncol(tmp)

# Add leading zeros to the COURSE_SECTION_NUMBER field to form complete three digit length, as MyReports strips leading zeros
#MyReportsDat$COURSE_SECTION_NUMBER <- invisible(stri_pad_left(str=MyReportsDat$COURSE_SECTION_NUMBER, 2, pad="0"))
#MyReportsDat$COURSE_SECTION_NUMBER <- invisible(stri_pad_left(str=MyReportsDat$COURSE_SECTION_NUMBER, 3, pad="0"))
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
#tmp$COURSEUNIQUEID <- do.call(paste, c(tmp[c("COURSE_REFERENCE_NUMBER",  "ACADEMIC_PERIOD")], sep = ""))


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

#### Roll-up all records by Instructor by Course by Title, where INSTRUCTION_DELIVERY_MODE == 'ITVPE' and == 'ONL' Irespective of Campus!
# Note: all child ITV Course Reference Numbers must be included in the CRNKey file!
# and where course number, title, and instructor NetID are the same, then assign Parent ITVPE CRN to all child records including matching ONL courses

# 1st remove ITVPE and ONL course data into its own data subset
allITVPE <- subset(tmp, tmp$INSTRUCTION_DELIVERY_MODE == "ITVPE") # make a copy of all ITVPE course records
tmp <- subset(tmp, tmp$INSTRUCTION_DELIVERY_MODE != "ITVPE") # Remove all ITVPE courses from master tmp dataset
allONL <- subset(tmp, tmp$INSTRUCTION_DELIVERY_MODE == "ONL") # make a copy of ONL course records
tmp <- subset(tmp, tmp$INSTRUCTION_DELIVERY_MODE != "ONL") # Remove all ONL course records from the master tmp dataset
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
# clear out variables
holdinstructor <- NULL
holdCRN <- NULL
holdcampuscode <- NULL
holdcampusdesc <- NULL
holdcoursenumber <- NULL  
holdtitle <- NULL
holdAP <- NULL

#### ROLL-UP All Music 'APMS' COURSES by INSTRUCTOR

# Remove APMS course data into its own data subset Note: APMS courses exist on Main Campus only
allAPMS <- subset(tmp, tmp$SUBJECT == "APMS") 
tmp <- subset(tmp, tmp$SUBJECT != "APMS") 

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
  #holdtitle <- allAPMS$TITLE_SHORT_DESC[n]
  yesflag <- "no"
  o <- 1 
  while(o <= numrowsAPMS) {                            # roll-up all courses by instructor, by course, by title, and by campus
    if (allAPMS$COURSE_REFERENCE_NUMBER[o] != holdCRN) {
      if (allAPMS$PRIMARY_INSTRUCTOR_NETID[o] == holdnetid) {
        allAPMS$COURSE_SECTION_NUMBER[o] <- " ALL APMS Classes Combined" 
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




#---------------------------------------------------------------------------------------------------------
#holdCRN <- NULL
#l <- 1
#o <- 1
#n <- 1
#while(l <= numUniqueCRNRows) {
#  n <- 1  
#while(n <= numrowsAPMS) {
#  if (allAPMS$COURSE_REFERENCE_NUMBER[n]==CRNKey$COURSE_REFERENCE_NUMBER[l]) {              #find each APMS course
#    holdinstructor <- allAPMS$PRIMARY_INSTRUCTOR_NETID[n]
#    holdCRN <- allAPMS$COURSE_REFERENCE_NUMBER[n]
#    holdcoursenumber <- allAPMS$COURSE_NUMBER[n]  
#    holdsection <- allAPMS$COURSE_SECTION_NUMBER[n]
#    o <- 1 
#    while(o <= numrowsAPMS) {                            #if same professor, subject and campus, assign all same CRN as first detected
#      if (allAPMS$PRIMARY_INSTRUCTOR_NETID[o] == holdinstructor && allAPMS$COURSE_REFERENCE_NUMBER[o] != allAPMS$COURSE_REFERENCE_NUMBER[n]) {
#        # save parent and child records and then extract from main 'allAPMS' data set to avoid conflict with combining code below...
#        allAPMS$COURSE_REFERENCE_NUMBER[o] <- holdCRN
#        allAPMS$COURSE_SECTION_NUMBER[o] <- "ALL Sections"
#        allAPMS$COURSE_SECTION_NUMBER[n] <- "ALL Sections"
#        #allAPMS$COURSE_NUMBER[o] <- holdcoursenumber
#        #allAPMS$COURSE_NUMBER[n] <- holdcoursenumber
#        allAPMS$COURSE_NUMBER[o] <- ""
#        allAPMS$COURSE_NUMBER[n] <- ""
#      }
#      o <- o+1
#    }
#    
#  }              
#  n <- n+1
#}  
#l <- l+1 # Count and stop while loop when number of unique CRNs is passed
#}
#---------------------------------------------------------------------------------------------------------

allAPMS <- unique(allAPMS)

# Write the combined APMS User data to file to view test data was combined correctly and this file/code can be deleted later
write.csv(allAPMS, file = "SaveallAPMSRecs.csv")

holdinstructor <- NULL
holdCRN <- NULL
holdcoursenumber <- NULL  
holdsection <- NULL


#### ROLL-UP NON-ITV/Online and NON-APMS COURSES FOR SAME INSTRUCTOR/SAME COURSE NUMBER/level and same CAMPUS  Respective of Campus!!
# Hide/Sort/Index the data 
#invisible(tmp[with(tmp, order(PRIMARY_INSTRUCTOR_NETID, COURSE_NUMBER, COURSE_SECTION_NUMBER, INSTRUCTION_DELIVERY_MODE_DESC)), ])

# Modify, or comment out, these two subset statements if you want to change the limits on F2F courses that get rolled-up 
#lowenroll <- subset(tmp, (as.numeric(tmp$ACTUAL_ENROLLMENT)) <= 5) # Grab all low enrollment records
#tmp <- subset(tmp, (as.numeric(tmp$ACTUAL_ENROLLMENT)) >= 6) # Remove all low enrollment records from the tmp dataset

########## The following code/while loops below have been commented out in lieu of using the Cross-Listed Functionality in EvaluationKIT #############

# Set number of rows variable for the Data.Frame and sub-while loops
#numrows <- nrow(tmp) 

#holdCRN <- NULL
#o <- 1
#n <- 1
#while(n <= numrows) { 
#  # Set the number, in the statement below, to control the size of courses that you want rolled-up for all non-ITVPE, non-ONL and non-APMS courses
#  if (as.numeric(tmp$ACTUAL_ENROLLMENT[n]) <= 50) {
#      holdnetid <- tmp$PRIMARY_INSTRUCTOR_NETID[n]
#      holdCRN <- tmp$COURSE_REFERENCE_NUMBER[n]
#      holdcampuscode <- tmp$CAMPUS[n]
#      holdcampusdesc <- tmp$CAMPUS_DESC[n]
#      holdcoursenumber <- tmp$COURSE_NUMBER[n]  
#      holdtitle <- tmp$TITLE_SHORT_DESC[n]
#      holdsubject <- tmp$SUBJECT[n]
#      yesflag <- "no"
#      o <- 1 
#       while(o <= numrows) {                            # roll-up all courses by instructor, by course, by title, and by campus
#        if (tmp$COURSE_REFERENCE_NUMBER[o] != holdCRN) {
#          if (tmp$PRIMARY_INSTRUCTOR_NETID[o] == holdnetid && tmp$COURSE_NUMBER[o] == holdcoursenumber && tmp$TITLE_SHORT_DESC[o] == holdtitle && tmp$CAMPUS[o] == holdcampuscode) {
#            if (tmp$SUBJECT[o] == holdsubject) { 
#            tmp$COURSE_SECTION_NUMBER[o] <- "-ALL Sections" 
#            tmp$COURSE_REFERENCE_NUMBER[o] <- holdCRN
#            tmp$CAMPUS[o] <- holdcampuscode
#            tmp$CAMPUS_DESC[o] <- holdcampusdesc
#            yesflag <- "yes"}
#          }
#        }
#        o <- o+1
#      }    
#      # The following if and ifelse statements make sure that the original/parent records are assigned with 'All Sections' 
#      if (yesflag=="yes") {tmp$COURSE_SECTION_NUMBER <- ifelse(tmp$COURSE_REFERENCE_NUMBER == holdCRN,"-All Sections",tmp$COURSE_SECTION_NUMBER)}
#  }
#      n <- n+1
#}  
#
#write.csv(tmp, file = "tmpRecsB4MergeAll.csv")

# Add extracted combined courses all back into the main 'tmp' dataset
tmp = rbind(allITVPEONL, allAPMS, tmp) # combine ITVPE and ONL courses into one dataset

# Remove any duplicate recoreds
tmp <- unique(tmp)

# Write the combined APMS User data to file to view test data was combined correctly and this file/code can be deleted later
write.csv(tmp, file = "SaveALLRecs.csv")

# Create the COURSEUNIQUEID field for both User files and the Course files and 
tmp$COURSEUNIQUEID <- do.call(paste, c(tmp[c("COURSE_REFERENCE_NUMBER",  "ACADEMIC_PERIOD")], sep = ""))

# Create stu file so that I can remove all unnecessary fields before writing Upload_Student_User_Data.csv to disk
stu <- tmp

#### For Students records that have less < 3 students for the same course with the same professor, make all the CRNs 
# the same for all the sections. I.E. roll-up Non-ITV courses that contain less than 3 students with same prof. and course #



# Write the Student detailed User data to file
write.csv(tmp, file = "Detailed_Student_User_Data.csv")



# Remove all fields not required by EvalKIT before writing Student upload file
#stu$COURSE_REFERENCE_NUMBER <- NULL
stu$TITLE_LONG_DESC <-NULL
stu$ACADEMIC_PERIOD <- NULL
stu$Academic.Period.Desc <- NULL
stu$SUB_ACADEMIC_PERIOD <- NULL
stu$SUB_ACADEMIC_PERIOD_DESC <- NULL
#stu$CAMPUS <- NULL
#stu$CAMPUS_DESC <- NULL
stu$COLLEGE <- NULL
stu$COLLEGE_DESC <- NULL
stu$DEPARTMENT <- NULL
stu$DEPARTMENT_DESC <- NULL
stu$SUBJECT <- NULL
stu$COURSE_NUMBER <- NULL
stu$COURSE_SECTION_NUMBER <- NULL
stu$TITLE_SHORT_DESC <- NULL
stu$TITLE_SHORT_DESC <- NULL
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
  if (CN == "TITLE_SHORT_DESC") {
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
fac$TITLE_LONG_DESC <-NULL
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
fac$TITLE_SHORT_DESC <- NULL
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
  
  if (tmp$SUBJECT[n]=="ANTH" & tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.Anthropology"} 
  if (tmp$SUBJECT[n]=="ANTH" & tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.Anthropology"} 
  
  if (tmp$SUBJECT[n]=="RELG" & tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.ReligiousStudies"} 
  if (tmp$SUBJECT[n]=="RELG" & tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.ReligiousStudies"} 
  
#  if (tmp$SUBJECT[n]=="SUST" & tmp$CAMPUS[n]=="ABQ") {
#    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.SustainabilityStudies"} 
#  if (tmp$SUBJECT[n]=="SUST" & tmp$CAMPUS[n]=="EA") {
#    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.SustainabilityStudies"} 
  
  if (tmp$SUBJECT[n]=="SHS" & tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.SpeechandHearingSciences"} 
  if (tmp$SUBJECT[n]=="SHS" & tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.SpeechandHearingSciences"} 
  
  if (tmp$DEPARTMENT_DESC[n]=="Biology" & tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.Biology"} 
  if (tmp$DEPARTMENT_DESC[n]=="Biology" & tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.Biology"} 
  
  if (tmp$SUBJECT[n]=="HMHV" && tmp$DEPARTMENT_DESC[n]=="*Interdisciplinary: A.S." && tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.Interdisciplinary.HMHV"} 
  if (tmp$SUBJECT[n]=="HMHV" && tmp$DEPARTMENT_DESC[n]=="*Interdisciplinary: A.S." && tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.Interdisciplinary.HMHV"} 
  
  if (tmp$SUBJECT[n]=="LTAM" && tmp$DEPARTMENT_DESC[n]=="*Interdisciplinary: A.S." && tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.Interdisciplinary.LTAM"} 
  if (tmp$SUBJECT[n]=="LTAM" && tmp$DEPARTMENT_DESC[n]=="*Interdisciplinary: A.S." && tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.Interdisciplinary.LTAM"}
  
  if (tmp$SUBJECT[n]=="ASCP" && tmp$DEPARTMENT_DESC[n]=="*Interdisciplinary: A.S." && tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.Interdisciplinary.ASCP"} 
  if (tmp$SUBJECT[n]=="ASCP" && tmp$DEPARTMENT_DESC[n]=="*Interdisciplinary: A.S." && tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.Interdisciplinary.ASCP"} 
  
  if (tmp$SUBJECT[n]=="ARSC" && tmp$DEPARTMENT_DESC[n]=="*Interdisciplinary: A.S." && tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.Interdisciplinary.ARSC"} 
  if (tmp$SUBJECT[n]=="ARSC" && tmp$DEPARTMENT_DESC[n]=="*Interdisciplinary: A.S." && tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.Interdisciplinary.ARSC"} 
  
  if (tmp$SUBJECT[n]=="MSST" && tmp$DEPARTMENT_DESC[n]=="*Interdisciplinary: A.S." && tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.Interdisciplinary.MSST"} 
  if (tmp$SUBJECT[n]=="MSST" && tmp$DEPARTMENT_DESC[n]=="*Interdisciplinary: A.S." && tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.Interdisciplinary.MSST"}
  
  if (tmp$SUBJECT[n]=="BIOC" & tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.SchoolofMedicine.BiochemistryandMolecularBiology"} 
  if (tmp$SUBJECT[n]=="BIOC" & tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.SchoolofMedicine.BiochemistryandMolecularBiology"} 
  
  if (tmp$SUBJECT[n]=="SUST" && tmp$DEPARTMENT_DESC[n]=="*Interdisciplinary: A.S." && tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.Interdisciplinary.SUST"} 
  if (tmp$SUBJECT[n]=="SUST" && tmp$DEPARTMENT_DESC[n]=="*Interdisciplinary: A.S." && tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.Interdisciplinary.SUST"}
  
  if (tmp$SUBJECT[n]=="FA" && tmp$DEPARTMENT_DESC[n]=="*Interdisciplinary: Fine Arts" && tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.CollegeofFineArts.Interdisciplinary.FA"} 
  if (tmp$SUBJECT[n]=="FA" && tmp$DEPARTMENT_DESC[n]=="*Interdisciplinary: Fine Arts" && tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.CollegeofFineArts.Interdisciplinary.FA"} 

if (tmp$SUBJECT[n]=="MDVL" && tmp$DEPARTMENT_DESC[n]=="*Interdisciplinary: A.S." && tmp$CAMPUS[n]=="ABQ") {
  tmp$NodePath[n] <- "University.CollegeofFineArts.Interdisciplinary.MDVL"} 
if (tmp$SUBJECT[n]=="MDV" && tmp$DEPARTMENT_DESC[n]=="*Interdisciplinary: A.S." && tmp$CAMPUS[n]=="EA") {
  tmp$NodePath[n] <- "University.CollegeofFineArts.Interdisciplinary.MDVL"} 
  
# Preserved code, as older courses/reports still exist in this Hierarchy
# Do not delete Hierarchy in EvalKIT unless you first make Hierarchy re-assignments to old courses
#  if (tmp$SUBJECT[n]=="IFDM" && tmp$DEPARTMENT_DESC[n]=="*Interdisciplinary: Fine Arts" && tmp$CAMPUS[n]=="ABQ") {  
#    tmp$NodePath[n] <- "University.CollegeofFineArts.Interdisciplinary.IFDM"} 
#  if (tmp$SUBJECT[n]=="IFDM" && tmp$DEPARTMENT_DESC[n]=="*Interdisciplinary: Fine Arts" && tmp$CAMPUS[n]=="EA") {   
#    tmp$NodePath[n] <- "University.CollegeofFineArts.Interdisciplinary.IFDM"}

  if (tmp$SUBJECT[n]=="IFDM" && tmp$DEPARTMENT_DESC[n]=="*Interdisciplinary: Fine Arts" && tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.CollegeofFineArts.CinematicArts.IFDM"} 
  if (tmp$SUBJECT[n]=="IFDM" && tmp$DEPARTMENT_DESC[n]=="*Interdisciplinary: Fine Arts" && tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.CollegeofFineArts.CinematicArts.IFDM"}

  if (tmp$SUBJECT[n]=="FA" && tmp$DEPARTMENT_DESC[n]=="*Interdisciplinary: Fine Arts" && tmp$CAMPUS[n]=="ABQ" && str_detect(tmp$TITLE_LONG_DESC[n], "Management")) {
    tmp$NodePath[n] <- "University.CollegeofFineArts.CinematicArts.ArtsManagement"} 
  if (tmp$SUBJECT[n]=="FA" && tmp$DEPARTMENT_DESC[n]=="*Interdisciplinary: Fine Arts" && tmp$CAMPUS[n]=="EA" && str_detect(tmp$TITLE_LONG_DESC[n], "Management")) {
    tmp$NodePath[n] <- "University.CollegeofFineArts.CinematicArts.ArtsManagement"}
    
# Special Hierarchy assignments for Cinematic Arts FA 284 Experiencing the Arts & FA 365 Soc Media Arts Marketing
  if (tmp$SUBJECT[n]=="FA" && tmp$DEPARTMENT_DESC[n]=="*Interdisciplinary: Fine Arts" && tmp$CAMPUS[n]=="ABQ" && tmp$COURSE_NUMBER[n]== "284") {
    tmp$NodePath[n] <- "University.CollegeofFineArts.CinematicArts.ArtsManagement"} 
  if (tmp$SUBJECT[n]=="FA" && tmp$DEPARTMENT_DESC[n]=="*Interdisciplinary: Fine Arts" && tmp$CAMPUS[n]=="EA" && tmp$COURSE_NUMBER[n]== "284") {
    tmp$NodePath[n] <- "University.CollegeofFineArts.CinematicArts.ArtsManagement"}
  if (tmp$SUBJECT[n]=="FA" && tmp$DEPARTMENT_DESC[n]=="*Interdisciplinary: Fine Arts" && tmp$CAMPUS[n]=="ABQ" && tmp$COURSE_NUMBER[n]== "365") {
    tmp$NodePath[n] <- "University.CollegeofFineArts.CinematicArts.ArtsManagement"} 
  if (tmp$SUBJECT[n]=="FA" && tmp$DEPARTMENT_DESC[n]=="*Interdisciplinary: Fine Arts" && tmp$CAMPUS[n]=="EA" && tmp$COURSE_NUMBER[n]== "365") {
    tmp$NodePath[n] <- "University.CollegeofFineArts.CinematicArts.ArtsManagement"}


  if (tmp$SUBJECT[n]=="BME" && tmp$DEPARTMENT_DESC[n]=="*Interdisciplinary:Engineering" && tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.SchoolofEngineering.Interdisciplinary.BME"} 
  if (tmp$SUBJECT[n]=="BME" && tmp$DEPARTMENT_DESC[n]=="*Interdisciplinary:Engineering" && tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.SchoolofEngineering.Interdisciplinary.BME"} 
  
  if (tmp$SUBJECT[n]=="ECOP" && tmp$DEPARTMENT_DESC[n]=="*Interdisciplinary:Engineering" && tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.SchoolofEngineering.Interdisciplinary.ECOP"} 
  if (tmp$SUBJECT[n]=="ECOP" && tmp$DEPARTMENT_DESC[n]=="*Interdisciplinary:Engineering" && tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.SchoolofEngineering.Interdisciplinary.ECOP"}

if (tmp$SUBJECT[n]=="ENG" && tmp$DEPARTMENT_DESC[n]=="*Interdisciplinary:Engineering" && tmp$CAMPUS[n]=="ABQ") {
  tmp$NodePath[n] <- "University.SchoolofEngineering.Interdisciplinary.ENG"} 
if (tmp$SUBJECT[n]=="ENG" && tmp$DEPARTMENT_DESC[n]=="*Interdisciplinary:Engineering" && tmp$CAMPUS[n]=="EA") {
  tmp$NodePath[n] <- "University.SchoolofEngineering.Interdisciplinary.ENG"}

if (tmp$SUBJECT[n]=="PCST" && tmp$DEPARTMENT_DESC[n]=="*Interdisciplinary: A.S." && tmp$CAMPUS[n]=="ABQ") {
  tmp$NodePath[n] <- "University.CollegeofArts&Sciences.Interdisciplinary.PCST"} 
if (tmp$SUBJECT[n]=="PCST" && tmp$DEPARTMENT_DESC[n]=="*Interdisciplinary: A.S." && tmp$CAMPUS[n]=="EA") {
  tmp$NodePath[n] <- "University.CollegeofArts&Sciences.Interdisciplinary.PCST"} 

if (tmp$SUBJECT[n]=="INTS" && tmp$DEPARTMENT_DESC[n]=="*Interdisciplinary: A.S." && tmp$CAMPUS[n]=="ABQ") {
  tmp$NodePath[n] <- "University.CollegeofArts&Sciences.Interdisciplinary.INTS"} 
if (tmp$SUBJECT[n]=="INTS" && tmp$DEPARTMENT_DESC[n]=="*Interdisciplinary: A.S." && tmp$CAMPUS[n]=="EA") {
  tmp$NodePath[n] <- "University.CollegeofArts&Sciences.Interdisciplinary.INTS"} 
  
  if (tmp$SUBJECT[n]=="POLS" & tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.PoliticalScience"} 
  if (tmp$SUBJECT[n]=="POLS" & tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.PoliticalScience"} 

if (tmp$SUBJECT[n]=="NVSC" & tmp$CAMPUS[n]=="ABQ") {
  tmp$NodePath[n] <- "University.NavalScience"} 
if (tmp$SUBJECT[n]=="NVSC" & tmp$CAMPUS[n]=="EA") {
  tmp$NodePath[n] <- "University.NavalScience"} 
  
  if (tmp$SUBJECT[n]=="OILS" & tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.CollegeofUniversityLibraries&LearningSciences.Organization,InformationandLearningSciences"} 
  if (tmp$SUBJECT[n]=="OILS" & tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.CollegeofUniversityLibraries&LearningSciences.Organization,InformationandLearningSciences"} 
  
  if (tmp$SUBJECT[n]=="UHON" & tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.HonorsCollege"} 
  if (tmp$SUBJECT[n]=="UHON" & tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.HonorsCollege"} 
  
  if (tmp$DEPARTMENT_DESC[n]=="School Architecture Planning" && tmp$SUBJECT[n]=="ARCH" && tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.SchoolofArchitectureandPlanning.Architecture"} 
  if (tmp$DEPARTMENT_DESC[n]=="School Architecture Planning" && tmp$SUBJECT[n]=="ARCH" && tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.SchoolofArchitectureandPlanning.Architecture"} 
  
  if (tmp$DEPARTMENT_DESC[n]=="School Architecture Planning" && tmp$SUBJECT[n]=="CRP" && tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.SchoolofArchitectureandPlanning.CommunityandRegionalPlanning"} 
  if (tmp$DEPARTMENT_DESC[n]=="School Architecture Planning" && tmp$SUBJECT[n]=="CRP" && tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.SchoolofArchitectureandPlanning.CommunityandRegionalPlanning"} 
  
  if (tmp$DEPARTMENT_DESC[n]=="School Architecture Planning" && tmp$SUBJECT[n]=="LA" && tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.SchoolofArchitectureandPlanning.LandscapeArchitecture"} 
  if (tmp$DEPARTMENT_DESC[n]=="School Architecture Planning" && tmp$SUBJECT[n]=="LA" && tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.SchoolofArchitectureandPlanning.LandscapeArchitecture"} 

if (tmp$DEPARTMENT_DESC[n]=="Earth & Planetary Sciences" && tmp$SUBJECT[n]=="ENVS" && tmp$CAMPUS[n]=="ABQ") {
  tmp$NodePath[n] <- "University.CollegeofArts&Sciences.EarthandPlanetarySciences"}
if (tmp$DEPARTMENT_DESC[n]=="Earth & Planetary Sciences" && tmp$SUBJECT[n]=="ENVS" && tmp$CAMPUS[n]=="EA") {
  tmp$NodePath[n] <- "University.CollegeofArts&Sciences.EarthandPlanetarySciences"}
  
  if (tmp$SUBJECT[n]=="EPS" & tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.EarthandPlanetarySciences"}
  if (tmp$SUBJECT[n]=="EPS" & tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.EarthandPlanetarySciences"}

if (tmp$SUBJECT[n]=="NTSC" & tmp$CAMPUS[n]=="ABQ") {
  tmp$NodePath[n] <- "University.CollegeofArts&Sciences.EarthandPlanetarySciences"}
if (tmp$SUBJECT[n]=="NTSC" & tmp$CAMPUS[n]=="EA") {
  tmp$NodePath[n] <- "University.CollegeofArts&Sciences.EarthandPlanetarySciences"}

if (tmp$SUBJECT[n]=="WMST" & tmp$CAMPUS[n]=="ABQ") {
  tmp$NodePath[n] <- "University.CollegeofArts&Sciences.WomenStudies"}
if (tmp$SUBJECT[n]=="WMST" & tmp$CAMPUS[n]=="EA") {
  tmp$NodePath[n] <- "University.CollegeofArts&Sciences.WomenStudies"}
  
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

if (tmp$SUBJECT[n]=="PUBP" & tmp$CAMPUS[n]=="ABQ") {
  tmp$NodePath[n] <- "University.CollegeofArts&Sciences.Interdisciplinary.PUBP"}
if (tmp$SUBJECT[n]=="PUBP" & tmp$CAMPUS[n]=="EA") {
  tmp$NodePath[n] <- "University.CollegeofArts&Sciences.Interdisciplinary.PUBP"}
  
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
  
  if (tmp$SUBJECT[n]=="DANC" & tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.CollegeofFineArts.TheatreandDance"}
  if (tmp$SUBJECT[n]=="DANC" & tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.CollegeofFineArts.TheatreandDance"}
  
  if (tmp$SUBJECT[n]=="THEA" & tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.CollegeofFineArts.TheatreandDance"}
  if (tmp$SUBJECT[n]=="THEA" & tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.CollegeofFineArts.TheatreandDance"}
  
  if (tmp$DEPARTMENT_DESC[n]=="Art Art History" & tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.CollegeofFineArts.ArtandArtHistory"}
  if (tmp$DEPARTMENT_DESC[n]=="Art Art History" & tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.CollegeofFineArts.ArtandArtHistory"}

# Preserved code, as older courses/reports still exist in this Hierarchy
# Do not delete Hierarchy in EvalKIT unless you first make Hierarchy re-assignments to old courses
#if (tmp$DEPARTMENT_DESC[n]=="Media Arts" & tmp$CAMPUS[n]=="ABQ") {   
#  tmp$NodePath[n] <- "University.CollegeofFineArts.MediaArts"}       
#if (tmp$DEPARTMENT_DESC[n]=="Media Art" & tmp$CAMPUS[n]=="EA") {
#  tmp$NodePath[n] <- "University.CollegeofFineArts.MediaArts"}

  if (tmp$DEPARTMENT_DESC[n]=="Media Arts" & tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.CollegeofFineArts.CinematicArts.MediaArts"}
  if (tmp$DEPARTMENT_DESC[n]=="Media Art" & tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.CollegeofFineArts.CinematicArts.MediaArts"}
  
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
    tmp$NodePath[n] <- "UniversityofNewMexico-AndersonSchoolofManagement"}
  if (tmp$SUBJECT[n]=="MGMT" & tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "UniversityofNewMexico-AndersonSchoolofManagement"}

if (tmp$SUBJECT[n]=="MGMT" & tmp$CAMPUS[n]=="EW") {
  tmp$NodePath[n] <- "UniversityofNewMexico-AndersonSchoolofManagement.UNMWest"}
  
  if (tmp$SUBJECT[n]=="DEHY" & tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.SchoolofMedicine.DentalHygiene"}
  if (tmp$SUBJECT[n]=="DEHY" & tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.SchoolofMedicine.DentalHygiene"}
  
  if (tmp$SUBJECT[n]=="EMS" & tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.SchoolofMedicine.EmergencyMedicine"}
  if (tmp$SUBJECT[n]=="EMS" & tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.SchoolofMedicine.EmergencyMedicine"}
  
# Remove History courses that department says are not to be evaluated
#  if (tmp$DEPARTMENT_DESC[n]=="History" && tmp$SUBJECT[n]=="HIST" && tmp$CAMPUS[n]=="ABQ") {
#    tmp <- subset(tmp, (str_sub(tmp$COURSE_NUMBER)!="699") )
#    tmp <- subset(tmp, (str_sub(tmp$COURSE_NUMBER)!="697") )
#    tmp <- subset(tmp, (str_sub(tmp$COURSE_NUMBER)!="599") )
#    tmp <- subset(tmp, (str_sub(tmp$COURSE_NUMBER)!="496") )
#    tmp <- subset(tmp, (str_sub(tmp$COURSE_NUMBER)!="493") )
#    tmp <- subset(tmp, (str_sub(tmp$COURSE_NUMBER)!="494") )  
#  }

# Remove History courses that department says are not to be evaluated, if they exist
tmp <- tmp[!(tmp$DEPARTMENT_DESC=="History" & tmp$SUBJECT=="HIST" & tmp$CAMPUS=="ABQ" & str_sub(tmp$COURSE_NUMBER)=="699") , ]
tmp <- tmp[!(tmp$DEPARTMENT_DESC=="History" & tmp$SUBJECT=="HIST" & tmp$CAMPUS=="ABQ" & str_sub(tmp$COURSE_NUMBER)=="697") , ]
tmp <- tmp[!(tmp$DEPARTMENT_DESC=="History" & tmp$SUBJECT=="HIST" & tmp$CAMPUS=="ABQ" & str_sub(tmp$COURSE_NUMBER)=="599") , ]
tmp <- tmp[!(tmp$DEPARTMENT_DESC=="History" & tmp$SUBJECT=="HIST" & tmp$CAMPUS=="ABQ" & str_sub(tmp$COURSE_NUMBER)=="496") , ]
tmp <- tmp[!(tmp$DEPARTMENT_DESC=="History" & tmp$SUBJECT=="HIST" & tmp$CAMPUS=="ABQ" & str_sub(tmp$COURSE_NUMBER)=="493") , ]
tmp <- tmp[!(tmp$DEPARTMENT_DESC=="History" & tmp$SUBJECT=="HIST" & tmp$CAMPUS=="ABQ" & str_sub(tmp$COURSE_NUMBER)=="494") , ]

  
  if (tmp$DEPARTMENT_DESC[n]=="History" && tmp$SUBJECT[n]=="HIST" && tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.History"}
  if (tmp$DEPARTMENT_DESC[n]=="History" && tmp$SUBJECT[n]=="HIST" && tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.History"}
  
  if (tmp$DEPARTMENT_DESC[n]=="Chem & Biological Engineering" && tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.SchoolofEngineering.ChemicalandBiologicalEngineering"}
  if (tmp$DEPARTMENT_DESC[n]=="Chem & Biological Engineering" && tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.SchoolofEngineering.ChemicalandBiologicalEngineering"}
  
  if (tmp$DEPARTMENT_DESC[n]=="Civil Engineering Civil Engr" & tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.SchoolofEngineering.CivilEngineering"}
  if (tmp$DEPARTMENT_DESC[n]=="Civil Engineering Civil Engr" & tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.SchoolofEngineering.CivilEngineering"}
  
  if (tmp$DEPARTMENT_DESC[n]=="Electrical Computer Engr" & tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.SchoolofEngineering.ElectricalandComputerEngineering"}
  if (tmp$DEPARTMENT_DESC[n]=="Electrical Computer Engr" & tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.SchoolofEngineering.ElectricalandComputerEngineering"}
if (tmp$DEPARTMENT_DESC[n]=="Electrical Computer Engr" & tmp$CAMPUS[n]=="ELA") {
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
  
#  if (tmp$SUBJEC[n]=="BME" & tmp$CAMPUS[n]=="ABQ") {
#    tmp$NodePath[n] <- "University.SchoolofEngineering.BiomedicalEngineering"}
#  if (tmp$SUBJEC[n]=="BME" & tmp$CAMPUS[n]=="EA") {
#    tmp$NodePath[n] <- "University.SchoolofEngineering.BiomedicalEngineering"}
  
#  if (tmp$SUBJEC[n]=="ENG" & tmp$CAMPUS[n]=="ABQ") {
#    tmp$NodePath[n] <- "University.SchoolofEngineering.Engineering"}
#  if (tmp$SUBJEC[n]=="ENG" & tmp$CAMPUS[n]=="EA") {
#    tmp$NodePath[n] <- "University.SchoolofEngineering.Engineering"}
  
  if (tmp$DEPARTMENT_DESC[n]=="Computer Science" & tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.SchoolofEngineering.ComputerScience"}
  if (tmp$DEPARTMENT_DESC[n]=="Computer Science" & tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.SchoolofEngineering.ComputerScience"}
  
  if (tmp$DEPARTMENT_DESC[n]=="Foreign Languages Literatures" & tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.ForeignLanguagesandLiterature"}
  if (tmp$DEPARTMENT_DESC[n]=="Foreign Languages Literatures" & tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.ForeignLanguagesandLiterature"}
  if (tmp$SUBJECT[n]=="RUSS" && tmp$DEPARTMENT_DESC[n]=="*Interdisciplinary: A.S." && tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.Interdisciplinary.RUSS"}
  
  if (tmp$DEPARTMENT_DESC[n]=="AS CHMS Program" & tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.ChicanaandChicanoStudies"}
  if (tmp$DEPARTMENT_DESC[n]=="AS CHMS Program" & tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.ChicanaandChicanoStudies"}
  
  if (tmp$SUBJECT[n]=="PADM" & tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.PublicAdministration"}
  if (tmp$SUBJECT[n]=="PADM" & tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.PublicAdministration"}
  if (tmp$SUBJECT[n]=="PADM" & tmp$CAMPUS[n]=="ESF") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.PublicAdministration"}
  if (tmp$SUBJECT[n]=="PADM" && tmp$INSTRUCTION_DELIVERY_MODE[n]=="ITVPE" && tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.PublicAdministration"}
  if (tmp$SUBJECT[n]=="PADM" && tmp$INSTRUCTION_DELIVERY_MODE[n]=="ITVE" && tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.PublicAdministration"}
  
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
    tmp$NodePath[n] <- "University.CollegeofEducation.TeacherEducation"}
  if (tmp$DEPARTMENT_DESC[n]=="Teacher Education" & tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.CollegeofEducation.TeacherEducation"}
  
  if (tmp$SUBJECT[n]=="EDPY" & tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.CollegeofEducation.EducationalPsychology"}
  if (tmp$SUBJECT[n]=="EDPY" & tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.CollegeofEducation.EducationalPsychology"}
  
  if (tmp$SUBJECT[n]=="SPCD" & tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.CollegeofEducation.EducationalSpecialties"}
  if (tmp$SUBJECT[n]=="SPCD" & tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.CollegeofEducation.EducationalSpecialties"}
  
  if (tmp$SUBJECT[n]=="COUN" & tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.CollegeofEducation.IndividualFamilyandCommunityEducation"}
  if (tmp$SUBJECT[n]=="COUN" & tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.CollegeofEducation.IndividualFamilyandCommunityEducation"}

if (tmp$SUBJECT[n]=="ECME" & tmp$CAMPUS[n]=="ABQ") {
  tmp$NodePath[n] <- "University.CollegeofEducation.IndividualFamilyandCommunityEducation"}
if (tmp$SUBJECT[n]=="ECME" & tmp$CAMPUS[n]=="EA") {
  tmp$NodePath[n] <- "University.CollegeofEducation.IndividualFamilyandCommunityEducation"}

if (tmp$SUBJECT[n]=="NUTR" & tmp$CAMPUS[n]=="ABQ") {
  tmp$NodePath[n] <- "University.CollegeofEducation.IndividualFamilyandCommunityEducation"}
if (tmp$SUBJECT[n]=="NUTR" & tmp$CAMPUS[n]=="EA") {
  tmp$NodePath[n] <- "University.CollegeofEducation.IndividualFamilyandCommunityEducation"}
  
  if (tmp$SUBJECT[n]=="FS" & tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.CollegeofEducation.IndividualFamilyandCommunityEducation"}
  if (tmp$SUBJECT[n]=="FS" & tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.CollegeofEducation.IndividualFamilyandCommunityEducation"}

if (tmp$SUBJECT[n]=="FCS" & tmp$CAMPUS[n]=="ABQ") {
  tmp$NodePath[n] <- "University.CollegeofEducation.IndividualFamilyandCommunityEducation"}
if (tmp$SUBJECT[n]=="FCS" & tmp$CAMPUS[n]=="EA") {
  tmp$NodePath[n] <- "University.CollegeofEducation.IndividualFamilyandCommunityEducation"}

if (tmp$SUBJECT[n]=="IFCE" & tmp$CAMPUS[n]=="ABQ") {
  tmp$NodePath[n] <- "University.CollegeofEducation.IndividualFamilyandCommunityEducation"}
if (tmp$SUBJECT[n]=="IFCE" & tmp$CAMPUS[n]=="EA") {
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

#if (tmp$SUBJECT[n]=="ISEP" & tmp$CAMPUS[n]=="ABQ") {
#  tmp$NodePath[n] <- "University.UniversityCollege.InternationalProgramsStudies"} 
#if (tmp$SUBJECT[n]=="ISEP" & tmp$CAMPUS[n]=="EA") {
#  tmp$NodePath[n] <- "University.UniversityCollege.InternationalProgramsStudies"} 

if (tmp$SUBJECT[n]=="WR" & tmp$CAMPUS[n]=="ABQ") {
  tmp$NodePath[n] <- "University.UniversityCollege.WaterResources"} 
if (tmp$SUBJECT[n]=="WR" & tmp$CAMPUS[n]=="EA") {
  tmp$NodePath[n] <- "University.UniversityCollege.WaterResources"} 

if (tmp$SUBJECT[n]=="ACAD" & tmp$CAMPUS[n]=="ABQ") {
  tmp$NodePath[n] <- "University.UniversityCollege.UCAdvisementCenter"} 
if (tmp$SUBJECT[n]=="ACAD" & tmp$CAMPUS[n]=="EA") {
  tmp$NodePath[n] <- "University.UniversityCollege.UCAdvisementCenter"} 
  
  if (tmp$SUBJECT[n]=="NATV" & tmp$CAMPUS[n]=="ABQ") {
    tmp$NodePath[n] <- "University.UniversityCollege.NativeAmericanStudies"} 
  if (tmp$SUBJECT[n]=="NATV" & tmp$CAMPUS[n]=="EA") {
    tmp$NodePath[n] <- "University.UniversityCollege.NativeAmericanStudies"} 
  
#  if (tmp$SUBJECT[n]=="INTS" & tmp$CAMPUS[n]=="ABQ") {
#    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.InternationalStudies"} 
#  if (tmp$SUBJECT[n]=="INTS" & tmp$CAMPUS[n]=="EA") {
#    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.InternationalStudies"} 
  
#  if (tmp$SUBJECT[n]=="MSST" & tmp$CAMPUS[n]=="ABQ") {
#    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.MuseumStudies"} 
#  if (tmp$SUBJECT[n]=="MSST" & tmp$CAMPUS[n]=="EA") {
#    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.MuseumStudies"} 
  
#  if (tmp$SUBJECT[n]=="PCST" & tmp$CAMPUS[n]=="ABQ") {
#    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.PeaceStudies"} 
#  if (tmp$SUBJECT[n]=="PCST" & tmp$CAMPUS[n]=="EA") {
#    tmp$NodePath[n] <- "University.CollegeofArts&Sciences.PeaceStudies"} 

if (tmp$SUBJECT[n]=="ASTR" & tmp$CAMPUS[n]=="ABQ") {
  tmp$NodePath[n] <- "University.CollegeofArts&Sciences.PhysicsandAstronomy"} 
if (tmp$SUBJECT[n]=="ASTR" & tmp$CAMPUS[n]=="EA") {
  tmp$NodePath[n] <- "University.CollegeofArts&Sciences.PhysicsandAstronomy"} 

if (tmp$SUBJECT[n]=="PHYC" & tmp$CAMPUS[n]=="ABQ") {
  tmp$NodePath[n] <- "University.CollegeofArts&Sciences.PhysicsandAstronomy"} 
if (tmp$SUBJECT[n]=="PHYC" & tmp$CAMPUS[n]=="EA") {
  tmp$NodePath[n] <- "University.CollegeofArts&Sciences.PhysicsandAstronomy"} 
  
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

if (tmp$SUBJECT[n]=="NURS" & tmp$CAMPUS[n]=="ABQ") {
  tmp$NodePath[n] <- "University.CollegeofNursing"}
if (tmp$SUBJECT[n]=="NURS" & tmp$CAMPUS[n]=="EA") {
  tmp$NodePath[n] <- "University.CollegeofNursing"}

# This is to assign a Hiearchy to 'College of Population Health' courses. If other "PH" subjects end up using EvalKIT, this code will have to be changed
if (tmp$SUBJECT[n]=="PH" & tmp$CAMPUS[n]=="ABQ") {
  tmp$NodePath[n] <- "University.SchoolofMedicine.CollegeofPopulationHealth"}
if (tmp$SUBJECT[n]=="PH" & tmp$CAMPUS[n]=="EA") {
  tmp$NodePath[n] <- "University.SchoolofMedicine.CollegeofPopulationHealth"}

if (tmp$SUBJECT[n]=="RADS" & tmp$CAMPUS[n]=="ABQ") {
  tmp$NodePath[n] <- "University.SchoolofMedicine.Radiology"}
if (tmp$SUBJECT[n]=="RADS" & tmp$CAMPUS[n]=="EA") {
  tmp$NodePath[n] <- "University.SchoolofMedicine.Radiology"}

if (tmp$SUBJECT[n]=="NUCM" & tmp$CAMPUS[n]=="ABQ") {
  tmp$NodePath[n] <- "University.SchoolofMedicine.Radiology"}
if (tmp$SUBJECT[n]=="NUCM" & tmp$CAMPUS[n]=="EA") {
  tmp$NodePath[n] <- "University.SchoolofMedicine.Radiology"}
  
  if (tmp$CAMPUS[n]=="GA") {
      tmp$NodePath[n] <- "University.BranchCampuses.Gallup"} 
  if (tmp$CAMPUS[n]=="EG") {
    tmp$NodePath[n] <- "University.BranchCampuses.Gallup"} 
  if (tmp$CAMPUS[n]=="LA") {
      tmp$NodePath[n] <- "University.BranchCampuses.LosAlamos"} 
  if (tmp$CAMPUS[n]=="TA") {
      tmp$NodePath[n] <- "University.BranchCampuses.Taos"} 
  if (tmp$CAMPUS[n]=="ET") {
      tmp$NodePath[n] <- "University.BranchCampuses.TaosBachelorsGraduate"} 
  if (tmp$CAMPUS[n]=="TAM") {
      tmp$NodePath[n] <- "University.BranchCampuses.TaosMora"} 
  if (tmp$CAMPUS[n]=="TAQ") {
      tmp$NodePath[n] <- "University.BranchCampuses.TaosQuesta"} 
  if (tmp$CAMPUS[n]=="VA") {
      tmp$NodePath[n] <- "University.BranchCampuses.Valencia"} 
  if (tmp$CAMPUS[n]=="EW") {
    tmp$NodePath[n] <- "University.BranchCampuses.UNMWest"} 
  if (tmp$CAMPUS[n]=="EF") {
    tmp$NodePath[n] <- "University.BranchCampuses.SanJuanBachelorsGraduate"} 
  n <- n+1
  #tmp$NodePath[n] <- NULL
}  

# Write the detailed Course file
write.csv(tmp, file = "Detailed_Course_Data.csv")

# Drop all fields except: TITLE, CODE, and COURSEUniqueID
tmp$TITLE_LONG_DESC <- NULL
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
tmp$TITLE_SHORT_DESC <- NULL
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



