clear all; clc
% written by Allison Shaw (contact ashaw@umn.edu for assistance)
% last updated 6 May 2021

%  CENSUS DATA
clear all;clc
    % CENSUS DATA (RACES/ETHNICITIES WITH FULL TIME SERIES)
    T = readtable('../datafiles_census/CensusData1.csv'); % import data
    T_text = table2array(T(:,1:2)); % convert to an array
    T_num = table2array(T(:,3:end)); % convert to an array
    yr_census = T_num(1,27) % convert table to array to years
    % indices corresponding to each stage
    ind_pop = find(strcmp(T_text(:,2),'Population Average')==1);
    % data corresponding to each stage
    census_pop = T_num(ind_pop,27);
    % pull races/ethnicities
    census_groups = T_text(ind_pop,1);
    
    % CENSUS DATA (RACES WITH SHORTER TIME SERIES)
    T = readtable('../datafiles_census/CensusData2.csv'); % import data
    T_text = table2array(T(:,1:2)); % convert to an array
    T_num = table2array(T(:,3:end)); % convert to an array
    yr_census = T_num(1,17) % convert table to array to years
    % indices corresponding to each stage
    ind_pop = find(strcmp(T_text(:,2),'Population Average')==1);
    % data corresponding to each stage
    census2_pop = T_num(ind_pop,17);
    % pull races/ethnicities
    census2_groups = T_text(ind_pop,1);
    
    %COMBINE
    census_pop = [census_pop; census2_pop];
    census_groups = [census_groups; census2_groups];
    
    % reorder to match NSF data
    % original order is: Native, Asian, Black, White, Hispanic, Hawaiian, Multiple
    indorder = [2 3 6 5 1 4 7]; 
    disp('order should be : Asian, Black, Hawaiian, Hispanic, Native, White, Multiple')
    census_groups(indorder) 
    census_pop = census_pop(indorder,:);
    clear x1 y1 census2* indorder T ind*

% SMOOTHED DATA AND MODEL
    load('../datafiles_matlab/model_output_main.mat')
    
    % reorder races alphabetically
    indorder = [2 3 6 4 5 1 7];
    
% OUTPUT RESULTS
    % check that years match
    yr_census
    yr_smooth(26)
    
    % check that races are in same order
    groups(indorder)
    
    % output results -census
    census_pop'
    % output results - undergrad
    frac_smooth_U(26,indorder)
    % output results - grad
    frac_smooth_G(26,indorder)
    frac_sim_fa_de(26,indorder,2)
    frac_sim_fa_su(26,indorder,2)
    frac_sim_sl_de(26,indorder,2)
    frac_sim_sl_su(26,indorder,2)
    % output results - postdocs
    frac_smooth_P(26,indorder)
    frac_sim_fa_de(26,indorder,3)
    frac_sim_fa_su(26,indorder,3)
    frac_sim_sl_de(26,indorder,3)
    frac_sim_sl_su(26,indorder,3)
    % output results - assistant professors
    frac_smooth_A(26,indorder)
    frac_sim_fa_de(26,indorder,4)
    frac_sim_fa_su(26,indorder,4)
    frac_sim_sl_de(26,indorder,4)
    frac_sim_sl_su(26,indorder,4)
    % output results - tenured professors
    frac_smooth_T(26,indorder)
    frac_sim_fa_de(26,indorder,5)
    frac_sim_fa_su(26,indorder,5)
    frac_sim_sl_de(26,indorder,5)
    frac_sim_sl_su(26,indorder,5)
    

