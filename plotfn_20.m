%==========================================================================
% A modular code for teaching Surrogate Modeling-Based Optimization
% Author: Yong Hoon Lee (ylee196@illinois.edu)
%==========================================================================
% PlotFN_20 Script
%==========================================================================

% Plot samples
axes(fh1);
pl11 = plot(x_sample{k}(:,1),x_sample{k}(:,2),'x'); hold on;
% Plot contours of the constructed RBF model
axes(fh2);
hold off;
xv = linspace(pc.lb(1),pc.ub(1),101);
yv = linspace(pc.lb(2),pc.ub(2),101);
[XMG,YMG] = meshgrid(xv,yv);
ZMG = zeros(101,101);
for j = 1:101
    ZMG(:,j) = tps_rbf_objfn([XMG(:,j),YMG(:,j)],weight,center);
end
[~,ctrpred] = contourf(XMG,YMG,ZMG,50); hold on;
plot(xopt(1),xopt(2),'o','MarkerFaceColor',[1 1 1],'Color','none');
%set(ctrpred,'LevelList',ctrlvl);
cbarpred = colorbar('east');
set(cbarpred,'Position',[0.36,0.2,0.01,0.25]);
set(cbarpred,'Color',[1 1 1]);
% Plot optimal point
axes(fh1);
pl12 = plot(xopt(1),xopt(2),'ok');
if (k>1) plot([xoptold(1),xopt(1)],[xoptold(2),xopt(2)],'-k'); end;
% Plot distance and error
axes(fh4);
pl41 = semilogy(k,norm(xopt - xtrue),'ko'); hold on;
axes(fh5);
pl51 = semilogy(k,norm(fopt - ftrue),'ko'); hold on;
pl52 = semilogy(k,norm(fopt - f_hf_opt),'kx'); hold on;
% Plot labels and legends
axes(fh1);
xlabel('$x_1$','Interpreter','latex','FontSize',12);
ylabel('$x_2$','Interpreter','latex','FontSize',12);
title('Predicted solution trajectory','Interpreter','latex','FontSize',12);
legend([pl11,pl12],{['Samples (',num2str(size(fsmp,1)),' generated)'],...
    'Predicted solution'},...
    'Interpreter','latex','FontSize',12);
axis([pc.lb(1),pc.ub(1),pc.lb(2),pc.ub(2)]);
axes(fh2);
xlabel('$x_1$','Interpreter','latex','FontSize',12);
ylabel('$x_2$','Interpreter','latex','FontSize',12);
title('Predicted response','Interpreter','latex','FontSize',12);
axis([pc.lb(1),pc.ub(1),pc.lb(2),pc.ub(2)]);
axes(fh3);
xlabel('$x_1$','Interpreter','latex','FontSize',12);
ylabel('$x_2$','Interpreter','latex','FontSize',12);
title('True response','Interpreter','latex','FontSize',12);
axis([pc.lb(1),pc.ub(1),pc.lb(2),pc.ub(2)]);
axes(fh4);
xlabel('iteration','Interpreter','latex','FontSize',12);
ylabel('distance','Interpreter','latex','FontSize',12);
legend([pl41],{'$||x_{\mathrm{predicted}} - x_{\mathrm{true}}||$'},...
    'Interpreter','latex','FontSize',12);
title('Distance to true solution','Interpreter','latex','FontSize',12);
axes(fh5);
xlabel('iteration','Interpreter','latex','FontSize',12);
ylabel('error','Interpreter','latex','FontSize',12);
legend([pl51,pl52],{'$||x_{\mathrm{predicted}} - x_{\mathrm{true}}||$',...
    '$||x_{\mathrm{predicted}} - x_{\mathrm{hi-fi\; fn}}||$'},...
    'Interpreter','latex','FontSize',12);
title('Error','Interpreter','latex','FontSize',12);