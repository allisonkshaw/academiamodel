function[yr_smooth,frac_smooth_U,frac_smooth_G,frac_smooth_P,frac_smooth_A,frac_smooth_T,frac_smooth_GRD_res,frac_smooth_tempres] = do_group_data_clean(ngroup,yr_NSF_U,N_NSF_UGD,yr_NSF_G,N_NSF_GR,yr_NSF_P,N_NSF_PD,yr_NSF_A,N_NSF_AP,yr_NSF_T,N_NSF_TP,yr_GRD_res,N_GRD_res,yr_NSF_tempres,N_NSF_tempres)
% USAGE: [yr_smooth,frac_smooth_U,frac_smooth_G,frac_smooth_P,frac_smooth_A,frac_smooth_T,frac_smooth_GRD_res,frac_smooth_tempres] = do_group_data_clean(ngroup,yr_NSF_U,N_NSF_UGD,yr_NSF_G,N_NSF_GR,yr_NSF_P,N_NSF_PD,yr_NSF_A,N_NSF_AP,yr_NSF_T,N_NSF_TP,yr_GRD_res,N_GRD_res,yr_NSF_tempres,N_NSF_tempres)
% written August 2020 by Allison Shaw (contact ashaw@umn.edu for assistance)
% updated 6 May 2021
%
% Inputs raw NSF data for groups, trims, converts to fraction, smooths,
%   and outputs.
% Also sets Hawaiian/Pacific Islander and More than one race categories to
%   only start in 2012 for all stages.
%
% INPUT:
%   ngroup = number of groups to consider
%   yr_NSF_U = years for which there are data on N_NSF_UGD
%   N_NSF_UGD = number of UGD by group (column) for years (rows)
%   yr_NSF_G = years for which there are data on N_NSF_GR
%   N_NSF_GR = number of GR by group (column) for years (rows)
%   yr_NSF_P = years for which there are data on N_NSF_PD
%   N_NSF_PD = number of PD by group (column) for years (rows)
%   yr_NSF_A = years for which there are data on N_NSF_AP
%   N_NSF_AP = number of AP by group (column) for years (rows)
%   yr_NSF_T = years for which there are data on N_NSF_TP
%   N_NSF_TP = number of TP by group (column) for years (rows)
%   yr_GRD_res = years for which there are data on N_res
%   N_GRD_res = number of GRD that are (i) US citizens/permanent residents
%     or (ii) temporary residents
%   yr_NSF_tempres = years for which there are data on N_NSF_tempres
%   N_NSF_tempres = number of individuals by group (columns) for years
%     (rows), data to approximate temporary resident GRDs (graduate degrees)
%
% OUTPUT:
%   yr_smooth = years for which there are smoothed group data
%   frac_smooth_U = fraction of UGD by group (column) for years (rows)
%   frac_smooth_G = fraction of GR by group (column) for years (rows)
%   frac_smooth_P = fraction of PD by group (column) for years (rows)
%   frac_smooth_A = fraction of AP by group (column) for years (rows)
%   frac_smooth_T = fraction of TP by group (column) for years (rows)
%   frac_smooth_GRD_res = fraction of GRD by CITIZENSHIP group (columns) for years (rows)
%   frac_smooth_tempres = fraction by group (column) for years (rows) for GRD temporary residents

 % (cut out unknown, temp residents)
 N_NSF_UGD = N_NSF_UGD(:,1:ngroup);
 N_NSF_GR = N_NSF_GR(:,1:ngroup);
 N_NSF_PD = N_NSF_PD(:,1:ngroup);
 N_NSF_AP = N_NSF_AP(:,1:ngroup);
 N_NSF_TP = N_NSF_TP(:,1:ngroup);
 
% calculate fraction of each group in each stage over time
frac_U = N_NSF_UGD./nansum(N_NSF_UGD,2);
frac_G = N_NSF_GR./nansum(N_NSF_GR,2);
frac_P = N_NSF_PD./nansum(N_NSF_PD,2);
frac_A = N_NSF_AP./nansum(N_NSF_AP,2);
frac_T = N_NSF_TP./nansum(N_NSF_TP,2);
clear N_NSF_UGD N_NSF_GR N_NSF_PD N_NSF_AP N_NSF_TP

%UNDERGRAD GROUP
    % add NaN for missing year (1999)
    ind1 = find(yr_NSF_U==1998);
    yr_NSF_U = [yr_NSF_U(1:ind1); 1999; yr_NSF_U(ind1+1:end)];
    frac_U = [frac_U(1:ind1,:); NaN(1,ngroup); frac_U(ind1+1:end,:)];
    clear ind1
    % smooth fraction with moving mean, across 5 values
    frac_smooth_U = smoothdata(frac_U,'movmean',5,'omitnan');
    % remove 'extra' early Hawaiian and Multiple-race data that was added with smoothing
    frac_smooth_U(24:25,6) = NaN;
    frac_smooth_U(24:25,7) = NaN;
    % trim down to just 1991 to 2016
    ind1 = find(yr_NSF_U==1991);
    ind2 = find(yr_NSF_U==2016);
    yr_smooth_U = yr_NSF_U(ind1:ind2);
    frac_smooth_U = frac_smooth_U(ind1:ind2,:);
    clear ind1 ind2 frac_U yr_NSF_U

%GRAD GROUP
    % add NaN for missing years (2007,2011,2013,2015)
    for yr = [2007,2011,2013,2015]
        ind1 = find(yr_NSF_G==yr-1);
        yr_NSF_G = [yr_NSF_G(1:ind1); yr; yr_NSF_G(ind1+1:end)];
        frac_G = [frac_G(1:ind1,:); NaN(1,ngroup); frac_G(ind1+1:end,:)];
    end
    clear ind1
    % smooth fraction with moving mean, across 5 values
    frac_smooth_G = smoothdata(frac_G,'movmean',5,'omitnan');
    % remove 'extra' early Hawaiian and Multiple-race data that was added with smoothing
    frac_smooth_G(21:22,6) = NaN;
    frac_smooth_G(21:22,7) = NaN;
    % trim down to just 1991+ data
    ind1 = find(yr_NSF_G==1991);
    yr_smooth_G = yr_NSF_G(ind1:end);
    frac_smooth_G = frac_smooth_G(ind1:end,:);
    clear ind1 frac_G yr_NSF_G
  
%ASSISTANT PROFESSOR GROUP
    % add NaN for missing years (1992,1994,1996,1998,1999,2000,2002,2004,2005,2007,2009,2011,2012,2014)
    for yr = [1992,1994,1996,1998,1999,2000,2002,2004,2005,2007,2009,2011,2012,2014]
        ind1 = find(yr_NSF_A==yr-1);
        yr_NSF_A = [yr_NSF_A(1:ind1); yr; yr_NSF_A(ind1+1:end)];
        frac_A = [frac_A(1:ind1,:); NaN(1,ngroup); frac_A(ind1+1:end,:)];
    end
    clear ind1
    % smooth fraction with moving mean, across 5 values
    frac_smooth_A = smoothdata(frac_A,'movmean',5,'omitnan');
    % remove 'extra' early Hawaiian and Multiple-race data that was added with smoothing
    frac_smooth_A(18:19,6) = NaN;
    frac_smooth_A(16:17,7) = NaN;
    yr_smooth_A = yr_NSF_A;
    clear ind1 frac_A yr_NSF_A

%TENURED PROFESSOR GROUP
    % add NaN for missing years (1992,1994,1996,1998,1999,2000,2002,2004,2005,2007,2009,2011,2012,2014)
    for yr = [1992,1994,1996,1998,1999,2000,2002,2004,2005,2007,2009,2011,2012,2014]
        ind1 = find(yr_NSF_T==yr-1);
        yr_NSF_T = [yr_NSF_T(1:ind1); yr; yr_NSF_T(ind1+1:end)];
        frac_T = [frac_T(1:ind1,:); NaN(1,ngroup); frac_T(ind1+1:end,:)];
    end
    clear ind1
    % smooth fraction with moving mean, across 5 values
    frac_smooth_T = smoothdata(frac_T,'movmean',5,'omitnan');
    % remove 'extra' early Hawaiian and Multiple-race data that was added with smoothing
    frac_smooth_T(18:19,6) = NaN;
    frac_smooth_T(16:17,7) = NaN;
    yr_smooth_T = yr_NSF_T;
    clear ind1 frac_T yr_NSF_T
    
%POSTDOC GROUP
    % smooth fraction with moving mean, across 5 values
    frac_smooth_P = smoothdata(frac_P,'movmean',5,'omitnan');
    % for missing years (1991-2009), approximate as average of AP and GR
    yr_P = [];
    frac_P = [];
    for i=1:length(1991:2009)
        yr_P = [yr_P; yr_smooth_G(i)];
        frac_P = [frac_P; mean([frac_smooth_G(i,:); frac_smooth_A(i,:)])];
    end
    % combine GR/AP estimated data with NSF data
    yr_smooth_P = [yr_P; yr_NSF_P];
    frac_smooth_P = [frac_P; frac_smooth_P];
    % trim off 2017+ data
    ind = find(yr_smooth_P==2016);
    yr_smooth_P = yr_smooth_P(1:ind);
    frac_smooth_P = frac_smooth_P(1:ind,:);
    clear i ind yr_NSF_P yr_P frac_P
    
% sub in zeros for NaNs for missing data (e.g. mostly Hawaiian data pre 2010)
frac_smooth_U(isnan(frac_smooth_U))=0;
frac_smooth_G(isnan(frac_smooth_G))=0;
frac_smooth_P(isnan(frac_smooth_P))=0;
frac_smooth_A(isnan(frac_smooth_A))=0;
frac_smooth_T(isnan(frac_smooth_T))=0;

%GRAD DEGREES - PROPORTION TEMPORARY RESIDENT
    %proportion of known that are temp residents
    frac_GRD_res = N_GRD_res./sum(N_GRD_res,2);
    % smooth fraction with moving mean, across 5 values
    frac_smooth_GRD_res = smoothdata(frac_GRD_res,'movmean',5,'omitnan');
    % cut out data outside 1991:2016
    i1=find(yr_GRD_res==1991);
    i2=find(yr_GRD_res==2016);
    yr_smooth_GRD_res = yr_GRD_res(i1:i2);
    frac_smooth_GRD_res = frac_smooth_GRD_res(i1:i2,:);
    clear i1 i2 N_GRD_res frac_GRD_res yr_GRD_res

%TEMPORARY RESIDENT GRAD DEGREES - PROPORTION BY GROUP
    %calculate fraction of each group in each stage over time
    frac_tempres = N_NSF_tempres./nansum(N_NSF_tempres,2);
    % add NaN for missing data
    frac_tempres((frac_tempres)==0)=NaN;
    % add NaN for missing years (1992,1994,1995,1996,1997,1998,1999)
    for yr = [1992,1994,1995,1996,1997,1998,1999]
        ind1 = find(yr_NSF_tempres==yr-1);
        yr_NSF_tempres = [yr_NSF_tempres(1:ind1); yr; yr_NSF_tempres(ind1+1:end)];
        frac_tempres = [frac_tempres(1:ind1,:); NaN(1,ngroup); frac_tempres(ind1+1:end,:)];
    end
    % smooth fraction with moving mean, across 5 values
    frac_smooth_tempres = smoothdata(frac_tempres,'movmean',5,'omitnan');
    % remove 'extra' early Native data that was added with smoothing
    frac_smooth_tempres(9:10,5) = NaN;
    % trim down to just 1991 to 2016
    ind1 = find(yr_NSF_tempres==1991);
    ind2 = find(yr_NSF_tempres==2016);
    yr_smooth_tempres = yr_NSF_tempres(ind1:ind2);
    frac_smooth_tempres = frac_smooth_tempres(ind1:ind2,:);
    clear ind1 ind2 yr N_NSF_tempres yr_NSF_tempres frac_tempres
    % interpolate still missing years (1996,1997)
    w1 = [2/3 1/3];
    w2 = 1-w1;
    dtmp = size(frac_smooth_tempres,2);
    frac_smooth_tempres(6:7,:) = [(repmat(w1',1,dtmp).*frac_smooth_tempres(5,:)+repmat(w2',1,dtmp).*frac_smooth_tempres(8,:))];
    clear w1 w2 dtmp
    % sub in zeros for NaNs for missing data (Native Americans)
    frac_smooth_tempres(isnan(frac_smooth_tempres))=0;
   

% category of Hawaiian/Pacific Islander is added in different years for
%   different stages: 2011 for U, 2012 for G, 2010 for P/A/T
% adjust data so that they are added in the same year (2012) for all stages
%   to avoid problems with the model
% do this by adding the fraction in Hawaiian back to Asian for
% * U in 2011
frac_smooth_U(21,2) = frac_smooth_U(21,2) + frac_smooth_U(21,6);
frac_smooth_U(21,6) = 0;
% * P in 2010-2011
frac_smooth_P(20:21,2) = frac_smooth_P(20:21,2) + frac_smooth_P(20:21,6);
frac_smooth_P(20:21,6) = 0;
% * A in 2010-2011
frac_smooth_A(20:21,2) = frac_smooth_A(20:21,2) + frac_smooth_A(20:21,6);
frac_smooth_A(20:21,6) = 0;
% * T in 2010-2011
frac_smooth_T(20:21,2) = frac_smooth_T(20:21,2) + frac_smooth_T(20:21,6);
frac_smooth_T(20:21,6) = 0;

% category of more than one race is added in different years for
%   different stages: 2011 for U, 2012 for G, 2010 for P, 2008 for A/T
% adjust data so that they are added in the same year (2012) for all stages
%   to avoid problems with the model
% do this by setting the fraction of more than one race to zero for
% * U in 2011
frac_smooth_U(21,7) = 0;
% * P in 2010-2011
frac_smooth_P(20:21,7) = 0;
% * A in 2008-2011
frac_smooth_A(18:21,7) = 0;
% * T in 2008-2011
frac_smooth_T(18:21,7) = 0;
% * temporary residents in 2001-2011
frac_smooth_tempres(9:21,7) = 0;
    
    
% since all smoothed data now have the same year range, just save as single
% variable
yr_smooth = yr_smooth_U;
clear yr_smooth_*

% normalize all fractions so that they sum to one
frac_smooth_U = frac_smooth_U./sum(frac_smooth_U,2);
frac_smooth_G = frac_smooth_G./sum(frac_smooth_G,2);
frac_smooth_P = frac_smooth_P./sum(frac_smooth_P,2);
frac_smooth_A = frac_smooth_A./sum(frac_smooth_A,2);
frac_smooth_T = frac_smooth_T./sum(frac_smooth_T,2);
frac_smooth_GRD_res = frac_smooth_GRD_res./sum(frac_smooth_GRD_res,2);
frac_smooth_tempres = frac_smooth_tempres./sum(frac_smooth_tempres,2);