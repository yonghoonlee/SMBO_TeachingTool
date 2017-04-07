%==========================================================================
% A modular code for teaching Surrogate Modeling-Based Optimization
% Author: Yong Hoon Lee (ylee196@illinois.edu)
%==========================================================================
% Main Script for SMBO run
%==========================================================================


%% PREPARATION

clear; close all; rng(100);
restoredefaultpath; path(path,fullfile(pwd,'export_fig'));

% Problem to be solved
prob = 'ScaledGoldsteinPriceFn';          % PROBLEM DIRECTORY NAME
                            % Use one of following predefined problems:
                            %   prob = 'AckleyFn';
                            %   prob = 'McCormickFn';
                            %   prob = 'SphereFn';
                            %   prob = 'GoldsteinPriceFn';
                            %   prob = 'ScaledGoldsteinPriceFn';
                            % Or you can easily generate your own problem
                            % by creating a directory and put objective and
                            % configuration files: 'obj.m' & 'conf.m'

% User parameter
export_plot = true;         % Export plot file

% Surrogate model-based optimization options
maxiter = 20;               % Number of maximum iteration
n_smp = 4;                  % Number of samples per each iteration
m.sampling = 'LHS';         % Sampling method: LHS, FF, Random, User
m.surrogate = 'TPS-RBF';    % Surrogate modeling method: TPS-RBF, User
opt = optimoptions('ga');   % Genetic algorithm is used for minimization
opt.Display = 'none';       % No display after GA run
opt.UseVectorized = true;   % Vectorized evaluation on the surrogate model

% Gradient-based optimization options (for comparison)
optfminunc = optimoptions('fminunc');
optfminunc.Display = 'none';
optfminunc.FiniteDifferenceType = 'central';
optfminunc.OptimalityTolerance = 1e-9;
optfminunc.StepTolerance = 1e-9;
optfminunc.MaxIterations = maxiter*n_smp;

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
xrange = (pc.ub - pc.lb)/2; % Half of the design space
x0 = pc.lb + xrange;        % Middle point between lower & upper bounds
xopt = x0;                  % First guess is equivalent to the init value

% Retrieve trues soltuion for comparison
xtrue = pc.xtrue;           % True solution in x (design var)
ftrue = pc.ftrue;           % True solution in f (objective function var)


%% SURROGATE MODELING-BASED OPTIMIZATION

%=== BEGIN: IGNORE THIS BOX IF VISUALIZATION IS NOT YOUR CONCERN ==========
    outputfn_00;            % Command window output for printing header
    plotfn_00;              % Plot preparation
    plotfn_10;              % Plot true solution
%=== END: IGNORE THIS BOX IF VISUALIZATION IS NOT YOUR CONCERN ============

% Loop for adaptive model refinement
k = 1;                      % Iteration number
while (k <= maxiter)
    % ==== SAMPLING IN DESIGN SPACE ====
    % Generating samples in [0,1] space
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
            % xsamp = ...
    end
    % Scaling samples to fill the space of exploration
    xs_g = 2*(xsmp01 - 0.5); % Scale samples from [0,1] to [-1,1] space
    xs_g = repmat(xopt,n_smp,1) + xs_g.*repmat(xrange,n_smp,1);
    % Enforce samples within bounds
    for i = 1:pc.nvar       % For each design variable
        xsampcol = xs_g(:,i);
        xsampcol(xsampcol>pc.ub(i)) = pc.ub(i); % Upper bound enforcement
        xsampcol(xsampcol<pc.lb(i)) = pc.lb(i); % Lower bound enforcement
        xs_g(:,i) = xsampcol; clear xsampcol;
    end
    % Save samples
    x_sample{k} = xs_g; clear xsamp;
    
    % ==== HIGH FIDELITY MODEL EVALUATION ====
    % Run objective function for each generated sample point
    f_hf{k} = zeros(n_smp,1);
    for i = 1:n_smp
        f_hf{k}(i) = feval(objfn,x_sample{k}(i,:));
    end
    
    % ==== SURROGATE MODELING-BASED OPTIMIZATION ====
    % Compiling known design points and high fidelity function results
    xs_g = []; fsmp = [];
    for i = 1:k
        xs_g = [xs_g; x_sample{i}];
        fsmp = [fsmp; f_hf{i}];
    end
    % Surrogate model construction and optimization run
    switch(m.surrogate)
        case 'TPS-RBF'      % Radial-Basis Function with TPS basis fn
            % Construct a RBF model using thin plate spline function
            [weight,center] = tps_rbf_construct(xs_g,fsmp);
            % Run GA-based optimization using the surrogate model
            [xopt,fopt] = ga(@(x)tps_rbf_objfn(x,weight,center),pc.nvar,...
                [],[],[],[],pc.lb,pc.ub,[],opt);
        case 'User'         % User-defined surrogate modeling method
            % Please write your own surrogate modeling method here:
    end
    % High fidelity solution for validation purpose
    f_hf_opt = objfn(xopt);
    
%=== BEGIN: IGNORE THIS BOX IF VISUALIZATION IS NOT YOUR CONCERN ==========
    % Command window output
    outputfn_10;            % Command window output per each iteration
    plotfn_20;              % Plot per each iteration
    plotfn_exp10;           % Export plot
%=== END: IGNORE THIS BOX IF VISUALIZATION IS NOT YOUR CONCERN ============
    
    % Next iteration
    xoptold = xopt;
    xrange = pc.fs_g * xrange; % Reduce sampling range with shrink factor
    k = k + 1;
end


%% GRADIENT-BASED OPTIMIZATION FOR COMPARISON

[xoptfminunc,foptfminunc,exfminunc,outpfminunc] ...
    = fminunc(@(x)objfn(x),x0,optfminunc);
distfminunc = norm(xoptfminunc - xtrue);
errfminunc = norm(foptfminunc - ftrue);

%=== BEGIN: IGNORE THIS BOX IF VISUALIZATION IS NOT YOUR CONCERN ==========
    outputfn_20;            % Command window output for fminunc
    plotfn_30;
    plotfn_exp20;
%=== END: IGNORE THIS BOX IF VISUALIZATION IS NOT YOUR CONCERN ============


