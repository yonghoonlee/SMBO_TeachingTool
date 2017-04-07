%==========================================================================
% A modular code for teaching Surrogate Modeling-Based Optimization
% Author: Yong Hoon Lee (ylee196@illinois.edu)
%==========================================================================
% Objective Function for the Rosenbrock Banana Function Problem
%==========================================================================
% Known Solution is: f([a,a^2]) = 0
%==========================================================================
%
% f = OBJ(x)
%   f: Objective Function Value
%   x: Design Variables

function f = obj(x)
    a = 1;
    b = 100;
    f = (a-x(:,1)).^2 + b*(x(:,2)-x(:,1).^2).^2;
end