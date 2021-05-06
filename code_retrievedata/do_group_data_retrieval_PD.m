function do_group_data_retrieval_PD
% USAGE: do_group_data_retrieval_PD
% written July 2020  by Allison Shaw (contact ashaw@umn.edu for assistance)
% last updated 6 May 2021
%
% retrieve data on postdocs by ethnicity/race over time
%
% DATA SOURCES:
% Survey of Graduate Students and Postdoctorates in Science and Engineering
%    https://www.nsf.gov/statistics/srvygradpostdoc/#tabs-2 
%  2010 report
%     Table 34 = 2010 postdocs, by ethnicity [saved as xlsx first to import]
%  2016 report
%     Table 34 = 2011-2016 postdocs, by ethnicity
%  2017 report
%     Table 2-2 = 2017 postdocs, by ethnicity
%  2018 report
%     Table 2-2 = 2018 postdocs, by ethnicity [re-saved first to import]
%
% CATEGORIES:
%   White
%   Asian (sometimes also Pacific Islander)
%   Black
%   Hispanic
%   American Indian/Alaskan Native
%   Native Hawaiian or Other Pacific Islander (when reported)
%   More than one race (when reported)
%   Unknown
%   Temporary resident
%
% OUTPUT: No direct output, but the following .csv file is generated:
%   N_NSF_PD.csv: years, number of postdocs by group (column) for years (rows)


%-----2010----------------------------------------------------------------%
    yr_tmp = 2010; % extract years
    % load NSF data
    [data,TXT]=xlsread('../../NSF data/GSPD/2010 report/tab34_ed.xlsx');
    % offset by this amount to map from row in excel to row in data
    tmp = 1; % rows of text at the start of file

    % All
    %   U.S. citizens and permanent residents
    %     Hispanic or Latino
    %     American Indian or Alaska Native
    %     Asian
    %     Black or African American
    %     Native Hawaiian or Other Pacific Islander
    %     White
    %     More than one race
    %     Unknown ethnicity/race
    %   Temporary visa holders
    ind = [18:20 22:29] - tmp;

    N_tmp = data(ind,end); % extract groups
    clear ind data TXT tmp

    % NOTES: In 2010, postdoc section of survey was expanded, and significant
    %   effort was made to ensure that appropriate personnel were providing
    %   postdoc data (see appendix A for more information). Thus it is unclear
    %   how much of increase reported in 2010 represents growth in postdoctoral
    %   appointments and how much results from improved data collection. More
    %   information on changes in postdoc data will be available in forthcoming
    %   InfoBrief at http://www.nsf.gov/statistics/gradpostdoc. Ethnicity and
    %   race of postdocs were collected for first time in 2010, and any missing
    %   data in this item were not imputed in 2010 because of lack of historical data.

    % check that interpretations are correct:
    % [A] first (total) is sum of second (citizens) and last (temp resident)
    if sum(abs(N_tmp(1) - sum(N_tmp([2 end])))) > 0; error('PD data interpretation incorrect'); end
    % [B] second row (citizens) is sum of third through second to last (by race/ethnicity)
    if sum(abs(N_tmp(2) - sum(N_tmp([3:end-1])))) > 0; error('PD data interpretation incorrect'); end

    % (cut out total, citizen)
    % reorder
    % transpose so that rows are years
    N_tmp = N_tmp([8 5 6 3 4 7 9 10 11],:)';
    % White
    % Asian
    % Black or African American
    % Hispanic or Latino
    % American Indian or Alaska Native
    % Native Hawaiian or Other Pacific Islanderc
    % More than one race
    % Unknown ethnicity/race
    % Temporary visa holders

    yr_P = yr_tmp;
    N_PD = N_tmp;
    clear N_tmp yr_tmp
%-----2010----------------------------------------------------------------%


%-----2011-2016-----------------------------------------------------------%
    yr_tmp = 2011:2016; % extract years
    % load NSF data
    [data,TXT]=xlsread('../../NSF data/GSPD/2016 report/GSS2016_DST_34.xlsx');
    % offset by this amount to map from row in excel to row in data
    tmp = 3; % rows of text at the start of file
    tmp2 = 1; % columns of text at the start of file

    % All
    %   U.S. citizens and permanent residents
    %     Hispanic or Latino
    %     American Indian or Alaska Native
    %     Asian
    %     Black or African American
    %     Native Hawaiian or Other Pacific Islanderc
    %     White
    %     More than one race
    %     Unknown ethnicity/race
    %   Temporary visa holders
    ind = [17:19 21:28] - tmp;
    indc = [2:4 6:8] - tmp2;
    
    N_tmp = data(ind,indc); % extract groups
    clear ind indc data TXT tmp tmp2

    % NOTES: In 2014, the survey frame was updated following a comprehensive
    %  frame evaluation study. The study identified potentially eligible but
    %  not previously surveyed academic institutions in the United States
    %  with master's- or doctorate-granting programs in science, engineering,
    %  or health. A total of 151 newly eligible institutions were added, and
    %  two private for-profit institutions offering mostly practitioner-based
    %  graduate degrees were determined to be ineligible.

    % check that interpretations are correct:
    % [A] first (total) is sum of second (citizens) and last (temp resident)
    if sum(abs(N_tmp(1,:) - sum(N_tmp([2 end],:)))) > 0; error('PD data interpretation incorrect'); end
    % [B] second row (citizens) is sum of third through second to last (by race/ethnicity)
    if sum(abs(N_tmp(2,:) - sum(N_tmp([3:end-1],:)))) > 0; error('PD data interpretation incorrect'); end
    
    % (cut out total, citizen)
    % reorder
    % transpose so that rows are years
    N_tmp = N_tmp([8 5 6 3 4 7 9 10 11],:)';
    % White
    % Asian
    % Black or African American
    % Hispanic or Latino
    % American Indian or Alaska Native
    % Native Hawaiian or Other Pacific Islanderc
    % More than one race
    % Unknown ethnicity/race
    % Temporary visa holders

    yr_P = [yr_P yr_tmp];
    N_PD = [N_PD; N_tmp];
    clear N_tmp yr_tmp
%-----2011-2016-----------------------------------------------------------%


%-----2017-----------------------------------------------------------%
    yr_tmp = 2017; % extract years
    % load NSF data
    [data,TXT]=xlsread('../../NSF data/GSPD/2017 report/gss17-dt-tab002-2.xlsx');
    % offset by this amount to map from row in excel to row in data
    tmp = 6; % rows of text at the start of file
    tmp2 = 1; % columns of text at the start of file

    % All
    %   U.S. citizens and permanent residents
    %     Hispanic or Latino
    %     American Indian or Alaska Native
    %     Asian
    %     Black or African American
    %     Native Hawaiian or Other Pacific Islanderc
    %     White
    %     More than one race
    %     Unknown ethnicity/race
    %   Temporary visa holders
    ind = [7:9 11:18] - tmp;
    indc = [8] - tmp2;
    
    N_tmp = data(ind,indc); % extract groups
    clear ind indc data TXT tmp tmp2

    % check that interpretations are correct:
    % [A] first (total) is sum of second (citizens) and last (temp resident)
    if sum(abs(N_tmp(1) - sum(N_tmp([2 end])))) > 0; error('PD data interpretation incorrect'); end
    % [B] second row (citizens) is sum of third through second to last (by race/ethnicity)
    if sum(abs(N_tmp(2) - sum(N_tmp([3:end-1])))) > 0; error('PD data interpretation incorrect'); end
    
    % (cut out total, citizen)
    % reorder
    % transpose so that rows are years
    N_tmp = N_tmp([8 5 6 3 4 7 9 10 11])';
    % White
    % Asian
    % Black or African American
    % Hispanic or Latino
    % American Indian or Alaska Native
    % Native Hawaiian or Other Pacific Islanderc
    % More than one race
    % Unknown ethnicity/race
    % Temporary visa holders

    yr_P = [yr_P yr_tmp];
    N_PD = [N_PD; N_tmp];
    clear N_tmp yr_tmp
%-----2017----------------------------------------------------------------%


%-----2018-----------------------------------------------------------%
    yr_tmp = 2018; % extract years
    % load NSF data
    [data,TXT]=xlsread('../../NSF data/GSPD/2018 report/gss18-dt-tab002-2_ed.xlsx');
    % offset by this amount to map from row in excel to row in data
    tmp = 6; % rows of text at the start of file
    tmp2 = 1; % columns of text at the start of file

    % All
    %   U.S. citizens and permanent residents
    %     Hispanic or Latino
    %     American Indian or Alaska Native
    %     Asian
    %     Black or African American
    %     Native Hawaiian or Other Pacific Islanderc
    %     White
    %     More than one race
    %     Unknown ethnicity/race
    %   Temporary visa holders
    ind = [7:9 11:18] - tmp;
    indc = [8] - tmp2;
    
    N_tmp = data(ind,indc); % extract groups
    clear ind indc data TXT tmp tmp2

    % check that interpretations are correct:
    % [A] first (total) is sum of second (citizens) and last (temp resident)
    if sum(abs(N_tmp(1) - sum(N_tmp([2 end])))) > 0; error('PD data interpretation incorrect'); end
    % [B] second row (citizens) is sum of third through second to last (by race/ethnicity)
    if sum(abs(N_tmp(2) - sum(N_tmp([3:end-1])))) > 0; error('PD data interpretation incorrect'); end
    
    % (cut out total, citizen)
    % reorder
    % transpose so that rows are years
    N_tmp = N_tmp([8 5 6 3 4 7 9 10 11])';
    % White
    % Asian
    % Black or African American
    % Hispanic or Latino
    % American Indian or Alaska Native
    % Native Hawaiian or Other Pacific Islanderc
    % More than one race
    % Unknown ethnicity/race
    % Temporary visa holders

    yr_P = [yr_P yr_tmp];
    N_PD = [N_PD; N_tmp];
    clear N_tmp yr_tmp N_tmp2
%-----2018----------------------------------------------------------------%

% save data as a CSV
fname='N_NSF_PD.csv';
textlabel =  {'year','White','Asian (somestimes also Pacific Islander)','Black','Hispanic','American Indian/Alaskan Native','Native Hawaiian or Other Pacific Islander (when reported)','More than one race (when reported)','Unknown','Temporary resident'};
writetable(cell2table([textlabel; num2cell([yr_P' N_PD])]),fname,'writevariablenames',0)
