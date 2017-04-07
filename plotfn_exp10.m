%==========================================================================
% A modular code for teaching Surrogate Modeling-Based Optimization
% Author: Yong Hoon Lee (ylee196@illinois.edu)
%==========================================================================
% PlotFN_EXP10 Script
%==========================================================================

if (export_plot == true)
    % Exporting figure takes some time, so we do not pause here
    eval(['export_fig ',fullfile(probpath,'plot_'),num2str(k),...
        '.png -png -r300']);
else
    % Without exporting figure, we need to pause to see the change here
    pause(1); % To see the change in real time, pause 1 sec.
end