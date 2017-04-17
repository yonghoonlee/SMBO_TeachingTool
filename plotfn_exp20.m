%==========================================================================
% A modular code for teaching Surrogate Modeling-Based Optimization
% Author: Yong Hoon Lee (ylee196@illinois.edu)
%==========================================================================
% PlotFN_EXP20 Script
%==========================================================================

if (export_plot == true)
    % Exporting figure takes some time, so we do not pause here
    eval(['export_fig ',fullfile(probpath,'plot_final'),...
        '.png -png -r300']);
end