clear all; clc
% written October 2020  by Allison Shaw (contact ashaw@umn.edu for assistance)
% last updated 6 May 2021

load('../datafiles_matlab/model_output_main.mat')
nstage = length(tau_fa); % number of academic stages
ngroup = length(groups); % number of individual groups (i.e., race/ethnicities)
time = 1991:2016; % years to simulate

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

% uses model structure data to estimate the number of individuals moving among stages each year
% this provides estimates for the 12 possible transitions in and out of
% classes (see schematic figure)
[n_move_fa_su,n_leave_fa_su,n_drop_fa_su,n_move_outside_fa_su] = do_transition_estimates(time,N,N_GRD,tau_fa,'supply');
[n_move_sl_su,n_leave_sl_su,n_drop_sl_su,n_move_outside_sl_su] = do_transition_estimates(time,N,N_GRD,tau_sl,'supply');
[n_move_fa_de,n_leave_fa_de,n_drop_fa_de,n_move_outside_fa_de] = do_transition_estimates(time,N,N_GRD,tau_fa,'demand');
[n_move_sl_de,n_leave_sl_de,n_drop_sl_de,n_move_outside_sl_de] = do_transition_estimates(time,N,N_GRD,tau_sl,'demand');


%-----WITH INTERNATIONAL STUDENTS-----------------------------------------%
    dim = size(frac_sim_fa_de); % get dimensions of simulated data (time x groups x stages)
    frac_sim_all_w = [frac_sim_fa_de(:) frac_sim_sl_de(:) frac_sim_fa_su(:) frac_sim_sl_su(:)];
    frac_sim_mean_w = mean(frac_sim_all_w,2); % get average
    frac_sim_max_w = max(frac_sim_all_w,[],2); % get highest simulated value
    frac_sim_min_w = min(frac_sim_all_w,[],2); % get lowest simulated value
    frac_sim_mean_w = reshape(frac_sim_mean_w,dim(1),dim(2),dim(3));
    frac_sim_min_w = reshape(frac_sim_min_w,dim(1),dim(2),dim(3));
    frac_sim_max_w = reshape(frac_sim_max_w,dim(1),dim(2),dim(3));
%-----WITH INTERNATIONAL STUDENTS-----------------------------------------%

%-----WITHOUT INTERNATIONAL STUDENTS--------------------------------------%
    % overwrite data so that all PhD graduates are assumed to be US
    % citizens / permanent residents
    frac_smooth_GRD_res(:,1) = 1;
    frac_smooth_GRD_res(:,2) = 0;

    % simulate individuals by group over time
    % output: years x group x stage
    [n_sim_fa_su,frac_sim_fa_su] = do_simulations(time,tstart,tdel,nstage,sind,ngroup,tau_fa,N,N_GRD,frac_smooth_U,frac_smooth_G,frac_smooth_P,frac_smooth_A,frac_smooth_T,frac_smooth_GRD_res,frac_smooth_tempres,n_move_fa_su,n_leave_fa_su,n_drop_fa_su,n_move_outside_fa_su);
    [n_sim_sl_su,frac_sim_sl_su] = do_simulations(time,tstart,tdel,nstage,sind,ngroup,tau_sl,N,N_GRD,frac_smooth_U,frac_smooth_G,frac_smooth_P,frac_smooth_A,frac_smooth_T,frac_smooth_GRD_res,frac_smooth_tempres,n_move_sl_su,n_leave_sl_su,n_drop_sl_su,n_move_outside_sl_su);
    [n_sim_fa_de,frac_sim_fa_de] = do_simulations(time,tstart,tdel,nstage,sind,ngroup,tau_fa,N,N_GRD,frac_smooth_U,frac_smooth_G,frac_smooth_P,frac_smooth_A,frac_smooth_T,frac_smooth_GRD_res,frac_smooth_tempres,n_move_fa_de,n_leave_fa_de,n_drop_fa_de,n_move_outside_fa_de);
    [n_sim_sl_de,frac_sim_sl_de] = do_simulations(time,tstart,tdel,nstage,sind,ngroup,tau_sl,N,N_GRD,frac_smooth_U,frac_smooth_G,frac_smooth_P,frac_smooth_A,frac_smooth_T,frac_smooth_GRD_res,frac_smooth_tempres,n_move_sl_de,n_leave_sl_de,n_drop_sl_de,n_move_outside_sl_de);
    
    dim = size(frac_sim_fa_de); % get dimensions of simulated data (time x groups x stages)
    frac_sim_all_wo = [frac_sim_fa_de(:) frac_sim_sl_de(:) frac_sim_fa_su(:) frac_sim_sl_su(:)];
    frac_sim_mean_wo = mean(frac_sim_all_wo,2); % get average
    frac_sim_max_wo = max(frac_sim_all_wo,[],2); % get highest simulated value
    frac_sim_min_wo = min(frac_sim_all_wo,[],2); % get lowest simulated value
    frac_sim_mean_wo = reshape(frac_sim_mean_wo,dim(1),dim(2),dim(3));
    frac_sim_min_wo = reshape(frac_sim_min_wo,dim(1),dim(2),dim(3));
    frac_sim_max_wo = reshape(frac_sim_max_wo,dim(1),dim(2),dim(3));
    


%-----WITHOUT INTERNATIONAL STUDENTS--------------------------------------%


fs1 = 11;  % axes labels
fs3 = 9;  % axis numbering
lw2 = 1; % fig edges
lw = 2; % fig lines

sx = 0.09;
sy = 0.07;
wi = 0.2;
he = 0.2;
delx = 0.13;
dely = 0.12;

colorder = [0.8500    0.3250    0.0980   % red
            0.9290    0.6940    0.1250   % yellow
            0.4660    0.6740    0.1880   % green
            0         0.4470    0.7410   % blue
            0.4940    0.1840    0.5560]; % purple

figure(2); clf
hh = gcf;
set(hh,'PaperUnits','inches');
set(hh,'Units','inches');
width = 6; height = 6;
xpos = 5;
ypos = 4;
set(gcf,'Position',[xpos ypos width height])



axes('position',[sx             sy+2*(dely+he) wi he])
    i=2; % Asian
    %plot model: lower values = upper bound
    hold on
    for j=2:5
        plot(time,squeeze(frac_sim_mean_w(:,i,j)),'Color',colorder(j,:),'LineWidth',lw)
        plot(time,squeeze(frac_sim_mean_wo(:,i,j)),':','Color',colorder(j,:),'LineWidth',lw)
    end
    box on
    xlabel('year','fontsize',fs1);
    ylabel('reprsentation','fontsize',fs1); 
    axis([1990 2020 0 0.3]);
    title(char(groups(i)),'fontsize',fs1);
    set(gca,'FontSize',fs3,'LineWidth',lw2,'Fontname', 'Arial');

axes('position',[sx+delx+wi     sy+2*(dely+he) wi he])
    i=3; % Black
    hold on
    for j=2:5
        plot(time,squeeze(frac_sim_mean_w(:,i,j)),'Color',colorder(j,:),'LineWidth',lw)
        plot(time,squeeze(frac_sim_mean_wo(:,i,j)),':','Color',colorder(j,:),'LineWidth',lw)
    end
    box on
    xlabel('year','fontsize',fs1);
    ylabel('representation','fontsize',fs1); 
    axis([1990 2020 0 0.1]);
    title(char(groups(i)),'fontsize',fs1);
    set(gca,'FontSize',fs3,'LineWidth',lw2,'Fontname', 'Arial');

axes('position',[sx+2*(delx+wi) sy+2*(dely+he) wi he])
    i=6; % Hawaiian
    hold on
    for j=2:5
        plot(time,squeeze(frac_sim_mean_w(:,i,j)),'Color',colorder(j,:),'LineWidth',lw)
        plot(time,squeeze(frac_sim_mean_wo(:,i,j)),':','Color',colorder(j,:),'LineWidth',lw)
    end
    box on
    xlabel('year','fontsize',fs1);
    ylabel('representation','fontsize',fs1); 
    axis([1990 2020 0 0.005]);
    set(gca,'YTick',[0 0.001 0.003 0.005])
    set(gca,'YTickLabel',[0 0.001 0.003 0.005])
    title(char(groups(i)),'fontsize',fs1);
    set(gca,'FontSize',fs3,'LineWidth',lw2,'Fontname', 'Arial');

axes('position',[sx             sy+dely+he wi he])
    i=4; % Hispanic
    hold on
    for j=2:5
        plot(time,squeeze(frac_sim_mean_w(:,i,j)),'Color',colorder(j,:),'LineWidth',lw)
        plot(time,squeeze(frac_sim_mean_wo(:,i,j)),':','Color',colorder(j,:),'LineWidth',lw)
    end
    box on
    xlabel('year','fontsize',fs1);
    ylabel('representation','fontsize',fs1); 
    axis([1990 2020 0 0.15]);
    title(char(groups(i)),'fontsize',fs1);
    set(gca,'FontSize',fs3,'LineWidth',lw2,'Fontname', 'Arial');


axes('position',[sx+delx+wi     sy+dely+he wi he])
    i=5; % Native
    hold on
    for j=2:5
        plot(time,squeeze(frac_sim_mean_w(:,i,j)),'Color',colorder(j,:),'LineWidth',lw)
        plot(time,squeeze(frac_sim_mean_wo(:,i,j)),':','Color',colorder(j,:),'LineWidth',lw)
    end
    box on
    xlabel('year','fontsize',fs1);
    ylabel('representation','fontsize',fs1); 
    axis([1990 2020 0 0.01]);
    title(char(groups(i)),'fontsize',fs1);
    set(gca,'FontSize',fs3,'LineWidth',lw2,'Fontname', 'Arial');

axes('position',[sx+2*(delx+wi) sy+dely+he wi he])
    i=1; % White
    hold on
    for j=2:5
        plot(time,squeeze(frac_sim_mean_w(:,i,j)),'Color',colorder(j,:),'LineWidth',lw)
        plot(time,squeeze(frac_sim_mean_wo(:,i,j)),':','Color',colorder(j,:),'LineWidth',lw)
    end
    box on
    xlabel('year','fontsize',fs1);
    ylabel('representation','fontsize',fs1); 
    axis([1990 2020 0.5 1]);
    set(gca,'YTick',0.5:0.1:1)
    title(char(groups(i)),'fontsize',fs1);
    set(gca,'FontSize',fs3,'LineWidth',lw2,'Fontname', 'Arial');

axes('position',[sx             sy wi he])
    i=7; % Multiple
    hold on
    for j=2:5
        plot(time,squeeze(frac_sim_mean_w(:,i,j)),'Color',colorder(j,:),'LineWidth',lw)
        plot(time,squeeze(frac_sim_mean_wo(:,i,j)),':','Color',colorder(j,:),'LineWidth',lw)
    end
    box on
    xlabel('year','fontsize',fs1);
    ylabel('representation','fontsize',fs1); 
    axis([1990 2020 0 0.03]);
    title(char(groups(i)),'fontsize',fs1);
    set(gca,'FontSize',fs3,'LineWidth',lw2,'Fontname', 'Arial');

% add legend axis
annotation('rectangle',[0.4 0.05 0.45 0.2],'Color','black','LineWidth',lw2)
axes('position',       [0.4 0.05 0.45 0.2])
    hold on
    xs = 1;
    i = 2; plot([xs xs+1],[4 4],'LineWidth',lw,'Color',colorder(i,:))
    i = 3; plot([xs xs+1],[3 3],'LineWidth',lw,'Color',colorder(i,:))
    i = 4; plot([xs xs+1],[2 2],'LineWidth',lw,'Color',colorder(i,:))
    i = 5; plot([xs xs+1],[1 1],'LineWidth',lw,'Color',colorder(i,:))
    xs = 3;
    i = 2; plot([xs xs+1],[4 4],':','LineWidth',lw,'Color',colorder(i,:))
    i = 3; plot([xs xs+1],[3 3],':','LineWidth',lw,'Color',colorder(i,:))
    i = 4; plot([xs xs+1],[2 2],':','LineWidth',lw,'Color',colorder(i,:))
    i = 5; plot([xs xs+1],[1 1],':','LineWidth',lw,'Color',colorder(i,:))
    axis off
    axis([0 15 0 6])
    xt = 5;
    text(0.5,5.2,'with  w/out')
    text(xt,4,'Graduate students')
    text(xt,3,'Postdoctoral researchers')
    text(xt,2,'Assistant Professors')
    text(xt,1,'Tenured Professors')
    set(gca,'FontSize',fs3,'LineWidth',lw2,'Fontname', 'Arial');
    
    

% labels
axes('position',[0 0 1 1],'visible','off')
hold on
     text(0.01, 0.09+3*he+2*dely,'a)','fontsize',fs3)
     text(0.34 ,0.09+3*he+2*dely,'b)','fontsize',fs3)
     text(0.67 ,0.09+3*he+2*dely,'c)','fontsize',fs3)
     text(0.01, 0.09+2*he+dely,'d)','fontsize',fs3)
     text(0.34 ,0.09+2*he+dely,'e)','fontsize',fs3)
     text(0.67 ,0.09+2*he+dely,'f)','fontsize',fs3)
     text(0.01 ,0.09+he,'g)','fontsize',fs3)
axis([0 1 0 1])


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

print -djpeg -r600 fig_S9_international.jpg

% Restore the previous settings
set(hh,'PaperType',prePaperType);
set(hh,'PaperPosition',prePaperPosition);
set(hh,'PaperSize',prePaperSize);
