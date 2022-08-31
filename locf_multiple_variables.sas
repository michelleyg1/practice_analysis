/* LOCF for multiple variables */
proc sort data=missing_obs;
	by subjid;
run;

%let origv= %str(pulse sbp dbp);
%let locfv=%str(pulse_ sbp_ dbp_);

data locf_final;
	set missing_obs;
	array origv{*} &origv;
	array locfv{*} &locfv;
	retain &locfv;
	
	do i= 1 to dim(origv);
		if first.subj then do;
		if origv(i)=. then locfv(i)=-99;
		end;
	if origv(i) ne " " then locfv(i)=origv(i);
	end;
	drop i &origv;
run;
	
	