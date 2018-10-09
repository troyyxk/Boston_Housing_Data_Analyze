/* In the 1970s */
libname bh '/folders/myfolders/Boston House';

/* Read the data into SAS */
/* replace if the file (the out file ) already exits */
proc import datafile= '/folders/myfolders/boston_house_train.csv'
	dbms= csv
	out=bh.boston_house
	replace;
	getnames= yes;
run;

/* make copies of the original data */
proc export data= bh.boston_house dbms= xlsx
	outfile= '/folders/myfolders/Boston House/boston_house_train.xlsx'
	replace;
run;

proc export data= bh.boston_house dbms= tab
	outfile= '/folders/myfolders/Boston House/boston house train.txt'
	replace;
run;

/* Create a new index call fancy_house which = 'Y' if the number of the rooms
 is higher than 6 and the age of the house is lower than 80, 'N' otherwise */
data bh.boston_house;
	set bh.boston_house;
	if rm > 6 and age < 80 then fancy_house = 'Y';
	else fancy_house = 'N';
run;

/* Create a new index call edu_ind which = 'good' if the ptratio(pupil-teacher ratio) is
 smaller than 20, 'ok' otherwise */
data bh.boston_houes;
	set bh.boston_house;
	if ptratio < 20 then edu_ind = 'good';
	else edu_ind = 'ok';
run;

/* Create a new index call quality_ind_1, = 'Super' if fancy_house = 'Y' and edu_ind = 'good', 
= 'Nice to live' if fancy_house = 'Y' and edu_ind = 'ok', = 'Good education' if fancy_house = 'N'
 and edu_ind = 'good' and lastly if the other condition (the worst condition, where fancy_house = 'N'
 and edu_ind = 'ok') occurs, then quanlity_ind = 'No good'.  */
/* Also, the length of the quanlity_ind is fixed to 20 since if we do not do so, SAS will automatically
 use the length for the first input as the length of the index/attribute which would lead to shortern of
 some input which we do not want. */
data bh.boston_house_test_v1;
	set bh.boston_houes;
	length quality_ind_1 $20;
	if fancy_house = 'Y' and edu_ind = 'good' then quality_ind_1 = 'Super';
	else if fancy_house = 'Y' and edu_ind = 'ok' then quality_ind_1 = 'Nice to live';
	else if fancy_house = 'N' and edu_ind = 'good' then quality_ind_1 = 'Good education';
	else quality_ind_1 = 'No good';
run;

/* Check the amount and frequency in quanlity_ind_1 */
proc freq data= bh.boston_house_test_v1;
	table quality_ind_1 /nocum;
run;

/* Use class quanlity_ind_1 to classfy */
/* Education more inportant. */
proc means data= bh.boston_house_test_v1;
	class quality_ind_1;
	var medv;
run;

/* proc univariate data= bh.boston_house_test_v1; */
/* 	var medv; */
/* 	histogram; */
/* run; */
/*  */
/* proc univariate data= bh.boston_house_test_v1; */
/* 	where quality_ind_1 = 'Super'; */
/* 	var medv; */
/* 	histogram; */
/* run; */
/*  */
/* proc univariate data= bh.boston_house_test_v1; */
/* 	class quality_ind_1; */
/* 	var medv; */
/* 	histogram; */
/* run; */




/*  */
/*  */
/* Create a dataset (name boston_age_ind) which contains  */
/* a new variable to see whether age is over 30 or not */
/* data bh.boston_house_age_ind; */
/* 	set bh.boston_house; */
/* 	if age >= 30 then age_ind = 1; */
/* 	else age_ind = 0; */
/* run; */
/*  */
/*  */
/*  */
/*  */
/*  */