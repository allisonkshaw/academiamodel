function do_group_data_retrieval_GR
% USAGE: do_group_data_retrieval_GR
% written July 2020  by Allison Shaw (contact ashaw@umn.edu for assistance)
% last updated 6 May 2021
%
% retrieve data on graduate students by ethnicity/race over time
%
% DATA SOURCES:
% Women, Minorities, and Persons with Disabilities in Science and Engineering report.
%    https://www.nsf.gov/statistics/women/
%  2002 report 
%     Table 4-6 = 1990-1999 graduate students by race/ethnicity [saved as xlsx first to import]
%  2009 report
%     Table D-1 = 1999-2006 grad enrollment [saved as xlsx first to import]
%  2011 report
%     Table 3-1 [tab3-1_updated_2011_02.xls] = 2008 grad enrollment
%     Table 3-1 [tab3-1_updated_2012_01.xls] = 2009 grad enrollment [saved as xlsx first to import]
%     Table 3-1 [tab3-1.xls] = 2010 grad enrollment [saved as xlsx first to import]
%  2013 report
%     Table 3-1 [tab3-1_updated_2014_10.xlsx] = 2012 grad enrollment
%  2017 report
%     Table 3-1 = 2014 grad enrollment
%  2019 report
%     Table 3-1 = 2016 grad enrollment
%
% CATEGORIES:
%   White
%   Asian (sometimes also Pacific Islander)
%   Black
%   Hispanic
%   American Indian/Alaskan Native
%   Native Hawaiian  or Other Pacific Islander (when reported)
%   More than one race (when reported)
%   Unknown
%   Temporary resident
%
% OUTPUT: No direct output, but the following .csv file is generated:
%   N_NSF_GR.csv: years, number of graduate students by group (column) for years (rows)


%-----1990-1999[1998]-----------------------------------------------------%
    % load NSF data
    [data,TXT]=xlsread('../../NSF data/WMPD/2002 report - part/at04-06_ed.xlsx');
    % offset by this amount to map from row in excel to row in data
    tmp = 5; % rows of text at the start of file

    % Total
    %   U.S. citizens and permanent residents, total
    %     White, non-hispanic
    %     Asian/Pacific Islanders
    %     Black, non-hispanic
    %     Hispanic
    %     American Indian/Alaskan Native
    %     Unknown race/ethnicity
    %   Temporary resident
    ind = [6:14] - tmp;

    yr_tmp = cellfun(@str2num,TXT(5,2:11)); % extract years
    N_tmp = data(ind,:); % extract groups
    clear ind data TXT tmp

    % check that interpretations are correct:
    % [A] first row (total) is sum of second (citizens) and last (temp resident)
    if sum(abs(N_tmp(1,:) - sum(N_tmp([2 end],:)))) > 0; error('GR data interpretation incorrect'); end
    % [B] second row (citizens) is sum of third through second to last (by race/ethnicity)
    if sum(abs(N_tmp(2,:) - sum(N_tmp([3:end-1],:)))) > 0; error('GR data interpretation incorrect'); end


    % (cut out total, citizen)
    % transpose so that rows are years
    N_tmp = N_tmp(3:end,:)';
    % White, non-hispanic
    % Asian/Pacific Islanders
    % Black, non-hispanic
    % Hispanic
    % American Indian/Alaskan Native
    % Unknown race/ethnicity
    % Temporary resident
    
    yr_G = yr_tmp(1:end-1);
    N_GR = N_tmp(1:end-1,:);
    clear N_tmp yr_tmp
%-----1990-1999[1998]-----------------------------------------------------%


%-----1999-2006-----------------------------------------------------------%
    % load NSF data
    [data,TXT]=xlsread('../../NSF data/WMPD/2009 report/data/tables/tabd-1_ed.xlsx');
    % offset by this amount to map from row in excel to row in data
    tmp = 1; % rows of text at the start of file

    % Total
    %   U.S. citizens and permanent residents, total
    %     White
    %     Asian/Pacific Islanders
    %     Black, non-hispanic
    %     Hispanic
    %     American Indian/Alaskan Native
    %     Other or unknown race/ethnicity
    %   Temporary resident
    ind = [3 68 133 198 263 328 393 458 523] - tmp;

    yr_tmp = data(1,:); % extract years
    N_tmp = data(ind,:); % extract groups
    clear ind data TXT tmp

    % check that interpretations are correct:
    % [A] first row (total) is sum of second (citizens) and last (temp resident)
    if sum(abs(N_tmp(1,:) - sum(N_tmp([2 end],:)))) > 0; error('GR data interpretation incorrect'); end
    % [B] second row (citizens) is sum of third through second to last (by race/ethnicity)
    if sum(abs(N_tmp(2,:) - sum(N_tmp([3:end-1],:)))) > 0; error('GR data interpretation incorrect'); end


    % (cut out total, citizen)
    % transpose so that rows are years
    N_tmp = N_tmp(3:end,:)';
    % White, non-hispanic
    % Asian/Pacific Islanders
    % Black, non-hispanic
    % Hispanic
    % American Indian/Alaskan Native
    % Unknown race/ethnicity
    % Temporary resident
    
    yr_G = [yr_G yr_tmp];
    N_GR = [N_GR; N_tmp];
    clear N_tmp yr_tmp

%-----1999-2006-----------------------------------------------------------%


%-----2008----------------------------------------------------------------%
    yr_tmp = 2008; % extract years
    % load NSF data
    [data,TXT]=xlsread('../../NSF data/WMPD/2011 report/data/tables/tab3-1_updated_2011_02.xls');
    % offset by this amount to map from row in excel to row in data
    tmp = 3; % rows of text at the start of file

    % Total
    %   White
    %   Asian/Pacific Islanders
    %   Black
    %   Hispanic
    %   American Indian/Alaskan Native
    %   Other/unknown
    %   Temporary resident
    ind = 4 - tmp;

    N_tmp = data(ind,:); % extract groups
    clear ind data TXT tmp

    % check that interpretations are correct:
    % [A] first (total) is sum of the others
    if sum(abs(N_tmp(1) - sum(N_tmp(2:end)))) > 0; error('GR data interpretation incorrect'); end

    % (cut out total)
    N_tmp = N_tmp(2:end);
    % White
    % Asian/Pacific Islanders
    % Black
    % Hispanic
    % American Indian/Alaskan Native
    % Other/unknown
    % Temporary resident
    
    yr_G = [yr_G yr_tmp];
    N_GR = [N_GR; N_tmp];
    clear N_tmp yr_tmp
%-----2008---------------------------------------------------------------%


%-----2009----------------------------------------------------------------%
    yr_tmp = 2009; % extract years
    % load NSF data
    [data,TXT]=xlsread('../../NSF data/WMPD/2011 report/data/tables/tab3-1_updated_2012_01_ed.xlsx');
    % offset by this amount to map from row in excel to row in data
    tmp = 3; % rows of text at the start of file

    % Total
    %   White
    %   Asian/Pacific Islanders [Includes Asian and Native Hawaiian/Other Pacific Islander]
    %   Black
    %   Hispanic [Includes Hispanic/Latino of one or more races.]
    %   American Indian/Alaskan Native
    %   Other/unknown [Includes Non-Hispanic/Latino of more than one race and/or ethnicity/race unknown or not stated.]
    %   Temporary resident
    ind = 4 - tmp;

    N_tmp = data(ind,:); % extract groups
    clear ind data TXT tmp

    % check that interpretations are correct:
    % [A] first (total) is sum of the others
    if sum(abs(N_tmp(1) - sum(N_tmp(2:end)))) > 0; error('GR data interpretation incorrect'); end

    % (cut out total)
    N_tmp = N_tmp(2:end);
    % White
    % Asian/Pacific Islanders
    % Black
    % Hispanic
    % American Indian/Alaskan Native
    % Other/unknown
    % Temporary resident
    
    yr_G = [yr_G yr_tmp];
    N_GR = [N_GR; N_tmp];
    clear N_tmp yr_tmp
%-----2009---------------------------------------------------------------%


%-----2010----------------------------------------------------------------%
    yr_tmp = 2010; % extract years
    % load NSF data
    [data,TXT]=xlsread('../../NSF data/WMPD/2011 report/data/tables/tab3-1_ed.xlsx');
    % offset by this amount to map from row in excel to row in data
    tmp = 4; % rows of text at the start of file

    % Total
    %   White
    %   Asian/Pacific Islanders [Includes Asian and Native Hawaiian/Other Pacific Islander]
    %   Black
    %   Hispanic [Includes Hispanic/Latino of one or more races.]
    %   American Indian/Alaskan Native
    %   Other/unknown [Includes Non-Hispanic/Latino of more than one race and/or ethnicity/race unknown or not stated.]
    %   Temporary resident
    ind = 5 - tmp;

    N_tmp = data(ind,:); % extract groups
    clear ind data TXT tmp

    % check that interpretations are correct:
    % [A] first (total) is sum of the others
    if sum(abs(N_tmp(1) - sum(N_tmp(2:end)))) > 0; error('GR data interpretation incorrect'); end

    % (cut out total)
    N_tmp = N_tmp(2:end);
    % White
    % Asian/Pacific Islanders
    % Black
    % Hispanic
    % American Indian/Alaskan Native
    % Other/unknown
    % Temporary resident
    
    yr_G = [yr_G yr_tmp];
    N_GR = [N_GR; N_tmp];
    clear N_tmp yr_tmp
%-----2010---------------------------------------------------------------%


%-----2012----------------------------------------------------------------%
    yr_tmp = 2012; % extract years
    % load NSF data
    [data,TXT]=xlsread('../../NSF data/WMPD/2013 report/data/tables/tab3-1_updated_2014_10.xlsx');
    % offset by this amount to map from row in excel to row in data
    tmp = 5; % rows of text at the start of file
    tmp2 = 1; % columns of text at the start of file
    
    % Total
    % Hispanic or Latino
    % American Indian or Alaska Native
    % Asian
    % Black or African American
    % Native Hawaiian  or Other Pacific Islander
    % White
    % More than one race	
    % Unknown ethnicity and race
    % Temporary visa holders
    ind = 6 - tmp;
    indc = [2 4 6:11 13 14] - tmp2;

    N_tmp = data(ind,indc); % extract groups
    clear ind indc data TXT tmp tmp2

    % check that interpretations are correct:
    % [A] first (total) is sum of the others
    if sum(abs(N_tmp(1) - sum(N_tmp(2:end)))) > 0; error('GR data interpretation incorrect'); end


    % (cut out total and reorder)
    N_tmp = N_tmp([7 4 5 2 3 6 8 9 10]);
    % White
    % Asian
    % Black or African American
    % Hispanic or Latino
    % American Indian or Alaska Native
    % Native Hawaiian  or Other Pacific Islander
    % More than one race
    % Unknown ethnicity and race
    % Temporary visa holders
    
    % add NaNs for missing data on native hawaiian and multiple races
    % before
    N_GR_new = [N_GR(:,1:5) NaN(size(N_GR,1),2) N_GR(:,6:7)];
    
    yr_G = [yr_G yr_tmp];
    N_GR = [N_GR_new; N_tmp];
    clear N_tmp yr_tmp N_GR_new
%-----2012---------------------------------------------------------------%


%-----2014----------------------------------------------------------------%
    yr_tmp = 2014; % extract years
    % load NSF data
    [data,TXT]=xlsread('../../NSF data/WMPD/2017 report - part/tab3-1.xlsx');
    % offset by this amount to map from row in excel to row in data
    tmp = 4; % rows of text at the start of file
    tmp2 = 1; % columns of text at the start of file
    
    % Total
    % Hispanic or Latino
    % American Indian or Alaska Native
    % Asian
    % Black or African American
    % Native Hawaiian  or Other Pacific Islander
    % White
    % More than one race	
    % Unknown ethnicity and race
    % Temporary visa holders
    ind = 5 - tmp;
    indc = [2:11] - tmp2;

    N_tmp = data(ind,indc); % extract groups
    clear ind indc data TXT tmp tmp2

    % check that interpretations are correct:
    % [A] first (total) is sum of the others
    if sum(abs(N_tmp(1) - sum(N_tmp(2:end)))) > 0; error('GR data interpretation incorrect'); end

    % (cut out total and reorder)
    N_tmp = N_tmp([7 4 5 2 3 6 8 9 10]);
    % White
    % Asian
    % Black or African American
    % Hispanic or Latino
    % American Indian or Alaska Native
    % Native Hawaiian  or Other Pacific Islander
    % More than one race
    % Unknown ethnicity and race
    % Temporary visa holders
    
    yr_G = [yr_G yr_tmp];
    N_GR = [N_GR; N_tmp];
    clear N_tmp yr_tmp
%-----2014---------------------------------------------------------------%


%-----2016----------------------------------------------------------------%
    yr_tmp = 2016; % extract years
    % load NSF data
    [data,TXT]=xlsread('../../NSF data/WMPD/2019 report - part/wmpd19-sr-tab03-001.xlsx');
    % offset by this amount to map from row in excel to row in data
    tmp = 6; % rows of text at the start of file
    tmp2 = 1; % columns of text at the start of file
    
    % Total
    % Hispanic or Latino
    % American Indian or Alaska Native
    % Asian
    % Black or African American
    % Native Hawaiian  or Other Pacific Islander
    % White
    % More than one race	
    % Unknown ethnicity and race
    % Temporary visa holders
    ind = 7 - tmp;
    indc = [2:11] - tmp2;

    N_tmp = data(ind,indc); % extract groups
    clear ind indc data TXT tmp tmp2

    % check that interpretations are correct:
    % [A] first (total) is sum of the others
    if sum(abs(N_tmp(1) - sum(N_tmp(2:end)))) > 0; error('GR data interpretation incorrect'); end


    % (cut out total and reorder)
    N_tmp = N_tmp([7 4 5 2 3 6 8 9 10]);
    % White
    % Asian
    % Black or African American
    % Hispanic or Latino
    % American Indian or Alaska Native
    % Native Hawaiian  or Other Pacific Islander
    % More than one race
    % Unknown ethnicity and race
    % Temporary visa holders
    
    yr_G = [yr_G yr_tmp];
    N_GR = [N_GR; N_tmp];
    clear N_tmp yr_tmp
%-----2016---------------------------------------------------------------%

% save data as a CSV
fname='N_NSF_GR.csv';
textlabel =  {'year','White','Asian (somestimes also Pacific Islander)','Black','Hispanic','American Indian/Alaskan Native','Native Hawaiian or Other Pacific Islander (when reported)','More than one race (when reported)','Unknown','Temporary resident'};
writetable(cell2table([textlabel; num2cell([yr_G' N_GR])]),fname,'writevariablenames',0)
