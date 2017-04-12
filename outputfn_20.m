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
fprintf('       %12.4e   %12.4e   ',xoptfminunc0);
fprintf('%12.4e   %12d   ',foptfminunc0,outpfminunc0.funcCount);
fprintf('%12.4e   %12.4e   \n',distfminunc0,errfminunc0);
fprintf('       %12.4e   %12.4e   ',xoptfminunc1);
fprintf('%12.4e   %12d   ',foptfminunc1,outpfminunc1.funcCount);
fprintf('%12.4e   %12.4e   \n',distfminunc1,errfminunc1);
fprintf('       %12.4e   %12.4e   ',xoptfminunc2);
fprintf('%12.4e   %12d   ',foptfminunc2,outpfminunc2.funcCount);
fprintf('%12.4e   %12.4e   \n',distfminunc2,errfminunc2);
