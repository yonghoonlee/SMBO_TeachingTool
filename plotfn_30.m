%==========================================================================
% A modular code for teaching Surrogate Modeling-Based Optimization
% Author: Yong Hoon Lee (ylee196@illinois.edu)
%==========================================================================
% PlotFN_30 Script
%==========================================================================

axes(fh4);
pl421 = plot([0,maxiter],[distfminunc0,distfminunc0],'k--');
pl422 = plot((outpfminunc0.funcCount+1)/(n_smp+1),distfminunc0,'kh','MarkerFaceColor',[0 0 0]);
pl423 = plot([0,maxiter],[distfminunc1,distfminunc1],'r--');
pl424 = plot((outpfminunc1.funcCount+1)/(n_smp+1),distfminunc1,'rh','MarkerFaceColor',[1 0 0]);
pl425 = plot([0,maxiter],[distfminunc2,distfminunc2],'b--');
pl426 = plot((outpfminunc2.funcCount+1)/(n_smp+1),distfminunc2,'bh','MarkerFaceColor',[0 0 1]);
legend([pl41,pl421,pl423,pl425],{'$||x_{\mathrm{predicted}} - x_{\mathrm{true}}||$',...
    ['$||x_{\mathrm{fminunc',num2str(outpfminunc0.funcCount),'}} - x_{\mathrm{true}}||$'],...
    ['$||x_{\mathrm{fminunc',num2str(outpfminunc1.funcCount),'}} - x_{\mathrm{true}}||$'],...
    ['$||x_{\mathrm{fminunc',num2str(outpfminunc2.funcCount),'}} - x_{\mathrm{true}}||$']},...
    'Interpreter','latex','FontSize',14,'Location','northoutside');

axes(fh5);
pl531 = plot([0,maxiter],[errfminunc0,errfminunc0],'k--');
pl532 = plot((outpfminunc0.funcCount+1)/(n_smp+1),errfminunc0,'kh','MarkerFaceColor',[0 0 0]);
pl533 = plot([0,maxiter],[errfminunc1,errfminunc1],'r--');
pl534 = plot((outpfminunc1.funcCount+1)/(n_smp+1),errfminunc1,'rh','MarkerFaceColor',[1 0 0]);
pl535 = plot([0,maxiter],[errfminunc2,errfminunc2],'b--');
pl536 = plot((outpfminunc2.funcCount+1)/(n_smp+1),errfminunc2,'bh','MarkerFaceColor',[0 0 1]);
legend([pl51,pl52,pl531,pl533,pl535],{'$||f_{\mathrm{predicted}} - f_{\mathrm{true}}||$',...
    '$||f_{\mathrm{predicted}} - f_{\mathrm{hi-fi\; fn}}||$',...
    ['$||f_{\mathrm{fminunc,',num2str(outpfminunc0.funcCount),'}} - f_{\mathrm{true}}||$'],...
    ['$||f_{\mathrm{fminunc,',num2str(outpfminunc1.funcCount),'}} - f_{\mathrm{true}}||$'],...
    ['$||f_{\mathrm{fminunc,',num2str(outpfminunc2.funcCount),'}} - f_{\mathrm{true}}||$']},...
    'Interpreter','latex','FontSize',14,'Location','northoutside');

