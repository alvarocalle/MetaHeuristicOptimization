% ------------------------------------------------------------- %
% Bat-inspired algorithm for continuous optimization (demo)     %
% ------------------------------------------------------------- %
% This is a simple version implementing the basic idea of the   %
% bat algorithm without fine-tuning the parameters.             %    
% ------------------------------------------------------------- %

% Main programs starts here
function [best,fmin,N_iter]=bat_algorithm(para)
% Display help
% help bat_algorithm.m

% Default parameters
if nargin<1,  para=[40 1000 0.9 0.5];  end
n=para(1);      % Population size, typically 10 to 40
N_gen=para(2);  % Number of generations
A=para(3);      % Loudness  (constant or decreasing)
r=para(4);      % Pulse rate (constant or decreasing)
% This frequency range determines the scalings
% You should change these values if necessary
Qmin=0;         % Frequency minimum
Qmax=2;         % Frequency maximum
% Iteration parameters
N_iter=0;       % Total number of function evaluations
% Dimension of the search variables
d=2;           % Number of dimensions
% Lower limit/bounds/ a vector
Lb=-2.*pi*ones(1,d);
% Upper limit/bounds/ a vector
Ub=2*pi*ones(1,d);
% ----------------------------------------------------
% Grid values of the objective function (visualization)
Ngrid=100;
range=[-2 2 -2 2]*pi;
dx=(range(2)-range(1))/Ngrid;
dy=(range(4)-range(3))/Ngrid;
xgrid=range(1):dx:range(2); ygrid=range(3):dy:range(4);
[x,y]=meshgrid(xgrid,ygrid);
z = x.^2 + y.^2 + 25.*( sin(x).^2 + sin(y).^2 );
% Display the shape of the function to be optimized
%figure(1);
%surfc(x,y,z);
% ---------------------------------------------------
% Initializing arrays
Q=zeros(n,1);   % Frequency
v=zeros(n,d);   % Velocities
% Initialize the population/solutions
for i=1:n,
  Sol(i,:)=Lb+(Ub-Lb).*rand(1,d);
  Fitness(i)=Fun(Sol(i,:));
  x0(i) = Sol(i,1);
  y0(i) = Sol(i,2);
end
% Find the initial best solution
[fmin,I]=min(Fitness);
best=Sol(I,:);
 
% Start the iterations -- Bat Algorithm (essential part)  %
for t=1:N_gen, 
      
  % Loop over all bats/solutions
        for i=1:n,
          Q(i)=Qmin+(Qmin-Qmax)*rand;
          v(i,:)=v(i,:)+(Sol(i,:)-best)*Q(i);
          S(i,:)=Sol(i,:)+v(i,:);

          xn(t,i) = Sol(i,1);
          yn(t,i) = Sol(i,2);
          
          % Apply simple bounds/limits
          Sol(i,:)=simplebounds(Sol(i,:),Lb,Ub);
          % Pulse rate
          if rand>r
          % The factor 0.001 limits the step sizes of random walks
              S(i,:)=best+0.1*randn(1,d);
              %S(i,:)=best+0.001*randn(1,d);
          end

          % Evaluate new solutions
          Fnew=Fun(S(i,:));
          % Update if the solution improves, or not too loud
          if (Fnew<=Fitness(i)) & (rand<A) ,
              Sol(i,:)=S(i,:);              
              Fitness(i)=Fnew;
          end

          % Update the current best solution
          if Fnew<=fmin,
                best=S(i,:);
                fmin=Fnew;
                xbest = S(i,1);
                ybest = S(i,2);
          end
          
        end
        N_iter=N_iter+n;

end
% Output/display
disp(['Number of evaluations: ',num2str(N_iter)]);
disp(['Best =',num2str(best),' fmin=',num2str(fmin)]);
%disp(['Best positions:']);
%disp([xbest,ybest]);

figure(2);
contour(x,y,z,15); hold on;
plot(x0,y0,'.1',"markersize", 5); axis(range);
%for t=50:100,
%  plot(xn(t,:),yn(t,:),'*1',"markersize", 5); axis(range/2);
%end
plot(xbest,ybest,'*0',"markersize", 5); axis(range);


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

% Objective function
function z=Fun(u)
%-----------------------------------------------------------
% Eggcrate function with fmin=0 at (0,0)
z = u(1).^2 + u(2).^2 + 25.*( sin(u(1)).^2 + sin(u(2)).^2 );
%-----------------------------------------------------------
% Sphere function with fmin=0 at (0,0,...,0)
%z=sum(u.^2);

