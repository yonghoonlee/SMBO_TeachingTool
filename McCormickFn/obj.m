%==========================================================================
% A modular code for teaching Surrogate Modeling-Based Optimization
% Author: Yong Hoon Lee (ylee196@illinois.edu)
%==========================================================================
% Objective Function for the McCormick Function Problem
%==========================================================================
% Known Solution is:
%   f([-0.547197612064673,-1.547197544523366]) = -1.913222954981030
%==========================================================================
%
% f = OBJ(x)
%   f: Objective Function Value
%   x: Design Variables

function f = obj(x)
    f = sin(x(1) + x(2)) + (x(1) - x(2))^2 - 1.5*x(1) + 2.5*x(2) + 1;
end