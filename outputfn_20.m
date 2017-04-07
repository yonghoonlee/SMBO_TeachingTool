%==========================================================================
% A modular code for teaching Surrogate Modeling-Based Optimization
% Author: Yong Hoon Lee (ylee196@illinois.edu)
%==========================================================================
% OutputFN_20 Script
%==========================================================================

fprintf('==============================================================================================\n');
fprintf('                                  GRADIENT-BASED OPTIMIZATION                                 \n');
fprintf('----------------------------------------------------------------------------------------------\n');
fprintf('             xopt_1         xopt_2           fopt    func eval #       distance          error\n');
fprintf('       ------------   ------------   ------------   ------------   ------------   ------------\n');
fprintf('       %12.4e   %12.4e   ',xopt);
fprintf('%12.4e   %12d   ',foptfminunc,outpfminunc.funcCount);
fprintf('%12.4e   %12.4e   \n',distfminunc,errfminunc);
