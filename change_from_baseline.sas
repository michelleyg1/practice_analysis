data change;
	input subject week test $ value;
	datalines;
	101 0 DBP 160
	101 1 DBP 143
	101 2 DBP 140
	101 3 DBP 139
	101 0 SBP 90
	101 1 SBP 84
	101 2 SBP 80
	101 3 SBP 70
	;
run;

proc sort data=change;
	by subject test week;
run;

data cfb;
	set change;
	by subject test week;
	retain baseline;
	if first.test then baseline=.;
	if week=0 then baseline=value;
	else if week > 0 then do;
		pct_chg=((value-baseline)/baseline)*100;
	end;
run;