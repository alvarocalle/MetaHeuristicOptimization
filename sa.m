% ===================================================================
% Simulated Annealing
% Usage: sa
% For the constrained optimization
% ===================================================================

function sa
disp('Simulating ... it will take a minute or so!');
% Lower and upper bounds
Lb=[-2 -2];
Ub=[2 2];
nd=length(Lb);

% Initializing parameters and settings
T_init =5.;     % Initial temperature
T_min = 1e-10;  % Final stopping temperature
F_min = -1e+100;% Min value of the function
max_rej=250;    % Maximum number of rejections
max_run=250;    % Maximum number of runs
max_accept=15;  % Maximum number of accept
k = 1;          % Boltzmann constant
alpha=0.8;      % Cooling factor
Enorm=1e-2;     % Energy norm (eg, Enorm=le-8)
guess=Lb+(Ub-Lb).*rand(size(Lb));    % Initial guess
% Initializing the counters i,j etc
i= 0; j = 0; accept = 0; totaleval = 0;
% Initializing various values
T = T_init;
E_init = fobj(guess);
E_old = E_init; E_new=E_old;
best=guess; % initially guessed values

% ***************************************************
% Starting the simulated annealling
% ***************************************************
while ((T > T_min) & (j <= max_rej) & E_new>F_min)
i = i+1;
% Check if max numbers of run/accept are met
if (i >= max_run) | (accept >= max_accept)
% Cooling according to a cooling schedule
T = alpha*T;
totaleval = totaleval + i;
% reset the counters
i = 1; accept = 1;
end
% Function evaluations at new locations
s=0.01*(Ub-Lb);
ns=best+s.*randn(1,nd);
E_new = fobj(ns);
% Decide to accept the new solution
DeltaE=E_new-E_old;
% Accept if improved
if (-DeltaE > Enorm)
best = ns; E_old = E_new;
accept=accept+1; j = 0;
end
% Accept with a small probability if not improved
if (DeltaE<=Enorm & exp(-DeltaE/(k*T))>rand );
best = ns; E_old = E_new;
accept=accept+1;
else
end
% Update the estimated optimal solution
f_opt=E_old;
end
% Display the final results
disp(strcat('Evaluations :', num2str(totaleval)));
disp(strcat('Best solution:', num2str(best)));
disp(strcat('Best objective:', num2str(f_opt)));

function z=fobj(u)
% Rosenbrock's function with f*=0 at (1,1)
z=(u(1)-1)^2+100*(u(2)-u(1)^2)^2;
