% -------------------------------------------------------- %
% Cuckoo algorithm                                         %
% -------------------------------------------------------- %
% Usage: cuckoo_search(5000) or cuckoo_search;             %

function [bestsol,fval]=cuckoo_search(Ngen)
% Here Ngen is the max number of function evaluations
if nargin<1, Ngen=1500; end

% Display help info
%help cuckoo_search

% Plot Function ------------------------
Ngrid=100;
range=[0 4 0 4];
dx=(range(2)-range(1))/Ngrid;
dy=(range(4)-range(3))/Ngrid;
xgrid=range(1):dx:range(2); ygrid=range(3):dy:range(4);

[x,y]=meshgrid(xgrid,ygrid);
z=-sin(x).*(sin(x.^2/pi)).^20 - sin(y).*(sin(2. .*y.^2/pi)).^20;

%figure(1);
%surfc(x,y,z);
% ----------------------------------------

% d-dimensions (any dimension)
d=2;
% Number of nests (or different solutions)
n=30;
% Discovery rate of alien eggs/solutions
pa=0.25;

% Lower limit/bounds/ a vector
Lb=0.*ones(1,d);
% Upper limit/bounds/ a vector
Ub=5.*ones(1,d);

% Random initial solutions
nest = 5. * randn(n,d);
fbest=ones(n,1)*10^(100);   % minimization problems
Kbest=1;

for j=1:Ngen,
    % Find the current best
    Kbest=get_best_nest(fbest);
    % Choose a random nest (avoid the current best)
    k=choose_a_nest(n,Kbest);
    bestnest=nest(Kbest,:) ;
    % Generate a new solution (but keep the current best)
    s=get_a_cuckoo(nest(k,:),bestnest);

    % Apply simple bounds/limits
    s=simplebounds(s,Lb,Ub);   
    
    % Evaluate this solution
    fnew=fobj(s);
    if fnew<=fbest(k),
        fbest(k)=fnew;
        nest(k,:)=s;
    end
    % discovery and randomization
    if rand<pa,
       k=get_max_nest(fbest);
       s=emptyit(nest(k,:));
       nest(k,:)=s;
       fbest(k)=fobj(s);
    end
end

% Post-optimization processing

% Display all the nests
nest

% Find the best and display
[fmin,I]=min(fbest); 
best_solution=nest(I,:)
best_fmin=fmin

% Plot Solution
figure(2);
refresh(2)
contour(x,y,z,15); hold on;
for i=1:n,
  plot(nest(i,1), nest(i,2),'.1',"markersize", 6); axis(range);
end
plot(best_solution(1),best_solution(2),'*0',"markersize", 6); axis(range);

% ----------------------------------
% --------- Subfunctions -----------
% ----------------------------------

% Choose a nest randomly
function k=choose_a_nest(n,Kbest)
k=floor(rand*n)+1;
% Avoid the best
if k==Kbest,
 k=mod(k+1,n)+1;
end

% Get a cuckoo and generate new solutions by ramdom walk
function s=get_a_cuckoo(s,star)
% This is a random walk, which is less efficient
% than Levy flights. In addition, the step size
% should be a vector for problems with different scales.
stepsize=0.05;
%s=star+stepsize*randn(size(s));
s=star+stepsize*(5.*randn(size(s))); % Modified: random jump in [0,5]
                     
% Find the worse nest
function k=get_max_nest(fbest)
[fmax,k]=max(fbest);

% Find the current best nest
function k=get_best_nest(fbest)
[fmin,k]=min(fbest);

% Replace some (of the worst nests)
% by constructing new solutions/nests
function s=emptyit(s)
% Again the step size should be varied
% Here is a simplified approach
% s=s+0.05*randn(size(s));
s=s+0.05*(5.*randn(size(s))); % Modified: random jump in [0,5]

% Application of simple limits/bounds
function s=simplebounds(s,Lb,Ub)
  % Apply the lower bound vector
  ns_tmp=s;
  I=ns_tmp<Lb;
  ns_tmp(I)=Lb(I);
  
  % Apply the upper bound vector 
  J=ns_tmp>Ub;
  ns_tmp(J)=Ub(J);
  % Update this new move 
  s=ns_tmp;

% d-dimensional objective function
% function z=fobj(u)
% Rosenbrock's function (in 2D)
% It has an optimal solution at (1.000,1.000)
% z=(1-u(1))^2+100*(u(2)-u(1)^2)^2;

% d-dimensional objective function
function z=fobj(u)
% Michaelewicz's function (in 2D)
% It has an optimal solution at (2.20319,1.57049)
z=-sin(u(1)).*(sin(u(1).^2/pi)).^20 - sin(u(2)).*(sin(2 .*u(2).^2/pi)).^20;
