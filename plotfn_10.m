%==========================================================================
% A modular code for teaching Surrogate Modeling-Based Optimization
% Author: Yong Hoon Lee (ylee196@illinois.edu)
%==========================================================================
% PlotFN_10 Script
%==========================================================================

axes(fh3);
xv = linspace(pc.lb(1),pc.ub(1),101);
yv = linspace(pc.lb(2),pc.ub(2),101);
[XMG,YMG] = meshgrid(xv,yv); ZMG = zeros(101,101);
for j = 1:101
    for i = 1:101
        ZMG(i,j) = objfn([XMG(i,j),YMG(i,j)]);
    end
end
[~,ctrtrue] = contourf(XMG,YMG,ZMG,50); hold on;
plot(pc.xtrue(1),pc.xtrue(2),'o','MarkerFaceColor',[1 1 1],'Color','none');
cbartrue = colorbar('east');
set(cbartrue,'Position',[0.56,0.2,0.01,0.25]);
set(cbartrue,'Color',[1 1 1]);
drawnow;
%ctrlvl = get(ctrtrue,'LevelList');
axis([pc.lb(1),pc.ub(1),pc.lb(2),pc.ub(2)]);