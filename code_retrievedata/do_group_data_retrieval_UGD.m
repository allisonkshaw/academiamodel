function do_group_data_retrieval_UGD
% USAGE: do_group_data_retrieval_UGD
% written July 2020  by Allison Shaw (contact ashaw@umn.edu for assistance)
% last updated 6 May 2021
%
% retrieve data on bachelors degrees by ethnicity/race over time
%
% DATA SOURCES:
% Women, Minorities, and Persons with Disabilities in Science and Engineering report.
%    https://www.nsf.gov/statistics/women/
%  1994 report
%     Table 5-19 = 1981-1991 bachelors by race/ethnicity
%  2002 report 
%     Table 3-8 = 1990-1998 bachelors by race/ethnicity [saved as xlsx first to import]
%  2009 report
%     Table C6 = 1996-2007 bachelors by race/ethnicity [saved as xlsx first to import]
%  2019 report
%     Table 5-3 = 2006-2016 bachelors by race/ethnicity
%
% CATEGORIES:
%   White
%   Asian (somestimes also Pacific Islander)
%   Black
%   Hispanic
%   American Indian/Alaskan Native
%   Native Hawaiian or Other Pacific Islander (when reported)
%   More than one race (when reported)
%   Unknown
%   Temporary resident
%
% OUTPUT: No direct output, but the following .csv file is generated:
%   N_NSF_UGD.csv: years, number of undergraduate degrees by group (column) for years (rows)


N_UGD = NaN(30,9); % rows = years; columns = group

%-----1981-1991-----------------------------------------------------------%
    % load NSF data
    [data,TXT]=xlsread('../../NSF data/WMPD/1994 report - part/appn5-19.xls');
    % offset by this amount to map from row in excel to row in data
    tmp = 11; % rows of text at the start of file

    % Total
    %     White, non-hispanic
    %     Asian
    %     Underrepresented minorities, total
    %       Black, non-hispanic
    %       Hispanic
    %       American Indian/Alaskan Native
    %   U.S. citizens and permanent residents, total:
    %   Nonresident alien
    %   Unknown status or race
    ind = [12 36 60 93 117 141 173 197 221 253] - tmp;

    yr_tmp = cellfun(@str2num,TXT(6,2:end)); % extract years
    N_tmp = data(ind,2:end); % extract groups

    % check that interpretations are correct:
    % [A] first row (total) is sum of last three (citizens, non-resident, unknown)
        if sum(abs(N_tmp(1,:) - sum(N_tmp([end-2:end],:)))) > 0; error('UG data interpretation incorrect'); end
    % [B] third to last row (citizens) is sum of second through fourth (white, asian, URM)
        if sum(abs(N_tmp(end-2,:) - sum(N_tmp([2:4],:)))) > 0; error('UG data interpretation incorrect'); end
    % [C] fourth row (URM) is sum of fifth through seventh (black, hispanic, native)
        if sum(abs(N_tmp(4,:) - sum(N_tmp([5:7],:)))) > 0; error('UG data interpretation incorrect'); end

    % save year data
    yr_U = yr_tmp(1:end-2);
    T1 = length(yr_U);

    % save group data
    N_UGD(1:T1,1:5) = N_tmp([2 3 5 6 7],1:T1)';
    % White
    % Asian
    % Black
    % Hispanic
    % American Indian/Alaskan Native
    N_UGD(1:T1,8:9) = N_tmp([10 9],1:T1)';
    % Unknown
    % Temporary resident

    clear data TXT tmp ind yr_tmp N_tmp
%-----1981-1991-----------------------------------------------------------%


%-----1990-1998-----------------------------------------------------------%
    % load NSF data
    [data,TXT]=xlsread('../../NSF data/WMPD/2002 report - part/at03-08_ed.xlsx');
    % offset by this amount to map from row in excel to row in data
    tmp = 5; % rows of text at the start of file

    % Total
    %   U.S. citizens and permanent residents, total
    %     White, non-hispanic
    %     Asian/Pacfic Islanders
    %     Black, non-hispanic
    %     Hispanic
    %     American Indian/Alaskan Native
    %     Unknown race/ethnicity
    %   Temporary resident
    ind = [7 20 32 43 62 73 85 96 115] - tmp;

    yr_tmp = cellfun(@str2num,TXT(5,2:end)); % extract years
    N_tmp = data(ind,:); % extract groups

    % check that interpretations are correct:
    % [A] first row (total) is sum of second (citizens) and last (temp resident)
        if sum(abs(N_tmp(1,:) - sum(N_tmp([2 end],:)))) > 0; error('UG data interpretation incorrect'); end
    % [B] second row (citizens) is sum of third through second to last (by race/ethnicity)
        if sum(abs(N_tmp(2,:) - sum(N_tmp([3:end-1],:)))) > 0; error('UG data interpretation incorrect'); end

    % save group data
    yr_U = [yr_U yr_tmp];
    T2 = length(yr_U);

    % save group data
    N_UGD(T1+1:T2,1:5) = N_tmp([3:7],1:T2-T1)';
    % White
    % Asian or Pacific Islander
    % Black
    % Hispanic
    % American Indian/Alaskan Native
    N_UGD(T1+1:T2,8:9) = N_tmp([8:9],1:T2-T1)';
    % Unknown
    % Temporary resident

    clear data TXT tmp ind yr_tmp N_tmp
%-----1990-1998-----------------------------------------------------------%
    
%-----1996-2007-----------------------------------------------------------%
    % load NSF data
    [data,TXT]=xlsread('../../NSF data/WMPD/2009 report/data/tables/tabc-6_updated_2009_11_ed.xlsx');
    % offset by this amount to map from row in excel to row in data
    tmp = 1; % rows of text at the start of file

    % Total
    %   U.S. citizen and permanent resident
    %     White
    %     Asian or Pacific Islander
    %     Black
    %     Hispanic
    %     American Indian or Alaska Native
    %     Other or unknown race and ethnicity
    %   Temporary resident
    ind = [5 53 101 149 197 245 293 341 389] - tmp;

    yr_tmp = data(1,:); % extract years
    N_tmp = data(ind,:); % extract groups

    % check that interpretations are correct:
    % [A] first row (total) is sum of second (citizens) and last (temp resident)
        if sum(abs(N_tmp(1,:) - sum(N_tmp([2 end],:)))) > 0; error('UG data interpretation incorrect'); end
    % [B] second row (citizens) is sum of third through second to last (by race/ethnicity)
        if sum(abs(N_tmp(2,:) - sum(N_tmp([3:end-1],:)))) > 0; error('UG data interpretation incorrect'); end

    % save year data
    yr_U = [yr_U yr_tmp(2:end)];
    T3 = length(yr_U);

    % save group data
    N_UGD(T2+1:T3,1:5) = N_tmp([3:7],2:T3-T2+1)';
    % White
    % Asian or Pacific Islander
    % Black
    % Hispanic
    % American Indian/Alaskan Native
    N_UGD(T2+1:T3,8:9) = N_tmp([8:9],2:T3-T2+1)';
    % Unknown
    % Temporary resident

    clear data TXT tmp ind yr_tmp N_tmp
%-----1996-2007-----------------------------------------------------------%

%-----2006-2016-----------------------------------------------------------%
    % load NSF data
    [data,TXT]=xlsread('../../NSF data/WMPD/2019 report - part/wmpd19-sr-tab05-003.xlsx');
    % offset by this amount to map from row in excel to row in data
    tmp = 3; % rows of text at the start of file

    % Total
    %   U.S. citizen and permanent resident
    %     Hispanic or Latino
    %     Non-Hispanic or Latino
    %       American Indian or Alaska Native
    %       Asian
    %       Asian or Pacific Islander
    %       Black or African American
    %       Native Hawaiian or Other Pacific Islander
    %       White
    %       More than one race
    %       Other or unknown race and ethnicity
    %   Temporary resident
    ind = [18:30] - tmp;

    yr_tmp = data(1,:); % extract years

    N_tmp = data(ind,:); % extract groups
    N_tmp(isnan(N_tmp)) = 0; % replace missing data as zeros

    % check that interpretations are correct:
    % [A] first row (all) is sum of second (citizens) and last (temp residents)
        if sum(abs(N_tmp(1,:) - sum(N_tmp([2 end],:)))) > 0; error('UG data interpretation incorrect'); end
    % [B] second row (citizens) is sum of third (hispanic) and fourth (non hispanic)
        if sum(abs(N_tmp(2,:) - sum(N_tmp([3 4],:)))) > 0; error('UG data interpretation incorrect'); end
    % [C] fourth row (non-hispanic) is sum of fifth through second to last (specific races)
        if sum(abs(N_tmp(4,:) - sum(N_tmp([5:end-1],:)))) > 0; error('UG data interpretation incorrect'); end

    % save year data
    yr_U = [yr_U yr_tmp(3:end)];
    T4 = length(yr_U);
    
    % save group data
    N_UGD(T3+1:T4,:) = N_tmp([10 6 8 3 5 9 11 12 13],3:T4-T3+2)';
    % White
    % Asian/Pacific Islander
    % Black
    % Hispanic
    % American Indian/Alaskan Native
    % Native Hawaiian
    % Multiple races
    % Unknown
    % Temporary resident
    
    % add Asian/Pacific Islander to Asian
    N_UGD(T3+1:T4,2) = N_UGD(T3+1:T4,2) + N_tmp(7,3:T4-T3+2)';
    N_UGD((N_UGD==0)) = NaN; % replace missing data as NaN

    clear data TXT tmp ind yr_tmp N_tmp T1 T2 T3 T4
%-----2006-2016-----------------------------------------------------------%

% save data as a CSV
fname='N_NSF_UGD.csv';
textlabel =  {'year','White','Asian (somestimes also Pacific Islander)','Black','Hispanic','American Indian/Alaskan Native','Native Hawaiian or Other Pacific Islander (when reported)','More than one race (when reported)','Unknown','Temporary resident'};
writetable(cell2table([textlabel; num2cell([yr_U' N_UGD])]),fname,'writevariablenames',0)
