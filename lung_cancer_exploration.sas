/* importing data */
%let path=/home/u61896790/lung;
libname lung "&path";

options validvarname=v7;
proc import datafile="&path/survey_lung_cancer.csv" dbms=csv
	out=lung.dataset replace;
	getnames=yes;
run;

/* creating format for binomial values */
proc format;
	value yesno 
	1 = "NO"
	2 = "YES";
run;

/* exploring data */
proc print data=lung.dataset noobs;
format SMOKING--CHEST_PAIN yesno.;
run;

/* gender distribution of whole dataset*/
ods graphics on;
ods noproctitle;
title "Gender Distribution of Entire Lung Cancer Prediction Dataset";
proc freq data=lung.dataset;
	tables gender / plots=freqplot nocum;
run;
title;

/* age distribution of whole dataset*/
ods trace on;
ods select Histogram;
ods noproctitle;
title "Age Distribution of Entire Lung Cancer Prediction Dataset";
proc univariate data=lung.dataset;
	var age;
	histogram / normal;
run;
title;

/* creating and applying custom informat for converting LUNG_CANCER column */
proc format;
	invalue numinfmt
	'NO' = 1
	'YES'= 2;
run;

data lung.lung_cancer_prediction;
	set lung.dataset;
	LUNG_CANCER_NUM=input(LUNG_CANCER, numinfmt.);
	drop LUNG_CANCER;
	format SMOKING--LUNG_CANCER_NUM yesno.;
	label YELLOW_FINGERS= "Yellow Fingers";
	label AGE="Age";
	label ALCOHOL_CONSUMING= "Consumes Alcohol";
	label ALLERGY= "Has Allergies";
	label ANXIETY= "Has Anxiety";
	label CHEST_PAIN= "Experiences Chest Pain";
	label CHRONIC_DISEASE= "Has a Chronic Disease";
	label COUGHING= "Experiences Coughing";
	label FATIGUE= "Experiences Fatigue";
	label GENDER= "Gender";
	label LUNG_CANCER_NUM= "Has/Had Lung Cancer";
	label PEER_PRESSURE= "Experiences Peer Pressure";
	label SHORTNESS_OF_BREATH= "Experiences Shortness of Breath";
	label SMOKING= "Smoker";
	label SWALLOWING_DIFFICULTY= "Experiences Difficulty Swallowing";
	label WHEEZING= "Experiences Wheezing";
run;

title "Lung Cancer Prediction Dataset";
proc print data=lung.lung_cancer_prediction noobs label;
run;
title;

ods pdf file="&path/lung_cancer_report.pdf" startpage=now;
/* gender distribution of positive cases */
ods graphics on;
ods noproctitle;
title "Gender Distribution of Lung Cancer Prediction Dataset where Lung Cancer is Positive";
proc freq data=lung.lung_cancer_prediction(where=(LUNG_CANCER_NUM=2));
	tables gender / plots=freqplot nocum;
run;
title;

/* age distribution of positive cases */
ods trace on;
ods select Histogram;
ods noproctitle;
title "Age Distribution of Lung Cancer Prediction Dataset where Lung Cancer is Positive";
proc univariate data=lung.lung_cancer_prediction(where=(LUNG_CANCER_NUM=2));
	var age;
	histogram / normal;
run;
title;

/* exploring smoking and lung cancer */
title "Frequency Table and Bar Chart for Smoking by Lung Cancer";
ods noproctitle;
proc freq data=lung.lung_cancer_prediction;
	tables SMOKING*LUNG_CANCER_NUM / norow nocol plots=freqplot
	(twoway=cluster);
	label LUNG_CANCER_NUM="Lung Cancer";
	label SMOKING="Smoking";
run;
title;

/* exploring peer pressure and smoking*/
title "Frequency Table and Bar Chart for Peer Pressure by Smoking";
ods noproctitle;
proc freq data=lung.lung_cancer_prediction;
	tables SMOKING*PEER_PRESSURE / norow nocol plots=freqplot
	(twoway=cluster);
	label PEER_PRESSURE="Peer Pressure";
	label SMOKING="Smoking";
run;
title;
ods pdf close;
