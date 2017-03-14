%==========================================================================
% A modular code for teaching Surrogate Modeling-Based Optimization
% Author: Yong Hoon Lee (ylee196@illinois.edu)
%==========================================================================
% Objective Function for the Goldstein Price Function Problem
%==========================================================================
% Known Solution is: f([0,-1]) = 3
%==========================================================================
%
% f = OBJ(x)
%   f: Objective Function Value
%   x: Design Variables

function f = obj(x)
    f = (1 + (x(1) + x(2) + 1)^2 ...
        * (19 - 14*x(1) + 3*x(1)^2 - 14*x(2) + 6*x(1)*x(2) + 3*x(2)^2)) ...
        * (30 + (2*x(1) - 3*x(2))^2 ...
        * (18 - 32*x(1) + 12*x(1)^2 + 48*x(2) - 36*x(1)*x(2) + 27*x(2)^2));
end