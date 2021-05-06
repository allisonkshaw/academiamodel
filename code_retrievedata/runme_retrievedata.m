clear all; clc
% written June 2020  by Allison Shaw (contact ashaw@umn.edu for assistance)
% last updated 6 May 2021
%
% This is the first of two main script which calls other 'do' functions.
% This script:
% (1) retrieves and saves NSF data on basic model structure (# in each stage over time)
% (2) retrieves and saves NSF data on race/ethnicity in each stage over time


% (1) retrieves and saves NSF data on basic model structure (# in each stage over time)
    do_structure_data_retrieval
    
% (2) retrieves and saves NSF data on race/ethnicity in each stage over time
    % retrieve data on undergraduate students
    do_group_data_retrieval_UGD
    
    % retrieve data on graduate students
    do_group_data_retrieval_GR
    
    % retrieve data on postdoctoral researchers
    do_group_data_retrieval_PD
    
    % retrieve data on faculty (assistant and tenured professors)
    do_group_data_retrieval_faculty
    
    % retrieve data on PhD degree recipients by residency
    % (above student data is just for US citizens and permanent residents
    % first data available for temporary residents is at the PhD degree)
    do_group_data_retrieval_residency
  