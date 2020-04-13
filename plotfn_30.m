%==========================================================================
% A modular code for teaching Surrogate Modeling-Based Optimization
% Author: Yong Hoon Lee (ylee196@illinois.edu)
%==========================================================================
% PlotFN_30 Script
%==========================================================================

axes(fh4);
pl421 = plot([0,maxiter],[distfmincon0,distfmincon0],'k--');
pl422 = plot((outpfmincon0.funcCount+1)/(n_smp+1),distfmincon0,'kh','MarkerFaceColor',[0 0 0]);
pl423 = plot([0,maxiter],[distfmincon1,distfmincon1],'r--');
pl424 = plot((outpfmincon1.funcCount+1)/(n_smp+1),distfmincon1,'rh','MarkerFaceColor',[1 0 0]);
pl425 = plot([0,maxiter],[distfmincon2,distfmincon2],'b--');
pl426 = plot((outpfmincon2.funcCount+1)/(n_smp+1),distfmincon2,'bh','MarkerFaceColor',[0 0 1]);
legend([pl41,pl421,pl423,pl425],{'$||x_{\mathrm{predicted}} - x_{\mathrm{true}}||$',...
    ['$||x_{\mathrm{fmincon',num2str(outpfmincon0.funcCount),'}} - x_{\mathrm{true}}||$'],...
    ['$||x_{\mathrm{fmincon',num2str(outpfmincon1.funcCount),'}} - x_{\mathrm{true}}||$'],...
    ['$||x_{\mathrm{fmincon',num2str(outpfmincon2.funcCount),'}} - x_{\mathrm{true}}||$']},...
    'Interpreter','latex','FontSize',14,'Location','northoutside');

axes(fh5);
pl531 = plot([0,maxiter],[errfmincon0,errfmincon0],'k--');
pl532 = plot((outpfmincon0.funcCount+1)/(n_smp+1),errfmincon0,'kh','MarkerFaceColor',[0 0 0]);
pl533 = plot([0,maxiter],[errfmincon1,errfmincon1],'r--');
pl534 = plot((outpfmincon1.funcCount+1)/(n_smp+1),errfmincon1,'rh','MarkerFaceColor',[1 0 0]);
pl535 = plot([0,maxiter],[errfmincon2,errfmincon2],'b--');
pl536 = plot((outpfmincon2.funcCount+1)/(n_smp+1),errfmincon2,'bh','MarkerFaceColor',[0 0 1]);
legend([pl51,pl52,pl531,pl533,pl535],{'$||f_{\mathrm{predicted}} - f_{\mathrm{true}}||$',...
    '$||f_{\mathrm{predicted}} - f_{\mathrm{hi-fi\; fn}}||$',...
    ['$||f_{\mathrm{fmincon,',num2str(outpfmincon0.funcCount),'}} - f_{\mathrm{true}}||$'],...
    ['$||f_{\mathrm{fmincon,',num2str(outpfmincon1.funcCount),'}} - f_{\mathrm{true}}||$'],...
    ['$||f_{\mathrm{fmincon,',num2str(outpfmincon2.funcCount),'}} - f_{\mathrm{true}}||$']},...
    'Interpreter','latex','FontSize',14,'Location','northoutside');

