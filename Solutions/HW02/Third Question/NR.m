function Q1

clear;  clc;
X0 = [0.5; 0.5; 0.5];

% Newon-Rapshon method %
err_rel_res = 0.001;
err_abs_res = 0.003;
err_abs_inc = 0.0035;

Nmax = 1000;

X = X0;
hist = [];

for k = 1:Nmax
    delta = -j_func(X)\f_func(X);
    
    % X_k+1 = X_k + delta %
    X1 = X + delta;
    hist = [hist, norm(f_func(X))];
    
    if (norm(f_func(X1)) <= err_rel_res * norm(f_func(X0))) || (norm(f_func(X1)) <= err_abs_res && norm(X1 - X) <= err_abs_inc)
        break;
    end
    
    X = X1;
end
solver = X;
fprintf('Newton-Raphson method solver : \n');
disp(solver);


fprintf('\nthe number of nonlinear iterations required for convergence, k = %d \n', k);
fprintf('the residual norm at convergence, ||R(x_k)|| = %d\n', norm(f_func(solver)));
fprintf('the number of Jacobian computations required = %d\n', k);
fprintf('the residual norm convergence history : ');   disp(hist);


% modified Newon-Rapshon method %
X = X0;
for k = 0:Nmax
    delta = -j_func(X)\f_func(X);
    
    % X_k+1 = X_k + delta %
    X1 = X + delta;
    if (norm(f_func(X1)) <= err_rel_res * norm(f_func(X0))) || (norm(f_func(X1)) <= err_abs_res && norm(X1 - X) <= err_abs_inc)
        if norm(f_func(X1)) > 0.1 * norm(f_func(X))
            break;
        end
    end
    
    X = X1;
end

solver = X;
fprintf('\nModified Newton-Raphson method solver : \n');
disp(solver);




%%%% R %%%%
function F = f_func(X)
    x = X(1);  y = X(2);   z = X(3);
 
    f1 = x ^ 2 - sin(y) + 0.5 * cos(z) - 0.5;
    f2 = 3 * x - cos(y) + sin(z);
    f3 = x ^ 2 + y ^ 2 + z ^ 2 - 0.95;
 
    F = [f1;f2;f3];
end

%%% Jacobian %%%
function J = j_func(X)
x = X(1);   y = X(2);   z = X(3);
J = [2*x, -cos(y), -0.5*sin(z); 3, sin(y), cos(z); 2*x, 2*y, 2*z];
end

%Q1 end%
end