% Script for solving linear advection equation
%% Setup problem
dlim = [0,1];
T = [0,1];

animate = false;

a = 1;
nx    = 1000;
nstep = ceil(nx*a);
dx = (dlim(2)-dlim(1))/(nx-1);
dt = (T(2)-T(1))/(nstep-1);

%% Define grid

% x = [];
% for i=1:nx
%     if i == 1
%         x(i) = dlim(1);
%     else
%         x(i)=x(end)+dx;
%     end
% end
% x=x';
%%%%%new code
x = linspace(dlim(1),dlim(2),nx)';

%% Create difference matrix

%A matrix of 1000x1000 is created. this matrix is full of 0s, except 2 diagonals. 
%The diagonals are (i,i) [i.e.(1,1),(2,2),...,(1000,1000)] which have value 999, and (i,i-1) [i,e (1,1000),(2,1),(3,2),...(1000,999)] which have value -999.

% D1 = (1/dx)*(diag(-1*ones(nx-1,1),-1) + ...
%                diag(ones(nx,1),0));
% D1(1,end) = -1/dx;

%1,2,...,1000,2,3,...,1000,1 (the second half starts at 2 and the 1 comes at the end because of the diagonal starting at 2,1
rows = [1:nx,2:nx,1]; 
%it can also be written as [1:nx,1:nx] but this way it looks more similar to the code above
cols = [1:nx,1:nx-1,nx];
%values, 1000 times 999 (as the first 1000 elements indicated by the first 1000 elements of 'rows' and 'cols' are valued 999, and the rest are -999
vals = (1/dx)*[ones(1,nx),-ones(1,nx)]; 
D1 = sparse(rows,cols,vals);

%% Time step

U = cos(2*pi*x);
% for i = 1:nstep
%     U(:,i+1) = optimize_me_too(D1,nx,a,dt)*U(:,i);
%     
%     neg_ind = find(U(:,i+1) < 0);
%     pos_ind = find(U(:,i+1) > 0);
%     
%     xneg     = x(neg_ind);
%     xpos     = x(pos_ind);
%     negative = U(neg_ind,i+1);
%     positive = U(pos_ind,i+1);
%     
%     if animate
%         plot(xneg,negative,'r.'); set(gca,'nextplot','add');
%         plot(xpos,positive,'k.'); set(gca,'nextplot','replacechildren'); drawnow;
%     end
% end
% 

for i = 1:nstep
    U = U - a*dt*D1*U;
    neg_ind = U < 0;
    
    if animate
        plot(x(neg_ind),U(neg_ind),'ro'); set(gca,'nextplot','add');
        plot(x(~neg_ind),U(~neg_ind),'ko'); set(gca,'nextplot','replacechildren'); drawnow;
    end
end