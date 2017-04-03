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
    pc.nvar = 2;
    pc.lb = [-1.5,-3];
    pc.ub = [4,4];
    pc.xtrue = [-0.547197612064673  -1.547197544523366];
    pc.ftrue = -1.913222954981030;
end