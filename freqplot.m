function [freq_plot] = freqplot(N, BW, EDGES, raw_units, Trigger, interv_times)
%% Calculating firing frequencies of the recording (e.g. fig 1 histogram normalized to # of units)

avg_firing = (N(1,:) / BW) / numel(raw_units);                              % [no. events / bin size (s) = frequency] / no. units = average firing frequency per unit
bin_centers = EDGES(1:end-1) + diff(EDGES)/2;

if Trigger == 0
    spikes = cell(numel(raw_units), 1);
    for m = 1:length(raw_units)
        spikes{m} = (numel(raw_units{m}(:,1)) / (length(EDGES) / 10));
    end
    spikefreq.avg = mean(cell2mat(spikes));
    spikefreq.std = std(cell2mat(spikes));
    fprintf('Average spiking frequency = %.2f +/- %.2f Hz \n', spikefreq.avg, spikefreq.std);
end

        
%% Create frequency raster (figure 4)

freq_plot = figure(4);
FreqPlot = bar(bin_centers, avg_firing, 'FaceColor', 'k', 'BarWidth', 1.5);
hold on;
if Trigger == 1
    for r = 1:length(interv_times)                                          % creates a shaded region for the light intervals
        stim_limits = interv_times(r,:);
        light_stim = [min(stim_limits) max(stim_limits) max(stim_limits) min(stim_limits)];
        patch(light_stim, [0 0 max(ylim)*[1 1]], [0.3010 0.7450 0.9330], 'LineStyle', 'none');
        hold on
    end
    FreqPlot = bar(bin_centers, avg_firing, 'FaceColor', 'k', 'BarWidth', 1.5);
    hold on
else
end

xlabel('Time (s)');
ylabel('Average firing frequency per unit (Hz)');
set(gca, 'TickDir', 'out');
hold off

end