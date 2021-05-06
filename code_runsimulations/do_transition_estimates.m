function[n_move,n_leave,n_drop,n_move_outside] = do_transition_estimates(time,N,N_GRD,tau,tflag)
% USAGE: [n_move,n_leave,n_drop,n_move_outside] = do_transition_estimates(time,N,N_GRD,tau,tflag)
% written June 2020  by Allison Shaw (contact ashaw@umn.edu for assistance)
% last updated 13 October 2020
%
% Calculate estimates of the number of individuals transitioning among
%    stages and out of the system for each year and each stage.
%
% Four outcomes are possible:
%   [1] too few individuals leaving stage j
%   [2] openings in stage j can be filled by individuals leaving stage j-1
%   [3] openings in stage j exceed total individuals in stage j-1
%   [4] openings in stage j exceed individuals leaving stage j-1 but does
%         not exceed total in stage j-1
% Not all of these happen (or are appropriate) for each transition.
%
% Mapping between model code and latex writeup:
%   n_move = mu = individuals moving up to the next stage
%   n_leave = lambda = individual leaving system at each stage
%   n_drop = delta = graduate students leaving before PhD degree
%   n_move_outside = alpha = individuals brought in from outside
%   n_out = rho = first estimate of indivduals leaving stage
%   n_open = omega = number of openings in a stage to be filled
%
% Stages considered:
%       U = undergraduate students
%       G = graduate students
%       P = postdocs
%       A = assistant professors
%       T = tenured professors
%
% INPUTS:
%   time = vector of the years considered
%   N = matrix of the size of each stage (U, G, P, A, T; rows) for each
%        year in time (columns)
%   N_GRD = vector of the number of PhD degrees awarded each year in time
%   tau = vector of the turnover rates for each stage (U, G, P, A, T)
%   tflag = whether to do 'supply' (faculty transition driven by tenure) or
%      'demand' (faculty transition driven by retirements) version of
%      transition estimates
%
% OUTPUTS:
%   n_move = matrix of the number of individuals of each stage (U, G,
%        P, A, T; rows) moving up to the next stage in each year (columns)
%   n_leave = matrix of the number of individual leaving each stage (U, G,
%        P, A; rows) in each year (columns)
%   n_drop = vector of the number of graduate students leaving before PhD
%        degree in each year
%   n_move_outside = matrix of the number of individuals of each stage (G,
%        A, T; rows) that are brought in from outside to fill gaps in the
%        next stage in each year (columns)

nstage = length(tau);
gind = 2; % grad stage index
T = length(time);

% set up empty transition arrays
[n_out,n_open,n_move] = deal(zeros(nstage,T-1));
[n_leave] = zeros(nstage-1,T-1);
[n_move_outside] = zeros(nstage-2,T-1);
[n_drop] = zeros(1,T-1);

for t = 1:T-1
    
    % iniital estimate of individuals leaving stage j, based on average turnover
    n_out(:,t) = (1./tau).*N(:,t);
    % actual number of individuals leaving stage j, based on degrees
    n_out(gind,t) = N_GRD(t); % grad student degrees
    n_out(gind-1,t) = N(1,t); % undergrad student degrees
    
    % number of openings in stage j based on stage size changes and turnover
    n_open(:,t) = N(:,t+1) - N(:,t) + n_out(:,t);
    
    
  %%---------------TENURED PROFESSORS-----------------------------------%
    j = 5;
    if strcmp(tflag,'demand') % do facultytransitions by demand
        n_move(j,t) = n_out(j,t);  % tenured professors retire

        if n_open(j,t)<0 % [1]
            n_move(j,t) = -( N(j,t+1) - N(j,t) ); % increase the number of TP retiring
            n_out(j,t) =  n_move(j,t); % adjust
            n_open(j,t) = N(j,t+1) - N(j,t) + n_out(j,t); % adjust

        elseif n_open(j,t) <= n_out(j-1,t) % [2]
            n_move(j-1,t) = n_open(j,t); % AP individuals moving to TP
            n_leave(j-1,t) = n_out(j-1,t) - n_move(j-1,t); % AP individuals moving outside academia

        elseif n_out(j-1,t) < n_open(j,t) && n_open(j,t) < N(j-1,t) % [4]
            n_move(j-1,t) = n_open(j,t); % move up extra AP to fill TP gaps
            n_leave(j-1,t) = 0;
            n_out(j-1,t) = n_move(j-1,t); % adjust individuals leaving AP
            n_open(j-1,t) = N(j-1,t+1) - N(j-1,t) + n_out(j-1,t); % adjust AP openings

        else
            disp([n_out(j-1,t) n_open(j,t)  N(j-1,t)])
            error(strcat(['error in AP/TP transition; t=' num2str(t)]))
        end
        
    elseif strcmp(tflag,'supply') % do facultytransitions by supply
        
        delN = N(j,t+1) - N(j,t); % calculate change in TP
        
        if delN > n_out(j-1,t) % more open TP slots than AP available
            n_out(j-1,t) = delN; % adjust AP getting tenure accordingly
        end

        n_move(j-1,t) = n_out(j-1,t); % all tenured AP move up to TP
        
        n_out(j,t) = n_out(j-1,t) - delN; % adjust TP leaving
        n_move(j,t) = n_out(j,t); % tenured professors retire

        n_open(j-1,t) = N(j-1,t+1) - N(j-1,t) + n_out(j-1,t); % adjust AP openings

        clear delN

    else
        error(strcat(['unknown tflag: ' tflag]))
    end
    
  %%---------------ASSISTANT PROFESSORS---------------------------------%
    j = 4;
    if 0<= n_open(j,t) && n_open(j,t) <= n_out(j-1,t)  % [2]
        n_move(j-1,t) = n_open(j,t); % PD individuals moving to AP
        n_leave(j-1,t) = n_out(j-1,t) - n_move(j-1,t); % PD individuals moving outside academia
        
    elseif N(j-1,t) < n_open(j,t) % [3]
        n_move(j-1,t) = N(j-1,t); % move all PD up
        n_out(j-1,t) = n_move(j-1,t); % adjust individuals leaving
        n_open(j-1,t) = N(j-1,t+1) - N(j-1,t) + n_out(j-1,t); % adjust openings
        n_move_outside(j-1,t) = n_open(j,t) - n_move(j-1,t); % individuals from other discipline

    elseif n_out(j-1,t) < n_open(j,t) && n_open(j,t) < N(j-1,t) % [4]
        n_move(j-1,t) = n_open(j,t); % move up extra PD to fill AP gaps
        n_leave(j-1,t) = 0;
        n_out(j-1,t) = n_move(j-1,t); % adjust individuals leaving PD
        n_open(j-1,t) = N(j-1,t+1) - N(j-1,t) + n_out(j-1,t); % adjust openings
        
    else
        disp([n_out(j-1,t) n_open(j,t) N(j-1,t)])
        error(strcat(['error in PD/AP transition; t=' num2str(t)]))
    end
    
  %%---------------POSTDOCS---------------------------------------------%
    j = 3;
    if 0<= n_open(j,t) && n_open(j,t) <= n_out(j-1,t) % [2]
        n_move(j-1,t) = n_open(j,t); % GR individuals moving to PD
        n_leave(j-1,t) = n_out(j-1,t) - n_move(j-1,t); % GR individuals moving outside academia
        
    elseif n_out(j-1,t) < n_open(j,t) % [3]
        n_move(j-1,t) = n_out(j-1,t); % move all new PhDs up
        n_leave(j-1,t) = 0;
        n_move_outside(j-1,t) = n_open(j,t) - n_move(j-1,t); % individuals from other discipline
        
    else
        error(strcat(['error in GR/PD transition; t=' num2str(t)]))
    end
    
  %%---------------GRADUATE STUDENTS------------------------------------%
    j = 2;
    n_drop(t) = (1./tau(gind)).*N(gind,t) - n_out(gind,t); % GR moving before degree
    n_open(gind,t) = n_open(gind,t) + n_drop(t); % adjust n-open
        
    if 0<= n_open(j,t) && n_open(j,t) <= n_out(j-1,t) % [2]
        n_move(j-1,t) = n_open(j,t); % UG individuals moving to GR
        n_leave(j-1,t) = n_out(j-1,t) - n_move(j-1,t); % UG individuals moving outside academia
        
    else
        error(strcat(['error in UG/GR transition; t=' num2str(t)]))
    end
    
end


%%---------------CHECKS---------------------------------------------------%

% check for negative transitions
if sum(sum(n_move<0)) +  sum(sum(n_leave<0)) +  sum(n_drop<0) + sum(sum(n_move_outside<0)) > 0
    error('negative transitions')
end

eps1 = 1e-8;  % error to check against
    
% check that TP in/out matches change in stage size
j=5;
diff1 =-n_move(j,1:end)+n_move(j-1,1:end);
diff2 = N(j,2:end) - N(j,1:end-1);
if sum(abs(diff1-diff2)) > eps1
    error('error in TP')
end

% check that PD and AP in/out matches change in stage size
j=3:4;
diff1 =-n_move(j,1:end)+n_move(j-1,1:end)-n_leave(j,1:end)+n_move_outside(j-1,1:end);
diff2 = N(j,2:end) - N(j,1:end-1);
if sum(sum(abs(diff1-diff2))) > eps1
    error('error in PD or AP')
end

% check that GR in/out matches change in stage size
j=2;
diff1 =-n_move(j,1:end)+n_move(j-1,1:end)-n_leave(j,1:end)-n_drop(1:end);
diff2 = N(j,2:end) - N(j,1:end-1);
if sum(sum(abs(diff1-diff2))) > eps1
    error('error in GR')
end