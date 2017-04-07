%==========================================================================
% A modular code for teaching Surrogate Modeling-Based Optimization
% Author: Yong Hoon Lee (ylee196@illinois.edu)
%==========================================================================
% PlotFN_30 Script
%==========================================================================

axes(fh4);
pl42 = plot([0,maxiter],[distfminunc1,distfminunc1],'r-');
pl425 = plot(outpfminunc1.funcCount/n_smp,distfminunc1,'rx');
pl43 = plot([0,maxiter],[distfminunc2,distfminunc2],'b--');
legend([pl41,pl42,pl43],{'$||x_{\mathrm{predicted}} - x_{\mathrm{true}}||$',...
    '$||x_{\mathrm{fminunc1}} - x_{\mathrm{true}}||$',...
    '$||x_{\mathrm{fminunc2}} - x_{\mathrm{true}}||$'},...
    'Interpreter','latex','FontSize',10,'Location','northoutside');

axes(fh5);
pl53 = plot([0,maxiter],[errfminunc1,errfminunc1],'r-');
pl535 = plot(outpfminunc1.funcCount/n_smp,errfminunc1,'rx');
pl54 = plot([0,maxiter],[errfminunc1,errfminunc1],'b--');
legend([pl51,pl52,pl53,pl54],{'$||f_{\mathrm{predicted}} - f_{\mathrm{true}}||$',...
    '$||f_{\mathrm{predicted}} - f_{\mathrm{hi-fi\; fn}}||$',...
    ['$||f_{\mathrm{fminunc,',num2str(outpfminunc1.funcCount),'}} - f_{\mathrm{true}}||$'],...
    ['$||f_{\mathrm{fminunc,',num2str(outpfminunc2.funcCount),'}} - f_{\mathrm{true}}||$']},...
    'Interpreter','latex','FontSize',10,'Location','northoutside');

