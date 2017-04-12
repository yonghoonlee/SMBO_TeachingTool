%==========================================================================
% A modular code for teaching Surrogate Modeling-Based Optimization
% Author: Yong Hoon Lee (ylee196@illinois.edu)
%==========================================================================
% Problem Configuration Function for the McCormick Function Problem
%==========================================================================
%
% pc = CONF()
%   pc: Structured Data Containing Problem Configurations

function pc = conf()
    pc.nvar = 2;                % Number of variables
    pc.lb = [-1.5,-3];          % Lower bounds
    pc.ub = [5.5,4];              % Upper bounds
    pc.fs_g = 0.8;              % Shrink factor for global sample range
    pc.xtrue = [-0.547197612064673,-1.547197544523366];
                                % True soltuion in x (for comparison)
    pc.ftrue = -1.913222954981030;
                                % True solution in f (for comparison)
end