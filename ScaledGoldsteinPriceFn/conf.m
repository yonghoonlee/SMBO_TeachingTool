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
    pc.nvar = 2;
    pc.lb = [-2,-2];
    pc.ub = [2,2];
    pc.xtrue = [0,-1];
    pc.ftrue = log(3);
end