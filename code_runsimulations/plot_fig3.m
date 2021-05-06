clear all; close all; clc
% written by Allison Shaw (contact ashaw@umn.edu for assistance)
% last updated 6 May 2021

% plot White vs All other races/ethnicities

ngroup = 7; % number of individual groups (i.e., race/ethnicities)

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
data = readmatrix('../datafiles_NSF/N_NSF_tempres.csv'); yr_NSF_tempres = data(:,1); N_NSF_tempres = data(:,2:end);
%this contains yr_NSF_x and N_NSF_x for each class x
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

% compare white (first group) to all other groups
N_NSF_UGD2 = N_NSF_UGD(:,1);
N_NSF_UGD2(:,2) = nansum(N_NSF_UGD(:,2:end),2);

N_NSF_GR2 = N_NSF_GR(:,1);
N_NSF_GR2(:,2) = nansum(N_NSF_GR(:,2:end),2);

N_NSF_PD2 = N_NSF_PD(:,1);
N_NSF_PD2(:,2) = nansum(N_NSF_PD(:,2:end),2);

N_NSF_AP2 = N_NSF_AP(:,1);
N_NSF_AP2(:,2) = nansum(N_NSF_AP(:,2:end),2);

N_NSF_TP2 = N_NSF_TP(:,1);
N_NSF_TP2(:,2) = nansum(N_NSF_TP(:,2:end),2);


fs1 = 9;  % axes labels
fs3 = 9;  % axis numbering
lw2 = 1; % fig edges
lw1 = 1.5; % fig lines

c1 = [0.3 0.3 0.3];
c2 = [0.7 0.7 0.7];

sx = 0.07;
sy = 0.16;
he = 0.58;

wi2 = 0.13;
delx2 = 0.062;

figure(2); clf
hh = gcf;
set(hh,'PaperUnits','centimeters');
set(hh,'Units','centimeters');
width = 18; height = 5;
xpos = 5;
ypos = 4;
set(gcf,'Position',[xpos ypos width height])

ii=1; % undergrads
    axes('position',[sx+(ii-1)*(delx2+wi2) sy wi2 he])
    hold on
    i=1; plot(yr_NSF_U,N_NSF_UGD2(:,i),'LineWidth',lw1,'color',c1)
    i=2; plot(yr_NSF_U,N_NSF_UGD2(:,i),'LineWidth',lw1,'color',c2)
    box on
    xlim([1990 2020]); set(gca,'XTick',[1990 2005 2020]); set(gca,'XTickLabel',{'1990','2005','2020'});
    ylim([0 400000]); set(gca,'YTick',[0 200000 400000]); set(gca,'YTickLabel',{'0','200','400'})
    set(gca,'FontSize',fs3,'LineWidth',lw2,'Fontname', 'Arial');
   
ii=2; % grads
    axes('position',[sx+(ii-1)*(delx2+wi2) sy wi2 he])
    hold on
    i=1; plot(yr_NSF_G,N_NSF_GR2(:,i),'LineWidth',lw1,'color',c1)
    i=2; plot(yr_NSF_G,N_NSF_GR2(:,i),'LineWidth',lw1,'color',c2)
    box on
    xlim([1990 2020]); set(gca,'XTick',[1990 2005 2020]); set(gca,'XTickLabel',{'1990','2005','2020'});
    ylim([0 300000]); set(gca,'YTick',[0 100000 200000 300000]); set(gca,'YTickLabel',{'0','100','200','300'})
    set(gca,'FontSize',fs3,'LineWidth',lw2,'Fontname', 'Arial');


ii=3; % postdocs
    axes('position',[sx+(ii-1)*(delx2+wi2) sy wi2 he])
    hold on
    i=1; plot(yr_NSF_P,N_NSF_PD2(:,i),'LineWidth',lw1,'color',c1)
    i=2; plot(yr_NSF_P,N_NSF_PD2(:,i),'LineWidth',lw1,'color',c2)
    box on
    xlim([1990 2020]); set(gca,'XTick',[1990 2005 2020]); set(gca,'XTickLabel',{'1990','2005','2020'});
    ylim([0 20000]); set(gca,'YTick',[0 10000 20000]); set(gca,'YTickLabel',{'0','10','20'})
    set(gca,'FontSize',fs3,'LineWidth',lw2,'Fontname', 'Arial');
    %legend('As.','Bl.','Haw.','His.','Nat.','Whi.','Mult.')
    
ii=4; % assistant professors
    axes('position',[sx+(ii-1)*(delx2+wi2) sy wi2 he])
    hold on
    i=1; plot(yr_NSF_A,N_NSF_AP2(:,i),'LineWidth',lw1,'color',c1)
    i=2; plot(yr_NSF_A,N_NSF_AP2(:,i),'LineWidth',lw1,'color',c2)
    box on
    xlim([1990 2020]); set(gca,'XTick',[1990 2005 2020]); set(gca,'XTickLabel',{'1090','2005','2020'});
    ylim([0 40000]); set(gca,'YTick',[0 20000 40000]); set(gca,'YTickLabel',{'0','20','40'})
    set(gca,'FontSize',fs3,'LineWidth',lw2,'Fontname', 'Arial');

ii=5; % tenured professors
    axes('position',[sx+(ii-1)*(delx2+wi2) sy wi2 he])
    hold on
    i=1; plot(yr_NSF_T,N_NSF_TP2(:,i),'LineWidth',lw1,'color',c1)
    i=2; plot(yr_NSF_T,N_NSF_TP2(:,i),'LineWidth',lw1,'color',c2)
    box on
    xlim([1990 2020]); set(gca,'XTick',[1990 2005 2020]); set(gca,'XTickLabel',{'1990','2005','2020'});
    ylim([0 150000]); set(gca,'YTick',[0 50000 100000 150000]); set(gca,'YTickLabel',{'0','50','100','150'})
    set(gca,'FontSize',fs3,'LineWidth',lw2,'Fontname', 'Arial');
        
    % labels
    axes('position',[0 0 1 1],'visible','off')
    hold on
    text(0.52,0.03,'Year','fontsize',fs1,'horizontalalignment','center')
    text(0.01,0.43,'Number (thounsands)','fontsize',fs1,'rotation',90,'horizontalalignment','center')
    
    
	% legend
    plot([0.47 0.485],[0.67 0.67],'LineWidth',lw1,'color',c1)
    plot([0.47 0.485],[0.62 0.62],'LineWidth',lw1,'color',c2)
    annotation('rectangle',[0.465 0.58 0.09 0.14],'Color','black','LineWidth',lw2)
    text(0.49,0.67,'White','FontSize',7)
    text(0.49,0.62,'All other','FontSize',7)
    
    del = 0.06;
    yy = 0.90;
    text(sx+0*(delx2+wi2)+del,yy,{'Undergraduate','students'},'fontsize',fs1,'horizontalalignment','center')
    text(sx+1*(delx2+wi2)+del,yy,{'Graduate','students'},'fontsize',fs1,'horizontalalignment','center')
    text(sx+2*(delx2+wi2)+del,yy,{'Postdoctoral','researchers'},'fontsize',fs1,'horizontalalignment','center')
    text(sx+3*(delx2+wi2)+del,yy,{'Assistant','Professors'},'fontsize',fs1,'horizontalalignment','center')
    text(sx+4*(delx2+wi2)+del,yy,{'Tenured','Professors'},'fontsize',fs1,'horizontalalignment','center')
    
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

print -djpeg -r600 fig3.jpg

% Restore the previous settings
set(hh,'PaperType',prePaperType);
set(hh,'PaperPosition',prePaperPosition);
set(hh,'PaperSize',prePaperSize);