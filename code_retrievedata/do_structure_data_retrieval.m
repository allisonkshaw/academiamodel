function do_structure_data_retrieval
% USAGE: do_structure_data_retrieval
% written July 2020  by Allison Shaw (contact ashaw@umn.edu for assistance)
% updated 6 May 2021
%
% retrieve data on model structure over time:
%  (1) number of degrees earned (N_UGD, N_GRD)
%  (2) number of individuals in each pool (N_GR, N_PD, N_AP, N_TP)
%
% DATA SOURCES:
% Science and Engineering Degrees: 1966–2012
%    https://www.nsf.gov/statistics/2015/nsf15326/
%      Table 5: bachelor’s degrees by field
%      Table 19: PhD degrees by field
% Survey of Graduate Students and Postdoctorates in Science and Engineering
%    https://www.nsf.gov/statistics/srvygradpostdoc/#tabs-2 
%    2018 report
%     Table 1-9a = 1975–2018 grad students SCIENCE only => had to resave to import
%     Table 1-9b = 1979–2018 postdocs SCIENCE only
%     Table 1-10a = 1975–2018 grad students ENGINEERING only => had to resave to import
%     Table 1-10b = 1979–2018 postdocs ENGINEERING only => had to resave to import
% Science & Engineering Indicators
%    https://ncses.nsf.gov/indicators
%    2019 report
%    Table S3-7 = 1973-2017 # faculty and postdocs by field
% Women, Minorities, and Persons with Disabilities in Science and Engineering report.
%    https://www.nsf.gov/statistics/women/
%    2019 report, https://ncses.nsf.gov/pubs/nsf19304/data
%    Table 5-3 = 2006-2016 bachelors degrees 
%    Table 7-4 = 2006–2016 doctoral degrees
%
% OUTPUT: No direct output, but the following .csv files are generated:
%   N_UGD.csv: years, number of undergraduate degrees for each year
%   N_GRD.csv: years, number of PhD degrees for each year
%   N_GR.csv:  years, number of graduate students for each year
%   N_PD.csv:  years, number of postdoctoral researchers for each year
%   N_AP.csv:  years, number of assistant professors for each year
%   N_TP.csv:  years, number of tenured professors for each year

    
%-----UNDERGRAD DEGREES---------------------------------------------------%
    % 1966-2012 data
    [data,~]=xlsread('../../NSF data/SE degrees/tab5.xlsx');
    yr_UGD = data(:,1);  % save years
    indyr = find(~isnan(yr_UGD)); % find non-empty rows
    yr_UGD = yr_UGD(indyr);   % save only non-empty rows
    % which column of data to pull
    ind = 4;  % all S&E
    % save data
    N_UGD = data(indyr,ind);
    clear data ind indyr
    
    % 2006-2016 data
    [data,~]=xlsread('../../NSF data/WMPD/2019 report - part/wmpd19-sr-tab05-003.xlsx');
    yr_tmp = data(1,:);  % save years
    tmp = 3; % rows of text at the start of file
    % which row of data to pull
    ind2 = [];
    ind1 = 18;  % all S&E
    % pull data
    N_tmp1 = data(ind1-tmp,:);
    if isempty(ind2)==0
        N_tmp2 = data(ind2-tmp,:); % get second data for ag & bio
        N_tmp1 = N_tmp1 + N_tmp2;
    end
    % cut out <2012 data and reorient
    yr_tmp = yr_tmp(8:end)';
    N_tmp1 = N_tmp1(8:end)';
    
    % add to above
    yr_UGD = [yr_UGD; yr_tmp];
    N_UGD = [N_UGD; N_tmp1];
    clear data yr_tmp N_tmp* ind* tmp
    
    % save data as a CSV
    fname='N_UGD.csv';
    textlabel =  {'year','number of undergraduate degrees'};
    writetable(cell2table([textlabel; num2cell([yr_UGD N_UGD])]),fname,'writevariablenames',0)
    clear yr_UGD N_UGD fname textlabel
%-----UNDERGRAD DEGREES---------------------------------------------------%


%-----GRAD DEGREES--------------------------------------------------------%
    % 1966-2012 data
    [data,~]=xlsread('../../NSF data/SE degrees/tab19.xlsx');
    % offset by this amount to map from row in excel to row in data
    tmp = 4; % rows of text at the start of file
    indr = [5:9 11:15 17:21 23:27 29:33 35:39 41:45 47:51 53:57 59:60];
    yr_GRD = data(indr-tmp,1);
    % which column of data to pull
    ind = 4;  % all S&E
    % save data
    N_GRD = data(indr-tmp,ind);
    clear data tmp ind indr
    
    % 2006-2016 data
    [data,~]=xlsread('../../NSF data/WMPD/2019 report - part/wmpd19-sr-tab07-004.xlsx');
    yr_tmp = data(1,:);  % save years
    tmp = 3; % rows of text at the start of file
    % which row of data to pull
    ind2 = [];
    ind1 = 18;  % all S&E
    % pull data
    N_tmp1 = data(ind1-tmp,:);
    if isempty(ind2)==0
        N_tmp2 = data(ind2-tmp,:); % get second data for ag & bio
        N_tmp1 = N_tmp1 + N_tmp2;
    end
    % cut out <2012 data and reorient
    yr_tmp = yr_tmp(8:end)';
    N_tmp1 = N_tmp1(8:end)';
    
    % add to above
    yr_GRD = [yr_GRD; yr_tmp];
    N_GRD = [N_GRD; N_tmp1];
    clear data yr_tmp N_tmp* ind* tmp
    
    % save data as a CSV
    fname='N_GRD.csv';
    textlabel =  {'year','number of doctoral degrees'};
    writetable(cell2table([textlabel; num2cell([yr_GRD N_GRD])]),fname,'writevariablenames',0)
    clear yr_GRD N_GRD fname textlabel
%-----GRAD DEGREES--------------------------------------------------------%


%-----GRAD STUDENTS-------------------------------------------------------%
    [data1,~]=xlsread('../../NSF data/GSPD/2018 report/gss18-dt-tab001-9a_ed.xlsx');
    [data2,~]=xlsread('../../NSF data/GSPD/2018 report/gss18-dt-tab001-10a.xlsx');
    % offset by this amount to map from row in excel to row in data
    tmp = 4; % rows of text at the start of file
    
    % which rows to take - some years have 2 sets of data, always take newer one
    % skip masters student (only started in 2017)
    ind = [5:36 38:44 46:48 50:51] - tmp;
    
    yr_GR = data1(ind,1);
    % fill in years that didn't import well (due to extra text)
    yr_GR(4)  = 1978;
    yr_GR(33) = 2007;
    yr_GR(40) = 2014;
    yr_GR(43) = 2017;

    nr_tmp = data1(ind,11); nr_tmp(isnan(nr_tmp))=0;
    N_G_eng = data2(ind,2);
    N_G_se  = data1(ind,2) + N_G_eng;

   % NOTE: As part of 2017 GSS redesign, the GSS taxonomy was changed to align
   % with the NCSES Taxonomy of Disciplines (TOD), thus increasing comparability
   % with other NCSES surveys. As a result, some eligible fields were reclassified
   % and a small number of fields became fully or partially ineligible.
   % Comparisons to prior years should use the 2017old estimates and should
   % be limited to broad areas of study—detailed field comparisons are not
   % recommended. Redesign includes the following: natural resources splitting
   % from agricultural sciences; neurosciences being reported under biological
   % and biomedical sciences; physical sciences adding materials sciences;
   % social sciences no longer including public administration; and
   % multidisciplinary and interdisciplinary studies no longer including nanoscience.
   
   % NOTE: In 2007, eligible fields were reclassified, newly eligible fields
   % were added, and the survey was redesigned to improve coverage and coding
   % of eligible units. "2007new" presents data as collected in 2007; "2007old"
   % shows data as they would have been collected in prior years. The science
   % field communication and the science field family and consumer sciences
   % and human sciences were newly eligible in 2007; data for these two fields
   % begin in 2007new. The science field multidisciplinary and interdisciplinary
   % studies was also added to the GSS code list in 2007; some data reported
   % in this field were reported under other fields before 2007 and are
   % included in those fields in 2007old. neuroscience is reported as a
   % separate field of science in 2007new; data were reported under health
   % field neurology in 2007old and previous years. See appendix A in
   % https://www.nsf.gov/statistics/nsf10307/ for more detail.
   
    N_GR = N_G_se;  % all S&E
    
   clear data1 data2 tmp ind N_G_* nr_tmp
   
   % save data as a CSV
   fname='N_GR.csv';
   textlabel =  {'year','number of graduate students'};
   writetable(cell2table([textlabel; num2cell([yr_GR N_GR])]),fname,'writevariablenames',0)
   clear yr_GR N_GR fname textlabel
%-----GRAD STUDENTS-------------------------------------------------------%


%-----POSTDOCS------------------------------------------------------------%
    [data1,~]=xlsread('../../NSF data/GSPD/2018 report/gss18-dt-tab001-9b_ed.xlsx');
    [data2,~]=xlsread('../../NSF data/GSPD/2018 report/gss18-dt-tab001-10b_ed.xlsx');
    % offset by this amount to map from row in excel to row in data
    tmp = 4; % rows of text at the start of file
    
    % which rows to take - some years have 2 sets of data, always take newer one
    % skip masters student (only started in 2017)
    ind = [5:32 34:40 42:44 46:47] - tmp;
    
    yr_PD = data1(ind,1);
    % fill in years that didn't import well (due to extra text)
    yr_PD(29) = 2007;
    yr_PD(32) = 2010;
    yr_PD(33) = 2011;
    yr_PD(36) = 2014;
    yr_PD(39) = 2017;

    nr_tmp = data1(ind,11); nr_tmp(isnan(nr_tmp))=0;
    
    N_P_eng = data2(ind,2);
    N_P_se  = data1(ind,2) + N_P_eng;
   
    N_PD = N_P_se;  % all S&E
    
   clear data1 data2 tmp ind N_P_* nr_tmp
   
   % save data as a CSV
   fname='N_PD.csv';
   textlabel =  {'year','number of postdocs'};
   writetable(cell2table([textlabel; num2cell([yr_PD N_PD])]),fname,'writevariablenames',0)
   clear yr_PD N_PD fname textlabel
%-----POSTDOCS------------------------------------------------------------%


%-----FACULTY-------------------------------------------------------------%
    [data,~]=xlsread('../../NSF data/SE ind/2019 report/nsb20198-tabs03-007.xlsx');
    yr_AP = data(1,:)';
    yr_TP = data(1,:)';
   
    % offset by this amount to map from row in excel to row in data
    tmp = 3; % 3 rows of text at the start of file
    
    % which row of data to pull
    indA = 42-tmp; indT = [24 33]-tmp; % all S&E

    N_AP = 1000*data(indA,:)'; % data are in thousands
    N_TP = sum(1000*data(indT,:),1)'; % data are in thousands
    clear data tmp indA indT
    
   % save data as a CSV
   fname='N_AP.csv';
   textlabel =  {'year','number of assistant professors'};
   writetable(cell2table([textlabel; num2cell([yr_AP N_AP])]),fname,'writevariablenames',0)
   clear yr_AP N_AP fname textlabel
   fname='N_TP.csv';
   textlabel =  {'year','number of tenured professors'};
   writetable(cell2table([textlabel; num2cell([yr_TP N_TP])]),fname,'writevariablenames',0)
%-----FACULTY-------------------------------------------------------------%
