%==========================================================================
% A modular code for teaching Surrogate Modeling-Based Optimization
% Author: Yong Hoon Lee (ylee196@illinois.edu)
%==========================================================================
% OutputFN_10 Script
%==========================================================================

dist = norm(xopt - xtrue);
err = norm(fopt - ftrue);
fprintf('%4d   ',k);
fprintf('%12.4e   %12.4e   ',xopt);
fprintf('%12.4e   %12d   ',fopt,size(fsmp,1));
fprintf('%12.4e   %12.4e   \n',dist,err);

