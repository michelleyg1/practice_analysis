/* WIDE TO LONG */
/* use vname() to get the variable names in there */
data tourism;
	set sashelp.tourism;
	keep year column type;
	array tour{*} vsp--exsp;

	do i=1 to dim(tour);
		column=tour{i};
		type=vname(tour{i});
		output;
	end;
run;

/* LONG TO WIDE */
proc sort data=tourism;
	by year;
run;

data tourwide;
	set tourism;
	by year;
	keep year cpisp exsp exuk pdi pop puk vsp;
	retain cpisp exsp exuk pdi pop puk vsp;
	array wide{*} cpisp exsp exuk pdi pop puk vsp;
		if first.year then count=1;
		else count+1;
	do i=1 to dim(wide);
		if first.year then do;
				wide{i}=.;
		end;
	end;
	wide{count}=column;
	if last.year then output;
run;