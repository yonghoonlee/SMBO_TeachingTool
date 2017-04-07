%==========================================================================
% A modular code for teaching Surrogate Modeling-Based Optimization
% Author: Yong Hoon Lee (ylee196@illinois.edu)
%==========================================================================
% Objective Function for the Ackley Function Problem
%==========================================================================
% Known Solution is: f([0,0]) = 0
%==========================================================================
%
% f = OBJ(x)
%   f: Objective Function Value
%   x: Design Variables

function f = obj(x)
    a = 20;
    b = 0.2;
    c = 2*pi;
    d = 2;
    f = -a*exp(-b*sqrt(1/d*sum(x.^2))) ...
        - exp(1/d*sum(cos(c*x))) + a + exp(1);
end