function [unit_PI, PI_histo] = spikefreq(units_sorted, interv_times, interv_duration, dark_time, BW2)
%% Function calculates the average PI of the recording
% first calculates the firing freq in light & dark and then the PI per unit

spikes_light = cell(numel(units_sorted), 1);
spikes_on = [];

freq_light = cell(numel(units_sorted), 1);
freq_on = [];

unitfreq_light = cell(numel(units_sorted), 1);
spikes_dark = cell(numel(units_sorted), 1);
unitfreq_dark = cell(numel(units_sorted), 1);

for m = 1:length(units_sorted)
    for r = 1:length(interv_times)
        spikes_on(r) = numel(units_sorted{m}(units_sorted{m}(:,1) >= interv_times(r,1) & units_sorted{m}(:,1) <= interv_times(r,2)));
        % spikes_on = spikes_on.';
        spikes_light{m} = spikes_on;                                        % calculates number of spikes that occur in each light-on interval for a particular unit
    end
end
for m = 1:length(units_sorted)
    for r = 1:length(interv_times)
        freq_on(r) = (spikes_light{m}(1,r) / interv_duration(1,r));
        % freq_on = freq_on.';
        freq_light{m} = freq_on;                                            % calculates the firing frequency of each unit in each of the light-on intervals
    end
    spikes_dark{m} = numel(units_sorted{m}(units_sorted{m}(:,1) >=0)) - sum(spikes_light{m});
    unitfreq_dark{m} = spikes_dark{m} / dark_time;                          % calculates the average unit firing frequency in without light stimulus
end

unitfreq_dark = cell2mat(unitfreq_dark);
unitfreq_light = cellfun(@mean, freq_light);

freqdark.avg = mean(unitfreq_dark);
freqdark.std = std(unitfreq_dark);
freqlight.avg = mean(unitfreq_light);
freqlight.std = std(unitfreq_light);

for m = 1:length(units_sorted)
    unit_PI(m) = (unitfreq_light(m) - unitfreq_dark(m)) / (unitfreq_light(m) + unitfreq_dark(m));
end

unit_PI = unit_PI.';

unitPI.avg = mean(unit_PI);
unitPI.std = std(unit_PI);
        

%% Plot histogram of LRI/PI values
PI_histo = figure(3);
hold on;
unitPI_histoplot = histogram(unit_PI, 'BinWidth', BW2);
xlim([-1 1]);
xlabel('Photoswitch index, PI');
ylabel('No. events');
xl = xline (0, ':', 'LineWidth', 1.5);
set(gca, 'TickDir', 'out');
hold off;

%% Display frequency & LRI/PI values
% values reported as average +/- standard deviation

fprintf('Average firing frequency in darkness = %.2f +/- %.2f Hz \n', freqdark.avg, freqdark.std);
fprintf('Average firing frequency in light = %.2f +/- %.2f Hz \n\n', freqlight.avg, freqlight.std);
fprintf('PI histogram binsize = %.3f \n', BW2);
fprintf('Average photoswitch index, P.I. = %.3f +/- %.3f \n\n', unitPI.avg, unitPI.std);    
end

