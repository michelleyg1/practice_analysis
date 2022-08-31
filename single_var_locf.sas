data var;
	set missing_obs(keep=subjid pulse);
run;

proc sort data=var;
by subjid;
run;

data locf;
	set var;
	retain locf;
	if first.subjid then LOCF=.;
	if pulse ~=. then LOCF=pulse;
run;
	