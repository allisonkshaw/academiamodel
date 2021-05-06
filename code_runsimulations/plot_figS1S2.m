clear all; clc
% written July 2020 by Allison Shaw (contact ashaw@umn.edu for assistance)
% last updated 6 May 2021

% load raw model structure data
data = readmatrix('../datafiles_NSF/N_UGD.csv'); yr_UGD = data(:,1); N_UGD = data(:,2);
data = readmatrix('../datafiles_NSF/N_GRD.csv'); yr_GRD = data(:,1); N_GRD = data(:,2);
data = readmatrix('../datafiles_NSF/N_GR.csv');  yr_GR  = data(:,1); N_GR  = data(:,2);
data = readmatrix('../datafiles_NSF/N_PD.csv');  yr_PD  = data(:,1); N_PD  = data(:,2);
data = readmatrix('../datafiles_NSF/N_AP.csv');  yr_AP  = data(:,1); N_AP  = data(:,2);
data = readmatrix('../datafiles_NSF/N_TP.csv');  yr_TP  = data(:,1); N_TP  = data(:,2);

fs1 = 11;  % axes labels
fs3 = 9;  % axis numbering
lw = 2; % fig lines
lw2 = 1; % fig edges
mksize = 10; % markersize


sx = 0.08;
sy = 0.1;
wi = 0.2;
he = 0.33;
delx = 0.13;
dely = 0.17;

figure(1); clf
hh = gcf;
set(hh,'PaperUnits','inches');
set(hh,'Units','inches');
width = 6; height = 4;
xpos = 5;
ypos = 4;
set(gcf,'Position',[xpos ypos width height])

axes('position',[sx             sy+dely+he wi he])
    plot(yr_UGD,N_UGD,'.','LineWidth',lw,'MarkerSize',mksize)
    grid on
    axis([1960 2020 100000 700000])
    set(gca,'YTick',[100000 300000 500000 700000])
    set(gca,'YTickLabel',[100 300 500 700])
    xlabel('Year','fontsize',fs1)
    ylabel('Number (thousands)','fontsize',fs1)
    title('UG degrees','fontsize',fs1)
    set(gca,'FontSize',fs3,'LineWidth',lw2,'Fontname', 'Arial');
    
axes('position',[sx+delx+wi     sy+dely+he wi he])
    plot(yr_GR,N_GR,'.','LineWidth',lw,'MarkerSize',mksize)
    grid on
    axis([1960 2020 100000 700000])
    set(gca,'YTick',[100000 300000 500000 700000])
    set(gca,'YTickLabel',[100 300 500 700])
    xlabel('Year','fontsize',fs1)
    ylabel('Number (thousands)','fontsize',fs1)
    title('GR students','fontsize',fs1)
    set(gca,'FontSize',fs3,'LineWidth',lw2,'Fontname', 'Arial');

axes('position',[sx+2*(delx+wi) sy+dely+he wi he])
    plot(yr_GRD,N_GRD,'.','LineWidth',lw,'MarkerSize',mksize)
    grid on
    axis([1960 2020 10000 40000])
    set(gca,'YTick',[10000 20000 30000 40000])
    set(gca,'YTickLabel',[10 20 30 40])
    xlabel('Year','fontsize',fs1)
    ylabel('Number (thousands)','fontsize',fs1)
    title('GR degrees','fontsize',fs1)
    set(gca,'FontSize',fs3,'LineWidth',lw2,'Fontname', 'Arial');

axes('position',[sx             sy wi he])
    plot(yr_PD,N_PD,'.','LineWidth',lw,'MarkerSize',mksize);
    grid on
    axis([1960 2020 10000 50000])
    set(gca,'YTick',[10000 30000 50000])
    set(gca,'YTickLabel',[10 30 50])
    xlabel('Year','fontsize',fs1)
    ylabel('Number (thousands)','fontsize',fs1)
    title('PD researchers','fontsize',fs1)
    set(gca,'FontSize',fs3,'LineWidth',lw2,'Fontname', 'Arial');

axes('position',[sx+delx+wi     sy wi he])
    plot(yr_AP,N_AP,'.','LineWidth',lw,'MarkerSize',mksize);
    grid on
    axis([1960 2020 20000 62000])
    set(gca,'YTick',[20000 40000 60000])
    set(gca,'YTickLabel',[20 40 60])
    xlabel('Year','fontsize',fs1)
    ylabel('Number (thousands)','fontsize',fs1)
    title('Assistant professors','fontsize',fs1)
    set(gca,'FontSize',fs3,'LineWidth',lw2,'Fontname', 'Arial');

    
axes('position',[sx+2*(delx+wi)     sy wi he])
    plot(yr_TP,N_TP,'.','LineWidth',lw,'MarkerSize',mksize);
    grid on
    axis([1960 2020 60000 180000])
    set(gca,'YTick',[60000 100000 140000 180000])
    set(gca,'YTickLabel',[60 100 140 180])
    xlabel('Year','fontsize',fs1)
    ylabel('Number (thousands)','fontsize',fs1)
    title('Tenured professors','fontsize',fs1)
    set(gca,'FontSize',fs3,'LineWidth',lw2,'Fontname', 'Arial');

    
% labels
axes('position',[0 0 1 1],'visible','off')
hold on
    text(0   ,0.98,'a)','fontsize',fs3)
    text(0.33,0.98,'b)','fontsize',fs3)
    text(0.66,0.98,'c)','fontsize',fs3)
    text(0   ,0.48,'d)','fontsize',fs3)
    text(0.33,0.48,'e)','fontsize',fs3)
    text(0.66,0.48,'f)','fontsize',fs3)
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

print -djpeg -r600 fig_S1_structure_data_raw.jpg

% Restore the previous settings
set(hh,'PaperType',prePaperType);
set(hh,'PaperPosition',prePaperPosition);
set(hh,'PaperSize',prePaperSize);
%%

% clean (truncate/interpolate)
[yr_UGD,N_UGD,yr_GRD,N_GRD,yr_GR,N_GR,yr_PD,N_PD,yr_AP,N_AP,yr_TP,N_TP] = do_structure_data_clean(yr_UGD,N_UGD,yr_GRD,N_GRD,yr_GR,N_GR,yr_PD,N_PD,yr_AP,N_AP,yr_TP,N_TP);

 
figure(1); clf
hh = gcf;
set(hh,'PaperUnits','inches');
set(hh,'Units','inches');
width = 6; height = 4;
xpos = 5;
ypos = 4;
set(gcf,'Position',[xpos ypos width height])

axes('position',[sx             sy+dely+he wi he])
    plot(yr_UGD,N_UGD,'.','LineWidth',lw,'MarkerSize',mksize)
    grid on
    axis([1990 2020 100000 700000])
    set(gca,'YTick',[100000 300000 500000 700000])
    set(gca,'YTickLabel',[100 300 500 700])
    xlabel('Year','fontsize',fs1)
    ylabel('Number (thousands)','fontsize',fs1)
    title('UG degrees','fontsize',fs1)
    set(gca,'FontSize',fs3,'LineWidth',lw2,'Fontname', 'Arial');
    
axes('position',[sx+delx+wi     sy+dely+he wi he])
    plot(yr_GR,N_GR,'.','LineWidth',lw,'MarkerSize',mksize)
    grid on
    axis([1990 2020 100000 700000])
    set(gca,'YTick',[100000 300000 500000 700000])
    set(gca,'YTickLabel',[100 300 500 700])
    xlabel('Year','fontsize',fs1)
    ylabel('Number (thousands)','fontsize',fs1)
    title('GR students','fontsize',fs1)
    set(gca,'FontSize',fs3,'LineWidth',lw2,'Fontname', 'Arial');

axes('position',[sx+2*(delx+wi) sy+dely+he wi he])
    plot(yr_GRD,N_GRD,'.','LineWidth',lw,'MarkerSize',mksize)
    grid on
    axis([1990 2020 10000 40000])
    set(gca,'YTick',[10000  20000 30000 40000])
    set(gca,'YTickLabel',[10 20 30 40])
    xlabel('Year','fontsize',fs1)
    ylabel('Number (thousands)','fontsize',fs1)
    title('GR degrees','fontsize',fs1)
    set(gca,'FontSize',fs3,'LineWidth',lw2,'Fontname', 'Arial');

axes('position',[sx             sy wi he])
    plot(yr_PD,N_PD,'.','LineWidth',lw,'MarkerSize',mksize);
    grid on
    axis([1990 2020 10000 50000])
    set(gca,'YTick',[10000 30000 50000])
    set(gca,'YTickLabel',[10 30 50])
    xlabel('Year','fontsize',fs1)
    ylabel('Number (thousands)','fontsize',fs1)
    title('PD researchers','fontsize',fs1)
    set(gca,'FontSize',fs3,'LineWidth',lw2,'Fontname', 'Arial');

axes('position',[sx+delx+wi     sy wi he])
    plot(yr_AP,N_AP,'.','LineWidth',lw,'MarkerSize',mksize);
    grid on
    axis([1960 2020 20000 62000])
    set(gca,'YTick',[20000 40000 60000])
    set(gca,'YTickLabel',[20 40 60])
    xlabel('Year','fontsize',fs1)
    ylabel('Number (thousands)','fontsize',fs1)
    title('Assistant professors','fontsize',fs1)
    set(gca,'FontSize',fs3,'LineWidth',lw2,'Fontname', 'Arial');

    
axes('position',[sx+2*(delx+wi)     sy wi he])
    plot(yr_TP,N_TP,'.','LineWidth',lw,'MarkerSize',mksize);
    grid on
    axis([1990 2020 80000 180000])
    set(gca,'YTick',[80000 100000 120000 140000 160000 180000])
    set(gca,'YTickLabel',[80 100 120 140 160 180])
    xlabel('Year','fontsize',fs1)
    ylabel('Number (thousands)','fontsize',fs1)
    title('Tenured professors','fontsize',fs1)
    set(gca,'FontSize',fs3,'LineWidth',lw2,'Fontname', 'Arial');
    
% labels
axes('position',[0 0 1 1],'visible','off')
hold on
    text(0   ,0.98,'a)','fontsize',fs3)
    text(0.33,0.98,'b)','fontsize',fs3)
    text(0.66,0.98,'c)','fontsize',fs3)
    text(0   ,0.48,'d)','fontsize',fs3)
    text(0.33,0.48,'e)','fontsize',fs3)
    text(0.66,0.48,'f)','fontsize',fs3)
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

print -djpeg -r600 fig_S2_structure_data_used.jpg

% Restore the previous settings
set(hh,'PaperType',prePaperType);
set(hh,'PaperPosition',prePaperPosition);
set(hh,'PaperSize',prePaperSize);

