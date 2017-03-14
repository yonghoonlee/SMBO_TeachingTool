%==========================================================================
% A modular code for teaching Surrogate Modeling-Based Optimization
% Author: Yong Hoon Lee (ylee196@illinois.edu)
%==========================================================================
% Surrogate Model Evaluation using RBF with TPS Basis Function
% RBF: Radial Basis Function, TPS: Thin-Plate Spline
%==========================================================================
%
% f = TPS_RBF_OBJFN(x,w,c)
%   f: Evaluated Objective Function Values
%   x: Evaluating Design Points
%   w: RBF Weights
%   c: RBF Centers

function f = tps_rbf_objfn(x,w,c)
    nx = size(x,1);         % Number of evaluating design points
    nc = size(c,1);         % Number of RBF centers (not equal to nx)
    phi = zeros(nx,nc);     % Allocate for Gram matrix
    for i = 1:nc
        % Radii (=distance) between i-th center and all evaluating points
        rad = sqrt(sum((repmat(c(i,:),nx,1) - x(:,:)).^2,2));
        phi(:,i) = rad.^2.*log(rad);    % thin-plate spline function
        phi(rad<eps,i) = 0;             % rad<eps: 2 points are identical
    end
    % Prediction of objective function value using RBF surrogate model
    f = phi*w;
end
