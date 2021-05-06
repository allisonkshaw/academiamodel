function do_group_data_retrieval_residency
% USAGE: do_group_data_retrieval_residency
% written August 2020  by Allison Shaw (contact ashaw@umn.edu for assistance)
% last updated 6 May 2021
%
% retrieve data on doctoral workforce by ethnicity/race and citizenship over time
%
% DATA SOURCES:
% Women, Minorities, and Persons with Disabilities in Science and Engineering report.
%    https://www.nsf.gov/statistics/women/
%  1994 report
%     Table 8-11 = 1991 doctoral workforce by citizenship
%  1996 report
%     Table 5-33 = 1993 doctoral workforce by citizenship
% Survey of Earned Doctorates
%    https://www.nsf.gov/statistics/srvydoctorates/
%  2010 report
%     Table 19 = 2000–2010 Doctorate recipients, by ethnicity/race and citizenship 
%     Table 23 = 1990–2010 Doctorate recipients, by ethnicity/race for US citizens
%  2014 report
%     Table 17 = 1984:5:2014 Doctorate recipients, by broad field of study and citizenship
%  2015 report
%     Table 17 = 1985:5:2015 Doctorate recipients, by broad field of study and citizenship
%  2016 report
%     Table 17 = 1986:5:2016 Doctorate recipients, by broad field of study and citizenship
%  2017 report
%     Table 17 = 1987:5:2017 Doctorate recipients, by broad field of study and citizenship
%  2018 report
%     Table 17 = 1993:5:2018 Doctorate recipients, by broad field of study and citizenship
%     Table 19 = 2009–2018 Doctorate recipients, by ethnicity/race and citizenship 
%
% CATEGORIES
%   White (sometimes also non-Hispanic)
%   Asian (sometimes also Pacific Islander)
%   Black (sometimes also non-Hispanic)
%   Hispanic
%   American Indian (sometimes also Alaskan Native)
%   Hawaiian [no data, but keep as place holder]
%   More than one race
%
% OUTPUT: No direct output, but the following .csv files are generated:
%   N_GRD_res.csv: years, number of doctoral degrees that are granted to 
%     (i) US  citizens/permanent residents or (ii) temporary residents
%   N_NSF_tempres.csv: years, number of doctoral degrees that are granted
%     to individuals by group (columns) for years (rows)
%   N_NSF_permres.csv: years, number of doctoral degrees that are granted
%     to individuals by group (columns) for years (rows)
%
% NOTES:
% * American Indian
%	masked for 1991, 1993

%----- [1] import number of GRD by residency group
yr_GRD_res = [];
N_GRD_res = [];


%-----1993:5:2018---------------------------------------------------------%
    % load NSF data
    [data,TXT]=xlsread('../../NSF data/SED/2018 report - part/nsf20301-tab017.xlsx');
    % offset by this amount to map from row in excel to row in data
    tmp = 3; % rows of text at the start of file

    % All
    % U.S. citizen or permanent resident
    % Temporary visa holder
    % Unknown
    indr = [5:8] - tmp;

    yr_tmp = data(1,:); % set years

    N_tmp = data(indr,:); % extract groups
    
    % check that interpretations are correct:
    % [A] first row (total) is sum of other two
    if sum(abs(N_tmp(1,:) - sum(N_tmp(2:end,:)))) > 0; error('data interpretation incorrect'); end

    % rotate so years are rows
    N_tmp = N_tmp';

    % save group data
    yr_GRD_res = [yr_GRD_res yr_tmp];
    N_GRD_res = [N_GRD_res; N_tmp];

    clear data TXT tmp ind* yr_tmp N_tmp
%-----1993:5:2018---------------------------------------------------------%


%-----1987:5:2017---------------------------------------------------------%
    % load NSF data
    [data,TXT]=xlsread('../../NSF data/SED/2017 report - part/sed17-sr-tab017.xlsx');
    % offset by this amount to map from row in excel to row in data
    tmp = 3; % rows of text at the start of file

    % All
    % U.S. citizen or permanent resident
    % Temporary visa holder
    % Unknown
    indr = [5:8] - tmp;

    yr_tmp = data(1,:); % set years

    N_tmp = data(indr,:); % extract groups
    
    % check that interpretations are correct:
    % [A] first row (total) is sum of other two
    if sum(abs(N_tmp(1,:) - sum(N_tmp(2:end,:)))) > 0; error('data interpretation incorrect'); end

    % rotate so years are rows
    N_tmp = N_tmp';

    % save group data
    yr_GRD_res = [yr_GRD_res yr_tmp];
    N_GRD_res = [N_GRD_res; N_tmp];

    clear data TXT tmp ind* yr_tmp N_tmp
%-----1987:5:2017---------------------------------------------------------%


%-----1986:5:2016---------------------------------------------------------%
    % load NSF data
    [data,TXT]=xlsread('../../NSF data/SED/2016 report - part/tab17.xlsx');
    % offset by this amount to map from row in excel to row in data
    tmp = 3; % rows of text at the start of file

    % All
    % U.S. citizen or permanent resident
    % Temporary visa holder
    % Unknown
    indr = [5:8] - tmp;

    yr_tmp = data(1,:); % set years

    N_tmp = data(indr,:); % extract groups
    
    % check that interpretations are correct:
    % [A] first row (total) is sum of other two
    if sum(abs(N_tmp(1,:) - sum(N_tmp(2:end,:)))) > 0; error('data interpretation incorrect'); end

    % rotate so years are rows
    N_tmp = N_tmp';

    % save group data
    yr_GRD_res = [yr_GRD_res yr_tmp];
    N_GRD_res = [N_GRD_res; N_tmp];

    clear data TXT tmp ind* yr_tmp N_tmp
%-----1986:5:2016---------------------------------------------------------%


%-----1985:5:2015---------------------------------------------------------%
    % load NSF data
    [data,TXT]=xlsread('../../NSF data/SED/2015 report - part/tab17.xlsx');
    % offset by this amount to map from row in excel to row in data
    tmp = 3; % rows of text at the start of file

    % All
    % U.S. citizen or permanent resident
    % Temporary visa holder
    % Unknown
    indr = [5:8] - tmp;

    yr_tmp = data(1,:); % set years

    N_tmp = data(indr,:); % extract groups
    
    % check that interpretations are correct:
    % [A] first row (total) is sum of other two
    if sum(abs(N_tmp(1,:) - sum(N_tmp(2:end,:)))) > 0; error('data interpretation incorrect'); end

    % rotate so years are rows
    N_tmp = N_tmp';

    % save group data
    yr_GRD_res = [yr_GRD_res yr_tmp];
    N_GRD_res = [N_GRD_res; N_tmp];

    clear data TXT tmp ind* yr_tmp N_tmp
%-----1985:5:2015---------------------------------------------------------%


%-----1984:5:2014---------------------------------------------------------%
    % load NSF data
    [data,TXT]=xlsread('../../NSF data/SED/2014 report - part/tab17.xlsx');
    % offset by this amount to map from row in excel to row in data
    tmp = 1; % rows of text at the start of file

    % All
    % U.S. citizen or permanent resident
    % Temporary visa holder
    % Unknown
    indr = [4:7] - tmp;

    yr_tmp = data(1,:); % set years

    N_tmp = data(indr,:); % extract groups
    
    % check that interpretations are correct:
    % [A] first row (total) is sum of other two
    if sum(abs(N_tmp(1,:) - sum(N_tmp(2:end,:)))) > 0; error('data interpretation incorrect'); end

    % rotate so years are rows
    N_tmp = N_tmp';

    % save group data
    yr_GRD_res = [yr_GRD_res yr_tmp];
    N_GRD_res = [N_GRD_res; N_tmp];

    clear data TXT tmp ind* yr_tmp N_tmp
%-----1984:5:2014---------------------------------------------------------%

% sort data by year
[a,b] = sort(yr_GRD_res);
yr_GRD_res = yr_GRD_res(b);
N_GRD_res = N_GRD_res(b,:);
clear a b

% cut out total and unknown
% leaving US citizens/perm. residents and then temp. residents
N_GRD_res = N_GRD_res(:,2:3);

%----- [2] import rough number of individuals of each race/ethnicity to use for
%  temporary resident GRDs
yr_NSF_tempres = [];
N_NSF_tempres = [];
yr_NSF_permres = [];
N_NSF_permres = [];

%-----1991----------------------------------------------------------------%
    yr_tmp = 1991; % set years
    % load NSF data
    [data,TXT]=xlsread('../../NSF data/WMPD/1994 report - part/appn8-11.xls');
    % offset by this amount to map from row in excel to row in data
    tmp = 10; % rows of text at the start of file

    % Total
    %   White, non-hispanic
    %   Black, non-hispanic
    %   Hispanic
    %   Asian
    %   American Indian
    indr = [11:16] - tmp; % row (all S&E)
    indc = 7; % temp resident

    N_tmp = data(indr,indc); % extract groups
    % NOTE from report: Because of rounding, other races, and "no reports," details may not add to totals.

    % reorder
    % (cut out total)
    % also swap so rows are years
    N_tmp = N_tmp([2 5 3 4 6])'; 
    %   White, non-hispanic
    %   Asian
    %   Black, non-hispanic
    %   Hispanic
    %   American Indian
    
    % swap NaN for American Indian to be zero
    i=isnan(N_tmp);
    N_tmp(i)=0;
    
    % add Hawaiian/Multipe race place holders
    N_tmp = [N_tmp NaN NaN];

    % save group data
    yr_NSF_tempres = [yr_NSF_tempres yr_tmp];
    N_NSF_tempres = [N_NSF_tempres; N_tmp];
    
    clear data TXT tmp ind* yr_tmp NTR_tmp i
%-----1991----------------------------------------------------------------%


%-----1993----------------------------------------------------------------%
    yr_tmp = 1993; % set years
    % load NSF data
    [data,TXT]=xlsread('../../NSF data/WMPD/1996 report - part/at5-33.xls');
    % offset by this amount to map from row in excel to row in data
    tmp = 0; % rows of text at the start of file
    
    % Total
    %   White
    %   Black
    %   Hispanic
    %   Asian
    %   American Indian
    indr = [8 18 28 38 48 58] - tmp; % row (all S&E)
    indc = 14; % temp resident
    
    N_tmp = data(indr,indc); % extract groups
    % NOTE: American Indian = fewer than 50 estimated
    
    % reorder
    % (cut out total)
    % also swap so rows are years
    N_tmp = N_tmp([2 5 3 4 6])'; 
    %   White, non-hispanic
    %   Asian
    %   Black, non-hispanic
    %   Hispanic
    %   American Indian
    
    % add Hawaiian/Multipe race place holders
    N_tmp = [N_tmp NaN NaN];

    % save group data
    yr_NSF_tempres = [yr_NSF_tempres yr_tmp];
    N_NSF_tempres = [N_NSF_tempres; N_tmp];
    
    clear data TXT tmp ind* yr_tmp N_tmp
%-----1993----------------------------------------------------------------%


%-----2000-2010(temp res)-------------------------------------------------%
    % load NSF data
    [data,TXT]=xlsread('../../NSF data/SED/2010 report/data/tab19_ed.xlsx');
    % offset by this amount to map from row in excel to row in data
    tmp = 1; % rows of text at the start of file

    % Total
    % American Indian/ Alaskan  Native
    % Asian
    % Black
    % Hispanic
    % White
    % Multiple races
    % Other/unknown (includes Native Hawaiian and Pacific Islanders)
    indr = [6 11 16 21 26 31 36 41] - tmp;

    yr_tmp = data(1,:); % set years

    N_tmp = data(indr,:); % extract groups
    % some missing data for native americans and other

    % estimate missing data for Native American
    N1_tmp = data(9 - tmp,8:9); % all Native American
    N2_tmp = data(10 - tmp,8:9); % US citizen Native American
    N_tmp(2,8:9)  = N1_tmp - N2_tmp;

    % reorder
    % (cut out total, other/unknown)
    % also swap so rows are years
    N_tmp2 = N_tmp([6 3 4 5 2],:)';
    %   White, non-hispanic
    %   Asian
    %   Black, non-hispanic
    %   Hispanic
    %   American Indian
    
    % add Hawaiian place holder
    N_tmp2 = [N_tmp2 NaN(length(yr_tmp),1)];
    
    % add in multipe race
    N_tmp = [N_tmp2 N_tmp(7,:)'];

    % save group data
    yr_NSF_tempres = [yr_NSF_tempres yr_tmp(1:end-2)];
    N_NSF_tempres = [N_NSF_tempres; N_tmp(1:end-2,:)];

    clear data TXT tmp ind* N1_tmp N2_tmp yr_tmp N_tmp N_tmp2
%-----2000-2010(temp res)-------------------------------------------------%


%-----1990-2010(perm res)-------------------------------------------------%
    % load NSF data
    [data,TXT]=xlsread('../../NSF data/SED/2010 report/data/tab23_ed.xlsx');
    % offset by this amount to map from row in excel to row in data
    tmp = 1; % rows of text at the start of file

    % Total
    % American Indian/ Alaskan  Native
    % Asian
    % Black
    % Hispanic
    % White
    % Multiple races
    % Other/unknown (includes Native Hawaiian and Pacific Islanders)
    indr = [4:11] - tmp;

    yr_tmp = data(1,:); % set years

    N_tmp = data(indr,:); % extract groups
    % some missing data for multi-race and other

    % reorder
    % (cut out total, other/unknown)
    % also swap so rows are years
    N_tmp2 = N_tmp([6 3 4 5 2],:)';
    %   White, non-hispanic
    %   Asian
    %   Black, non-hispanic
    %   Hispanic
    %   American Indian

    % add Hawaiian place holder
    N_tmp2 = [N_tmp2 NaN(length(yr_tmp),1)];
    
    % add in multipe race
    N_tmp = [N_tmp2 N_tmp(7,:)'];
   
    % save group data
    yr_NSF_permres = [yr_NSF_permres yr_tmp(1:end-1)];
    N_NSF_permres = [N_NSF_permres; N_tmp(1:end-1,:)];

    clear data TXT tmp ind* yr_tmp N_tmp N_tmp2
%-----1990-2010(perm res)-------------------------------------------------%


%-----2009-2018-----------------------------------------------------------%
    % load NSF data
    [data,TXT]=xlsread('../../NSF data/SED/2018 report - part/nsf20301-tab019.xlsx');
    % offset by this amount to map from row in excel to row in data
    tmp = 3; % rows of text at the start of file

    % Total
    % Hispanic or Latino
    % American Indian/ Alaskan  Native
    % Asian
    % Black
    % White
    % Multiple races
    % Other/unknown (includes Native Hawaiian and Pacific Islanders)
    % Ethnicity not reported
     indr = [7 11 16 20 24 28 32 36 40] - tmp;
     indr2 = indr - 1;

     yr_tmp = data(1,:); % set years
     
     N_tmp = data(indr,:); % extract groups for temp residents
     N_tmp2 = data(indr2,:); % extract groups for perm residents
     % some missing data for native americans and multi-race
     
     % estimate missing data for Native American
     N1_tmp = data(14 - tmp,[4 9:10]); % all Native American
     N2_tmp = data(15 - tmp,[4 9:10]); % US citizen Native American
     N_tmp(3,[4 9:10])  = N1_tmp - N2_tmp;
     
     % estimate missing data for multiple races
     N1_tmp = data(30 - tmp,[9:10]); % all multiple races
     N2_tmp = data(31 - tmp,[9:10]); % US citizen multiple races
     N_tmp(7,[9:10])  = N1_tmp - N2_tmp;
    
    % reorder
    % (cut out total, other/unknown, not reported)
    % also swap so rows are years
    N_tmp3 = N_tmp([6 4 5 2 3],:)'; 
    N_tmp4 = N_tmp2([6 4 5 2 3],:)'; 
    % White
    % Asian
    % Black
    % Hispanic or Latino
    % American Indian/ Alaskan  Native
    
    % add Hawaiian place holder
    N_tmp3 = [N_tmp3 NaN(length(yr_tmp),1)];
    N_tmp4 = [N_tmp4 NaN(length(yr_tmp),1)];
    
    % add in multipe race
    N_tmp = [N_tmp3 N_tmp(7,:)'];
    N_tmp2 = [N_tmp4 N_tmp2(7,:)'];
    
    % save group data
    yr_NSF_tempres = [yr_NSF_tempres yr_tmp];
    yr_NSF_permres = [yr_NSF_permres yr_tmp];
    N_NSF_tempres = [N_NSF_tempres; N_tmp];
    N_NSF_permres = [N_NSF_permres; N_tmp2];

     clear data TXT tmp ind* N1_tmp N2_tmp yr_tmp N_tmp*
%-----2009-2018-----------------------------------------------------------%

% save data as a CSV
fname='N_GRD_res.csv';
textlabel =  {'year','US  citizens/permanent residents','temporary residents'};
writetable(cell2table([textlabel; num2cell([yr_GRD_res' N_GRD_res])]),fname,'writevariablenames',0)
    
fname='N_NSF_tempres.csv';
textlabel =  {'year','White (sometimes also non-Hispanic)','Asian (somestimes also Pacific Islander)','Black (sometimes also non-Hispanic)','Hispanic','American Indian (sometimes also Alaskan Native)','Native Hawaiian (no data)','More than one race'};
writetable(cell2table([textlabel; num2cell([yr_NSF_tempres' N_NSF_tempres])]),fname,'writevariablenames',0)

fname='N_NSF_permres.csv';
textlabel =  {'year','White (sometimes also non-Hispanic)','Asian (somestimes also Pacific Islander)','Black (sometimes also non-Hispanic)','Hispanic','American Indian (sometimes also Alaskan Native)','Native Hawaiian (no data)','More than one race'};
writetable(cell2table([textlabel; num2cell([yr_NSF_permres' N_NSF_permres])]),fname,'writevariablenames',0)

