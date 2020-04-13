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
fprintf('       %12.4e   %12.4e   ',xoptfmincon0);
fprintf('%12.4e   %12d   ',foptfmincon0,outpfmincon0.funcCount);
fprintf('%12.4e   %12.4e   \n',distfmincon0,errfmincon0);
fprintf('       %12.4e   %12.4e   ',xoptfmincon1);
fprintf('%12.4e   %12d   ',foptfmincon1,outpfmincon1.funcCount);
fprintf('%12.4e   %12.4e   \n',distfmincon1,errfmincon1);
fprintf('       %12.4e   %12.4e   ',xoptfmincon2);
fprintf('%12.4e   %12d   ',foptfmincon2,outpfmincon2.funcCount);
fprintf('%12.4e   %12.4e   \n',distfmincon2,errfmincon2);
