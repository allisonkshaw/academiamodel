function do_group_data_retrieval_faculty
% USAGE: do_group_data_retrieval_faculty
% written July 2020  by Allison Shaw (contact ashaw@umn.edu for assistance)
% last updated 6 May 2021
%
% retrieve data on faculty by ethnicity/race over time
%
% DATA SOURCES:
% Women, Minorities, and Persons with Disabilities in Science and Engineering report.
%    https://www.nsf.gov/statistics/women/
%  1994 report
%     Table 8-18 = 1991 faculty
%  1996 report
%     Table 5-28 = 1993 faculty by tenure status
%  1998 report
%     Table 5-10 = 1995 faculty by tenure status
%  2000 report
%     Table 5-19 = 1997 faculty by tenure status [saved as xlsx first to import]
%  2004 report
%     Table H-26 = 2001 faculty by tenure status
%  2007 report
%     Table H-28 = 2003 faculty by tenure status [saved as xlsx first to import]
%  2009 report
%     Table H-28 = 2006 faculty by tenure status [saved as xlsx first to import]
%  2011 report
%     Table 9-26 = 2008 faculty by tenure status
%  2013 report
%     Table 9-26 = 2010 faculty by tenure status [saved as xlsx first to import]
%  2015 report
%     Table 9-26 = 2013 faculty by tenure status
%  2017 report
%     Table 9-26 = 2015 faculty by tenure status
%  2019 report
%     Table 9-26 = 2017 faculty by tenure status
%
% CATEGORIES
%   White (sometimes also non-Hispanic)
%   Asian (sometimes also Pacific Islander)
%   Black (sometimes also non-Hispanic)
%   Hispanic
%   American Indian (sometimes also Alaskan Native)
%   Native Hawaiian (when reported)
%   Multiple races (when reported)
%
% OUTPUT: No direct output, but the following .csv files are generated:
%   N_NSF_AP.csv: years, number of assistant professors by group (column) for years (rows)
%   N_NSF_TP.csv: years, number of tenured professors by group (column) for years (rows)
%
% NOTES:
% * Sum of race/ethnicity groups don’t sum to total because ‘other’ is not listed as a group
% * weird blips in the number of faculty reporting
% * 1991-1995 lists as white and black (without non-hispanic qualifier), asian (without pacific islander), and american indian (without alaskan native)
% * “African American” started in 2017
% * American Indian
%	masked for 1993 but reported for other years (before and after)
%	partially masked for 2001/2010/2013/2015/2017 so partially estimated
% 	masked for 2008
% * Native Hawaiian/Pacific Islander
%	2003 counted separately but not reported
%	2008 masked for all occupations, so no way to estimate
%	2010/2013/2015/2017 partially masked so partially estimated
% * 2010 data reports multiple races that are hispanic in hispanic and multiple races that are not hispanic in multiple races
% * 2002 report has no rank data??
% * data also by sex: 2000, 2008 2010


%-----1991----------------------------------------------------------------%
    yr_tmp = 1991; % set years
    % load NSF data
    [data,TXT]=xlsread('../../NSF data/WMPD/1994 report - part/appn8-18.xls');
    % offset by this amount to map from row in excel to row in data
    tmp = 10; % rows of text at the start of file

    % Total
    %   White, non-hispanic
    %   Black, non-hispanic
    %   Hispanic
    %   Asian
    %   American Indian
    indT = [18:23] - tmp;
    indA = [25:30] - tmp;

    NT_tmp = data(indT,2); % extract groups
    NA_tmp = data(indA,2); % extract groups
    clear indT indA data TXT tmp

    % NOTE from report: Because of rounding, other races, and "no reports," details may not add to totals.

    % reorder
    % (cut out total)
    % also swap so rows are years
    N_AP = NA_tmp([2 5 3 4 6])'; 
    N_TP = NT_tmp([2 5 3 4 6])';
    %   White, non-hispanic
    %   Asian
    %   Black, non-hispanic
    %   Hispanic
    %   American Indian

    yr_A = yr_tmp;
    yr_T = yr_tmp;
    clear NA_tmp NT_tmp yr_tmp
%-----1991----------------------------------------------------------------%


%-----1993----------------------------------------------------------------%
    yr_tmp = 1993; % set years
    % load NSF data
    [data,TXT]=xlsread('../../NSF data/WMPD/1996 report - part/at5-28.xls','Sheet1');

    % Total
    %   White
    %   Asian
    %   Black
    %   Hispanic
    %   American Indian
    indTr = 30;
    indAr = 31;
    indc = [4 10 12 14 16 18];

    NT_tmp = data(indTr,indc); % extract groups
    NA_tmp = data(indAr,indc); % extract groups
    clear indTr indAr indc data TXT

    %1993: American Indian = fewer than 500 estimated/percent distribution not available

    % NOTES:     Because of rounding, details may not add to totals.  Data are preliminary.

    % save group data
    yr_A = [yr_A yr_tmp];
    yr_T = [yr_T yr_tmp];

    % (cut out total)
    % swap 0 for NaN for masked data
    N_AP = [N_AP; NA_tmp([2:5]) NaN]; 
    N_TP = [N_TP; NT_tmp([2:5]) NaN];
    % White
    % Asian
    % Black
    % Hispanic
    % American Indian

    clear NA_tmp NT_tmp yr_tmp
%-----1993----------------------------------------------------------------%


%-----1995----------------------------------------------------------------%
    yr_tmp = 1995; % set years
    % load NSF data
    [data,TXT]=xlsread('../../NSF data/WMPD/1998 report - part/at05-10.xls');
    % offset by this amount to map from row in excel to row in data
    tmp = 7; % rows of text at the start of file

    % Total
    %   White
    %   Asian
    %   Black
    %   Hispanic
    %   American Indian
    indTr = 13 - tmp;
    indAr = 15 - tmp;
    indc = [3 6 7 8 9 10];

    NT_tmp = data(indTr,indc); % extract groups
    NA_tmp = data(indAr,indc); % extract groups
    clear indTr indAr indc data TXT tmp

    % NOTES:     Because of rounding, details may not add up to totals. Total includes "other" race/ethnicity. 

    % save group data
    yr_A = [yr_A yr_tmp];
    yr_T = [yr_T yr_tmp];

    % (cut out total)
    N_AP = [N_AP; NA_tmp([2:6])]; 
    N_TP = [N_TP; NT_tmp([2:6])];
    % White
    % Asian
    % Black
    % Hispanic
    % American Indian

    clear NA_tmp NT_tmp yr_tmp
%-----1995----------------------------------------------------------------%


%-----1997----------------------------------------------------------------%
    yr_tmp = 1997; % set years
    % load NSF data
    [data,TXT]=xlsread('../../NSF data/WMPD/2000 report - part/at05-19_ed.xlsx');
    % offset by this amount to map from row in excel to row in data
    tmp = 0; % rows of text at the start of file

    % Total
    % White, non-Hispanic
    % Asian/ Pacific Islander
    % Black, non-Hispanic
    % Hispanic
    % American Indian/ Alaskan  Native
    indTr = 8 - tmp;
    indAr = 9 - tmp;
    indc = [3:8];

    NT_tmp = data(indTr,indc); % extract groups
    NA_tmp = data(indAr,indc); % extract groups
    clear indTr indAr indc data TXT tmp

    % NOTE: Figures are rounded to nearest hundred. Details may not add to
    %  total because of rounding. Total includes "other" race/ethnicity not
    %  shown separately. The term "scientists and engineers" includes all
    %  persons who have ever received a bachelor's degree or higher in a
    %  science or engineering field, plus persons holding a non-science and
    %  -engineering bachelor's or higher degree who were employed in a
    %  science or engineering occupation.

    % save group data
    yr_A = [yr_A yr_tmp];
    yr_T = [yr_T yr_tmp];

    % (cut out total)
    N_AP = [N_AP; NA_tmp([2:6])]; 
    N_TP = [N_TP; NT_tmp([2:6])];
    % White, non-Hispanic
    % Asian/ Pacific Islander
    % Black, non-Hispanic
    % Hispanic
    % American Indian/ Alaskan  Native

    clear NA_tmp NT_tmp yr_tmp
%-----1997----------------------------------------------------------------%


%-----2001----------------------------------------------------------------%
    yr_tmp = 2001; % set years
    % load NSF data
    [data,TXT]=xlsread('../../NSF data/WMPD/2004 report/data/tables/tabh-26.xls');
    % offset by this amount to map from row in excel to row in data
    tmp = 5; % rows of text at the start of file

    % Total
    % White, non-Hispanic
    % Asian/ Pacific Islander
    % Black, non-Hispanic
    % Hispanic
    % American Indian/ Alaskan  Native
    indTc = 3;
    indAc = 4;
    indr1 = [14:19] - tmp;
    indr2 = [61:66] - tmp;

    NT_tmp1 = data(indr1,indTc); % extract groups
    NA_tmp1 = data(indr1,indAc); % extract groups
    NT_tmp2 = data(indr2,indTc); % extract groups
    NA_tmp2 = data(indr2,indAc); % extract groups
    
    % Tenured Native is masked for Engineers but not for Scientists, all
    % occupations, or non-S&E, so estimate:
    N_tmp1 = data(11-tmp,indTc);  % native for all occupations
    N_tmp2 = data(72-tmp,indTc);  % native for non S&E occupations
    NT_tmp2 (end) = N_tmp1 - N_tmp2 - NT_tmp1(end); % alll occupations minus non S&E minus S should give E
    
    % Non-tenured Native is masked for Engineers and non-S&E but not for
    % Scientists or all occupations, so estimate:
    N_tmp1 = data(11-tmp,indAc);  % native for all occupations
    NA_tmp2 (end) = 1/2*(N_tmp1  - NA_tmp1(end)); % alll occupations minus S gives E and non S&E, so divide by two for rough guess
    
    clear data TXT indTc indAc indr1 indr2 N_tmp1 N_tmp2  tmp

    % NOTES:  Data are limited to those who earned a doctorate in an S&E
    %  field from a U.S. institution. Numbers rounded to nearest 10. Details
    %  may not add to total because of rounding. Total includes "other
    %  race/ethnicity" not shown separately.

    % save group data
    yr_A = [yr_A yr_tmp];
    yr_T = [yr_T yr_tmp];

    % combine two counts (Science and Engineering)
    % (cut out total)
    % rotate data
    N_AP = [N_AP; NA_tmp1(2:6)' + NA_tmp2(2:6)']; 
    N_TP = [N_TP; NT_tmp1(2:6)' + NT_tmp2(2:6)'];
    % White, non-Hispanic
    % Asian/ Pacific Islander
    % Black, non-Hispanic
    % Hispanic
    % American Indian/ Alaskan  Native

    clear NA_tmp NT_tmp yr_tmp NA_tmp1 NA_tmp2 NT_tmp1 NT_tmp2
%-----2001----------------------------------------------------------------%


%-----2003----------------------------------------------------------------%
    yr_tmp = 2003; % set years
    % load NSF data
    [data,TXT]=xlsread('../../NSF data/WMPD/2007 report/data/tables/tabh-28_ed.xlsx');
    % offset by this amount to map from row in excel to row in data
    tmp = 3; % rows of text at the start of file
    tmp2 = 1; % columns of text at the start of file

    % Total
    % White
    % Asian
    % Black
    % Hispanic
    % American Indian/ Alaskan  Native
    indTc = 3 - tmp2;
    indAc = 4 - tmp2;
    indr = [36 37 43 49 55 61] - tmp;

    NT_tmp = data(indr,indTc); % extract groups
    NA_tmp = data(indr,indAc); % extract groups
    
    clear data TXT indTc indAc indr tmp tmp2

    % NOTES:  Numbers rounded to nearest 100. Detail may not add to total
    %  because of rounding. Total includes Native Hawaiian/other Pacific
    %  Islander and multiple race not shown separately. 

    % save group data
    yr_A = [yr_A yr_tmp];
    yr_T = [yr_T yr_tmp];

    % (cut out total)
    % rotate data
    N_AP = [N_AP; NA_tmp(2:6)']; 
    N_TP = [N_TP; NT_tmp(2:6)'];
    % White
    % Asian
    % Black
    % Hispanic
    % American Indian/ Alaskan  Native

    clear NA_tmp NT_tmp yr_tmp NA_tmp1 NA_tmp2 NT_tmp1 NT_tmp2
%-----2003----------------------------------------------------------------%

%-----2006----------------------------------------------------------------%
    yr_tmp = 2006; % set years
    % load NSF data
    [data,TXT]=xlsread('../../NSF data/WMPD/2009 report/data/tables/tabh-28_ed.xlsx');
    % offset by this amount to map from row in excel to row in data
    tmp = 3; % rows of text at the start of file
    tmp2 = 1; % columns of text at the start of file

    % Total
    % White
    % Asian
    % Black
    % Hispanic
    % American Indian/ Alaskan  Native
    indTc = 3 - tmp2;
    indAc = 4 - tmp2;
    indr = [36 37 43 49 55 61] - tmp;

    NT_tmp = data(indr,indTc); % extract groups
    NA_tmp = data(indr,indAc); % extract groups
    
    clear data TXT indTc indAc indr tmp tmp2

    % NOTES:  Numbers rounded to nearest 100. Detail may not add to total
    %  because of rounding. Total includes Native Hawaiian/other Pacific
    %  Islander and multiple race not shown separately. 

    % save group data
    yr_A = [yr_A yr_tmp];
    yr_T = [yr_T yr_tmp];

    % (cut out total)
    % rotate data
    N_AP = [N_AP; NA_tmp(2:6)']; 
    N_TP = [N_TP; NT_tmp(2:6)'];
    % White
    % Asian
    % Black
    % Hispanic
    % American Indian/ Alaskan  Native

    clear NA_tmp NT_tmp yr_tmp
%-----2006----------------------------------------------------------------%


%-----2008----------------------------------------------------------------%
    yr_tmp = 2008; % set years
    % load NSF data
    [data,TXT]=xlsread('../../NSF data/WMPD/2011 report/data/tables/tab9-26.xls');
    % offset by this amount to map from row in excel to row in data
    tmp = 4; % rows of text at the start of file
    tmp2 = 1; % columns of text at the start of file

    % Total                                  
    % White                           
    % Asian                           
    % Black                           
    % Hispanic                        
    % American Indian/Alaska Native   
    % Native Hawaiian/Other Pacific Islander
    % Multiple race
    indTc = 3 - tmp2;
    indAc = 4 - tmp2;
    indr1 = [26:33] - tmp;
    indr2 = [35:42] - tmp;

    NT_tmp1 = data(indr1,indTc); % extract groups
    NA_tmp1 = data(indr1,indAc); % extract groups
    NT_tmp2 = data(indr2,indTc); % extract groups
    NA_tmp2 = data(indr2,indAc); % extract groups
    
    clear data TXT indTc indAc indr1 indr2 tmp tmp2

    % NOTES:  Numbers are rounded to nearest 100. Detail may not add to
    %  total because of rounding and suppression. S&E doctorate holders
    %  refers to all persons with doctoral degrees in science, engineering,
    %  or health fields from U.S. universities.

    % save group data
    yr_A = [yr_A yr_tmp];
    yr_T = [yr_T yr_tmp];

    % add NaNs for missing data on native hawaiian and multiple races
    % before
    % (cut out total)
    % rotate data
    N_AP = [N_AP NaN(size(N_AP,1),2); NA_tmp1(2:8)' + NA_tmp2(2:8)']; 
    N_TP = [N_TP NaN(size(N_TP,1),2); NT_tmp1(2:8)' + NT_tmp2(2:8)'];
    % White
    % Asian
    % Black
    % Hispanic
    % American Indian/ Alaskan  Native
    % Native Hawaiian/Other Pacific Islander
    % Multiple race

    clear yr_tmp NA_tmp1 NA_tmp2 NT_tmp1 NT_tmp2
%-----2008----------------------------------------------------------------%


%-----2010----------------------------------------------------------------%
    yr_tmp = 2010; % set years
    % load NSF data
    [data,TXT]=xlsread('../../NSF data/WMPD/2013 report/data/tables/tab9-26_ed.xlsx');
    % offset by this amount to map from row in excel to row in data
    tmp = 4; % rows of text at the start of file
    tmp2 = 1; % columns of text at the start of file

    % Total                                  
    % White                           
    % Asian                           
    % Black                           
    % Hispanic (May be any race)
    % American Indian or Alaska Native 
    % Native Hawaiian or Other Pacific Islander
    % Multiple race
    indTc = 3 - tmp2;
    indAc = 4 - tmp2;
    indr1 = [26:33] - tmp;
    indr2 = [35:42] - tmp;

    NT_tmp1 = data(indr1,indTc); % extract groups
    NA_tmp1 = data(indr1,indAc); % extract groups
    NT_tmp2 = data(indr2,indTc); % extract groups
    NA_tmp2 = data(indr2,indAc); % extract groups
    
    % NOTES:  Numbers rounded to nearest 100. Detail may not add to total
    %  because of rounding and suppression. S&E occupations include S&E
    % postsecondary teachers. S&E-related occupations include health occupations.  
    
    % Female American Indian
    N_tmp1 = data(31-tmp,indTc-1);  % total Female American Indian
    mcount = sum(isnan(data(31-tmp,indTc:indTc+3))); % number of blanks to average across
    NA_tmp1(6) = (N_tmp1 - NT_tmp1(6))/mcount; % total minus Tenured, averaged across number of blanks
    clear N_tmp1 mcount

    % Female Hawaiian
    N_tmp1 = data(32-tmp,indTc-1);  % total Female Hawaiian
    mcount = sum(isnan(data(32-tmp,indTc:indTc+3))); % number of blanks to average across
    NA_tmp1(7) = (N_tmp1)/mcount; % total, averaged across number of blanks
    NT_tmp1(7) = (N_tmp1)/mcount; % total, averaged across number of blanks
    clear N_tmp1 mcount
    
    % Male Hawaiian
    N_tmp1 = data(41-tmp,indTc-1);  % total male Hawaiian
    mcount = sum(isnan(data(41-tmp,indTc:indTc+3))); % number of blanks to average across
    NT_tmp2(7) = (N_tmp1 - NA_tmp2(7))/mcount; % total minus Tenured, averaged across number of blanks
    clear N_tmp1 mcount
    
    % save group data
    yr_A = [yr_A yr_tmp];
    yr_T = [yr_T yr_tmp];

    % (cut out total)
    % rotate data
    N_AP = [N_AP; NA_tmp1(2:8)' + NA_tmp2(2:8)'];
    N_TP = [N_TP; NT_tmp1(2:8)' + NT_tmp2(2:8)'];
    % White
    % Asian
    % Black
    % Hispanic
    % American Indian/ Alaskan  Native
    % Native Hawaiian or Other Pacific Islander
    % Multiple race
        
    clear data TXT indTc indAc indr1 indr2 tmp2 tmp
    clear yr_tmp NA_tmp1 NA_tmp2 NT_tmp1 NT_tmp2 
%-----2010----------------------------------------------------------------%


%-----2013----------------------------------------------------------------%
    yr_tmp = 2013; % set years
    % load NSF data
    [data,TXT]=xlsread('../../NSF data/WMPD/2015 report/data/tables/tab9-26.xlsx');
    % offset by this amount to map from row in excel to row in data
    tmp = 4; % rows of text at the start of file
    tmp2 = 1; % columns of text at the start of file

    % Total                                  
    % White                           
    % Asian                           
    % Black                           
    % Hispanic (Includes Hispanic or Latino of one or more races)
    % American Indian or Alaska Native 
    % Native Hawaiian or Other Pacific Islander
    % More than one race (Includes persons of more than one race who are not
    %   Hispanic or Latino.)
    indTc = 3 - tmp2;
    indAc = 4 - tmp2;
    indr1 = [26:33] - tmp;
    indr2 = [35:42] - tmp;

    NT_tmp1 = data(indr1,indTc); % extract groups
    NA_tmp1 = data(indr1,indAc); % extract groups
    NT_tmp2 = data(indr2,indTc); % extract groups
    NA_tmp2 = data(indr2,indAc); % extract groups
    
    %NOTES: Numbers rounded to nearest 100. Detail may not add to total
    %  because of rounding and suppression. S&E occupations include S&E
    %  postsecondary teachers. S&E-related occupations include health occupations.  

     % Female American Indian
    N_tmp1 = data(31-tmp,indTc-1);  % total Female American Indian
    N_tmp2 = data(31-tmp,indTc+3);  % NATT Female American Indian
    mcount = sum(isnan(data(31-tmp,indTc:indTc+3))); % number of blanks to average across
    NA_tmp1(6) = (N_tmp1 - N_tmp2 - NT_tmp1(6))/mcount; % total minus NA-TT minus Tenured, averaged across number of blanks
    clear N_tmp1 N_tmp2 mcount

    % Female Hawaiian
    N_tmp1 = data(32-tmp,indTc-1);  % total Female Hawaiian
    mcount = sum(isnan(data(32-tmp,indTc:indTc+3))); % number of blanks to average across
    NA_tmp1(7) = (N_tmp1)/mcount; % total, averaged across number of blanks
    NT_tmp1(7) = (N_tmp1)/mcount; % total, averaged across number of blanks
    clear N_tmp1 mcount
    
    % Male American Indian
    N_tmp1 = data(40-tmp,indTc-1);  % total male American Indian
    mcount = sum(isnan(data(40-tmp,indTc:indTc+3))); % number of blanks to average across
    NA_tmp2(6) = (N_tmp1 - NT_tmp2(6))/mcount; % total minus Tenured, averaged across number of blanks
    clear N_tmp1 mcount

    % Male Hawaiian
    N_tmp1 = data(41-tmp,indTc-1);  % total male Hawaiian
    mcount = sum(isnan(data(41-tmp,indTc:indTc+3))); % number of blanks to average across
    NT_tmp2(7) = (N_tmp1 - NA_tmp2(7))/mcount; % total minus Tenured, averaged across number of blanks
    clear N_tmp1 mcount
    
    % save group data
    yr_A = [yr_A yr_tmp];
    yr_T = [yr_T yr_tmp];

    % (cut out total)
    % rotate data
    N_AP = [N_AP; NA_tmp1(2:8)' + NA_tmp2(2:8)'];
    N_TP = [N_TP; NT_tmp1(2:8)' + NT_tmp2(2:8)'];
    % White
    % Asian
    % Black
    % Hispanic
    % American Indian/ Alaskan  Native
    % Native Hawaiian or Other Pacific Islander
    % Multiple race
    
    clear data TXT indTc indAc indr1 indr2 tmp2 tmp
    clear yr_tmp NA_tmp1 NA_tmp2 NT_tmp1 NT_tmp2 
%-----2013----------------------------------------------------------------%


%-----2015----------------------------------------------------------------%
    yr_tmp = 2015; % set years
    % load NSF data
    [data,TXT]=xlsread('../../NSF data/WMPD/2017 report - part/tab9-26-updated-2018-06.xlsx');
    % offset by this amount to map from row in excel to row in data
    tmp = 3; % rows of text at the start of file
    tmp2 = 1; % columns of text at the start of file

    % Total                                  
    % White                           
    % Asian                           
    % Black                           
    % Hispanic (Includes Hispanic or Latino of one or more races)
    % American Indian or Alaska Native 
    % Native Hawaiian or Other Pacific Islander
    % More than one race (Includes persons of more than one race who are not
    %   Hispanic or Latino.)
    indTc = 3 - tmp2;
    indAc = 4 - tmp2;
    indr1 = [22:29] - tmp;
    indr2 = [30:37] - tmp;

    NT_tmp1 = data(indr1,indTc); % extract groups
    NA_tmp1 = data(indr1,indAc); % extract groups
    NT_tmp2 = data(indr2,indTc); % extract groups
    NA_tmp2 = data(indr2,indAc); % extract groups
    
    % NOTES: Numbers rounded to nearest 50. Detail may not add to total
    %  because of rounding and suppression. S&E occupations include S&E
    %  postsecondary teachers. S&E-related occupations include health occupations.  

    % Female Hawaiian
    N_tmp1 = data(28-tmp,indTc-1);  % total Female Hawaiian
    mcount = sum(isnan(data(28-tmp,indTc:indTc+3))); % number of blanks to average across
    NA_tmp1(7) = (N_tmp1)/mcount; % total, averaged across number of blanks
    NT_tmp1(7) = (N_tmp1)/mcount; % total, averaged across number of blanks
    clear N_tmp1 mcount
    
    % Male American Indian
    N_tmp1 = data(35-tmp,indTc-1);  % total male American Indian
    N_tmp2 = data(35-tmp,indTc+2);  % non TT male American Indian
    N_tmp3 = data(35-tmp,indTc+3);  % NA-TT male American Indian
    mcount = sum(isnan(data(35-tmp,indTc:indTc+3))); % number of blanks to average across
    NA_tmp2(6) = (N_tmp1 - N_tmp2 - N_tmp3 - NT_tmp2(6))/mcount; % total minus nonTT minus NA-TT minus Tenured, averaged across number of blanks
    clear N_tmp1 N_tmp2 N_tmp3 mcount

    % Male Hawaiian
    N_tmp1 = data(36-tmp,indTc-1);  % total male Hawaiian
    mcount = sum(isnan(data(36-tmp,indTc:indTc+3))); % number of blanks to average across
    NA_tmp2(7) = (N_tmp1 - NT_tmp2(7))/mcount; % total minus Tenured, averaged across number of blanks
    clear N_tmp1 mcount
    
    % save group data
    yr_A = [yr_A yr_tmp];
    yr_T = [yr_T yr_tmp];

    % (cut out total)
    % rotate data
    N_AP = [N_AP; NA_tmp1(2:8)' + NA_tmp2(2:8)'];
    N_TP = [N_TP; NT_tmp1(2:8)' + NT_tmp2(2:8)'];
    % White
    % Asian
    % Black
    % Hispanic
    % American Indian/ Alaskan  Native
    % Native Hawaiian or Other Pacific Islander
    % Multiple race
    clear data TXT indTc indAc indr1 indr2 tmp2 tmp
    clear yr_tmp NA_tmp1 NA_tmp2 NT_tmp1 NT_tmp2
%-----2015----------------------------------------------------------------%


%-----2017----------------------------------------------------------------%
    yr_tmp = 2017; % set years
    % load NSF data
    [data,TXT]=xlsread('../../NSF data/WMPD/2019 report - part/wmpd19-sr-tab09-026.xlsx');
    % offset by this amount to map from row in excel to row in data
    tmp = 5; % rows of text at the start of file
    tmp2 = 1; % columns of text at the start of file

    % Total                                  
    % White                           
    % Asian                           
    % Black or African American                           
    % Hispanic or Latino (Hispanic or Latino may be any race.)
    % American Indian or Alaska Native 
    % Native Hawaiian or Other Pacific Islander
    % More than one race (Includes persons of more than one race who are not
    %   Hispanic or Latino.)
    indTc = 3 - tmp2;
    indAc = 4 - tmp2;
    indr1 = [24:31] - tmp;
    indr2 = [32:39] - tmp;

    NT_tmp1 = data(indr1,indTc); % extract groups
    NA_tmp1 = data(indr1,indAc); % extract groups
    NT_tmp2 = data(indr2,indTc); % extract groups
    NA_tmp2 = data(indr2,indAc); % extract groups
    
    % Note(s): Numbers rounded to nearest 50. Detail may not add to total
    %  because of rounding and suppression. S&E occupations include S&E
    %  postsecondary teachers. S&E occupations include S&E postsecondary
    %  teachers. S&E-related occupations include health-related occupations
    %  (e.g. diagnosing practitioners, registered nurses, postsecondary
    %  teachers in health and related sciences), S&E managers, S&E precollege
    %  teachers, S&E technicians and technologists, and other S&E related occupations.

    % Female Hawaiian
    N_tmp1 = data(30-tmp,indTc-1);  % total Female Hawaiian
    mcount = sum(isnan(data(30-tmp,indTc:indTc+3))); % number of blanks to average across
    NA_tmp1(7) = (N_tmp1)/mcount; % total, averaged across number of blanks
    NT_tmp1(7) = (N_tmp1)/mcount; % total, averaged across number of blanks
    clear N_tmp1 mcount
    
    % Male American Indian
    N_tmp1 = data(37-tmp,indTc-1);  % total male American Indian
    mcount = sum(isnan(data(37-tmp,indTc:indTc+3))); % number of blanks to average across
    NA_tmp2(6) = (N_tmp1 - NT_tmp2(6))/mcount; % total minus Tenured, averaged across number of blanks
    clear N_tmp1 mcount

    % Male Hawaiian
    N_tmp1 = data(38-tmp,indTc-1);  % total male Hawaiian
    mcount = sum(isnan(data(38-tmp,indTc:indTc+3))); % number of blanks to average across
    NA_tmp2(7) = (N_tmp1 - NT_tmp2(7))/mcount; % total minus Tenured, averaged across number of blanks
    clear N_tmp1 mcount
    
    % save group data
    yr_A = [yr_A yr_tmp];
    yr_T = [yr_T yr_tmp];

    % (cut out total)
    % rotate data
    N_AP = [N_AP; NA_tmp1(2:8)' + NA_tmp2(2:8)'];
    N_TP = [N_TP; NT_tmp1(2:8)' + NT_tmp2(2:8)'];
    % White
    % Asian
    % Black
    % Hispanic
    % American Indian/ Alaskan  Native
    % Native Hawaiian or Other Pacific Islander
    % Multiple race
    clear data TXT indTc indAc indr1 indr2 tmp2 tmp
    clear yr_tmp NA_tmp1 NA_tmp2 NT_tmp1 NT_tmp2
%-----2017----------------------------------------------------------------%

% save data as a CSV
fname='N_NSF_AP.csv';
textlabel =  {'year','White (sometimes also non-Hispanic)','Asian (somestimes also Pacific Islander)','Black (sometimes also non-Hispanic)','Hispanic','American Indian (sometimes also Alaskan Native)','Native Hawaiian (when reported)','Multiple races (when reported)'};
writetable(cell2table([textlabel; num2cell([yr_A' N_AP])]),fname,'writevariablenames',0)
fname='N_NSF_TP.csv';
textlabel =  {'year','White (sometimes also non-Hispanic)','Asian (somestimes also Pacific Islander)','Black (sometimes also non-Hispanic)','Hispanic','American Indian (sometimes also Alaskan Native)','Native Hawaiian (when reported)','Multiple races (when reported)'};
writetable(cell2table([textlabel; num2cell([yr_T' N_TP])]),fname,'writevariablenames',0)
