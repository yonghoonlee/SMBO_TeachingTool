%==========================================================================
% A modular code for teaching Surrogate Modeling-Based Optimization
% Author: Yong Hoon Lee (ylee196@illinois.edu)
%==========================================================================
% Main Script for SMBO run
%==========================================================================


%% PREPARATION

clc; clear; close all; rng(100);
restoredefaultpath; path(path,fullfile(pwd,'export_fig'));

% Problem to be solved
prob = 'AckleyFn'; % PROBLEM DIRECTORY NAME
                            % Use one of following predefined problems:
                            % 1. prob = 'AckleyFn';
                            %       fminunc cannot converge to soln
                            %       while SMBO converges to the soln
                            % 2. prob = 'RosenbrockBananaFn';
                            %       fminunc demands many fn evaluations
                            %       and SMBO has difficulty in finding soln
                            % 3. prob = 'McCormickFn';
                            %       easy for both fminunc and SMBO
                            % 4. prob = 'McCormickDifferentRangeFn';
                            %       fminunc converges to local soln
                            %       while SMBO converges to global soln
                            % 5. prob = 'SphereFn';
                            %       SMBO converges faster in first few iter
                            %       and fminunc converges faster for later
                            % 6. prob = 'GoldsteinPriceFn';
                            %       SMBO has difficulty in finding soln
                            %       while fminunc is relatively efficient
                            % 7. prob = 'ScaledGoldsteinPriceFn';
                            %       fminunc converges to local soln
                            %       while SMBO converges to global soln
                            % Or you can easily generate your own problem
                            % by creating a directory and put objective and
                            % configuration files: 'obj.m' & 'conf.m'

% User parameter
export_plot = false;        % Export plot file
visualization_on = true;    % Set to true to turn on visualization 

% Surrogate model-based optimization options
maxiter = 20;               % Maximum number of iterations allowed
n_smp = 4;                  % Number of samples for each iteration
m.sampling = 'LHS';         % Sampling method: LHS, FF, Random, User
m.surrogate = 'TPS-RBF';    % Surrogate modeling method: TPS-RBF, User
opt = optimoptions('ga');   % Genetic algorithm is used for minimization
opt.Display = 'none';       % No display after GA run
opt.UseVectorized = true;   % Vectorized evaluation on the surrogate model

% Gradient-based optimization options (for comparison)
optfmincon = optimoptions('fmincon');
optfmincon.Display = 'none';
optfmincon.FiniteDifferenceType = 'central';
optfmincon.OptimalityTolerance = 1e-9;
optfmincon.StepTolerance = 1e-9;

% Save current (parent) directory and problem (sub) directory paths
currentpath = pwd;
probpath = fullfile(currentpath,prob);

% Get obj-fn handle from the problem path
cd(probpath);               % Enter the problem directory
objfn = str2func('obj');    % Obtain function handle for objective function
conffn = str2func('conf');  % Obtain function handle for configurations
cd(currentpath);            % Return to the root directory

% Problem configurations (number of variables, lower & upper bounds)
pc = feval(conffn);

% Assumption of solution (initial value) for sample distribution
xrange = (pc.ub - pc.lb)/2; % Half of the design space for each dimension
                            % These bounds are for specifying the design
                            % and modeling domain.
x0 = pc.lb + xrange;        % Midpoint between lower and upper bounds
xopt = x0;                  % First guess is equivalent to the init value

% Retrieve true solution for comparison
xtrue = pc.xtrue;           % True solution x (design var)
ftrue = pc.ftrue;           % True solution f(x) (objective function var)


%% SURROGATE MODELING-BASED OPTIMIZATION

if visualization_on
    outputfn_00;            % Command window output for printing header
    plotfn_00;              % Plot preparation
    plotfn_10;              % Plot true solution
end

% Adaptive surrogate model refinement loop
k = 1;                      % Iteration number
while (k <= maxiter)
    % ==== DESIGN SPACE SAMPLING ====
    % Generate samples in the range [0,1] (scaled space)
    switch(m.sampling)
        case 'LHS'          % Latin hypercube sampling
            xsmp01 = lhsdesign(n_smp, pc.nvar);
        case 'FF'           % Full factorial sampling
            xsmp01 = (fullfact(round(sqrt(n_smp))*ones(1,pc.nvar)) ...
                - 1)/(round(sqrt(n_smp)) - 1);
        case 'Random'       % Random sampling
            xsmp01 = rand(n_smp, pc.nvar);
        case 'User'         % User-defined sampling method
            % Please write your own sampling method here:
            % xsmp01 = ...
    end
    
    % Scale sample points to original design space range
    xs_g = 2*(xsmp01 - 0.5);    % Scale samples from [0,1] to [-1,1]
    xs_g = repmat(xopt,n_smp,1) + xs_g.*repmat(xrange,n_smp,1);
                                % Scale from [-1,1] to [lb,ub]
    % Ensure that samples lie within bounds
    for i = 1:pc.nvar       % Loop over each design variable
        xsampcol = xs_g(:,i);
        xsampcol(xsampcol>pc.ub(i)) = pc.ub(i); % Upper bound enforcement
        xsampcol(xsampcol<pc.lb(i)) = pc.lb(i); % Lower bound enforcement
        xs_g(:,i) = xsampcol; clear xsampcol;
    end
    % Save samples
    x_sample{k} = xs_g; clear xsmp01;
    
    % ==== HIGH FIDELITY MODEL EVALUATION ====
    % Execute original objective function calculation for each sample point
    f_hf{k} = zeros(n_smp,1);
    for i = 1:n_smp     % If objfn is computationally expensive, this is 
                        % the most computationally intensive step.
        f_hf{k}(i) = feval(objfn,x_sample{k}(i,:));
    end
    
    % ==== SURROGATE MODELING-BASED OPTIMIZATION ====
    % Compile design points (past and current samples) along with high
    % fidelity function results:
    xs_g = x_sample{1};     % For first iteration, we only have sample pts
    fsmp = f_hf{1};         % and its high fidelity function results
    if (k>1)
        for i = 2:k
            xs_g = [xs_g; x_sample{i}; xopt_history{i-1}];
            fsmp = [fsmp; f_hf{i}; f_hf_opt_history{i-1}];
        end
    end
    
    % Surrogate model construction and optimization run
    switch(m.surrogate)
        case 'TPS-RBF'      % Radial-Basis Function (Thin-Plate Spline)
            % Construct an RBF model using thin plate spline function
            [weight,center] = tps_rbf_construct(xs_g,fsmp);
            % Run GA-based optimization using the surrogate model
            [xopt,fopt] = ga(@(x)tps_rbf_objfn(x,weight,center),pc.nvar,...
                [],[],[],[],pc.lb,pc.ub,[],opt);
        case 'User'         % User-defined surrogate modeling method
            % Please write your own surrogate modeling-based optimization
            % method here:
            % [xopt,fopt] = ...
    end
    
    % Evaluate the high fidelity function to evaluate error at the
    % predicted optimum (model validation, only at solution):
    f_hf_opt = objfn(xopt);
    
    % Save the high fidelity function result at the predicted optimum
    xopt_history{k} = xopt;
    f_hf_opt_history{k} = f_hf_opt;
    
    if visualization_on
        outputfn_10;        % Command window output per each iteration
        plotfn_20;          % Plot per each iteration
        plotfn_exp10;       % Export plot
    end
    
    % Calculations for next iteration
    xrange = pc.fs_g * xrange;  % Reduce sampling range with a factor < 1
    k = k + 1;                  % Increment iteration number
end


%% GRADIENT-BASED OPTIMIZATION FOR COMPARISON

% Try with the half number of maximum function evaluations
optfmincon.MaxFunctionEvaluations = round((maxiter*(n_smp+1)-1)/4);
[xoptfmincon0,foptfmincon0,exfmincon0,outpfmincon0] ...
    = fmincon(@(x)objfn(x),x0,[],[],[],[],pc.lb,pc.ub,[],optfmincon);
distfmincon0 = norm(xoptfmincon0 - xtrue);
errfmincon0 = norm(foptfmincon0 - ftrue);

% Try with the same number of maximum function evaluations
optfmincon.MaxFunctionEvaluations = round((maxiter*(n_smp+1)-1)/2);
[xoptfmincon1,foptfmincon1,exfmincon1,outpfmincon1] ...
    = fmincon(@(x)objfn(x),x0,[],[],[],[],pc.lb,pc.ub,[],optfmincon);
distfmincon1 = norm(xoptfmincon1 - xtrue);
errfmincon1 = norm(foptfmincon1 - ftrue);

% Try with increased number of maximum function evaluations
optfmincon.MaxFunctionEvaluations = (maxiter*(n_smp+1)-1);
[xoptfmincon2,foptfmincon2,exfmincon2,outpfmincon2] ...
    = fmincon(@(x)objfn(x),x0,[],[],[],[],pc.lb,pc.ub,[],optfmincon);
distfmincon2 = norm(xoptfmincon2 - xtrue);
errfmincon2 = norm(foptfmincon2 - ftrue);

if visualization_on
    outputfn_20;            % Command window output for fminunc
    plotfn_30;
    plotfn_exp20;
end


