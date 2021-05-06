clear all
% written 17 September 2020 by Allison Shaw (contact ashaw@umn.edu for assistance)
% last updated 6 May 2021
%
% This script calls the function jbfill.m which can be downloaded from
% here:
% https://www.mathworks.com/matlabcentral/fileexchange/13188-shade-area-between-two-curves


ngroup = 7; % number of race/ethnic groups

% CENSUS DATA (RACES/ETHNICITIES WITH FULL TIME SERIES)
    T = readtable('../datafiles_census/CensusData1.csv'); % import data
    Ttext = T(:,1:2); % take text portion
    Tnum = T(:,3:end); % take number portion
    Ttext = table2array(Ttext); % convert to an array
    Tnum = table2array(Tnum); % convert to an array
    yrs = Tnum(1,:); % pull out years
    
    % indices corresponding to each stage
    ind_pop = strcmp(Ttext(:,2),'Population Average')==1;
    ind_U = find(strcmp(Ttext(:,2),'Undergraduate')==1);
    ind_G = strcmp(Ttext(:,2),'Graduate')==1;
    ind_P = strcmp(Ttext(:,2),'Postdoc')==1;
    ind_A = strcmp(Ttext(:,2),'Assistant')==1;
    ind_T = strcmp(Ttext(:,2),'Tenured')==1;
    
    % data corresponding to each stage
    census_pop = Tnum(ind_pop,:);
    census_U   = Tnum(ind_U,:);
    census_G   = Tnum(ind_G,:);
    census_P   = Tnum(ind_P,:);
    census_A   = Tnum(ind_A,:);
    census_T   = Tnum(ind_T,:);
    
    % pull races/ethnicities
    census_groups = Ttext(ind_U,1);
    clear T ind*
    
% CENSUS DATA (RACES WITH SHORTER TIME SERIES)
    T = readtable('../datafiles_census/CensusData2.csv'); % import data
    Ttext = T(:,1:2); % take text portion
    Tnum = T(:,3:end); % take number portion
    Ttext = table2array(Ttext); % convert to an array
    Tnum = table2array(Tnum); % convert to an array
    yrs_short = Tnum(1,:); % convert table to array to years
    % indices corresponding to each stage
    ind_pop = strcmp(Ttext(:,2),'Population Average')==1;
    ind_U = find(strcmp(Ttext(:,2),'Undergraduate')==1);
    ind_G = strcmp(Ttext(:,2),'Graduate')==1;
    ind_P = strcmp(Ttext(:,2),'Postdoc')==1;
    ind_A = strcmp(Ttext(:,2),'Assistant')==1;
    ind_T = strcmp(Ttext(:,2),'Tenured')==1;
    % data corresponding to each stage
    census2_pop = Tnum(ind_pop,:);
    census2_U   = Tnum(ind_U,:);
    census2_G   = Tnum(ind_G,:);
    census2_P   = Tnum(ind_P,:);
    census2_A   = Tnum(ind_A,:);
    census2_T   = Tnum(ind_T,:);
    
    % pull races/ethnicities
    census2_groups = Ttext(ind_U,1);
    clear T ind*

%COMBINE
    x1=length(yrs)-length(yrs_short);
    y1=size(census2_groups,1);
    census_pop = [census_pop; NaN(y1,x1) census2_pop];
    census_U = [census_U; NaN(y1,x1) census2_U];
    census_G = [census_G; NaN(y1,x1) census2_G];
    census_P = [census_P; NaN(y1,x1) census2_P];
    census_A = [census_A; NaN(y1,x1) census2_A];
    census_T = [census_T; NaN(y1,x1) census2_T];
    census_groups = [census_groups; census2_groups];
    clear x1 y1 census2*
    
    % reorder to match NSF data
    indorder = [4 2 3 5 1 6 7]; 
    disp('order should be : White, Asian, Black, Hispanic, Native, Hawaiian, Multiple')
    census_groups(indorder) 
    census_pop = census_pop(indorder,:);
    census_U = census_U(indorder,:);
    census_G = census_G(indorder,:);
    census_P = census_P(indorder,:);
    census_A = census_A(indorder,:);
    census_T = census_T(indorder,:);

%% RAW DATA

    % load data on undergraduate students
    data = readmatrix('../datafiles_NSF/N_NSF_UGD.csv'); yr_NSF_U = data(:,1); N_NSF_UGD = data(:,2:end);
    
    % load data on gradulate students
    data = readmatrix('../datafiles_NSF/N_NSF_GR.csv'); yr_NSF_G = data(:,1); N_NSF_GR = data(:,2:end);
    
    % load data on postdoctoral researchers
    data = readmatrix('../datafiles_NSF/N_NSF_PD.csv'); yr_NSF_P = data(:,1); N_NSF_PD = data(:,2:end);
    
    % load data on faculty (assistant and tenured professors)
    data = readmatrix('../datafiles_NSF/N_NSF_AP.csv'); yr_NSF_A = data(:,1); N_NSF_AP = data(:,2:end);
    data = readmatrix('../datafiles_NSF/N_NSF_TP.csv'); yr_NSF_T = data(:,1); N_NSF_TP = data(:,2:end);
    
    % (cut out unknown, temp residents)
    N_NSF_UGD = N_NSF_UGD(:,1:ngroup);
    N_NSF_GR = N_NSF_GR(:,1:ngroup);
    N_NSF_PD = N_NSF_PD(:,1:ngroup);
    N_NSF_AP = N_NSF_AP(:,1:ngroup);
    N_NSF_TP = N_NSF_TP(:,1:ngroup);
    frac_NSF_U = N_NSF_UGD./nansum(N_NSF_UGD,2);
    frac_NSF_G = N_NSF_GR./nansum(N_NSF_GR,2);
    frac_NSF_P = N_NSF_PD./nansum(N_NSF_PD,2);
    frac_NSF_A = N_NSF_AP./nansum(N_NSF_AP,2);
    frac_NSF_T = N_NSF_TP./nansum(N_NSF_TP,2);
    

% SMOOTHED DATA AND MODEL
load('../datafiles_matlab/model_output_main.mat')
    % set zeros to NaN - this affects hawaiians
    frac_smooth_U(frac_smooth_U==0)=NaN;
    frac_smooth_G(frac_smooth_G==0)=NaN;
    frac_smooth_P(frac_smooth_P==0)=NaN;
    frac_smooth_A(frac_smooth_A==0)=NaN;
    frac_smooth_T(frac_smooth_T==0)=NaN;

    frac_sim_fa_de(frac_sim_fa_de==0)=NaN;
    frac_sim_fa_su(frac_sim_fa_su==0)=NaN;
    frac_sim_sl_de(frac_sim_sl_de==0)=NaN;
    frac_sim_sl_su(frac_sim_sl_su==0)=NaN;
    
    dim = size(frac_sim_fa_de); % get dimensions of simulated data (time x groups x stages)
    frac_sim_all = [frac_sim_fa_de(:) frac_sim_sl_de(:) frac_sim_fa_su(:) frac_sim_sl_su(:)];
    frac_sim_max = max(frac_sim_all,[],2); % get highest simulated value
    frac_sim_min = min(frac_sim_all,[],2); % get lowest simulated value
    frac_sim_min = reshape(frac_sim_min,dim(1),dim(2),dim(3));
    frac_sim_max = reshape(frac_sim_max,dim(1),dim(2),dim(3));
%%
mksize = 10; % markersize
fs1 = 9;  % axes labels
fs2 = 8; % legend labels
fs3 = 9;  % axis numbering
lw2 = 1; % fig edges
lw1 = 1.5; % fig lines

sx = 0.11;
sy = 0.14;
wi = 0.128;
he = 0.17;
delx = 0.055;
dely = 0.02*22/15;

colorder = [0.8500    0.3250    0.0980   % red
            0.9290    0.6940    0.1250   % yellow
            0.4660    0.6740    0.1880   % green
            0         0.4470    0.7410   % blue
            0.4940    0.1840    0.5560]; % purple

figure(2); clf
hh = gcf;
set(hh,'PaperUnits','centimeters');
set(hh,'Units','centimeters');
width = 18; height = 15;
xpos = 5;
ypos = 4;
set(gcf,'Position',[xpos ypos width height])

for ii = 0:3
    if     ii==0; i=1; % White
    elseif ii==1; i=4; % Hispanic
    elseif ii==2; i=3; % Black
    elseif ii==3; i=2; % Asian
    end

axes('position',[sx+0*(delx+wi) sy+ii*(dely+he) wi he])
    plot(yr_NSF_U,frac_NSF_U(:,i),'.','LineWidth',lw1,'MarkerSize',mksize,'MarkerEdgeColor',colorder(1,:))
    hold on
    plot(yr_smooth,frac_smooth_U(:,i),':','LineWidth',lw1,'MarkerEdgeColor',colorder(1,:))
    %plot census data
    plot(yrs,census_pop(i,:),'k-','LineWidth',lw1)
    plot(yrs,census_U(i,:),'k--','LineWidth',lw1)
    % set x labels only for bottom panel
    xlim([1990 2020])
    set(gca,'XTick',[1990 2005 2020])
    if ii==0; set(gca,'XTickLabel',{'1990','2005','2020'});
    else     set(gca,'XTickLabel',{});
    end
    set(gca,'FontSize',fs3,'LineWidth',lw2,'Fontname', 'Arial');
    if     ii==0; ylim([0.5 0.9]); set(gca,'YTick',[0.5 0.7 0.9]); set(gca,'YTickLabel',[0.5 0.7 0.9]) % White
    elseif ii==1; ylim([0 0.25]);  set(gca,'YTick',[0 0.1 0.2]); set(gca,'YTickLabel',[0 0.1 0.2]) % Hispanic
    elseif ii==2; ylim([0 0.2]);  set(gca,'YTick',[0 0.1 0.2]); set(gca,'YTickLabel',[0 0.1 0.2]) % Black
    elseif ii==3; ylim([0 0.3]);   set(gca,'YTick',[0 0.1 0.2 0.3]); set(gca,'YTickLabel',[0 0.1 0.2 0.3]) % Asian
    end

axes('position',[sx+1*(delx+wi) sy+ii*(dely+he) wi he])
    plot(yr_NSF_G,frac_NSF_G(:,i),'.','LineWidth',lw1,'MarkerSize',mksize,'MarkerEdgeColor',colorder(2,:))
    hold on
    plot(yr_smooth,frac_smooth_G(:,i),':','LineWidth',lw1,'color',colorder(2,:))
    j=2;
    [ph,msg]=jbfill(time,frac_sim_min(:,i,j)',frac_sim_max(:,i,j)',colorder(j,:),colorder(j,:),'','0.5'); % fill
    plot(time,squeeze(frac_sim_min(:,i,j)),'Color',colorder(j,:),'LineWidth',lw1) % lower bound
    plot(time,squeeze(frac_sim_max(:,i,j)),'Color',colorder(j,:),'LineWidth',lw1) % upper bound
    %plot census data
    plot(yrs,census_pop(i,:),'k-','LineWidth',lw1)
    plot(yrs,census_G(i,:),'k--','LineWidth',lw1)
    % set x labels only for bottom panel
    xlim([1990 2020])
    set(gca,'XTick',[1990 2005 2020])
    if ii==0; set(gca,'XTickLabel',{'1990','2005','2020'});
    else     set(gca,'XTickLabel',{});
    end
    set(gca,'FontSize',fs3,'LineWidth',lw2,'Fontname', 'Arial');
    if     ii==0; ylim([0.5 0.9]);  set(gca,'YTick',[]) % White
    elseif ii==1; ylim([0 0.25]);   set(gca,'YTick',[]) % Hispanic
    elseif ii==2; ylim([0 0.2]);    set(gca,'YTick',[]) % Black
    elseif ii==3; ylim([0 0.3]);    set(gca,'YTick',[]) % Asian
    end

axes('position',[sx+2*(delx+wi) sy+ii*(dely+he) wi he])
    plot(yr_NSF_P,frac_NSF_P(:,i),'.','LineWidth',lw1,'MarkerSize',mksize,'MarkerEdgeColor',colorder(3,:))
    hold on
    % POSTDOC DATA PRE 2010 IS EXTRAPOLATED - PLOT THIS IN GREY
    ind=find(yr_smooth==2010);
    plot(yr_smooth(1:ind-1),frac_smooth_P(1:ind-1,i),':','LineWidth',lw1,'color',[0.8 0.8 0.8])
    plot(yr_smooth(ind:end),frac_smooth_P(ind:end,i),':','LineWidth',lw1,'color',colorder(3,:))
    j=3;
    [ph,msg]=jbfill(time,frac_sim_min(:,i,j)',frac_sim_max(:,i,j)',colorder(j,:),colorder(j,:),'','0.5'); % fill
    plot(time,squeeze(frac_sim_min(:,i,j)),'Color',colorder(j,:),'LineWidth',lw1) % lower bound
    plot(time,squeeze(frac_sim_max(:,i,j)),'Color',colorder(j,:),'LineWidth',lw1) % upper bound
    %plot census data
    plot(yrs,census_pop(i,:),'k-','LineWidth',lw1)
    plot(yrs,census_P(i,:),'k--','LineWidth',lw1)
    % set x labels only for bottom panel
    xlim([1990 2020])
    set(gca,'XTick',[1990 2005 2020])
    if ii==0; set(gca,'XTickLabel',{'1990','2005','2020'});
    else     set(gca,'XTickLabel',{});
    end
    set(gca,'FontSize',fs3,'LineWidth',lw2,'Fontname', 'Arial');
    if     ii==0; ylim([0.5 0.9]); set(gca,'YTick',[]) % White
    elseif ii==1; ylim([0 0.25]);  set(gca,'YTick',[]) % Hispanic
    elseif ii==2; ylim([0 0.2]);    set(gca,'YTick',[]) % Black
    elseif ii==3; ylim([0 0.3]);    set(gca,'YTick',[]) % Asian
    end

axes('position',[sx+3*(delx+wi) sy+ii*(dely+he) wi he])
    plot(yr_NSF_A,frac_NSF_A(:,i),'.','LineWidth',lw1,'MarkerSize',mksize,'MarkerEdgeColor',colorder(4,:))
    hold on
    plot(yr_smooth,frac_smooth_A(:,i),':','LineWidth',lw1,'color',colorder(4,:))
    j=4;
    [ph,msg]=jbfill(time,frac_sim_min(:,i,j)',frac_sim_max(:,i,j)',colorder(j,:),colorder(j,:),'','0.5'); % fill
    plot(time,squeeze(frac_sim_min(:,i,j)),'Color',colorder(j,:),'LineWidth',lw1) % lower bound
    plot(time,squeeze(frac_sim_max(:,i,j)),'Color',colorder(j,:),'LineWidth',lw1) % upper bound
    %plot census data
    plot(yrs,census_pop(i,:),'k-','LineWidth',lw1)
    plot(yrs,census_A(i,:),'k--','LineWidth',lw1)
    % set x labels only for bottom panel
    xlim([1990 2020])
    set(gca,'XTick',[1990 2005 2020])
    if ii==0; set(gca,'XTickLabel',{'1990','2005','2020'});
    else     set(gca,'XTickLabel',{});
    end
    set(gca,'FontSize',fs3,'LineWidth',lw2,'Fontname', 'Arial');
    if     ii==0; ylim([0.5 0.9]); set(gca,'YTick',[]) % White
    elseif ii==1; ylim([0 0.25]);  set(gca,'YTick',[]) % Hispanic
    elseif ii==2; ylim([0 0.2]);    set(gca,'YTick',[]) % Black
    elseif ii==3; ylim([0 0.3]);    set(gca,'YTick',[]) % Asian
    end

axes('position',[sx+4*(delx+wi) sy+ii*(dely+he) wi he])
    plot(yr_NSF_T,frac_NSF_T(:,i),'.','LineWidth',lw1,'MarkerSize',mksize,'MarkerEdgeColor',colorder(5,:))
    hold on
    plot(yr_smooth,frac_smooth_T(:,i),':','LineWidth',lw1,'color',colorder(5,:))
    j=5;
    [ph,msg]=jbfill(time,frac_sim_min(:,i,j)',frac_sim_max(:,i,j)',colorder(j,:),colorder(j,:),'','0.5'); % fill
    plot(time,squeeze(frac_sim_min(:,i,j)),'Color',colorder(j,:),'LineWidth',lw1) % lower bound
    plot(time,squeeze(frac_sim_max(:,i,j)),'Color',colorder(j,:),'LineWidth',lw1) % upper bound
    %plot census data
    plot(yrs,census_pop(i,:),'k-','LineWidth',lw1)
    plot(yrs,census_T(i,:),'k--','LineWidth',lw1)
    % set x labels only for bottom panel
    xlim([1990 2020])
    set(gca,'XTick',[1990 2005 2020])
    if ii==0; set(gca,'XTickLabel',{'1990','2005','2020'});
    else     set(gca,'XTickLabel',{});
    end
    set(gca,'FontSize',fs3,'LineWidth',lw2,'Fontname', 'Arial');
    if     ii==0; ylim([0.5 0.9]); set(gca,'YTick',[]) % White
    elseif ii==1; ylim([0 0.25]);  set(gca,'YTick',[]) % Hispanic
    elseif ii==2; ylim([0 0.2]);    set(gca,'YTick',[]) % Black
    elseif ii==3; ylim([0 0.3]);    set(gca,'YTick',[]) % Asian
    end
end

    % add legend axis
    axes('position',       [0.11 0.01 0.86 0.06])
    annotation('rectangle',[0.11 0.01 0.86 0.06],'Color','black','LineWidth',lw2)
    hold on
    x1 = 1;
    x2 = x1+6;
    x3 = x1+19;
    [ph,msg]=jbfill([x1 x1+1],[1 1],[2 2],colorder(5,:),colorder(5,:),'','0.5'); % fill
    plot([x1 x1+1],[2 2],'LineWidth',lw1,'color',colorder(5,:))
    plot([x1 x1+1],[1 1],'LineWidth',lw1,'color',colorder(5,:))
    plot(linspace(x2,x2+1,4),2*ones(1,4),'.','LineWidth',lw1,'MarkerSize',mksize,'MarkerEdgeColor',colorder(5,:))
    plot([x2 x2+1],[1 1],'LineWidth',lw1,'LineStyle',':','color',colorder(5,:))
    plot([x3 x3+1],[2 2],'LineWidth',lw1,'Color','k')
    plot([x3 x3+1],[1 1],'LineWidth',lw1,'Color','k','LineStyle','--')
    axis off
    axis([0 28 0 3])
    dx = 1.5;
    text(x1+dx,1.5,'model','FontSize',fs2)
    text(x2+dx,2,'academia (raw data)','FontSize',fs2)
    text(x2+dx,1,'academia (smoothed/estimated)','FontSize',fs2)
    text(x3+dx,2,'census (overall)','FontSize',fs2)
    text(x3+dx,1,'census (age-specific)','FontSize',fs2)
    set(gca,'FontSize',fs2,'LineWidth',lw2,'Fontname', 'Arial');

% labels
axes('position',[0 0 1 1],'visible','off')
    hold on
    text(0.5,0.09,'Year','fontsize',fs1,'horizontalalignment','center')
    text(0.01,0.55,'Representation (proportion of scholars) by race/ethnicity','fontsize',fs1,'rotation',90,'horizontalalignment','center')
    line([0.265 0.265],[0.11 0.97],'color','k','LineWidth',lw1)
    
    % column labels
    del = 0.06;
    yy = 0.96;
    text(sx+0*(delx+wi)+del,yy,{'Undergraduate','students'},'fontsize',fs1,'horizontalalignment','center')
    text(sx+1*(delx+wi)+del,yy,{'Graduate','students'},'fontsize',fs1,'horizontalalignment','center')
    text(sx+2*(delx+wi)+del,yy,{'Postdoctoral','researchers'},'fontsize',fs1,'horizontalalignment','center')
    text(sx+3*(delx+wi)+del,yy,{'Assistant','Professors'},'fontsize',fs1,'horizontalalignment','center')
    text(sx+4*(delx+wi)+del,yy,{'Tenured','Professors'},'fontsize',fs1,'horizontalalignment','center')
    
    % row labels
    del = 0.07;
    xx = 0.05;
    text(xx ,sy+3*(dely+he)+del,'Asian','fontsize',fs1,'rotation',90,'horizontalalignment','center')
    text(xx ,sy+2*(dely+he)+del,{'Black &','African Amer.'},'fontsize',fs1,'rotation',90,'horizontalalignment','center')
    text(xx ,sy+1*(dely+he)+del,{'Hispanic','& Latino'},'fontsize',fs1,'rotation',90,'horizontalalignment','center')
    text(xx ,sy+0*(dely+he)+del,'White','fontsize',fs1,'rotation',90,'horizontalalignment','center')
    
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

print -djpeg -r600 fig2.jpg

% Restore the previous settings
set(hh,'PaperType',prePaperType);
set(hh,'PaperPosition',prePaperPosition);
set(hh,'PaperSize',prePaperSize);
%%
mksize = 10; % markersize
fs1 = 9;  % axes labels
fs3 = 9;  % axis numbering
lw2 = 1; % fig edges
lw1 = 1.5; % fig lines

sx = 0.10;
sy = 0.04;
wi = 0.14;
he = 0.11;
delx = 0.046;
dely = 0.02;

colorder = [0.8500    0.3250    0.0980   % red
            0.9290    0.6940    0.1250   % yellow
            0.4660    0.6740    0.1880   % green
            0         0.4470    0.7410   % blue
            0.4940    0.1840    0.5560]; % purple

figure(2); clf
hh = gcf;
set(hh,'PaperUnits','centimeters');
set(hh,'Units','centimeters');
width = 18; height = 22;
xpos = 5;
ypos = 4;
set(gcf,'Position',[xpos ypos width height])

for ii = 0:6
    if     ii==0; i=7; % Multiple
    elseif ii==1; i=1; % White
    elseif ii==2; i=5; % Native
    elseif ii==3; i=4; % Hispanic
    elseif ii==4; i=6; % Hawaiian
    elseif ii==5; i=3; % Black
    elseif ii==6; i=2; % Asian
    end

axes('position',[sx+0*(delx+wi) sy+ii*(dely+he) wi he])
    plot(yr_NSF_U,frac_NSF_U(:,i),'.','LineWidth',lw1,'MarkerSize',mksize,'MarkerEdgeColor',colorder(1,:))
    hold on
    plot(yr_smooth,frac_smooth_U(:,i),':','LineWidth',lw1,'MarkerEdgeColor',colorder(1,:))
    %plot census data
    plot(yrs,census_pop(i,:),'k-','LineWidth',lw1)
    plot(yrs,census_U(i,:),'k--','LineWidth',lw1)
    % set x labels only for bottom panel
    xlim([1990 2020])
    set(gca,'XTick',[1990 2005 2020])
    if ii==0; set(gca,'XTickLabel',{'`90','`05','`20'});
    else     set(gca,'XTickLabel',{});
    end
    set(gca,'FontSize',fs3,'LineWidth',lw2,'Fontname', 'Arial');
    if     ii==0; ylim([0 0.04]);  set(gca,'YTick',[0 0.02 0.04]); set(gca,'YTickLabel',[0 0.02 0.04]) % Multiple
    elseif ii==1; ylim([0.5 0.9]); set(gca,'YTick',[0.5 0.7 0.9]); set(gca,'YTickLabel',[0.5 0.7 0.9]) % White
    elseif ii==2; ylim([0 0.015]); set(gca,'YTick',[0 0.005 0.01 0.015]); set(gca,'YTickLabel',[0 0.005 0.01 0.015]) % Native
    elseif ii==3; ylim([0 0.25]);  set(gca,'YTick',[0 0.1 0.2]); set(gca,'YTickLabel',[0 0.1 0.2]) % Hispanic
    elseif ii==4; ylim([0 0.006]); set(gca,'YTick',[0 0.003 0.006]); set(gca,'YTickLabel',[0 0.003 0.006]) % Hawaiian
    elseif ii==5; ylim([0 0.2]);  set(gca,'YTick',[0 0.1 0.2]); set(gca,'YTickLabel',[0 0.1 0.2]) % Black
    elseif ii==6; ylim([0 0.3]);   set(gca,'YTick',[0 0.1 0.2 0.3]); set(gca,'YTickLabel',[0 0.1 0.2 0.3]) % Asian
    end

    
axes('position',[sx+1*(delx+wi) sy+ii*(dely+he) wi he])
    plot(yr_NSF_G,frac_NSF_G(:,i),'.','LineWidth',lw1,'MarkerSize',mksize,'MarkerEdgeColor',colorder(2,:))
    hold on
    plot(yr_smooth,frac_smooth_G(:,i),':','LineWidth',lw1,'color',colorder(2,:))
    j=2;
    [ph,msg]=jbfill(time,frac_sim_min(:,i,j)',frac_sim_max(:,i,j)',colorder(j,:),colorder(j,:),'','0.5'); % fill
    plot(time,squeeze(frac_sim_min(:,i,j)),'Color',colorder(j,:),'LineWidth',lw1) % lower bound
    plot(time,squeeze(frac_sim_max(:,i,j)),'Color',colorder(j,:),'LineWidth',lw1) % upper bound
    %plot census data
    plot(yrs,census_pop(i,:),'k-','LineWidth',lw1)
    plot(yrs,census_G(i,:),'k--','LineWidth',lw1)
    % set x labels only for bottom panel
    xlim([1990 2020])
    set(gca,'XTick',[1990 2005 2020])
    if ii==0; set(gca,'XTickLabel',{'`90','`05','`20'});
    else     set(gca,'XTickLabel',{});
    end
    set(gca,'FontSize',fs3,'LineWidth',lw2,'Fontname', 'Arial');
    if     ii==0; ylim([0 0.04]);   set(gca,'YTick',[]) % Multiple
    elseif ii==1; ylim([0.5 0.9]);  set(gca,'YTick',[]) % White
    elseif ii==2; ylim([0 0.015]);  set(gca,'YTick',[]) % Native
    elseif ii==3; ylim([0 0.25]);   set(gca,'YTick',[]) % Hispanic
    elseif ii==4; ylim([0 0.006]);  set(gca,'YTick',[]) % Hawaiian
    elseif ii==5; ylim([0 0.2]);    set(gca,'YTick',[]) % Black
    elseif ii==6; ylim([0 0.3]);    set(gca,'YTick',[]) % Asian
    end

axes('position',[sx+2*(delx+wi) sy+ii*(dely+he) wi he])
    plot(yr_NSF_P,frac_NSF_P(:,i),'.','LineWidth',lw1,'MarkerSize',mksize,'MarkerEdgeColor',colorder(3,:))
    hold on
    % POSTDOC DATA PRE 2010 IS EXTRAPOLATED - PLOT THIS IN GREY
    ind=find(yr_smooth==2010);
    plot(yr_smooth(1:ind-1),frac_smooth_P(1:ind-1,i),':','LineWidth',lw1,'color',[0.8 0.8 0.8])
    plot(yr_smooth(ind:end),frac_smooth_P(ind:end,i),':','LineWidth',lw1,'color',colorder(3,:))
    j=3;
    [ph,msg]=jbfill(time,frac_sim_min(:,i,j)',frac_sim_max(:,i,j)',colorder(j,:),colorder(j,:),'','0.5'); % fill
    plot(time,squeeze(frac_sim_min(:,i,j)),'Color',colorder(j,:),'LineWidth',lw1) % lower bound
    plot(time,squeeze(frac_sim_max(:,i,j)),'Color',colorder(j,:),'LineWidth',lw1) % upper bound
    %plot census data
    plot(yrs,census_pop(i,:),'k-','LineWidth',lw1)
    plot(yrs,census_P(i,:),'k--','LineWidth',lw1)
    % set x labels only for bottom panel
    xlim([1990 2020])
    set(gca,'XTick',[1990 2005 2020])
    if ii==0; set(gca,'XTickLabel',{'`90','`05','`20'});
    else     set(gca,'XTickLabel',{});
    end
    set(gca,'FontSize',fs3,'LineWidth',lw2,'Fontname', 'Arial');
    if     ii==0; ylim([0 0.04]);   set(gca,'YTick',[]) % Multiple
    elseif ii==1; ylim([0.5 0.9]);  set(gca,'YTick',[]) % White
    elseif ii==2; ylim([0 0.015]);  set(gca,'YTick',[]) % Native
    elseif ii==3; ylim([0 0.25]);   set(gca,'YTick',[]) % Hispanic
    elseif ii==4; ylim([0 0.006]);  set(gca,'YTick',[]) % Hawaiian
    elseif ii==5; ylim([0 0.2]);    set(gca,'YTick',[]) % Black
    elseif ii==6; ylim([0 0.3]);    set(gca,'YTick',[]) % Asian
    end

axes('position',[sx+3*(delx+wi) sy+ii*(dely+he) wi he])
    plot(yr_NSF_A,frac_NSF_A(:,i),'.','LineWidth',lw1,'MarkerSize',mksize,'MarkerEdgeColor',colorder(4,:))
    hold on
    plot(yr_smooth,frac_smooth_A(:,i),':','LineWidth',lw1,'color',colorder(4,:))
    j=4;
    [ph,msg]=jbfill(time,frac_sim_min(:,i,j)',frac_sim_max(:,i,j)',colorder(j,:),colorder(j,:),'','0.5'); % fill
    plot(time,squeeze(frac_sim_min(:,i,j)),'Color',colorder(j,:),'LineWidth',lw1) % lower bound
    plot(time,squeeze(frac_sim_max(:,i,j)),'Color',colorder(j,:),'LineWidth',lw1) % upper bound
    %plot census data
    plot(yrs,census_pop(i,:),'k-','LineWidth',lw1)
    plot(yrs,census_A(i,:),'k--','LineWidth',lw1)
    % set x labels only for bottom panel
    xlim([1990 2020])
    set(gca,'XTick',[1990 2005 2020])
    if ii==0; set(gca,'XTickLabel',{'`90','`05','`20'});
    else     set(gca,'XTickLabel',{});
    end
    set(gca,'FontSize',fs3,'LineWidth',lw2,'Fontname', 'Arial');
    if     ii==0; ylim([0 0.04]);   set(gca,'YTick',[]) % Multiple
    elseif ii==1; ylim([0.5 0.9]);  set(gca,'YTick',[]) % White
    elseif ii==2; ylim([0 0.015]);  set(gca,'YTick',[]) % Native
    elseif ii==3; ylim([0 0.25]);   set(gca,'YTick',[]) % Hispanic
    elseif ii==4; ylim([0 0.006]);  set(gca,'YTick',[]) % Hawaiian
    elseif ii==5; ylim([0 0.2]);    set(gca,'YTick',[]) % Black
    elseif ii==6; ylim([0 0.3]);    set(gca,'YTick',[]) % Asian
    end

axes('position',[sx+4*(delx+wi) sy+ii*(dely+he) wi he])
    plot(yr_NSF_T,frac_NSF_T(:,i),'.','LineWidth',lw1,'MarkerSize',mksize,'MarkerEdgeColor',colorder(5,:))
    hold on
    plot(yr_smooth,frac_smooth_T(:,i),':','LineWidth',lw1,'color',colorder(5,:))
    j=5;
    [ph,msg]=jbfill(time,frac_sim_min(:,i,j)',frac_sim_max(:,i,j)',colorder(j,:),colorder(j,:),'','0.5'); % fill
    plot(time,squeeze(frac_sim_min(:,i,j)),'Color',colorder(j,:),'LineWidth',lw1) % lower bound
    plot(time,squeeze(frac_sim_max(:,i,j)),'Color',colorder(j,:),'LineWidth',lw1) % upper bound
    %plot census data
    plot(yrs,census_pop(i,:),'k-','LineWidth',lw1)
    plot(yrs,census_T(i,:),'k--','LineWidth',lw1)
    % set x labels only for bottom panel
    xlim([1990 2020])
    set(gca,'XTick',[1990 2005 2020])
    if ii==0; set(gca,'XTickLabel',{'`90','`05','`20'});
    else     set(gca,'XTickLabel',{});
    end
    set(gca,'FontSize',fs3,'LineWidth',lw2,'Fontname', 'Arial');
    if     ii==0; ylim([0 0.04]);   set(gca,'YTick',[]) % Multiple
    elseif ii==1; ylim([0.5 0.9]);  set(gca,'YTick',[]) % White
    elseif ii==2; ylim([0 0.015]);  set(gca,'YTick',[]) % Native
    elseif ii==3; ylim([0 0.25]);   set(gca,'YTick',[]) % Hispanic
    elseif ii==4; ylim([0 0.006]);  set(gca,'YTick',[]) % Hawaiian
    elseif ii==5; ylim([0 0.2]);    set(gca,'YTick',[]) % Black
    elseif ii==6; ylim([0 0.3]);    set(gca,'YTick',[]) % Asian
    end
end

% labels
axes('position',[0 0 1 1],'visible','off')
    hold on
    del = 0.06;
    yy = 0.96;
    text(sx+0*(delx+wi)+del,yy,{'Undergraduate','students'},'fontsize',fs1,'horizontalalignment','center')
    text(sx+1*(delx+wi)+del,yy,{'Graduate','students'},'fontsize',fs1,'horizontalalignment','center')
    text(sx+2*(delx+wi)+del,yy,{'Postdoctoral','researchers'},'fontsize',fs1,'horizontalalignment','center')
    text(sx+3*(delx+wi)+del,yy,{'Assistant','Professors'},'fontsize',fs1,'horizontalalignment','center')
    text(sx+4*(delx+wi)+del,yy,{'Tenured','Professors'},'fontsize',fs1,'horizontalalignment','center')
    
    del = 0.07;
    xx = 0.02;
    text(xx ,sy+6*(dely+he)+del,'Asian','fontsize',fs1,'rotation',90,'horizontalalignment','center')
    text(xx ,sy+5*(dely+he)+del,{'Black &','African Amer.'},'fontsize',fs1,'rotation',90,'horizontalalignment','center')
    text(xx ,sy+4*(dely+he)+del,{'Native Haw.','& Pacific Isl.'},'fontsize',fs1,'rotation',90,'horizontalalignment','center')
    text(xx ,sy+3*(dely+he)+del,{'Hispanic','& Latino'},'fontsize',fs1,'rotation',90,'horizontalalignment','center')
    text(xx ,sy+2*(dely+he)+del,{'Amer. Indian &','Alaskan Native'},'fontsize',fs1,'rotation',90,'horizontalalignment','center')
    text(xx ,sy+1*(dely+he)+del,'White','fontsize',fs1,'rotation',90,'horizontalalignment','center')
    text(xx ,sy+0*(dely+he)+del,{'More than','one race'},'fontsize',fs1,'rotation',90,'horizontalalignment','center')

    line([0.265 0.265],[0.02 0.97],'color','k','LineWidth',lw1)
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

print -djpeg -r600 fig_S7_data_model_census.jpg

% Restore the previous settings
set(hh,'PaperType',prePaperType);
set(hh,'PaperPosition',prePaperPosition);
set(hh,'PaperSize',prePaperSize);
