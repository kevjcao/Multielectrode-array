function [unit_PI, PI_histo] = spikefreq(raw_units, interv_times, interv_duration, dark_time, BW2)
%% Function calculates the average PI of the recording
% first calculates the firing freq in light & dark and then the PI per unit


raw_unitsTime = cell(numel(raw_units), 1);

for m = 1:length(raw_units)
    unit_time = raw_units{m,1}(:,1);
    raw_unitsTime{m} = unit_time;
end

spikes_light = cell(numel(raw_units), 1);
spikes_on = [];

freq_light = cell(numel(raw_units), 1);
freq_on = [];

unitfreq_light = cell(numel(raw_units), 1);
spikes_dark = cell(numel(raw_units), 1);
unitfreq_dark = cell(numel(raw_units), 1);

for m = 1:length(raw_units)
    for r = 1:length(interv_times)
        spikes_on(r) = numel(raw_unitsTime{m}(raw_unitsTime{m}(:,1) >= interv_times(r,1) & raw_unitsTime{m}(:,1) <= interv_times(r,2)));
        % spikes_on = spikes_on.';
        
        spikes_light{m} = spikes_on;                                % calculates number of spikes that occur in each light-on interval for a particular unit
    end
end
for m = 1:length(raw_units)
    for r = 1:length(interv_times)
        freq_on(r) = (spikes_light{m}(1,r) / interv_duration(1,r));
        % freq_on = freq_on.';
        
        freq_light{m} = freq_on;                                    % calculates the firing frequency of each unit in each of the light-on intervals
    end
    
    
    spikes_dark{m} = numel(raw_unitsTime{m}(raw_unitsTime{m}(:,1) >=0)) - sum(spikes_light{m});
    unitfreq_dark{m} = spikes_dark{m} / dark_time;                      % calculates the average unit firing frequency in without light stimulus
end

unitfreq_dark = cell2mat(unitfreq_dark);
unitfreq_light = cellfun(@mean, freq_light);

avgfreq_dark = mean(unitfreq_dark);
stdfreq_dark = std(unitfreq_dark);
avgfreq_light = mean(unitfreq_light);
stdfreq_light = std(unitfreq_light);

for m = 1:length(raw_units)
    unit_PI(m) = (unitfreq_light(m) - unitfreq_dark(m)) / (unitfreq_light(m) + unitfreq_dark(m));
end

unit_PI = unit_PI.';

avg_unitPI = mean(unit_PI);
std_unitPI = std(unit_PI);

PI_histo = figure(3);
hold on;
unitPI_histoplot = histogram(unit_PI, 'BinWidth', BW2);
xlim([-1 1]);
xlabel('Photoswitch index, PI');
ylabel('No. events');
xl = xline (0, ':', 'LineWidth', 1.5);
hold off;

fprintf('Average firing frequency in darkness = %.2f +/- %.2f Hz \n', avgfreq_dark, stdfreq_dark);
fprintf('Average firing frequency in light = %.2f +/- %.2f Hz \n\n', avgfreq_light, stdfreq_light);
fprintf('PI histogram binsize = %.3f \n', BW2);
fprintf('Average photoswitch index, P.I. = %.3f +/- %.3f \n\n', avg_unitPI, std_unitPI);    %values reported as average +/- standard deviation

end

