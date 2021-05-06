function[yr_UGD,N_UGD,yr_GRD,N_GRD,yr_GR,N_GR,yr_PD,N_PD,yr_AP,N_AP,yr_TP,N_TP] = do_structure_data_clean(yr_UGD,N_UGD,yr_GRD,N_GRD,yr_GR,N_GR,yr_PD,N_PD,yr_AP,N_AP,yr_TP,N_TP)
% USAGE: [yr_UGD,N_UGD,yr_GRD,N_GRD,yr_GR,N_GR,yr_PD,N_PD,yr_AP,N_AP,yr_TP,N_TP] = do_structure_data_clean(yr_UGD,N_UGD,yr_GRD,N_GRD,yr_GR,N_GR,yr_PD,N_PD,yr_AP,N_AP,yr_TP,N_TP)
% written July 2020  by Allison Shaw (contact ashaw@umn.edu for assistance)
% updated 29 Oct 2020
%
% call in raw NSF data and trim/interpolate/extrapolate as needed:
%   NOTE 1: AP and TP pool sizes are only every other year or so and need
%     to be interpolated to yearly
%   NOTE 2: undergrad data is missing for 1999 so interpolate in
%   NOTE 3: trim all data to 1991-2016
%
% INPUT/OUTPUT:
%   yr_UGD = years for which there are data on N_UGD
%   N_UGD = number of undergraduate degrees for each year
%   yr_GRD = years for which there are data on N_GRD
%   N_GRD = number of PhD degrees for each year
%   yr_GR = years for which there are data on N_GR
%   N_GR = number of graduate students for each year
%   yr_PD = years for which there are data on N_PD
%   N_PD = number of postdoctoral researchers for each year
%   yr_AP = years for which there are data on N_AP
%   N_AP = number of assistant professors for each year
%   yr_TP = years for which there are data on N_TP
%   N_TP = number of tenured professors for each year

%%-----TRUNCATED-DATA------------------------------------------------------

% truncate all data to 1991-2016
yr_UGD = yr_UGD(26:end)';
 N_UGD =  N_UGD(26:end);
yr_GRD = yr_GRD(26:end)';
 N_GRD =  N_GRD(26:end);
yr_GR = yr_GR(17:end-2)';
 N_GR =  N_GR(17:end-2);
yr_PD = yr_PD(13:end-2)';
 N_PD =  N_PD(13:end-2);
yr_AP = yr_AP(8:end)';
 N_AP =  N_AP(8:end);
yr_TP = yr_TP(8:end)';
 N_TP =  N_TP(8:end);

% interpolate in missing year for UGD
N_UGD(9) = 0.5*(N_UGD(8)+N_UGD(10));

% interpolate in missing years for faculty
yr_AP_new = [];
 N_AP_new = [];
yr_TP_new = [];
 N_TP_new = [];

% interpolate single missing even years (add 1992, 1994, 1996, 1998, 2000, 2002)
for i=1:6
    yr_AP_new(end+1:end+2) = [yr_AP(i) 0.5*(yr_AP(i)+yr_AP(i+1))];
     N_AP_new(end+1:end+2) = [ N_AP(i) 0.5*( N_AP(i)+ N_AP(i+1))];
    yr_TP_new(end+1:end+2) = [yr_TP(i) 0.5*(yr_TP(i)+yr_TP(i+1))];
     N_TP_new(end+1:end+2) = [ N_TP(i) 0.5*( N_TP(i)+ N_TP(i+1))];
end

% interpolate multi-missing years even years (add 2004, 2005)
tmp = yr_AP(7:8); yr_AP_new(end+1:end+3) = [tmp(1) (2*tmp(1)+tmp(2))/3 (tmp(1)+2*tmp(2))/3];
tmp =  N_AP(7:8);  N_AP_new(end+1:end+3) = [tmp(1) (2*tmp(1)+tmp(2))/3 (tmp(1)+2*tmp(2))/3];
tmp = yr_TP(7:8); yr_TP_new(end+1:end+3) = [tmp(1) (2*tmp(1)+tmp(2))/3 (tmp(1)+2*tmp(2))/3];
tmp =  N_TP(7:8);  N_TP_new(end+1:end+3) = [tmp(1) (2*tmp(1)+tmp(2))/3 (tmp(1)+2*tmp(2))/3];

% interpolate single missing even years (add 2007, 2009)
for i=8:9
    yr_AP_new(end+1:end+2) = [yr_AP(i) 0.5*(yr_AP(i)+yr_AP(i+1))];
     N_AP_new(end+1:end+2) = [ N_AP(i) 0.5*( N_AP(i)+ N_AP(i+1))];
    yr_TP_new(end+1:end+2) = [yr_TP(i) 0.5*(yr_TP(i)+yr_TP(i+1))];
     N_TP_new(end+1:end+2) = [ N_TP(i) 0.5*( N_TP(i)+ N_TP(i+1))];
end

% interpolate multi-missing years even years (add 2011, 2012)
tmp = yr_AP(10:11); yr_AP_new(end+1:end+3) = [tmp(1) (2*tmp(1)+tmp(2))/3 (tmp(1)+2*tmp(2))/3];
tmp =  N_AP(10:11);  N_AP_new(end+1:end+3) = [tmp(1) (2*tmp(1)+tmp(2))/3 (tmp(1)+2*tmp(2))/3];
tmp = yr_TP(10:11); yr_TP_new(end+1:end+3) = [tmp(1) (2*tmp(1)+tmp(2))/3 (tmp(1)+2*tmp(2))/3];
tmp =  N_TP(10:11);  N_TP_new(end+1:end+3) = [tmp(1) (2*tmp(1)+tmp(2))/3 (tmp(1)+2*tmp(2))/3];

% interpolate single missing even years (add 2014, 2016)
% also leave out 2017
for i=11:12
    yr_AP_new(end+1:end+2) = [yr_AP(i) 0.5*(yr_AP(i)+yr_AP(i+1))];
     N_AP_new(end+1:end+2) = [ N_AP(i) 0.5*( N_AP(i)+ N_AP(i+1))];
    yr_TP_new(end+1:end+2) = [yr_TP(i) 0.5*(yr_TP(i)+yr_TP(i+1))];
     N_TP_new(end+1:end+2) = [ N_TP(i) 0.5*( N_TP(i)+ N_TP(i+1))];
end

yr_AP = yr_AP_new;
 N_AP =  N_AP_new';
yr_TP = yr_TP_new;
 N_TP =  N_TP_new';
 
clear *_new i tmp