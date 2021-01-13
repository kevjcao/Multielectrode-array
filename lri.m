function [LRI_histo] = lri(unit_PI, BW2)
%% Function to create an LRI histogram (e.g. abs(PI)
% LRIdata = 0;                                                              % if 1 = return an array of LRI histogram data for exporting

unit_LRI = abs(unit_PI);

LRI_histo = figure(5);

hold on;
unitPI_histoplot = histogram(unit_LRI, 'BinWidth', BW2);
xlim([0 1]);
xlabel('Light response index, LRI');
ylabel('No. events');
% xl2 = xline (0, ':', 'LineWidth', 1.5);
set(gca, 'TickDir', 'out');
hold off;

% [N_histLRI, edge_histLRI] = histcounts(unit_LRI, 'BinWidth', BW2);
% bin_centersLRI = edge_histLRI(1:end-1) + diff(edge_histLRI)/2;
% if LRIdata == 1
%     LRI_histcount = [bin_centersLRI.', N_histLRI.'];
% else
% end

end