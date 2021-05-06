clear all; close all; clc
% written by Allison Shaw (contact ashaw@umn.edu for assistance)
% last updated 6 May 2021

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

% N_NSF_x is a matrix with rows corresponding to years and columns as group
% faculty have 7 groups: white, asian, black, hispanic, native, hawaiian,
%                        multi-race
% students and postdocs have 9: the 7 above, unknown, temporary resident

% (cut out unknown, temp residents)
N_NSF_UGD = N_NSF_UGD(:,1:7);
N_NSF_GR = N_NSF_GR(:,1:7);
N_NSF_PD = N_NSF_PD(:,1:7);
N_NSF_AP = N_NSF_AP(:,1:7);
N_NSF_TP = N_NSF_TP(:,1:7);

frac_NSF_U = N_NSF_UGD./nansum(N_NSF_UGD,2);
frac_NSF_G = N_NSF_GR./nansum(N_NSF_GR,2);
frac_NSF_P = N_NSF_PD./nansum(N_NSF_PD,2);
frac_NSF_A = N_NSF_AP./nansum(N_NSF_AP,2);
frac_NSF_T = N_NSF_TP./nansum(N_NSF_TP,2);

%calculate fraction of each group in each stage over time
frac_NSF_tempres = N_NSF_tempres./nansum(N_NSF_tempres,2);
    
groups = {'White','Asian','Black','Hispanic','Native/Alaskan','Hawaiian/Pacific','Multiple'};

fs1 = 11;  % axes labels
fs3 = 9;  % axis numbering
lw2 = 1; % fig edges
lw = 2; % fig lines
mksize = 10; % markersize

sx = 0.09;
sy = 0.08;
wi = 0.2;
he = 0.2;
delx = 0.13;
dely = 0.13;

colorder = [0.8500    0.3250    0.0980   % red
            0.9290    0.6940    0.1250   % yellow
            0.4660    0.6740    0.1880   % green
            0         0.4470    0.7410   % blue
            0.4940    0.1840    0.5560]; % purple


  
figure(1); clf
hh = gcf;
set(hh,'PaperUnits','inches');
set(hh,'Units','inches');
width = 6; height = 6;
xpos = 5;
ypos = 4;
set(gcf,'Position',[xpos ypos width height])

axes('position',[sx             sy+2*(dely+he) wi he])
    i=2; % Asian
    plot(yr_NSF_U,N_NSF_UGD(:,i),'.','LineWidth',lw,'MarkerSize',mksize,'Color',colorder(1,:))
    hold on
    plot(yr_NSF_G,N_NSF_GR(:,i),'.','LineWidth',lw,'MarkerSize',mksize,'Color',colorder(2,:))
    plot(yr_NSF_P,N_NSF_PD(:,i),'.','LineWidth',lw,'MarkerSize',mksize,'Color',colorder(3,:))
    plot(yr_NSF_A,N_NSF_AP(:,i),'.','LineWidth',lw,'MarkerSize',mksize,'Color',colorder(4,:))
    plot(yr_NSF_T,N_NSF_TP(:,i),'.','LineWidth',lw,'MarkerSize',mksize,'Color',colorder(5,:))
    xlabel('year','fontsize',fs1);
    ylabel('number (thousands)','fontsize',fs1); 
    axis([1980 2020 0 60000]);
    set(gca,'YTick',[0 20000 40000 60000])
    set(gca,'YTickLabel',[0 20 40 60])
    title(char(groups(i)),'fontsize',fs1);
    set(gca,'FontSize',fs3,'LineWidth',lw2,'Fontname', 'Arial');

axes('position',[sx+delx+wi     sy+2*(dely+he) wi he])
    i=3; % Black
    plot(yr_NSF_U,N_NSF_UGD(:,i),'.','LineWidth',lw,'MarkerSize',mksize,'Color',colorder(1,:))
    hold on
    plot(yr_NSF_G,N_NSF_GR(:,i),'.','LineWidth',lw,'MarkerSize',mksize,'Color',colorder(2,:))
    plot(yr_NSF_P,N_NSF_PD(:,i),'.','LineWidth',lw,'MarkerSize',mksize,'Color',colorder(3,:))
    plot(yr_NSF_A,N_NSF_AP(:,i),'.','LineWidth',lw,'MarkerSize',mksize,'Color',colorder(4,:))
    plot(yr_NSF_T,N_NSF_TP(:,i),'.','LineWidth',lw,'MarkerSize',mksize,'Color',colorder(5,:))
    xlabel('year','fontsize',fs1);
    ylabel('number (thousands)','fontsize',fs1); 
    axis([1980 2020 0 60000]);
    set(gca,'YTick',[0 20000 40000 60000])
    set(gca,'YTickLabel',[0 20 40 60])
    title(char(groups(i)),'fontsize',fs1);
    set(gca,'FontSize',fs3,'LineWidth',lw2,'Fontname', 'Arial');

axes('position',[sx+2*(delx+wi) sy+2*(dely+he) wi he])
    i=6; % Hawaiian
    plot(yr_NSF_U,N_NSF_UGD(:,i),'.','LineWidth',lw,'MarkerSize',mksize,'Color',colorder(1,:))
    hold on
    plot(yr_NSF_G,N_NSF_GR(:,i),'.','LineWidth',lw,'MarkerSize',mksize,'Color',colorder(2,:))
    plot(yr_NSF_P,N_NSF_PD(:,i),'.','LineWidth',lw,'MarkerSize',mksize,'Color',colorder(3,:))
    plot(yr_NSF_A,N_NSF_AP(:,i),'.','LineWidth',lw,'MarkerSize',mksize,'Color',colorder(4,:))
    plot(yr_NSF_T,N_NSF_TP(:,i),'.','LineWidth',lw,'MarkerSize',mksize,'Color',colorder(5,:))
    xlabel('year','fontsize',fs1);
    ylabel('number (thousands)','fontsize',fs1); 
    axis([1980 2020 0 2000]);
    set(gca,'YTick',[0 1000 2000])
    set(gca,'YTickLabel',[0 1 2])
    title(char(groups(i)),'fontsize',fs1);
    %legend('U','G','P','A','T','location','West');
    set(gca,'FontSize',fs3,'LineWidth',lw2,'Fontname', 'Arial');

axes('position',[sx             sy+dely+he wi he])
    i=4; % Hispanic
    plot(yr_NSF_U,N_NSF_UGD(:,i),'.','LineWidth',lw,'MarkerSize',mksize,'Color',colorder(1,:))
    hold on
    plot(yr_NSF_G,N_NSF_GR(:,i),'.','LineWidth',lw,'MarkerSize',mksize,'Color',colorder(2,:))
    plot(yr_NSF_P,N_NSF_PD(:,i),'.','LineWidth',lw,'MarkerSize',mksize,'Color',colorder(3,:))
    plot(yr_NSF_A,N_NSF_AP(:,i),'.','LineWidth',lw,'MarkerSize',mksize,'Color',colorder(4,:))
    plot(yr_NSF_T,N_NSF_TP(:,i),'.','LineWidth',lw,'MarkerSize',mksize,'Color',colorder(5,:))
    xlabel('year','fontsize',fs1);
    ylabel('number (thousands)','fontsize',fs1); 
    axis([1980 2020 0 100000]);
    set(gca,'YTick',[0 50000 100000])
    set(gca,'YTickLabel',[0 50 100])
    title(char(groups(i)),'fontsize',fs1);
    set(gca,'FontSize',fs3,'LineWidth',lw2,'Fontname', 'Arial');

axes('position',[sx+delx+wi     sy+dely+he wi he])
    i=5; % Native
    plot(yr_NSF_U,N_NSF_UGD(:,i),'.','LineWidth',lw,'MarkerSize',mksize,'Color',colorder(1,:))
    hold on
    plot(yr_NSF_G,N_NSF_GR(:,i),'.','LineWidth',lw,'MarkerSize',mksize,'Color',colorder(2,:))
    plot(yr_NSF_P,N_NSF_PD(:,i),'.','LineWidth',lw,'MarkerSize',mksize,'Color',colorder(3,:))
    plot(yr_NSF_A,N_NSF_AP(:,i),'.','LineWidth',lw,'MarkerSize',mksize,'Color',colorder(4,:))
    plot(yr_NSF_T,N_NSF_TP(:,i),'.','LineWidth',lw,'MarkerSize',mksize,'Color',colorder(5,:))
    xlabel('year','fontsize',fs1);
    ylabel('number (thousands)','fontsize',fs1); 
    axis([1980 2020 0 4000]);
    set(gca,'YTick',[0 2000 4000])
    set(gca,'YTickLabel',[0 2 4])
    title(char(groups(i)),'fontsize',fs1);
    set(gca,'FontSize',fs3,'LineWidth',lw2,'Fontname', 'Arial');    
    
axes('position',[sx+2*(delx+wi) sy+dely+he wi he])    
    i=1; % White
    plot(yr_NSF_U,N_NSF_UGD(:,i),'.','LineWidth',lw,'MarkerSize',mksize,'Color',colorder(1,:))
    hold on
    plot(yr_NSF_G,N_NSF_GR(:,i),'.','LineWidth',lw,'MarkerSize',mksize,'Color',colorder(2,:))
    plot(yr_NSF_P,N_NSF_PD(:,i),'.','LineWidth',lw,'MarkerSize',mksize,'Color',colorder(3,:))
    plot(yr_NSF_A,N_NSF_AP(:,i),'.','LineWidth',lw,'MarkerSize',mksize,'Color',colorder(4,:))
    plot(yr_NSF_T,N_NSF_TP(:,i),'.','LineWidth',lw,'MarkerSize',mksize,'Color',colorder(5,:))
    xlabel('year','fontsize',fs1);
    ylabel('number (thousands)','fontsize',fs1); 
    axis([1980 2020 0 400000]);
    set(gca,'YTick',[0 200000 400000])
    set(gca,'YTickLabel',[0 200 400])
    title(char(groups(i)),'fontsize',fs1);
    set(gca,'FontSize',fs3,'LineWidth',lw2,'Fontname', 'Arial');

axes('position',[sx             sy wi he])
    i=7; % Multiple
    plot(yr_NSF_U,N_NSF_UGD(:,i),'.','LineWidth',lw,'MarkerSize',mksize,'Color',colorder(1,:))
    hold on
    plot(yr_NSF_G,N_NSF_GR(:,i),'.','LineWidth',lw,'MarkerSize',mksize,'Color',colorder(2,:))
    plot(yr_NSF_P,N_NSF_PD(:,i),'.','LineWidth',lw,'MarkerSize',mksize,'Color',colorder(3,:))
    plot(yr_NSF_A,N_NSF_AP(:,i),'.','LineWidth',lw,'MarkerSize',mksize,'Color',colorder(4,:))
    plot(yr_NSF_T,N_NSF_TP(:,i),'.','LineWidth',lw,'MarkerSize',mksize,'Color',colorder(5,:))
    xlabel('year','fontsize',fs1);
    ylabel('number (thousands)','fontsize',fs1); 
    axis([1980 2020 0 25000]);
    set(gca,'YTick',[0 10000 20000])
    set(gca,'YTickLabel',[0 10 20])
    title(char(groups(i)),'fontsize',fs1);
    set(gca,'FontSize',fs3,'LineWidth',lw2,'Fontname', 'Arial');
    
% add legend axis
annotation('rectangle',[0.45 0.08 0.5 he],'Color','black','LineWidth',lw2)
axes('position',[0.45 0.08 0.5 he])
    hold on
    for i = 1:5
        plot([1 2],[6-i 6-i],'LineWidth',lw,'Color',colorder(i,:))
    end
    axis off
    axis([0 25 0 6])
    text(3,5,'Undergrad. degrees (perm. res. only)')
    text(3,4,'Grad. students (perm. res. only)')
    text(3,3,'Postdoc. ')
    text(3,2,'Assistant Prof.')
    text(3,1,'Tenured Prof.')
    set(gca,'FontSize',fs3,'LineWidth',lw2,'Fontname', 'Arial');

% labels
axes('position',[0 0 1 1],'visible','off')
hold on
     text(0.01, 0.11+3*he+2*dely,'a)','fontsize',fs3)
     text(0.34 ,0.11+3*he+2*dely,'b)','fontsize',fs3)
     text(0.67 ,0.11+3*he+2*dely,'c)','fontsize',fs3)
     text(0.01, 0.11+2*he+dely,'d)','fontsize',fs3)
     text(0.34 ,0.11+2*he+dely,'e)','fontsize',fs3)
     text(0.67 ,0.11+2*he+dely,'f)','fontsize',fs3)
     text(0.01 ,0.11+he,'g)','fontsize',fs3)
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

%saveas(1,strcat(['fig.jpg']))
%print -dpdf -r600 fig.pdf
print -djpeg -r600 fig_S3_group_data_count.jpg
%print -dtiff -r600 fig.tiff

% Restore the previous settings
set(hh,'PaperType',prePaperType);
set(hh,'PaperPosition',prePaperPosition);
set(hh,'PaperSize',prePaperSize);



%%
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
    plot(yr_NSF_U,frac_NSF_U(:,i),'.','LineWidth',lw,'MarkerSize',mksize,'Color',colorder(1,:))
    hold on
    plot(yr_NSF_G,frac_NSF_G(:,i),'.','LineWidth',lw,'MarkerSize',mksize,'Color',colorder(2,:))
    plot(yr_NSF_P,frac_NSF_P(:,i),'.','LineWidth',lw,'MarkerSize',mksize,'Color',colorder(3,:))
    plot(yr_NSF_A,frac_NSF_A(:,i),'.','LineWidth',lw,'MarkerSize',mksize,'Color',colorder(4,:))
    plot(yr_NSF_T,frac_NSF_T(:,i),'.','LineWidth',lw,'MarkerSize',mksize,'Color',colorder(5,:))
    xlabel('year','fontsize',fs1);
    ylabel('representation','fontsize',fs1); 
    axis([1980 2020 0 0.3]);
    title(char(groups(i)),'fontsize',fs1);
    set(gca,'FontSize',fs3,'LineWidth',lw2,'Fontname', 'Arial');

axes('position',[sx+delx+wi     sy+2*(dely+he) wi he])
    i=3; % Black
    plot(yr_NSF_U,frac_NSF_U(:,i),'.','LineWidth',lw,'MarkerSize',mksize,'Color',colorder(1,:))
    hold on
    plot(yr_NSF_G,frac_NSF_G(:,i),'.','LineWidth',lw,'MarkerSize',mksize,'Color',colorder(2,:))
    plot(yr_NSF_P,frac_NSF_P(:,i),'.','LineWidth',lw,'MarkerSize',mksize,'Color',colorder(3,:))
    plot(yr_NSF_A,frac_NSF_A(:,i),'.','LineWidth',lw,'MarkerSize',mksize,'Color',colorder(4,:))
    plot(yr_NSF_T,frac_NSF_T(:,i),'.','LineWidth',lw,'MarkerSize',mksize,'Color',colorder(5,:))
    xlabel('year','fontsize',fs1);
    ylabel('representation','fontsize',fs1); 
    axis([1980 2020 0 0.1]);
    title(char(groups(i)),'fontsize',fs1);
    set(gca,'FontSize',fs3,'LineWidth',lw2,'Fontname', 'Arial');

axes('position',[sx+2*(delx+wi) sy+2*(dely+he) wi he])
    i=6; % Hawaiian
    plot(yr_NSF_U,frac_NSF_U(:,i),'.','LineWidth',lw,'MarkerSize',mksize,'Color',colorder(1,:))
    hold on
    plot(yr_NSF_G,frac_NSF_G(:,i),'.','LineWidth',lw,'MarkerSize',mksize,'Color',colorder(2,:))
    plot(yr_NSF_P,frac_NSF_P(:,i),'.','LineWidth',lw,'MarkerSize',mksize,'Color',colorder(3,:))
    plot(yr_NSF_A,frac_NSF_A(:,i),'.','LineWidth',lw,'MarkerSize',mksize,'Color',colorder(4,:))
    plot(yr_NSF_T,frac_NSF_T(:,i),'.','LineWidth',lw,'MarkerSize',mksize,'Color',colorder(5,:))
    xlabel('year','fontsize',fs1);
    ylabel('representation','fontsize',fs1); 
    axis([1980 2020 0 0.005]);
    set(gca,'YTick',[0 0.001 0.003 0.005])
    set(gca,'YTickLabel',[0 0.001 0.003 0.005])
    title(char(groups(i)),'fontsize',fs1);
    set(gca,'FontSize',fs3,'LineWidth',lw2,'Fontname', 'Arial');

axes('position',[sx             sy+dely+he wi he])
    i=4; % Hispanic
    plot(yr_NSF_U,frac_NSF_U(:,i),'.','LineWidth',lw,'MarkerSize',mksize,'Color',colorder(1,:))
    hold on
    plot(yr_NSF_G,frac_NSF_G(:,i),'.','LineWidth',lw,'MarkerSize',mksize,'Color',colorder(2,:))
    plot(yr_NSF_P,frac_NSF_P(:,i),'.','LineWidth',lw,'MarkerSize',mksize,'Color',colorder(3,:))
    plot(yr_NSF_A,frac_NSF_A(:,i),'.','LineWidth',lw,'MarkerSize',mksize,'Color',colorder(4,:))
    plot(yr_NSF_T,frac_NSF_T(:,i),'.','LineWidth',lw,'MarkerSize',mksize,'Color',colorder(5,:))
    xlabel('year','fontsize',fs1);
    ylabel('representation','fontsize',fs1); 
    axis([1980 2020 0 0.2]);
    title(char(groups(i)),'fontsize',fs1);
    set(gca,'FontSize',fs3,'LineWidth',lw2,'Fontname', 'Arial');

axes('position',[sx+delx+wi     sy+dely+he wi he])
    i=5; % Native
    plot(yr_NSF_U,frac_NSF_U(:,i),'.','LineWidth',lw,'MarkerSize',mksize,'Color',colorder(1,:))
    hold on
    plot(yr_NSF_G,frac_NSF_G(:,i),'.','LineWidth',lw,'MarkerSize',mksize,'Color',colorder(2,:))
    plot(yr_NSF_P,frac_NSF_P(:,i),'.','LineWidth',lw,'MarkerSize',mksize,'Color',colorder(3,:))
    plot(yr_NSF_A,frac_NSF_A(:,i),'.','LineWidth',lw,'MarkerSize',mksize,'Color',colorder(4,:))
    plot(yr_NSF_T,frac_NSF_T(:,i),'.','LineWidth',lw,'MarkerSize',mksize,'Color',colorder(5,:))
    xlabel('year','fontsize',fs1);
    ylabel('representation','fontsize',fs1); 
    axis([1980 2020 0 0.02]);
    title(char(groups(i)),'fontsize',fs1);
    set(gca,'FontSize',fs3,'LineWidth',lw2,'Fontname', 'Arial');

axes('position',[sx+2*(delx+wi) sy+dely+he wi he])
    i=1; % White
    plot(yr_NSF_U,frac_NSF_U(:,i),'.','LineWidth',lw,'MarkerSize',mksize,'Color',colorder(1,:))
    hold on
    plot(yr_NSF_G,frac_NSF_G(:,i),'.','LineWidth',lw,'MarkerSize',mksize,'Color',colorder(2,:))
    plot(yr_NSF_P,frac_NSF_P(:,i),'.','LineWidth',lw,'MarkerSize',mksize,'Color',colorder(3,:))
    plot(yr_NSF_A,frac_NSF_A(:,i),'.','LineWidth',lw,'MarkerSize',mksize,'Color',colorder(4,:))
    plot(yr_NSF_T,frac_NSF_T(:,i),'.','LineWidth',lw,'MarkerSize',mksize,'Color',colorder(5,:))
    xlabel('year','fontsize',fs1);
    ylabel('representation','fontsize',fs1); 
    axis([1980 2020 0.5 1]);
    set(gca,'YTick',[0.5:0.1:1])
    title(char(groups(i)),'fontsize',fs1);
    set(gca,'FontSize',fs3,'LineWidth',lw2,'Fontname', 'Arial');

    
axes('position',[sx             sy wi he])
    i=7; % Multiple
    plot(yr_NSF_U,frac_NSF_U(:,i),'.','LineWidth',lw,'MarkerSize',mksize,'Color',colorder(1,:))
    hold on
    plot(yr_NSF_G,frac_NSF_G(:,i),'.','LineWidth',lw,'MarkerSize',mksize,'Color',colorder(2,:))
    plot(yr_NSF_P,frac_NSF_P(:,i),'.','LineWidth',lw,'MarkerSize',mksize,'Color',colorder(3,:))
    plot(yr_NSF_A,frac_NSF_A(:,i),'.','LineWidth',lw,'MarkerSize',mksize,'Color',colorder(4,:))
    plot(yr_NSF_T,frac_NSF_T(:,i),'.','LineWidth',lw,'MarkerSize',mksize,'Color',colorder(5,:))
    xlabel('year','fontsize',fs1);
    ylabel('representation','fontsize',fs1); 
    axis([1980 2020 0 0.04]);
    title(char(groups(i)),'fontsize',fs1);
    set(gca,'FontSize',fs3,'LineWidth',lw2,'Fontname', 'Arial');

% add legend axis
annotation('rectangle',[0.45 0.08 0.5 he],'Color','black','LineWidth',lw2)
axes('position',[0.45 0.08 0.5 he])
    hold on
    for i = 1:5
        plot([1 2],[6-i 6-i],'LineWidth',lw,'Color',colorder(i,:))
    end
    axis off
    axis([0 25 0 6])
    text(3,5,'Undergrad. degrees (perm. res. only)')
    text(3,4,'Grad. students (perm. res. only)')
    text(3,3,'Postdoc. ')
    text(3,2,'Assistant Prof.')
    text(3,1,'Tenured Prof.')
    set(gca,'FontSize',fs3,'LineWidth',lw2,'Fontname', 'Arial');

% labels
axes('position',[0 0 1 1],'visible','off')
hold on
     text(0.01, 0.11+3*he+2*dely,'a)','fontsize',fs3)
     text(0.34 ,0.11+3*he+2*dely,'b)','fontsize',fs3)
     text(0.67 ,0.11+3*he+2*dely,'c)','fontsize',fs3)
     text(0.01, 0.11+2*he+dely,'d)','fontsize',fs3)
     text(0.34 ,0.11+2*he+dely,'e)','fontsize',fs3)
     text(0.67 ,0.11+2*he+dely,'f)','fontsize',fs3)
     text(0.01 ,0.11+he,'g)','fontsize',fs3)
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

%saveas(1,strcat(['fig.jpg']))
%print -dpdf -r600 fig.pdf
print -djpeg -r600 fig_S4_group_data_frac.jpg
%print -dtiff -r600 fig.tiff

% Restore the previous settings
set(hh,'PaperType',prePaperType);
set(hh,'PaperPosition',prePaperPosition);
set(hh,'PaperSize',prePaperSize);

%%
% cut out data outside 1991:2016
i1=find(yr_GRD_res==1991);
i2=find(yr_GRD_res==2016);
yr_GRD_res = yr_GRD_res(i1:i2);
N_GRD_res = N_GRD_res(i1:i2,:);
clear i1 i2

%   N_NSF_tempres = number of individuals by group (columns) for years
%     (rows), data to approximate temporary resident GRDs (graduate degrees)
%   yr_NSF_permres = years for which there are data on N_NSF_permres
%   N_NSF_permres = number of individuals by group (columns) for years
%     (rows), data to approximate permanent resident GRDs (graduate degrees)


%proportion of known that are temp residents
frac_GRD_res = N_GRD_res./sum(N_GRD_res,2);

%calculate fraction of each group in each stage over time
frac_NSF_tempres = N_NSF_tempres./nansum(N_NSF_tempres,2);
frac_NSF_permres = N_NSF_permres./nansum(N_NSF_permres,2);


%subset residency for the years we have overlapping data for permanent vs
%temporary
yr_by_res = yr_NSF_tempres([3 8 12:end]);
total = N_NSF_tempres([3 8 12:end],:) + N_NSF_permres([3:end],:);
frac_temp_res = N_NSF_tempres([3 8 12:end],:)./total;
frac_perm_res = N_NSF_permres([3:end],:)./total;


mksize2 = 15; % markersize

sx = 0.08;
sy = 0.05;
wi = 0.34;
he = 0.25;
delx = 0.16;
dely = 0.07;

figure(1); clf
hh = gcf;
set(hh,'PaperUnits','inches');
set(hh,'Units','inches');
width = 6; height = 8;
xpos = 5;
ypos = 4;
set(gcf,'Position',[xpos ypos width height])

axes('position',[sx             sy+2*(dely+he) wi he])
    plot(yr_GRD_res,N_GRD_res(:,1),'.','LineWidth',lw,'MarkerSize',mksize2)
    xlabel('year','fontsize',fs1);
    ylabel('number (thousands)','fontsize',fs1);
    axis([1990 2020 0 40000])
    set(gca,'YTick',0:20000:40000)
    set(gca,'YTickLabel',[0 20 40])
    set(gca,'FontSize',fs3,'LineWidth',lw2,'Fontname', 'Arial');

axes('position',[sx+delx+wi     sy+2*(dely+he) wi he])
    plot(yr_GRD_res,N_GRD_res(:,2),'.','LineWidth',lw,'MarkerSize',mksize2)
    xlabel('year','fontsize',fs1);
    ylabel('number (thousands)','fontsize',fs1);
    axis([1990 2020 0 40000])
    set(gca,'YTick',0:20000:40000)
    set(gca,'YTickLabel',[0 20 40])
    set(gca,'FontSize',fs3,'LineWidth',lw2,'Fontname', 'Arial');

axes('position',[sx             sy+dely+he wi he])
	plot(yr_NSF_permres,frac_NSF_permres,'.','LineWidth',lw,'MarkerSize',mksize2)
    axis([1990 2020 0 1])
    xlabel('year','fontsize',fs1);
    ylabel('fraction','fontsize',fs1);
    legend('White','Asian','Black','Hispanic','Native','Hawaiian','Multiple','location','west')
    set(gca,'FontSize',fs3,'LineWidth',lw2,'Fontname', 'Arial');

axes('position',[sx+delx+wi     sy+dely+he wi he])
    plot(yr_NSF_tempres,frac_NSF_tempres,'.','LineWidth',lw,'MarkerSize',mksize2)
    axis([1990 2020 0 1])
    xlabel('year','fontsize',fs1);
    ylabel('fraction','fontsize',fs1);
    set(gca,'FontSize',fs3,'LineWidth',lw2,'Fontname', 'Arial');

axes('position',[sx             sy wi he])
	plot(yr_by_res,frac_perm_res,'.','LineWidth',lw,'MarkerSize',mksize2)
     axis([1990 2020 0 1])
    xlabel('year','fontsize',fs1);
    ylabel('fraction','fontsize',fs1);
    set(gca,'FontSize',fs3,'LineWidth',lw2,'Fontname', 'Arial');
% 
axes('position',[sx+delx+wi     sy wi he])
    plot(yr_by_res,frac_temp_res,'.','LineWidth',lw,'MarkerSize',mksize2)
     axis([1990 2020 0 1])
    xlabel('year','fontsize',fs1);
    ylabel('fraction','fontsize',fs1);
    set(gca,'FontSize',fs3,'LineWidth',lw2,'Fontname', 'Arial');
    
% labels
axes('position',[0 0 1 1],'visible','off')
hold on
    text(0.01,0.94,'a)','fontsize',fs3)
    text(0.5 ,0.94,'b)','fontsize',fs3)
    text(0.01,0.62,'c)','fontsize',fs3)
    text(0.5 ,0.62,'d)','fontsize',fs3)
    text(0.01,0.30,'e)','fontsize',fs3)
    text(0.5 ,0.30,'f)','fontsize',fs3)
    text(0.25,0.98,{'U.S. citizens and','permanent residents'},'horizontalalign','center','fontsize',fs1)
    text(0.75,0.98,'U.S. temporary residents'                 ,'horizontalalign','center','fontsize',fs1)
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

%saveas(1,strcat(['fig.jpg']))
%print -dpdf -r600 fig.pdf
print -djpeg -r600 fig_S5_data_by_residency.jpg
%print -dtiff -r600 fig.tiff

% Restore the previous settings
set(hh,'PaperType',prePaperType);
set(hh,'PaperPosition',prePaperPosition);
set(hh,'PaperSize',prePaperSize);


