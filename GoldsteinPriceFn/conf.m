%==========================================================================
% A modular code for teaching Surrogate Modeling-Based Optimization
% Author: Yong Hoon Lee (ylee196@illinois.edu)
%==========================================================================
% Problem Configuration Function for the Goldstein Price Function Problem
%==========================================================================
%
% pc = CONF()
%   pc: Structured Data Containing Problem Configurations

function pc = conf()
    pc.nvar = 2;                % Number of variables
    pc.lb = [-2,-2];            % Lower bounds
    pc.ub = [2,2];              % Upper bounds
    pc.fs_g = 0.97;             % Shrink factor for global sample range
    pc.xtrue = [0,-1];          % True soltuion in x (for comparison)
    pc.ftrue = 3;               % True solution in f (for comparison)
end