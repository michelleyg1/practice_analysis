data lab;
	length labtest $10;
	retain subjid sampledat value labtest;
	input subjid sampledat value labtest $;
	datalines;
	11001 10146 9.500 CALCIUM
	11001 10146 112.000 GLUCOSE
	11001 10146 14.900 HEMOGLOBIN
	11001 10146 4.200 POTASSIUM
	11001 10146 5.070 RBC
	11001 10146 14.100 WBC
	11001 10153 8.800 CALCIUM
	11001 10153 91.000 GLUCLOSE
	11001 10153 13.200 HEMOGLOBIN
	11001 10153 4.300 POTASSIUM
;
run;

proc sort data=lab;
	by subjid sampledat;
run;
/* long to wide  */
data lab_wide;
	set lab;
	by subjid sampledat;
	retain calcium glucose hemoglobin potassium rbc wbc;
	keep subjid sampledat calcium glucose hemoglobin potassium rbc wbc;
	array wide{*} calcium glucose hemoglobin potassium rbc wbc;
		if first.sampledat then count=1;
		else count+1;
		do i=1 to dim(wide);
			if first.sampledat then do;
			wide{i}=.;
		end;
		end;
		wide{count}=value;
	if last.sampledat;
	format sampledat date9.;
run;

/* wide to long */
data lab_skinny;
	set lab_wide;
	retain value labtest;
	keep subjid sampledat value labtest;
	array t{*} calcium glucose hemoglobin potassium rbc wbc;
		do i= 1 to dim(t);
			value=t{i};
			labtest=vname(t{i});
			output;
		end;
run;
	