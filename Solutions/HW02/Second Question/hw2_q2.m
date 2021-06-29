clear;clc;

which_matrix = "medium"; %while the code should work for large matrix, matlab
if which_matrix == "medium" %gives an error while creating the matrix, as it
    load('matrix_medium.mat'); %would take too much space.
elseif which_matrix=="large"
    load("matrix_large.mat");
end
row = linsys.row;
col = linsys.col; 
val = linsys.val;
b   = linsys.b;

size = size(row);
max_row = max(row);
max_col = max(col);
A_ = zeros(max_row,max_col);
for i=1:size
   A_(row(i),col(i)) = val(i); 
end
 
A=sparse(A_);  %matlab requires matrix A to be in sparse matrix format for some of the later codes

non_zero = nnz(A);
disp("Number of nonzeros in A is " + non_zero);
p = amd(A);
spy(A);
title("Sparsity structure of matrix A");

[L,U] = lu(A(p,p));
if which_matrix == "medium"
    figure
    spy(L);
    title("Sparsity structure of lower triangular matrix (L)");
    figure
    spy(U);
    title("Sparsity structure of upper triangular matrix (U)");
end

SPD = false;
if issymmetric(A)               %A is symmetric, this is a requirement for the 'chol' function which is used later
    disp('A is symmetric');
    try chol(A);                                            %this code is taken from
        disp('Matrix is symmetric positive definite.')      %MATLAB's site. it checks
        SPD = true;                                         %for SPD. because it throws
    catch ME                                                %an exception if its not SPD,
        disp('Matrix is not symmetric positive definite')   %there is a try-catch                                                 
    end
else
    disp('A is not symmetric')
end

if SPD == true
    R = chol(A);
    if which_matrix == "medium"
        figure
        spy(R)
        title("Sparsity structure of R");
        
        figure
        Rinc = ichol(A,struct('type','nofill'));
        spy(Rinc)
        title("Sparsity structure of incomplete Cholesky factorization (Rinc)");
    end
    
    M = Rinc'*Rinc;
    exact_solution = b\A;
    t0 = cputime;
    [sol1,~,~,it1,rn1] = pcg(A,b,1e-06,150);     %here, for some methods
    t1 = cputime;                                %default 100 iteration limit
    [sol2,~,~,it2,rn2] = pcg(A,b,1e-06,150,M);   %was not enough for convergence.
    t2 = cputime;                                %To make each method converge
    [sol3,~,~,it3,rn3] = minres(A,b,1e-06,150);  %the iteration limit was changed
    t3 = cputime;                                %to 150. the tolerance was not
    [sol4,~,~,it4,rn4] = minres(A,b,1e-06,150,M);%changed as it was not required
    t4 = cputime;
    disp("calculating errors, this takes some time")
    err1 = norm(exact_solution - sol1)/norm(exact_solution);
    err2 = norm(exact_solution - sol2)/norm(exact_solution);
    err3 = norm(exact_solution - sol3)/norm(exact_solution);
    err4 = norm(exact_solution - sol4)/norm(exact_solution);
    
    Names = {'Conjugate Gradient without preconditioning';'Preconditioned Conjugate Gradient, preconditioned with M';...
        'MINRES without preconditioning';'MINRES, preconditioned with M'};
    Times = [t1-t0;t2-t1;t3-t2;t4-t3];
    Iterations = [it1;it2;it3;it4];
    Errors = [err1;err2;err3;err4];
    T = table(Names,Times,Iterations,Errors);
    disp(T);
    
    figure
    semilogy(0:length(rn1)-1,rn1,'-o') %because the difference between later
    hold on                            %iterations would be small, y axis
    semilogy(0:length(rn2)-1,rn2,'-o') %was used in terms of log
    semilogy(0:length(rn3)-1,rn3,'-o')
    semilogy(0:length(rn4)-1,rn4,'-o')
    legend('Conjugate Gradient without preconditioning','Preconditioned Conjugate Gradient, preconditioned with M',...
        'MINRES without preconditioning','MINRES, preconditioned with M','Location','NorthEast')
    xlabel('Iteration number')
    ylabel('Residual Vector Norm')
end
