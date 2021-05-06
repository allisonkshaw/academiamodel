clear all; close all; clc
% written by Allison Shaw (contact ashaw@umn.edu for assistance)
% last updated 6 May 2021
% plot figures comparing model and data

% load mat files from simulations started at different stages
load('../datafiles_matlab/model_output_varyinputstage.mat')
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

% check that everything is using same data
yr_smooth(tstart+tdel) % data year
time(tstart+tdel) % model year

% column orders: White, Asian, Black, Hispanic, Native, Hawaiian, Multiple
data = [
frac_smooth_G(tstart+tdel,:);
frac_smooth_P(tstart+tdel,:);
frac_smooth_A(tstart+tdel,:);
frac_smooth_T(tstart+tdel,:)];

% reorder races alphabetically (multi last for now)
%races = {'White','Asian','Black','Hispanic','Native','Hawaiian','Multiple'};
%new order: amer-native, asian, black, hispanic, native-haw, white, mult
indorder = [5 2 3 4 6 1 7]
groups = groups(indorder)
model_transitions = model_transitions(:,indorder);
data = data(:,indorder);


% and convert model and data to vectors
data = data(:);
model_transitions = model_transitions(:);

% relative representation
RR_transitions = (data-model_transitions)./model_transitions;

del = 0.05; % amount of error to consider

% calculate data and model plus / minus the error
data_p = (1+del)*data;
data_m = (1-del)*data;
model_t_p = (1+del)*model_transitions;
model_t_m = (1-del)*model_transitions;

% calculate how these errors would translate into metrics
RR1_t = (data_m-model_t_m)./model_t_m;
RR2_t = (data_m-model_t_p)./model_t_p;
RR3_t = (data_p-model_t_m)./model_t_m;
RR4_t = (data_p-model_t_p)./model_t_p;

% find the smallest and biggest metric values
RR_t_all = [RR1_t(:) RR2_t(:) RR3_t(:) RR4_t(:)];
RR_t_min = min(RR_t_all,[],2);
RR_t_max = max(RR_t_all,[],2);

% calculate size of upper and lower CI bars
RR_t_up =   RR_t_max -       RR_transitions;
RR_t_down = RR_transitions - RR_t_min;

%%

sx = 0.07;
sy = 0.24;
wi = 0.92;
he = 0.72;

fs1 = 9;  % axes labels
fs3 = 9;  % axis numbering
lw2 = 1; % fig edges
lw1 = 1.5; % fig lines
mksize = 20;

colorder = [0.8500    0.3250    0.0980   % red
            0.9290    0.6940    0.1250   % yellow
            0.4660    0.6740    0.1880   % green
            0         0.4470    0.7410   % blue
            0.4940    0.1840    0.5560]; % purple


figure(2); clf
hh = gcf;
set(hh,'PaperUnits','centimeters');
set(hh,'Units','centimeters');
width = 18; height = 8;
xpos = 5;
ypos = 4;
set(gcf,'Position',[xpos ypos width height])

axes('position',[sx sy wi he])
    for i=1:4
        errorbar(i:4:length(RR_transitions),RR_transitions(i:4:end),RR_t_down(i:4:end),RR_t_up(i:4:end),'.','LineWidth',lw1,'MarkerSize',mksize,'color',colorder(i+1,:))
        hold on
    end
    set(gca,'XTick',1:(nstage-1)*ngroup)
    labels = {'U to G','G to P','G to A','A to T'};
    labels = cellfun(@(x) strrep(x,' ','\newline'), labels,'UniformOutput',false);
    set(gca,'XTickLabel',labels)
    
    xlabel('Academic transition','fontsize',fs1)
    ylabel('Relative representation (\theta)','fontsize',fs1)
    line([0 (nstage-1)*ngroup+1],[0 0],'color','k')
% add lines and text to separate by race/ethnicity
    x= 4:4:(nstage-1)*ngroup;
    for i=1:length(x)
        line([ x(i)+0.5  x(i)+0.5],[-2 2],'color','k')
    end
    axis([0.5 (nstage-1)*ngroup+0.5 -1 1])
    set(gca,'FontSize',fs3,'LineWidth',lw2,'Fontname', 'Arial');
    
   yy=0.8;   
   text(4+0*4-1.5,yy,{'Amer. Indian &','Alaskan Native'},'fontsize',fs1,'horizontalalignment','center')
   text(4+1*4-1.5,yy,'Asian','fontsize',fs1,'horizontalalignment','center')
   text(4+2*4-1.5,yy,{'Black &','African Amer.'},'fontsize',fs1,'horizontalalignment','center')
   text(4+3*4-1.5,yy,{'Hispanic','& Latino'},'fontsize',fs1,'horizontalalignment','center')
   text(4+4*4-1.5,yy,{'Native Haw.','& Pacific Isl.'},'fontsize',fs1,'horizontalalignment','center')
   text(4+5*4-1.5,yy,'White','fontsize',fs1,'horizontalalignment','center')
   text(4+6*4-1.5,yy,{'More than','one race'},'fontsize',fs1,'horizontalalignment','center')

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

saveas(2,'fig4.jpg')

% Restore the previous settings
set(hh,'PaperType',prePaperType);
set(hh,'PaperPosition',prePaperPosition);
set(hh,'PaperSize',prePaperSize);
