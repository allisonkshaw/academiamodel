clear all; clc
% written June 2020  by Allison Shaw (contact ashaw@umn.edu for assistance)
% last updated 6 May 2021
%
% This is the second of two main script which calls other 'do' functions.
% This script:
% (1) loads and cleans NSF data on basic model structure (# in each stage over time)
% (2) uses model structure data to estimate the number of individuals moving among
%       stages each year
% (3) loads and cleans NSF data on race/ethnicity in each stage over time
% (4) uses subset of group data to simulate the number of individuals by group
%       moving among stages each year. Uses:
%       * number of undergraduate degrees by group for all years
%       * number of grad students, postdocs, professors by group for the
%       first year (initial conditions)
% Simulations can be run initialized in different starting years, or using
%   data from different stages, by setting options below.

time = 1991:2016; % make sure this matches model structure and group data ranges
T = length(time);

ngroup = 7; % number of individual groups (race/ethnicities)
groups = {'White','Asian','Black','Hispanic','Native/Alaskan','Hawaiian/Pacific','Multiple'};


%-----(1) MODEL STRUCTURE-------------------------------------------------%
    % loads and cleans NSF data on basic model structure (# in each stage over time)

    % load raw model structure data
    data = readmatrix('../datafiles_NSF/N_UGD.csv'); yr_UGD = data(:,1); N_UGD = data(:,2);
    data = readmatrix('../datafiles_NSF/N_GRD.csv'); yr_GRD = data(:,1); N_GRD = data(:,2);
    data = readmatrix('../datafiles_NSF/N_GR.csv');  yr_GR  = data(:,1); N_GR  = data(:,2);
    data = readmatrix('../datafiles_NSF/N_PD.csv');  yr_PD  = data(:,1); N_PD  = data(:,2);
    data = readmatrix('../datafiles_NSF/N_AP.csv');  yr_AP  = data(:,1); N_AP  = data(:,2);
    data = readmatrix('../datafiles_NSF/N_TP.csv');  yr_TP  = data(:,1); N_TP  = data(:,2);
    clear data
    % N_x is a vector with rows corresponding to years 
       
    % clean (truncate/interpolate)
    [yr_UGD,N_UGD,yr_GRD,N_GRD,yr_GR,N_GR,yr_PD,N_PD,yr_AP,N_AP,yr_TP,N_TP] = do_structure_data_clean(yr_UGD,N_UGD,yr_GRD,N_GRD,yr_GR,N_GR,yr_PD,N_PD,yr_AP,N_AP,yr_TP,N_TP);

    N = [N_UGD'; N_GR'; N_PD'; N_AP'; N_TP']; % number in each stage (row) for each year (column)
    
    % number of years spent in each pool (T_GR, T_PD, T_AP, T_TP)
    T_GR = 6.8;    % 2015 (https://www.nsf.gov/statistics/2018/nsb20181/assets/561/tables/at02-30.xlsx)
    T_PD = 2*1.9;  % 2006 (https://wayback.archive-it.org/5902/20160210152853/http://www.nsf.gov/statistics/infbrief/nsf08307/tab2.xls)
    T_AP_fa = 5;
    T_AP_sl = 8;
    T_TP_fa = 20; % fast - guess 20-30 from SESTAT database
    T_TP_sl = 30; % slow
    tau_fa = [NaN; T_GR; T_PD; T_AP_fa; T_TP_fa]; % turnover rates for each stage
    tau_sl = [NaN; T_GR; T_PD; T_AP_sl; T_TP_sl]; % turnover rates for each stage
    nstage = length(tau_fa);
%-----(1) MODEL STRUCTURE-------------------------------------------------%
    

%-----(2) TRANSITIONS-----------------------------------------------------%
    % uses model structure data to estimate the number of individuals moving among stages each year
    % this provides estimates for the 12 possible transitions in and out of
    % classes (see schematic figure)
    [n_move_fa_su,n_leave_fa_su,n_drop_fa_su,n_move_outside_fa_su] = do_transition_estimates(time,N,N_GRD,tau_fa,'supply');
    [n_move_sl_su,n_leave_sl_su,n_drop_sl_su,n_move_outside_sl_su] = do_transition_estimates(time,N,N_GRD,tau_sl,'supply');
    [n_move_fa_de,n_leave_fa_de,n_drop_fa_de,n_move_outside_fa_de] = do_transition_estimates(time,N,N_GRD,tau_fa,'demand');
    [n_move_sl_de,n_leave_sl_de,n_drop_sl_de,n_move_outside_sl_de] = do_transition_estimates(time,N,N_GRD,tau_sl,'demand');
%-----(2) TRANSITIONS-----------------------------------------------------%


%-----(3) GROUP DATA------------------------------------------------------%
    % loads and cleans NSF data on race/ethnicity in each stage over time
    
    % load data on undergraduate students
    data = readmatrix('../datafiles_NSF/N_NSF_UGD.csv'); yr_NSF_U = data(:,1); N_NSF_UGD = data(:,2:end);
    
    % load data on gradulate students
    data = readmatrix('../datafiles_NSF/N_NSF_GR.csv'); yr_NSF_G = data(:,1); N_NSF_GR = data(:,2:end);
    
    % load data on postdoctoral researchers
    data = readmatrix('../datafiles_NSF/N_NSF_PD.csv'); yr_NSF_P = data(:,1); N_NSF_PD = data(:,2:end);
    
    % load data on faculty (assistant and tenured professors)
    data = readmatrix('../datafiles_NSF/N_NSF_AP.csv'); yr_NSF_A = data(:,1); N_NSF_AP = data(:,2:end);
    data = readmatrix('../datafiles_NSF/N_NSF_TP.csv'); yr_NSF_T = data(:,1); N_NSF_TP = data(:,2:end);
    
    % load data on PhD degree recipients by residency
    % (above student data is just for US citizens and permanent residents
    % first data available for temporary residents is at the PhD degree)
    data = readmatrix('../datafiles_NSF/N_GRD_res.csv');     yr_GRD_res = data(:,1);     N_GRD_res = data(:,2:end);
    data = readmatrix('../datafiles_NSF/N_NSF_tempres.csv'); yr_NSF_tempres = data(:,1); N_NSF_tempres = data(:,2:end);
    data = readmatrix('../datafiles_NSF/N_NSF_permres.csv'); yr_NSF_permres = data(:,1); N_NSF_permres = data(:,2:end);

    % these contain yr_NSF_x and N_NSF_x for each class x
    %   N_NSF_x is a matrix with rows corresponding to years and columns as group
    %   faculty have 7 groups: white, asian, black, hispanic, native, hawaiian,
    %                        multi-race
    %   students and postdocs have 9: the 7 above, unknown, temporary resident
    % also contains data for permanent and temporary residents at PhD degree
    %   stage by race/ethnicity (yr_NSF_permres, yr_NSF_tempres,
    %   N_NSF_permres, N_NSF_tempres)
    % finally, contains data for the number of students at PhD stage that
    %    were permanent and temporary residents (yr_GRD_res, N_GRD_res)

    % clean group data (reduce to groups/years that we will use)
    [yr_smooth,frac_smooth_U,frac_smooth_G,frac_smooth_P,frac_smooth_A,frac_smooth_T,frac_smooth_GRD_res,frac_smooth_tempres] = do_group_data_clean(ngroup,yr_NSF_U,N_NSF_UGD,yr_NSF_G,N_NSF_GR,yr_NSF_P,N_NSF_PD,yr_NSF_A,N_NSF_AP,yr_NSF_T,N_NSF_TP,yr_GRD_res,N_GRD_res,yr_NSF_tempres,N_NSF_tempres);
    clear N_NSF_UGD N_NSF_GR N_NSF_PD N_NSF_AP N_NSF_TP
    clear N_GRD_res N_NSF_tempres N_NSF_permres
    clear yr_GRD_res yr_NSF_A yr_NSF_G yr_NSF_P yr_NSF_T yr_NSF_U
    clear yr_NSF_permres yr_NSF_tempres
%-----(3) GROUP DATA------------------------------------------------------%


%-----(4a) SIMULATE (PRIMARY) --------------------------------------------%
    % uses subset of group data to simulate the number of individuals by
    %    group moving among stages each year. Uses:
    %       * number of undergraduate degrees by group for all years
    %       * number of grad students, postdocs, professors by group for the
    %       first year (initial conditions)
    
    % set index of stage where NSF data is fed in
    % 1=U, 2=G, 3=P, 4=A, 5=T
    sind = 1;
    
    % set starting year and simulation length
    startyear = 1991; % set starting year
    tstart = find(time==startyear); % index corresponding to start year
    tdel = T-1; % simulation length

    % simulate individuals by group over time
    % output: years x group x stage
    [n_sim_fa_su,frac_sim_fa_su] = do_simulations(time,tstart,tdel,nstage,sind,ngroup,tau_fa,N,N_GRD,frac_smooth_U,frac_smooth_G,frac_smooth_P,frac_smooth_A,frac_smooth_T,frac_smooth_GRD_res,frac_smooth_tempres,n_move_fa_su,n_leave_fa_su,n_drop_fa_su,n_move_outside_fa_su);
    [n_sim_sl_su,frac_sim_sl_su] = do_simulations(time,tstart,tdel,nstage,sind,ngroup,tau_sl,N,N_GRD,frac_smooth_U,frac_smooth_G,frac_smooth_P,frac_smooth_A,frac_smooth_T,frac_smooth_GRD_res,frac_smooth_tempres,n_move_sl_su,n_leave_sl_su,n_drop_sl_su,n_move_outside_sl_su);

    [n_sim_fa_de,frac_sim_fa_de] = do_simulations(time,tstart,tdel,nstage,sind,ngroup,tau_fa,N,N_GRD,frac_smooth_U,frac_smooth_G,frac_smooth_P,frac_smooth_A,frac_smooth_T,frac_smooth_GRD_res,frac_smooth_tempres,n_move_fa_de,n_leave_fa_de,n_drop_fa_de,n_move_outside_fa_de);
    [n_sim_sl_de,frac_sim_sl_de] = do_simulations(time,tstart,tdel,nstage,sind,ngroup,tau_sl,N,N_GRD,frac_smooth_U,frac_smooth_G,frac_smooth_P,frac_smooth_A,frac_smooth_T,frac_smooth_GRD_res,frac_smooth_tempres,n_move_sl_de,n_leave_sl_de,n_drop_sl_de,n_move_outside_sl_de);
    % just save simulation output and smoothed data, corresponding parameters
    save 'model_output_main.mat' frac* groups s* t* yr_smooth
    clear n_sim* frac_sim*
%-----(4a) SIMULATE (PRIMARY) --------------------------------------------%


%-----(4b) SIMULATE (VARY STARTING STAGE) --------------------------------%
    % uses subset of group data to simulate the number of individuals by group
    %       moving among stages each year. Uses:
    %       * number of undergraduate degrees by group for all years
    %       * number of grad students, postdocs, professors by group for the
    %       first year (initial conditions)
    
    % set starting year and simulation length
    startyear = 1991; % set starting year
    tstart = find(time==startyear); % index corresponding to start year
    tdel = T-1; % simulation length

    % feed in NSF data at different stages, simulate individuals by group
    % over time
    % output dimensions: years x group x stage
    
    % feed in at U level (sind=1)
    sind = 1;
    [n_sim_fa_su_sind1,frac_sim_fa_su_sind1] = do_simulations(time,tstart,tdel,nstage,sind,ngroup,tau_fa,N,N_GRD,frac_smooth_U,frac_smooth_G,frac_smooth_P,frac_smooth_A,frac_smooth_T,frac_smooth_GRD_res,frac_smooth_tempres,n_move_fa_su,n_leave_fa_su,n_drop_fa_su,n_move_outside_fa_su);
    [n_sim_sl_su_sind1,frac_sim_sl_su_sind1] = do_simulations(time,tstart,tdel,nstage,sind,ngroup,tau_sl,N,N_GRD,frac_smooth_U,frac_smooth_G,frac_smooth_P,frac_smooth_A,frac_smooth_T,frac_smooth_GRD_res,frac_smooth_tempres,n_move_sl_su,n_leave_sl_su,n_drop_sl_su,n_move_outside_sl_su);
    [n_sim_fa_de_sind1,frac_sim_fa_de_sind1] = do_simulations(time,tstart,tdel,nstage,sind,ngroup,tau_fa,N,N_GRD,frac_smooth_U,frac_smooth_G,frac_smooth_P,frac_smooth_A,frac_smooth_T,frac_smooth_GRD_res,frac_smooth_tempres,n_move_fa_de,n_leave_fa_de,n_drop_fa_de,n_move_outside_fa_de);
    [n_sim_sl_de_sind1,frac_sim_sl_de_sind1] = do_simulations(time,tstart,tdel,nstage,sind,ngroup,tau_sl,N,N_GRD,frac_smooth_U,frac_smooth_G,frac_smooth_P,frac_smooth_A,frac_smooth_T,frac_smooth_GRD_res,frac_smooth_tempres,n_move_sl_de,n_leave_sl_de,n_drop_sl_de,n_move_outside_sl_de);
    % feed in at G level (sind=2)
    sind = 2;
    [n_sim_fa_su_sind2,frac_sim_fa_su_sind2] = do_simulations(time,tstart,tdel,nstage,sind,ngroup,tau_fa,N,N_GRD,frac_smooth_U,frac_smooth_G,frac_smooth_P,frac_smooth_A,frac_smooth_T,frac_smooth_GRD_res,frac_smooth_tempres,n_move_fa_su,n_leave_fa_su,n_drop_fa_su,n_move_outside_fa_su);
    [n_sim_sl_su_sind2,frac_sim_sl_su_sind2] = do_simulations(time,tstart,tdel,nstage,sind,ngroup,tau_sl,N,N_GRD,frac_smooth_U,frac_smooth_G,frac_smooth_P,frac_smooth_A,frac_smooth_T,frac_smooth_GRD_res,frac_smooth_tempres,n_move_sl_su,n_leave_sl_su,n_drop_sl_su,n_move_outside_sl_su);
    [n_sim_fa_de_sind2,frac_sim_fa_de_sind2] = do_simulations(time,tstart,tdel,nstage,sind,ngroup,tau_fa,N,N_GRD,frac_smooth_U,frac_smooth_G,frac_smooth_P,frac_smooth_A,frac_smooth_T,frac_smooth_GRD_res,frac_smooth_tempres,n_move_fa_de,n_leave_fa_de,n_drop_fa_de,n_move_outside_fa_de);
    [n_sim_sl_de_sind2,frac_sim_sl_de_sind2] = do_simulations(time,tstart,tdel,nstage,sind,ngroup,tau_sl,N,N_GRD,frac_smooth_U,frac_smooth_G,frac_smooth_P,frac_smooth_A,frac_smooth_T,frac_smooth_GRD_res,frac_smooth_tempres,n_move_sl_de,n_leave_sl_de,n_drop_sl_de,n_move_outside_sl_de);
    % feed in at A level (sind=4)
    sind = 4;
    [n_sim_fa_su_sind4,frac_sim_fa_su_sind4] = do_simulations(time,tstart,tdel,nstage,sind,ngroup,tau_fa,N,N_GRD,frac_smooth_U,frac_smooth_G,frac_smooth_P,frac_smooth_A,frac_smooth_T,frac_smooth_GRD_res,frac_smooth_tempres,n_move_fa_su,n_leave_fa_su,n_drop_fa_su,n_move_outside_fa_su);
    [n_sim_sl_su_sind4,frac_sim_sl_su_sind4] = do_simulations(time,tstart,tdel,nstage,sind,ngroup,tau_sl,N,N_GRD,frac_smooth_U,frac_smooth_G,frac_smooth_P,frac_smooth_A,frac_smooth_T,frac_smooth_GRD_res,frac_smooth_tempres,n_move_sl_su,n_leave_sl_su,n_drop_sl_su,n_move_outside_sl_su);
    [n_sim_fa_de_sind4,frac_sim_fa_de_sind4] = do_simulations(time,tstart,tdel,nstage,sind,ngroup,tau_fa,N,N_GRD,frac_smooth_U,frac_smooth_G,frac_smooth_P,frac_smooth_A,frac_smooth_T,frac_smooth_GRD_res,frac_smooth_tempres,n_move_fa_de,n_leave_fa_de,n_drop_fa_de,n_move_outside_fa_de);
    [n_sim_sl_de_sind4,frac_sim_sl_de_sind4] = do_simulations(time,tstart,tdel,nstage,sind,ngroup,tau_sl,N,N_GRD,frac_smooth_U,frac_smooth_G,frac_smooth_P,frac_smooth_A,frac_smooth_T,frac_smooth_GRD_res,frac_smooth_tempres,n_move_sl_de,n_leave_sl_de,n_drop_sl_de,n_move_outside_sl_de);
    clear sind
    save 'model_output_varyinputstage.mat' *
    clear n_sim* frac_sim*
%-----(4b) SIMULATE (VARY STARTING STAGE) --------------------------------%


%-----(4c) SIMULATE (VARY STARTING YEAR) ---------------------------------%
    % uses subset of group data to simulate the number of individuals by group
    %       moving among stages each year.
    % This set of simulations varies the initial year simulations start and
    %   varies the stage at which NSF data is fed in
    
    % set index of stage where NSF data is fed in
    % 1=U, 2=G, 3=P, 4=A, 5=T
    sind = 1;

    % run short simulations: tdel years each
    tdel = 10; % simulation length
    startyear = [1991 1996 2001 2006]; % set starting year
    for i = 1:length(startyear)
        tstart = find(time==startyear(i)); % index corresponding to start year
        
        % simulate individuals by group over time
        % output: years x group x stage
        sind = 1;
        [n_sim_fa_su_sind1,frac_sim_fa_su_sind1] = do_simulations(time,tstart,tdel,nstage,sind,ngroup,tau_fa,N,N_GRD,frac_smooth_U,frac_smooth_G,frac_smooth_P,frac_smooth_A,frac_smooth_T,frac_smooth_GRD_res,frac_smooth_tempres,n_move_fa_su,n_leave_fa_su,n_drop_fa_su,n_move_outside_fa_su);
        [n_sim_sl_su_sind1,frac_sim_sl_su_sind1] = do_simulations(time,tstart,tdel,nstage,sind,ngroup,tau_sl,N,N_GRD,frac_smooth_U,frac_smooth_G,frac_smooth_P,frac_smooth_A,frac_smooth_T,frac_smooth_GRD_res,frac_smooth_tempres,n_move_sl_su,n_leave_sl_su,n_drop_sl_su,n_move_outside_sl_su);
        [n_sim_fa_de_sind1,frac_sim_fa_de_sind1] = do_simulations(time,tstart,tdel,nstage,sind,ngroup,tau_fa,N,N_GRD,frac_smooth_U,frac_smooth_G,frac_smooth_P,frac_smooth_A,frac_smooth_T,frac_smooth_GRD_res,frac_smooth_tempres,n_move_fa_de,n_leave_fa_de,n_drop_fa_de,n_move_outside_fa_de);
        [n_sim_sl_de_sind1,frac_sim_sl_de_sind1] = do_simulations(time,tstart,tdel,nstage,sind,ngroup,tau_sl,N,N_GRD,frac_smooth_U,frac_smooth_G,frac_smooth_P,frac_smooth_A,frac_smooth_T,frac_smooth_GRD_res,frac_smooth_tempres,n_move_sl_de,n_leave_sl_de,n_drop_sl_de,n_move_outside_sl_de);
        % feed in at G level (sind=2)
        sind = 2;
        [n_sim_fa_su_sind2,frac_sim_fa_su_sind2] = do_simulations(time,tstart,tdel,nstage,sind,ngroup,tau_fa,N,N_GRD,frac_smooth_U,frac_smooth_G,frac_smooth_P,frac_smooth_A,frac_smooth_T,frac_smooth_GRD_res,frac_smooth_tempres,n_move_fa_su,n_leave_fa_su,n_drop_fa_su,n_move_outside_fa_su);
        [n_sim_sl_su_sind2,frac_sim_sl_su_sind2] = do_simulations(time,tstart,tdel,nstage,sind,ngroup,tau_sl,N,N_GRD,frac_smooth_U,frac_smooth_G,frac_smooth_P,frac_smooth_A,frac_smooth_T,frac_smooth_GRD_res,frac_smooth_tempres,n_move_sl_su,n_leave_sl_su,n_drop_sl_su,n_move_outside_sl_su);
        [n_sim_fa_de_sind2,frac_sim_fa_de_sind2] = do_simulations(time,tstart,tdel,nstage,sind,ngroup,tau_fa,N,N_GRD,frac_smooth_U,frac_smooth_G,frac_smooth_P,frac_smooth_A,frac_smooth_T,frac_smooth_GRD_res,frac_smooth_tempres,n_move_fa_de,n_leave_fa_de,n_drop_fa_de,n_move_outside_fa_de);
        [n_sim_sl_de_sind2,frac_sim_sl_de_sind2] = do_simulations(time,tstart,tdel,nstage,sind,ngroup,tau_sl,N,N_GRD,frac_smooth_U,frac_smooth_G,frac_smooth_P,frac_smooth_A,frac_smooth_T,frac_smooth_GRD_res,frac_smooth_tempres,n_move_sl_de,n_leave_sl_de,n_drop_sl_de,n_move_outside_sl_de);
        % feed in at A level (sind=4)
        sind = 4;
        [n_sim_fa_su_sind4,frac_sim_fa_su_sind4] = do_simulations(time,tstart,tdel,nstage,sind,ngroup,tau_fa,N,N_GRD,frac_smooth_U,frac_smooth_G,frac_smooth_P,frac_smooth_A,frac_smooth_T,frac_smooth_GRD_res,frac_smooth_tempres,n_move_fa_su,n_leave_fa_su,n_drop_fa_su,n_move_outside_fa_su);
        [n_sim_sl_su_sind4,frac_sim_sl_su_sind4] = do_simulations(time,tstart,tdel,nstage,sind,ngroup,tau_sl,N,N_GRD,frac_smooth_U,frac_smooth_G,frac_smooth_P,frac_smooth_A,frac_smooth_T,frac_smooth_GRD_res,frac_smooth_tempres,n_move_sl_su,n_leave_sl_su,n_drop_sl_su,n_move_outside_sl_su);
        [n_sim_fa_de_sind4,frac_sim_fa_de_sind4] = do_simulations(time,tstart,tdel,nstage,sind,ngroup,tau_fa,N,N_GRD,frac_smooth_U,frac_smooth_G,frac_smooth_P,frac_smooth_A,frac_smooth_T,frac_smooth_GRD_res,frac_smooth_tempres,n_move_fa_de,n_leave_fa_de,n_drop_fa_de,n_move_outside_fa_de);
        [n_sim_sl_de_sind4,frac_sim_sl_de_sind4] = do_simulations(time,tstart,tdel,nstage,sind,ngroup,tau_sl,N,N_GRD,frac_smooth_U,frac_smooth_G,frac_smooth_P,frac_smooth_A,frac_smooth_T,frac_smooth_GRD_res,frac_smooth_tempres,n_move_sl_de,n_leave_sl_de,n_drop_sl_de,n_move_outside_sl_de);
        clear sind

        save(strcat(['model_output_varystartyear_i=' num2str(i) '.mat']))
        clear n_sim* frac_sim* tstart
    end
%-----(4c) SIMULATE (VARIANTS) -------------------------------------------%
