clear all; close all; clc
% written by Allison Shaw (contact ashaw@umn.edu for assistance)
% last updated 6 May 2021
% plot a figure of metric quantifying difference between model and data

ngroup = 7; % number of individual groups

startyear = [1991 1996 2001 2006]; % set starting year
ny = length(startyear);
RR_mid = NaN(ny,4,ngroup);
data_all = NaN(ny,4,ngroup);
model_all = NaN(ny,4,ngroup);
for i = 1:length(startyear)
    
    load(strcat(['../datafiles_matlab/model_output_varystartyear_i=' num2str(i) '.mat']))
    
    % column orders: White, Asian, Black, Hispanic, Native, Hawaiian
    data = [
        frac_smooth_G(tstart+tdel,:);
        frac_smooth_P(tstart+tdel,:);
        frac_smooth_A(tstart+tdel,:);
        frac_smooth_T(tstart+tdel,:)];
    
    dim = size(frac_sim_fa_de_sind1); % get dimensions of simulated data (time x groups x stages)
    % pull together all simulations versions
    frac_sim_all_sind1 = [frac_sim_fa_de_sind1(:) frac_sim_sl_de_sind1(:) frac_sim_fa_su_sind1(:) frac_sim_sl_su_sind1(:)];
    frac_sim_all_sind2 = [frac_sim_fa_de_sind2(:) frac_sim_sl_de_sind2(:) frac_sim_fa_su_sind2(:) frac_sim_sl_su_sind2(:)];
    frac_sim_all_sind4 = [frac_sim_fa_de_sind4(:) frac_sim_sl_de_sind4(:) frac_sim_fa_su_sind4(:) frac_sim_sl_su_sind4(:)];
    % calculate average value for each
    frac_sim_mean_sind1 = mean(frac_sim_all_sind1,2);
    frac_sim_mean_sind2 = mean(frac_sim_all_sind2,2);
    frac_sim_mean_sind4 = mean(frac_sim_all_sind4,2);
    % reshape array
    frac_sim_mean_sind1 = reshape(frac_sim_mean_sind1,dim(1),dim(2),dim(3));
    frac_sim_mean_sind2 = reshape(frac_sim_mean_sind2,dim(1),dim(2),dim(3));
    frac_sim_mean_sind4 = reshape(frac_sim_mean_sind4,dim(1),dim(2),dim(3));
    clear frac_sim_de* frac_sim_sl* frac_sim_all*

    % output: rows are group -> transpose to columns
    model_mid_sind1 = squeeze(frac_sim_mean_sind1(tstart+tdel,:,2:5))';
    model_mid_sind2 = squeeze(frac_sim_mean_sind2(tstart+tdel,:,2:5))';
    model_mid_sind4 = squeeze(frac_sim_mean_sind4(tstart+tdel,:,2:5))';
    % compile data
    model_transitions = [model_mid_sind1(1,:);  % take G data from sims starting with U NSF data
                         model_mid_sind2(2:3,:) % take P and A data from sims starting with G NSF data
                         model_mid_sind4(4,:)];  % take T data from sims starting with T NSF data

    %store data and model
    data_all(i,:,:) = data;
    model_all(i,:,:) = model_transitions;
    
    % relative ratio
    % dimensions are start time x stage x group
    RR_mid(i,:,:) = (data-model_transitions)./model_transitions;
    
end

% set to NaN the first two temporal data points for postdocs, since the
% data the model is compared to is extrapolated
RR_mid(1:2,2,:) = NaN;


% reorder groups alphabetically (with multi at end for now)
groups = {'White','Asian','Black','Hispanic','Native','Hawaiian','Multiple'};
indorder = [2 3 6 4 5 1 7]
groups = groups(indorder)
RR_mid = RR_mid(:,:,indorder);
data_all = data_all(:,:,indorder);
model_all = model_all(:,:,indorder);

% convert to vectors for plotting
data_all = data_all(:);
model_all = model_all(:);
RR_mid = RR_mid(:);

del = 0.05; % amount of error to consider
% calculate data and model plus / minus the error
data_p = (1+del)*data_all;
data_m = (1-del)*data_all;
model_p = (1+del)*model_all;
model_m = (1-del)*model_all;

% calculate how these errors would translate into metrics
RR1 = (data_m-model_m)./model_m;
RR2 = (data_m-model_p)./model_p;
RR3 = (data_p-model_m)./model_m;
RR4 = (data_p-model_p)./model_p;

% find the smallest and biggest metric values
RR_all = [RR1(:) RR2(:) RR3(:) RR4(:)];
RR_min = min(RR_all,[],2);
RR_max = max(RR_all,[],2);

% calculate size of upper and lower CI bars
RR_up =   RR_max -   RR_mid;
RR_down = RR_mid - RR_min;

nt = 4; % number of transitions

% since we only have a single time point for Hawaiian and Multiple, remove
% and make a shorter version of this figure
RR_mid = RR_mid([1:nt*ny*2 nt*ny*3+1:nt*ny*6]);
RR_down = RR_down([1:nt*ny*2 nt*ny*3+1:nt*ny*6]);
RR_up = RR_up([1:nt*ny*2 nt*ny*3+1:nt*ny*6]);
ngroup = ngroup-2;
groups = groups([1 2 4 5 6])

% convert back to matrix for plotting
RR_mid =  reshape(RR_mid,ny,nt,ngroup);
RR_up =   reshape(RR_up,ny,nt,ngroup);
RR_down = reshape(RR_down,ny,nt,ngroup);


%%
% 
fs1 = 11;  % axes labels
fs3 = 11;  % axis numbering
lw2 = 1; % fig edges
lw = 2; % fig lines
mksize = 10;

colorder = [0.8500    0.3250    0.0980   % red
            0.9290    0.6940    0.1250   % yellow
            0.4660    0.6740    0.1880   % green
            0         0.4470    0.7410   % blue
            0.4940    0.1840    0.5560]; % purple


sx = 0.10;
sy = 0.05;
wi = 0.18;
he = 0.14;
delx = 0.05;
dely = 0.05;

figure(2); clf
hh = gcf;
set(hh,'PaperUnits','centimeters');
set(hh,'Units','centimeters');
width = 18; height = 22;
xpos = 5;
ypos = 4;
set(gcf,'Position',[xpos ypos width height])

for ii = 0:ngroup-1
    for iii=0:nt-1
        
        axes('position',[sx+iii*(delx+wi) sy+(4-ii)*(dely+he) wi he])
        errorbar(1:ny,RR_mid(:,iii+1,ii+1),RR_down(:,iii+1,ii+1),RR_up(:,iii+1,ii+1),'.','LineWidth',lw,'MarkerSize',mksize,'color',colorder(iii+2,:))
        % add zero line as baseline
        line([0 5],[0 0],'color','k')
        
        if ii==3
            axis([0.5 4.5 -1 2])
        else
            axis([0.5 4.5 -1 1])
        end
        
        set(gca,'XTick',1:4)
        set(gca,'XTickLabel',{'t_1','t_2','t_3','t_4'})
        set(gca,'FontSize',fs3,'LineWidth',lw2,'Fontname', 'Arial');


    end
end

% labels
axes('position',[0 0 1 1],'visible','off')
    hold on
    del = 0.08;
    yy = 0.97;
    text(sx+0*(delx+wi)+del,yy,{'Undergrad.','to Grad.'},'fontsize',fs1,'horizontalalignment','center')
    text(sx+1*(delx+wi)+del,yy,{'Grad.','to Postdoc.'},'fontsize',fs1,'horizontalalignment','center')
    text(sx+2*(delx+wi)+del,yy,{'Grad.','to Ast.Prof.'},'fontsize',fs1,'horizontalalignment','center')
    text(sx+3*(delx+wi)+del,yy,{'Ast.Prof.','to Ten.Prof.'},'fontsize',fs1,'horizontalalignment','center')
    
    del = 0.07;
    xx = 0.03;
    text(xx ,sy+4*(dely+he)+del,'Asian','fontsize',fs1,'rotation',90,'horizontalalignment','center')
    text(xx ,sy+3*(dely+he)+del,{'Black &','African Amer.'},'fontsize',fs1,'rotation',90,'horizontalalignment','center')
    text(xx ,sy+2*(dely+he)+del,{'Hispanic','& Latino'},'fontsize',fs1,'rotation',90,'horizontalalignment','center')
    text(xx ,sy+1*(dely+he)+del,{'Amer. Indian &','Alaskan Native'},'fontsize',fs1,'rotation',90,'horizontalalignment','center')
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

saveas(2,'fig_S8_metrics_overtime.jpg')

% Restore the previous settings
set(hh,'PaperType',prePaperType);
set(hh,'PaperPosition',prePaperPosition);
set(hh,'PaperSize',prePaperSize);
