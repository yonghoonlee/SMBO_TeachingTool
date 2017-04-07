%==========================================================================
% A modular code for teaching Surrogate Modeling-Based Optimization
% Author: Yong Hoon Lee (ylee196@illinois.edu)
%==========================================================================
% PlotFN_30 Script
%==========================================================================

axes(fh4);
pl42 = plot([0,maxiter],[distfminunc,distfminunc],'r-');
legend([pl41,pl42],{'$||x_{\mathrm{predicted}} - x_{\mathrm{true}}||$',...
    '$||x_{\mathrm{fminunc}} - x_{\mathrm{true}}||$'},...
    'Interpreter','latex','FontSize',10,'Location','northoutside');

axes(fh5);
pl53 = plot([0,maxiter],[errfminunc,errfminunc],'r-');
legend([pl51,pl52,pl53],{'$||x_{\mathrm{predicted}} - x_{\mathrm{true}}||$',...
    '$||x_{\mathrm{predicted}} - x_{\mathrm{hi-fi\; fn}}||$',...
    '$||x_{\mathrm{fminunc}} - x_{\mathrm{true}}||$'},...
    'Interpreter','latex','FontSize',10,'Location','northoutside');

