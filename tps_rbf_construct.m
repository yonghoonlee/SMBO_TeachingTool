%==========================================================================
% A modular code for teaching Surrogate Modeling-Based Optimization
% Author: Yong Hoon Lee (ylee196@illinois.edu)
%==========================================================================
% Surrogate Model Construction using RBF with TPS Basis Function
% RBF: Radial Basis Function, TPS: Thin-Plate Spline
%==========================================================================
%
% [w,c] = TPS_RBF_CONSTRUCT(x,f)
%   w: RBF Weights
%   c: RBF Centers
%   x: Known Design Points
%   f: Known Objective Function Values

function [w,c] = tps_rbf_construct(x,f)
    c = x;                              % Set RBF centers from known data
    nc = size(x,1);                     % Number of RBF centers
    phi = zeros(nc,nc);                 % Allocate for Gram matrix
    for i = 1:nc
        % Radii (=distance) between i-th point and the other points
        rad = sqrt(sum((repmat(x(i,:),nc,1) - x(:,:)).^2,2));
        % Thin-plate spline functions are computed for all radii
        phi(:,i) = rad.^2.*log(rad);    % thin-plate spline function
        phi(rad<eps,i) = 0;             % rad<eps: 2 points are identical
    end
    % RBF weight computation: weight = phi\fsamp (= pinv(phi)\f)
    w = pinv(phi)*f;
end
