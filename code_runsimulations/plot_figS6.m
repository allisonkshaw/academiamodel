clear all; clc
% written July 2020 by Allison Shaw (contact ashaw@umn.edu for assistance)
% last updated 6 May 2021

time = 1991:2016; % make sure this matches pipeline and race/ethnicity data ranges
T = length(time);
gind = 2; % grad stage index

% load raw model structure data
data = readmatrix('../datafiles_NSF/N_UGD.csv'); yr_UGD = data(:,1); N_UGD = data(:,2);
data = readmatrix('../datafiles_NSF/N_GRD.csv'); yr_GRD = data(:,1); N_GRD = data(:,2);
data = readmatrix('../datafiles_NSF/N_GR.csv');  yr_GR  = data(:,1); N_GR  = data(:,2);
data = readmatrix('../datafiles_NSF/N_PD.csv');  yr_PD  = data(:,1); N_PD  = data(:,2);
data = readmatrix('../datafiles_NSF/N_AP.csv');  yr_AP  = data(:,1); N_AP  = data(:,2);
data = readmatrix('../datafiles_NSF/N_TP.csv');  yr_TP  = data(:,1); N_TP  = data(:,2);
clear data

% clean (truncate/interpolate)
[yr_UGD,N_UGD,yr_GRD,N_GRD,yr_GR,N_GR,yr_PD,N_PD,yr_AP,N_AP,yr_TP,N_TP] = do_structure_data_clean(yr_UGD,N_UGD,yr_GRD,N_GRD,yr_GR,N_GR,yr_PD,N_PD,yr_AP,N_AP,yr_TP,N_TP);

N = [N_UGD'; N_GR'; N_PD'; N_AP'; N_TP']; % number in each stage (row) for each year (column)

% number of years spent in each pool (T_GR, T_PD, T_AP, T_TP)
T_GR = 6.8;    % 2015 (https://www.nsf.gov/statistics/2018/nsb20181/assets/561/tables/at02-30.xlsx)
T_PD = 2*1.9;  % 2009 (http://www.nsf.gov/statistics/infbrief/nsf08307/tab2.xls)
T_AP_fa = 5;
T_AP_sl = 8;
T_TP_fa = 20;     %guess 20-30: half retired by 67 (http://nsf.gov/statistics/seind10/c3/c3s3.htm)
T_TP_sl = 30;
tau_fa = [NaN; T_GR; T_PD; T_AP_fa; T_TP_fa]; % turnover rates for each stage
tau_sl = [NaN; T_GR; T_PD; T_AP_sl; T_TP_sl]; % turnover rates for each stage
nstage = length(tau_sl);

% uses pipeline data to estimate the number of individuals moving among stages each year
[n_move_fa_su,n_leave_fa_su,n_drop_fa_su,n_move_outside_fa_su] = do_transition_estimates(time,N,N_GRD,tau_fa,'supply');
[n_move_sl_su,n_leave_sl_su,n_drop_sl_su,n_move_outside_sl_su] = do_transition_estimates(time,N,N_GRD,tau_sl,'supply');
[n_move_fa_de,n_leave_fa_de,n_drop_fa_de,n_move_outside_fa_de] = do_transition_estimates(time,N,N_GRD,tau_fa,'demand');
[n_move_sl_de,n_leave_sl_de,n_drop_sl_de,n_move_outside_sl_de] = do_transition_estimates(time,N,N_GRD,tau_sl,'demand');

%%
lw = 2; % fig lines
mksize = 10; % markersize
fs1 = 11;  % axes labels
fs3 = 9;  % axis numbering
lw2 = 1; % fig edges

sx = 0.10;
sy = 0.05;
wi = 0.17;
he = 0.11;
delx = 0.17;
dely = 0.09;

figure(1); clf
hh = gcf;
set(hh,'PaperUnits','inches');
set(hh,'Units','inches');
width = 6; height = 9;
xpos = 5;
ypos = 4;
set(gcf,'Position',[xpos ypos width height])

% UNDERGRAD
j=1;
axes('position',[sx sy+4*(dely+he) wi he])
    plot(time(1:end-1),n_move_fa_de(j,:),'-','LineWidth',lw)
    hold on
    plot(time(1:end-1),n_move_sl_de(j,:),'-','LineWidth',lw)
    plot(time(1:end-1),n_move_fa_su(j,:),'-','LineWidth',lw)
    plot(time(1:end-1),n_move_sl_su(j,:),'-','LineWidth',lw)
    axis([1990 2020 0 150000])
    set(gca,'YTick',[0 50000 100000 150000])
    set(gca,'YTickLabel',[0 50 100 150])
    set(gca,'XTick',[1990 2005 2020])
    xlabel('Year','fontsize',fs1)
    ylabel('No. (thousands)','fontsize',fs1)
    title('UG to GR (\mu_U)','fontsize',fs1)   
    set(gca,'FontSize',fs3,'LineWidth',lw2,'Fontname', 'Arial');
axes('position',[sx+delx+wi       sy+4*(dely+he) wi+0.3 he])
    plot(time(1:end-1),n_leave_fa_de(j,:),'-','LineWidth',lw)
    hold on
    plot(time(1:end-1),n_leave_sl_de(j,:),'-','LineWidth',lw)
    plot(time(1:end-1),n_leave_fa_su(j,:),'-','LineWidth',lw)
    plot(time(1:end-1),n_leave_sl_su(j,:),'-','LineWidth',lw)
    axis([1990 2020 0 600000])
    set(gca,'YTick',[0 300000 600000])
    set(gca,'YTickLabel',[0 300 600])
    set(gca,'XTick',[1990 2005 2020])
    xlabel('Year','fontsize',fs1)
    ylabel('No. (thousands)','fontsize',fs1)
    title('UG to out (\lambda_U)','fontsize',fs1)
    set(gca,'FontSize',fs3,'LineWidth',lw2,'Fontname', 'Arial');
    legend('fast-demand','slow-demand','fast-supply','slow-supply','location','EastOutside','fontsize',fs1)

% GRAD
j=2;
axes('position',[sx sy+3*(dely+he) wi he])
    plot(time(1:end-1),n_move_fa_de(j,:),'-','LineWidth',lw)
    hold on
    plot(time(1:end-1),n_move_sl_de(j,:),'-','LineWidth',lw)
    plot(time(1:end-1),n_move_fa_su(j,:),'-','LineWidth',lw)
    plot(time(1:end-1),n_move_sl_su(j,:),'-','LineWidth',lw)
    axis([1990 2020 0 20000])
    set(gca,'YTick',[0 5000 10000 15000 20000])
    set(gca,'YTickLabel',[0 5 10 15 20])
    set(gca,'XTick',[1990 2005 2020])
    xlabel('Year','fontsize',fs1)
    ylabel('No. (thousands)','fontsize',fs1)
    title('GR to PD (\mu_G)','fontsize',fs1)   
    set(gca,'FontSize',fs3,'LineWidth',lw2,'Fontname', 'Arial');
axes('position',[sx+delx+wi  sy+3*(dely+he) wi he])
    plot(time(1:end-1),n_drop_fa_de,'-','LineWidth',lw)
    hold on
    plot(time(1:end-1),n_drop_sl_de,'-','LineWidth',lw)
    plot(time(1:end-1),n_drop_fa_su,'.','LineWidth',lw,'MarkerSize',mksize)
    plot(time(1:end-1),n_drop_sl_su,'-','LineWidth',lw)
    axis([1990 2020 0 55000])
    set(gca,'YTick',[0 25000 50000])
    set(gca,'YTickLabel',[0 25 50])
    set(gca,'XTick',[1990 2005 2020])
    xlabel('Year','fontsize',fs1)
    ylabel('No. (thousands)','fontsize',fs1)
    title({'GR to out','mid-degree (\delta_G)'},'fontsize',fs1)   
    set(gca,'FontSize',fs3,'LineWidth',lw2,'Fontname', 'Arial');
axes('position',[sx+2*(delx+wi) sy+3*(dely+he)   wi he])
    plot(time(1:end-1),n_leave_fa_de(j,:),'-','LineWidth',lw)
    hold on
    plot(time(1:end-1),n_leave_sl_de(j,:),'-','LineWidth',lw)
    plot(time(1:end-1),n_leave_fa_su(j,:),'-','LineWidth',lw)
    plot(time(1:end-1),n_leave_sl_su(j,:),'-','LineWidth',lw)
    axis([1990 2020 0 30000])
    set(gca,'YTick',[0 10000 20000 30000])
    set(gca,'YTickLabel',[0 10 20 30])
    set(gca,'XTick',[1990 2005 2020])
    xlabel('Year','fontsize',fs1)
    ylabel('No. (thousands)','fontsize',fs1)
    title({'GR to out','post-degree (\lambda_G)'},'fontsize',fs1)   
    set(gca,'FontSize',fs3,'LineWidth',lw2,'Fontname', 'Arial');

% POSTDOCS
j=3;
axes('position',[sx sy+2*(dely+he) wi he])
    plot(time(1:end-1),n_move_fa_de(j,:),'-','LineWidth',lw)
    hold on
    plot(time(1:end-1),n_move_sl_de(j,:),'-','LineWidth',lw)
    plot(time(1:end-1),n_move_fa_su(j,:),'-','LineWidth',lw)
    axis([1990 2020 0 20000])
    plot(time(1:end-1),n_move_sl_su(j,:),'-','LineWidth',lw)
    set(gca,'YTick',[0 10000 20000])
    set(gca,'YTickLabel',[0 10 20])
    set(gca,'XTick',[1990 2005 2020])
    xlabel('Year','fontsize',fs1)
    ylabel('No. (thousands)','fontsize',fs1)
    title('PD to AP (\mu_P)','fontsize',fs1)   
    set(gca,'FontSize',fs3,'LineWidth',lw2,'Fontname', 'Arial');
axes('position',[sx+delx+wi sy+2*(dely+he) wi he])
    plot(time(1:end-1),n_leave_fa_de(j,:),'-','LineWidth',lw)
    hold on
    plot(time(1:end-1),n_leave_sl_de(j,:),'-','LineWidth',lw)
    plot(time(1:end-1),n_leave_fa_su(j,:),'-','LineWidth',lw)
    plot(time(1:end-1),n_leave_sl_su(j,:),'-','LineWidth',lw)
    xlim([1990 2020])
    axis([1990 2020 0 6000])
    set(gca,'YTick',[0 2000 4000 6000])
    set(gca,'YTickLabel',[0 2 4 6])
    set(gca,'XTick',[1990 2005 2020])
    xlabel('Year','fontsize',fs1)
    ylabel('No. (thousands)','fontsize',fs1)
    title('PD to out (\lambda_P)','fontsize',fs1)   
    set(gca,'FontSize',fs3,'LineWidth',lw2,'Fontname', 'Arial');

% ASSISTANT PROFS
j=4;
axes('position',[sx sy+1*(dely+he) wi he])
    plot(time(1:end-1),n_move_fa_de(j,:),'-','LineWidth',lw)
    hold on
    plot(time(1:end-1),n_move_sl_de(j,:),'-','LineWidth',lw)
    plot(time(1:end-1),n_move_fa_su(j,:),'-','LineWidth',lw)
    plot(time(1:end-1),n_move_sl_su(j,:),'-','LineWidth',lw)
    axis([1990 2020 0 20000])
    set(gca,'YTick',[0 10000 20000])
    set(gca,'YTickLabel',[0 10 20])
    set(gca,'XTick',[1990 2005 2020])
    xlabel('Year','fontsize',fs1)
    ylabel('No. (thousands)','fontsize',fs1)
    title('AP to TP (\mu_A)','fontsize',fs1)   
    set(gca,'FontSize',fs3,'LineWidth',lw2,'Fontname', 'Arial');
axes('position',[sx+1*(delx+wi) sy+1*(dely+he) wi he])
    plot(time(1:end-1),n_leave_fa_de(j,:),'-','LineWidth',lw)
    hold on
    plot(time(1:end-1),n_leave_sl_de(j,:),'-','LineWidth',lw)
    plot(time(1:end-1),n_leave_fa_su(j,:),'-','LineWidth',lw)
    plot(time(1:end-1),n_leave_sl_su(j,:),'-','LineWidth',lw)
    axis([1990 2020 0 10000])
    set(gca,'YTick',[0 5000 10000])
    set(gca,'YTickLabel',[0 5 10])
    set(gca,'XTick',[1990 2005 2020])
    xlabel('Year','fontsize',fs1)
    ylabel('No. (thousands)','fontsize',fs1)
    title('AP to out (\lambda_A)','fontsize',fs1)   
    set(gca,'FontSize',fs3,'LineWidth',lw2,'Fontname', 'Arial');

% TENURED PROFS
j=5;
axes('position',[sx sy wi he])
    plot(time(1:end-1),n_move_fa_de(j,:),'-','LineWidth',lw,'MarkerSize',mksize)
    hold on
    plot(time(1:end-1),n_move_sl_de(j,:),'-','LineWidth',lw)
    plot(time(1:end-1),n_move_fa_su(j,:),'-','LineWidth',lw)
    plot(time(1:end-1),n_move_sl_su(j,:),'-','LineWidth',lw)
    axis([1990 2020 0 20000])
    set(gca,'YTick',[0 10000 20000])
    set(gca,'YTickLabel',[0 10 20])
    set(gca,'XTick',[1990 2005 2020])
    xlabel('Year','fontsize',fs1)
    ylabel('No. (thousands)','fontsize',fs1)
    title('TP retire (\mu_T = \rho_T)','fontsize',fs1)   
    set(gca,'FontSize',fs3,'LineWidth',lw2,'Fontname', 'Arial');

% Backup previous settings
prePaperType = get(hh,'PaperType');
prePaperPosition = get(hh,'PaperPosition');
prePaperSize = get(hh,'PaperSize');

% Make changing paper type possible
set(hh,'PaperType','<custom>');
% Set the page size and position to match the figure's dimensions
position = get(hh,'Position');
set(hh,'PaperPosition',[0,0,position(3:4)]);
set(hh,'PaperSize',position(3:4));

print -djpeg -r600 fig_S6_transitions.jpg

% Restore the previous settings
set(hh,'PaperType',prePaperType);
set(hh,'PaperPosition',prePaperPosition);
set(hh,'PaperSize',prePaperSize);

