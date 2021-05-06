function[n_sim,frac_sim] = do_simulations(time,tstart,tdel,nstage,sind,ngroup,tau,N,N_GRD,frac_smooth_U,frac_smooth_G,frac_smooth_P,frac_smooth_A,frac_smooth_T,frac_smooth_GRD_res,frac_smooth_tempres,n_move,n_leave,n_drop,n_move_outside)
% USAGE: [n_sim,frac_sim] = do_simulations(time,tstart,tdel,nstage,sind,ngroup,tau,N,N_GRD,frac_smooth_U,frac_smooth_G,frac_smooth_P,frac_smooth_A,frac_smooth_T,frac_smooth_GRD_res,frac_smooth_tempres,n_move,n_leave,n_drop,n_move_outside)
% written July 2020  by Allison Shaw (contact ashaw@umn.edu for assistance)
% last updated 29 October 2020
%
% Simulate the number of individuals in each stage and each year, based on
%    NSF data for the number of individuals in each stage and previously 
%    calculated estimates of the total number of individuals transitioning
%    among stages in each year.
%
% Stages considered
%       U = undergraduate students
%       G = graduate students
%       P = postdocs
%       A = assistant professors
%       T = tenured professors
%
% INPUTS:
%   time = vector of years that data is available for (max simulation)
%   tstart = year index to start simulations
%   tdel = number of years to simulate for
%   nstage = number of stages (U, G, P, A, T)
%   sind = index of stage where NSF data is fed in (1=U, 2=G, 3=P, 4=A, 5=T)
%   ngroup = number of groups of individuals
%   tau = vector of the turnover rates for each stage (U, G, P, A, T)
%   N = matrix of the size of each stage (U, G, P, A, T; rows) for each
%        year in time (columns)
%   N_GRD = number of PhDs granted in each year
%   frac_smooth_U = smoothed data of the fraction of undergrad students by
%         group (columns) for each year (rows)
%   frac_smooth_G = smoothed data of the fraction of grad students by
%         group (columns) for each year (rows)
%   frac_smooth_P = smoothed data of the fraction of postdocs by 
%        group (columns) for each year (rows)
%   frac_smooth_A = smoothed data of the fraction of assistant professors 
%        by group (columns) for each year (rows)
%   frac_smooth_T = smoothed data of the fraction of tenured professors by 
%        group (columns) for each year (rows)
%   frac_smooth_GRD_res = smoothed fraction of GRD by CITIZENSHIP group
%        (columns) for years (rows)
%   frac_smooth_tempres = smoothed fraction by group (column) for years
%        (rows) for GRD temporary residents
%   n_move = matrix of the number of individuals of each stage (U, G,
%        P, A, T; rows) moving up to the next stage in each year (columns)
%   n_leave = matrix of the number of individual leaving each stage (U, G,
%        P, A; rows) in each year (columns)
%   n_drop = vector of the number of graduate students leaving before PhD
%        degree in each year
%   n_move_outside = matrix of the number of individuals of each stage (U,
%        G, P, A, T; rows) that are brought in from outside to fill gaps in
%        the next stage in each year (columns)
%
% OUTPUTS:
%   n_sim = number of individuals in each year (dim 1), of each group (dim 2)
%        and each stage (dim 3)
%   frac_sim = fraction of individuals in each year (dim 1), of each group (dim 2)
%        and each stage (dim 3)


T = length(time); % max possible years to simulate for

gind = 2; % grad stage index

%specify number of partitions for each pool
np_GR = 2;
np_TP = 5;

% set years in each of subpartitions
Tp_GR(1) = 3;
Tp_GR(2) = tau(gind) - Tp_GR(1);
if Tp_GR(2) < 0; error('T_GR not correct'); end
Tp_TP = NaN(np_TP,1);
for i=1:np_TP; Tp_TP(i) = tau(end)/np_TP; end

% set up arrays
n_sim = NaN(T,ngroup,nstage); % years x group x stage
n_sim_Gpart = NaN(T,ngroup,np_GR); % years x group x G partition
n_sim_Tpart = NaN(T,ngroup,np_TP); % years x group x T partition
frac_sim = NaN(T,ngroup,nstage); % years x group x stage
frac_sim_Gpart = NaN(T,ngroup,np_GR); % years x group x G partition
frac_sim_Tpart = NaN(T,ngroup,np_TP); % years x group x T partition

% ----INITIAL CONDITIONS -------------------------------------------------%
t = tstart; %  year to start initial conditions

% initialize number of individuals by group in each pool
% fill in grad students, assuming even across partitions
n_sim_Gpart(t,:,1) = (Tp_GR(1)/tau(gind))*N(gind,1)*frac_smooth_G(t,:);
n_sim_Gpart(t,:,2) = (Tp_GR(2)/tau(gind))*N(gind,1)*frac_smooth_G(t,:);

% fill in PD (j=3)
j=3;n_sim(t,:,j) = N(gind+1,1)*frac_smooth_P(t,:);
% fill in AP (j=4)
j=4;n_sim(t,:,j) = N(gind+2,1)*frac_smooth_A(t,:);
% fill in TP (j=5), assuming even across partitions
j=5;
for i=1:np_TP
    n_sim_Tpart(t,:,i) = (Tp_TP(i)/tau(end))*N(end,1)*frac_smooth_T(t,:);
end

% fraction of each group for undergrads
j=1; % undergrads
frac_sim(t,:,j) = frac_smooth_U(t,:);

% fraction of each group for grads
j = 2; % grad students
frac_sim_Gpart(t,:,1) = n_sim_Gpart(t,:,1) ./ sum(n_sim_Gpart(t,:,1));
frac_sim_Gpart(t,:,2) = n_sim_Gpart(t,:,2) ./ sum(n_sim_Gpart(t,:,2));
frac_sim(t,:,j) = sum(n_sim_Gpart(t,:,:),3) ./ sum(sum(n_sim_Gpart(t,:,:)));

% fraction of each group for postdocs
j=3; % postdocs
frac_sim(t,:,j) = n_sim(t,:,j)   ./ ( sum(n_sim(t,:,j)));

% fraction of each group for assistant profs
j=4; % assistant professors
frac_sim(t,:,j) = n_sim(t,:,j)   ./ ( sum(n_sim(t,:,j)));

% fraction of each group for tenured profs
j=5; % tenured professors
for i=1:np_TP
    frac_sim_Tpart(t,:,i) = n_sim_Tpart(t,:,i) ./ sum(n_sim_Tpart(t,:,i));
end
frac_sim(t,:,j) = sum(n_sim_Tpart(t,:,:),3) ./ sum(sum(n_sim_Tpart(t,:,:)));
% ----INITIAL CONDITIONS -------------------------------------------------%


for t = tstart:tstart+tdel-1
    
  %--CALCULATE TRANSITIONS AMONG PARTITIONS-----------------------------%
    pass_G(t) = (1/Tp_GR(1)).*( sum(n_sim_Gpart(t,:,1)) );
    for i = 1:np_TP-1
        pass_T(t,i) = (1/Tp_TP(i))*sum(n_sim_Tpart(t,:,i));
    end
  %--CALCULATE TRANSITIONS AMONG PARTITIONS-----------------------------%

    
  %--SIMULATE FORWARD BY GROUP-------------------------------------------%
    % number of each group in each class at the next time step
    
    j=2; % graduate students
    % grad stage 1       :   (initial #)         (moved on)      (drop out)     (frac in GR-1)       (moved from UG)   (frac in UG)
    n_sim_Gpart(t+1,:,1) = n_sim_Gpart(t,:,1) - ( pass_G(t) + 0.5*n_drop(t) ).*frac_sim_Gpart(t,:,1) + n_move(j-1,t).*frac_sim(t,:,j-1);    
    % grad stage 2       :   (initial #)        (graduated)     (drop out)     (frac in GR-2)       (from GR-1)   (frac in GR-1)
    n_sim_Gpart(t+1,:,2) = n_sim_Gpart(t,:,2) - ( N_GRD(t) + 0.5*n_drop(t) ).*frac_sim_Gpart(t,:,2) + pass_G(t).*frac_sim_Gpart(t,:,1);

    j=3; % postdocs:    (initial #)   (moved on)      (left)    (frac in PD stage)    (moved from GR) (GR from outside)         (frac in GR-2)        
    n_sim(t+1,:,j) =  n_sim(t,:,j) - (n_move(j,t) + n_leave(j,t)).*frac_sim(t,:,j)  + n_move_outside(j-1,t).*frac_sim_Gpart(t,:,2) + n_move(j-1,t).*(frac_smooth_GRD_res(t,1).*frac_sim_Gpart(t,:,2) + frac_smooth_GRD_res(t,2).*frac_smooth_tempres(t,:)); % NEW
    %n_sim(t+1,:,j) =  n_sim(t,:,j) - (n_move(j,t) + n_leave(j,t)).*frac_sim(t,:,j) + ( n_move(j-1,t) + n_move_outside(j-1,t) ).*frac_sim_Gpart(t,:,2); % OLD

    j=4; % ast. prof:  (initial #)    (moved on)      (left)     (frac in AP stage)  (moved from PD) (PD from outside)           (frac in PD)        
    n_sim(t+1,:,j) =  n_sim(t,:,j) - (n_move(j,t) + n_leave(j,t)).*frac_sim(t,:,j) + ( n_move(j-1,t) + n_move_outside(j-1,t) ).*frac_sim(t,:,j-1);
   
    j=5; % tenured professors 
    % TP stage 1             :    (initial #)         (moved on)      (frac in TP 1)       (moved from AP)  (frac in AP)
    i=1;n_sim_Tpart(t+1,:,i) = n_sim_Tpart(t,:,i)  - pass_T(t,1).*frac_sim_Tpart(t,:,i) + n_move(j-1,t).*frac_sim(t,:,j-1);
    
    for i = 2:np_TP-1
        % TP stage i         :    (initial #)       (moved on)      (frac in TP i)       (moved from TP i-1)  (frac in TP i-1)        
        n_sim_Tpart(t+1,:,i) = n_sim_Tpart(t,:,i)  - pass_T(t,i).*frac_sim_Tpart(t,:,i) + pass_T(t,i-1).*frac_sim_Tpart(t,:,i-1);
    end
    % TP stage end               :    (initial #)           (moved on)      (frac in TP end)   (moved from TP i-1)  (frac in TP i-1)
    i=np_TP;n_sim_Tpart(t+1,:,i) = n_sim_Tpart(t,:,i)  - n_move(nstage,t).*frac_sim_Tpart(t,:,i) + pass_T(t,i-1).*frac_sim_Tpart(t,:,i-1);
  %--SIMULATE FORWARD BY GROUP-------------------------------------------%
  
  
  % ----ADJUST FOR ADDITIONAL GROUPS-------------------------------------%
    if t == 21  % when t=21, its 2011, so add new groups starting in t+1 (2012)
        
        % NATIVE HAWAIIAN AND OTHER PACIFIC ISLANDER
        j=2; %(grad students)
        i=1;
        n_sim_Gpart(t+1,6,i) = n_sim_Gpart(t+1,2,i) * frac_smooth_G(t+1,6)/(frac_smooth_G(t+1,2)+frac_smooth_G(t+1,6));
        n_sim_Gpart(t+1,2,i) = n_sim_Gpart(t+1,2,i) * frac_smooth_G(t+1,2)/(frac_smooth_G(t+1,2)+frac_smooth_G(t+1,6));
        i=2;
        n_sim_Gpart(t+1,6,i) = n_sim_Gpart(t+1,2,i) * frac_smooth_G(t+1,6)/(frac_smooth_G(t+1,2)+frac_smooth_G(t+1,6));
        n_sim_Gpart(t+1,2,i) = n_sim_Gpart(t+1,2,i) * frac_smooth_G(t+1,2)/(frac_smooth_G(t+1,2)+frac_smooth_G(t+1,6));
        
        j=3; % (postdocs)
        n_sim(t+1,6,j) = n_sim(t+1,2,j) * frac_smooth_P(t+1,6)/(frac_smooth_P(t+1,2)+frac_smooth_P(t+1,6));
        n_sim(t+1,2,j) = n_sim(t+1,2,j) * frac_smooth_P(t+1,2)/(frac_smooth_P(t+1,2)+frac_smooth_P(t+1,6));
        
        j=4; %(assistant professors)
        n_sim(t+1,6,j) = n_sim(t+1,2,j) * frac_smooth_A(t+1,6)/(frac_smooth_A(t+1,2)+frac_smooth_A(t+1,6));
        n_sim(t+1,2,j) = n_sim(t+1,2,j) * frac_smooth_A(t+1,2)/(frac_smooth_A(t+1,2)+frac_smooth_A(t+1,6));
        
        j=5; %(tenured professors)
        for i=1:np_TP
            n_sim_Tpart(t+1,6,i) = n_sim_Tpart(t+1,2,i) * frac_smooth_T(t+1,6)/(frac_smooth_T(t+1,2)+frac_smooth_T(t+1,6));
            n_sim_Tpart(t+1,2,i) = n_sim_Tpart(t+1,2,i) * frac_smooth_T(t+1,2)/(frac_smooth_T(t+1,2)+frac_smooth_T(t+1,6));
        end
        
        % MORE THAN ONE RACE
        j=2; %(grad students)
        i=1;
        n_tot = sum(n_sim_Gpart(t+1,:,i)); % total number in stage
        mfrac = frac_smooth_G(t+1,7)/(sum(frac_smooth_G(t+1,:))); % proportion of multiple-race in data
        n_sim_Gpart(t+1,:,i) = n_sim_Gpart(t+1,:,i) * (1-mfrac); % reduce all race/ethnic groups equally
        n_sim_Gpart(t+1,7,i) = n_tot * mfrac; % put this amount as multiple-race
        clear n_tot mfrac
        i=2;
        n_tot = sum(n_sim_Gpart(t+1,:,i)); % total number in stage
        mfrac = frac_smooth_G(t+1,7)/(sum(frac_smooth_G(t+1,:))); % proportion of multiple-race in data
        n_sim_Gpart(t+1,:,i) = n_sim_Gpart(t+1,:,i) * (1-mfrac); % reduce all race/ethnic groups equally
        n_sim_Gpart(t+1,7,i) = n_tot * mfrac; % put this amount as multiple-race
        clear n_tot mfrac
        
        j=3; % (postdocs)
        n_tot = sum(n_sim(t+1,:,j)); % total number in stage
        mfrac = frac_smooth_P(t+1,7)/(sum(frac_smooth_P(t+1,:))); % proportion of multiple-race in data
        n_sim(t+1,:,j) = n_sim(t+1,:,j) * (1-mfrac); % reduce all race/ethnic groups equally
        n_sim(t+1,7,j) = n_tot * mfrac; % put this amount as multiple-race
        clear n_tot mfrac
        
        j=4; %(assistant professors)
        n_tot = sum(n_sim(t+1,:,j)); % total number in stage
        mfrac = frac_smooth_A(t+1,7)/(sum(frac_smooth_A(t+1,:))); % proportion of multiple-race in data
        n_sim(t+1,:,j) = n_sim(t+1,:,j) * (1-mfrac); % reduce all race/ethnic groups equally
        n_sim(t+1,7,j) = n_tot * mfrac; % put this amount as multiple-race
        clear n_tot mfrac
        
        j=5; %(tenured professors)
        for i=1:np_TP
            n_tot = sum(n_sim_Tpart(t+1,:,i)); % total number in stage
            mfrac = frac_smooth_T(t+1,7)/(sum(frac_smooth_T(t+1,:))); % proportion of multiple-race in data
            n_sim_Tpart(t+1,:,i) = n_sim_Tpart(t+1,:,i) * (1-mfrac); % reduce all race/ethnic groups equally
            n_sim_Tpart(t+1,7,i) = n_tot * mfrac; % put this amount as multiple-race
            clear n_tot mfrac
        end
        
    end
  % ----ADJUST FOR ADDITIONAL GROUPS-------------------------------------%
  
  
  % ----CALCULATE FRACTION OF EACH GROUP --------------------------------%
    j=1; % undergrads
    frac_sim(t+1,:,j) = frac_smooth_U(t+1,:);

    j = 2; % grad students
    if sind>=2 % set representation data from NSF data
        frac_sim_Gpart(t+1,:,1) = frac_smooth_G(t+1,:);
        frac_sim_Gpart(t+1,:,2) = frac_smooth_G(t+1,:);
        frac_sim(t+1,:,j) = frac_smooth_G(t+1,:);
        % set number of individuals accordingly too
        n_sim_Gpart(t+1,:,1) = sum(n_sim_Gpart(t+1,:,1)).*frac_sim_Gpart(t+1,:,1);
        n_sim_Gpart(t+1,:,2) = sum(n_sim_Gpart(t+1,:,2)).*frac_sim_Gpart(t+1,:,2);
        n_sim(t+1,:,j) = sum(n_sim(t+1,:,j)).*frac_sim(t+1,:,j);
    else % otherwise, set from simulation data
        frac_sim_Gpart(t+1,:,1) = n_sim_Gpart(t+1,:,1) ./ sum(n_sim_Gpart(t+1,:,1));
        frac_sim_Gpart(t+1,:,2) = n_sim_Gpart(t+1,:,2) ./ sum(n_sim_Gpart(t+1,:,2));
        frac_sim(t+1,:,j) = sum(n_sim_Gpart(t+1,:,:),3) ./ sum(sum(n_sim_Gpart(t+1,:,:)));
    end

    j=3; % postdocs
    if sind>=3 % set representation data from NSF data
        frac_sim(t+1,:,j) = frac_smooth_P(t+1,:);
        % set number of individuals accordingly too
        n_sim(t+1,:,j) = sum(n_sim(t+1,:,j)).*frac_sim(t+1,:,j);
    else % otherwise, set from simulation data
        frac_sim(t+1,:,j) = n_sim(t+1,:,j)   ./ ( sum(n_sim(t+1,:,j)));
    end

    j=4; % assistant professors
    if sind>=4 % set representation data from NSF data
        frac_sim(t+1,:,j) = frac_smooth_A(t+1,:);
        % set number of individuals accordingly too
        n_sim(t+1,:,j) = sum(n_sim(t+1,:,j)).*frac_sim(t+1,:,j);
    else % otherwise, set from simulation data
        frac_sim(t+1,:,j) = n_sim(t+1,:,j)   ./ ( sum(n_sim(t+1,:,j)));
    end
    
    j=5; % tenured professors
    if sind>=5 % set representation data from NSF data
        for i=1:np_TP
            frac_sim_Tpart(t+1,:,i) = frac_smooth_T(t+1,:);
            % set number of individuals accordingly too
            n_sim_Tpart(t+1,:,i) = sum(n_sim_Tpart(t+1,:,i)).*frac_sim_Tpart(t+1,:,i);
        end
        frac_sim(t+1,:,j) = frac_smooth_T(t+1,:);
        % set number of individuals accordingly too
        n_sim(t+1,:,j) = sum(n_sim(t+1,:,j)).*frac_sim(t+1,:,j);
    else % otherwise, set from simulation data
        for i=1:np_TP
            frac_sim_Tpart(t+1,:,i) = n_sim_Tpart(t+1,:,i) ./ sum(n_sim_Tpart(t+1,:,i));
        end
        frac_sim(t+1,:,j) = sum(n_sim_Tpart(t+1,:,:),3) ./ sum(sum(n_sim_Tpart(t+1,:,:)));
    end
    % ----CALCULATE FRACTION OF EACH GROUP --------------------------------%
    
    
end


% copy partitioned data to overall data
n_sim(:,:,gind) = sum(n_sim_Gpart,3);
n_sim(:,:,end) = sum(n_sim_Tpart,3);

% check that nothing is going negative
if sum(sum(sum(n_sim<0)))>0; error('negative numbers in simulations'); end
if sum(sum(sum(n_sim_Gpart<0)))>0; error('negative numbers in simulations - G partitions'); end
if sum(sum(sum(n_sim_Tpart<0)))>0; error('negative numbers in simulations - T partitions'); end

if sum(sum(sum(frac_sim<0)))>0; error('negative fractions in simulations'); end
if sum(sum(sum(frac_sim_Gpart<0)))>0; error('negative fractions in simulations - G partitions'); end
if sum(sum(sum(frac_sim_Tpart<0)))>0; error('negative fractions in simulations - T partitions'); end

eps1 = 1e-8;  % error to check against

% check that number of individuals partitioned by group sums to the total
%    number of individuals in each stage
if     sum(abs(N(gind,:)'   - sum(n_sim(:,:,gind),2))) > eps1
    error('error in GR counts')
elseif sum(abs(N(gind+1,:)' - sum(n_sim(:,:,3),2))) > eps1
    error('error in PD counts')
elseif sum(abs(N(gind+2,:)' - sum(n_sim(:,:,4),2))) > eps1
    error('error in AP counts')
elseif sum(abs(N(end,:)'    - sum(n_sim(:,:,end),2))) > eps1
end
