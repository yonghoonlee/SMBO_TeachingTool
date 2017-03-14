%==========================================================================
% A modular code for teaching Surrogate Modeling-Based Optimization
% Author: Yong Hoon Lee (ylee196@illinois.edu)
%==========================================================================
% Objective Function for the Sphere Function Problem
%==========================================================================
% Known Solution is: f([0,0]) = 0
%==========================================================================
%
% f = OBJ(x)
%   f: Objective Function Value
%   x: Design Variables

function f = obj(x)
    f = sum(x.^2);
end