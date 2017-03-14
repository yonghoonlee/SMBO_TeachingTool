%==========================================================================
% A modular code for teaching Surrogate Modeling-Based Optimization
% Author: Yong Hoon Lee (ylee196@illinois.edu)
%==========================================================================
% Main Script
%==========================================================================

clear; clc; close all;

%=== BEGIN: IGNORE THIS BOX IF VISUALIZATION IS NOT YOUR CONCERN ==========
fprintf('Iter        xopt(1)        xopt(2)           fopt\n')
fg1 = figure('Color',[1 1 1]);
set(fg1,'Position',[5 200 1600 400]);
fh1 = axes; set(fh1,'Position',[0.03 0.15 0.16 0.75]);
fh2 = axes; set(fh2,'Position',[0.23 0.15 0.16 0.75]);
fh3 = axes; set(fh3,'Position',[0.43 0.15 0.16 0.75]);
fh4 = axes; set(fh4,'Position',[0.63 0.15 0.16 0.75]);
fh5 = axes; set(fh5,'Position',[0.83 0.15 0.16 0.75]);
%=== END: IGNORE THIS BOX IF VISUALIZATION IS NOT YOUR CONCERN ============

% User defined settings and parameters
prob = 'McCormickFn';  % Problem directory name
maxiter = 50;               % Number of maximum iteration
n_sample_g = 4;             % Number of global samples per each iteration
n_sample_l = 4;             % Number of local samples per each iteration
f_shk_g = 0.95;             % Shrink factor for global sample range
f_shk_l = 1;                % Initial shrink factor for local sample range
m.sampling = 'LHS';         % Sampling method: LHS, FF, Random, User
m.surrogate = 'TPS-RBF';    % Surrogate modeling method: PRS, TPS-RBF, User
opt = optimoptions('ga');   % Genetic algorithm is used for minimization
opt.Display = 'none';       % No display after GA run
opt.UseVectorized = true;   % Vectorized evaluation on the surrogate model

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

% Assumption of solution for sample distribution
xrange = (pc.ub - pc.lb)/2; % Half of the design space
xopt = pc.lb + xrange;      % Middle point between lower & upper bounds
xtrue = pc.xtrue;
ftrue = pc.ftrue;

% Iteration number
k = 1;

%=== BEGIN: IGNORE THIS BOX IF VISUALIZATION IS NOT YOUR CONCERN ==========
% Figures for plot (Plot only once before getting into the main loop)
axes(fh3);
xv = linspace(pc.lb(1),pc.ub(1),101);
yv = linspace(pc.lb(2),pc.ub(2),101);
[XMG,YMG] = meshgrid(xv,yv); ZMG = zeros(101,101);
for j = 1:101
    for i = 1:101
        ZMG(i,j) = objfn([XMG(i,j),YMG(i,j)]);
    end
end
contourf(XMG,YMG,ZMG,50); drawnow; hold on;
%=== END: IGNORE THIS BOX IF VISUALIZATION IS NOT YOUR CONCERN ============

% Loop for adaptive model refinement
while (k <= maxiter)
    % ==== SAMPLING IN DESIGN SPACE ====
    % Generating samples in [0,1] space
    switch(m.sampling)
        case 'LHS'          % Latin hypercube sampling
            xsmp01 = lhsdesign(n_sample_g, pc.nvar);
        case 'FF'           % Full factorial sampling
            xsmp01 = (fullfact(round(sqrt(n_sample_g))*ones(1,pc.nvar)) ...
                - 1)/(round(sqrt(n_sample_g)) - 1);
        case 'Random'       % Random sampling
            xsmp01 = rand(n_sample_g, pc.nvar);
        case 'User'         % User-defined sampling method
            % Please write your own sampling method here:
            % xsamp = ...
    end
    % Scaling samples to fill the space of exploration
    xsmp_g = 2*(xsmp01 - 0.5); % Scale samples from [0,1] to [-1,1] space
    xsmp_g = repmat(xopt,n_sample_g,1) + xsmp_g.*repmat(xrange,n_sample_g,1);
    % Enforce samples within bounds
    for i = 1:pc.nvar       % For each design variable
        xsampcol = xsmp_g(:,i);
        xsampcol(xsampcol>pc.ub(i)) = pc.ub(i); % Upper bound enforcement
        xsampcol(xsampcol<pc.lb(i)) = pc.lb(i); % Lower bound enforcement
        xsmp_g(:,i) = xsampcol; clear xsampcol;
    end
    % Save samples
    x_sample{k} = xsmp_g; clear xsamp;
    
    % ==== HIGH FIDELITY MODEL EVALUATION ====
    % Run objective function for each generated sample point
    f_hf{k} = zeros(n_sample_g,1);
    for i = 1:n_sample_g
        f_hf{k}(i) = feval(objfn,x_sample{k}(i,:));
    end
    
    % ==== SURROGATE MODELING-BASED OPTIMIZATION ====
    % Compiling known design points and high fidelity function results
    xsmp_g = []; fsmp = [];
    for i = 1:k
        xsmp_g = [xsmp_g; x_sample{i}];
        fsmp = [fsmp; f_hf{i}];
    end
    % Surrogate model construction and optimization run
    switch(m.surrogate)
        case 'PRS'              % Polynomial Regression Surface
        case 'TPS-RBF'          % Radial-Basis Function with TPS basis fn
            % Construct a RBF model using thin plate spline function
            [weight,center] = tps_rbf_construct(xsmp_g,fsmp);
            % Run GA-based optimization using the surrogate model
            [xopt,fopt] = ga(@(x)tps_rbf_objfn(x,weight,center),pc.nvar,...
                [],[],[],[],pc.lb,pc.ub,[],opt);
        case 'User'             % User-defined surrogate modeling method
            % Please write your own surrogate modeling method here:
    end
    % High fidelity solution for validation purpose
    f_hf_opt = objfn(xopt);
    
%=== BEGIN: IGNORE THIS BOX IF VISUALIZATION IS NOT YOUR CONCERN ==========
    % Plot samples
    axes(fh1);
    plot(x_sample{k}(:,1),x_sample{k}(:,2),'x'); hold on;
    % Plot contours of the constructed RBF model
    axes(fh2);
    xv = linspace(pc.lb(1),pc.ub(1),101);
    yv = linspace(pc.lb(2),pc.ub(2),101);
    [XMG,YMG] = meshgrid(xv,yv);
    ZMG = zeros(101,101);
    for j = 1:101
        ZMG(:,j) = tps_rbf_objfn([XMG(:,j),YMG(:,j)],weight,center);
    end
    contourf(XMG,YMG,ZMG,50); drawnow;
    % Plot optimal point
    axes(fh1);
    plot(xopt(1),xopt(2),'ok');
    if (k>1) plot([xoptold(1),xopt(1)],[xoptold(2),xopt(2)],'-k'); end;
    % Plot distance and error
    axes(fh4);
    semilogy(k,norm(xopt - xtrue),'ko'); hold on;
    axes(fh5);
    semilogy(k,norm(fopt - ftrue),'ko'); hold on;
    semilogy(k,norm(fopt - f_hf_opt),'kx'); hold on;
    % Plot labels
    axes(fh1);
    xlabel('x_1'); ylabel('x_2'); title('Solution and samples');
    axes(fh2);
    xlabel('x_1'); ylabel('x_2'); title('Predicted response');
    axes(fh3);
    xlabel('x_1'); ylabel('x_2'); title('True response');
    axes(fh4);
    xlabel('iteration'); ylabel('||x_p - x_t||');
    title('Distance to true solution');
    axes(fh5);
    xlabel('iteration'); ylabel('o: ||f_p - f_t||, x: ||f_p - f_h||');
    title('Error');
    % Display optimal result
    fprintf('%4d   ',k);
    fprintf('%12.4e   %12.4e   ',xopt);
    fprintf('%12.4e   \n',fopt);
%=== END: IGNORE THIS BOX IF VISUALIZATION IS NOT YOUR CONCERN ============
    
    % Next iteration
    xoptold = xopt;
    xrange = f_shk_g * xrange;  % Reduce sampling range with shrink factor
    k = k + 1;
    pause(1);
end