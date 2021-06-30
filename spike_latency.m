function [earliest_spikes, spike_latency] = spike_latency(units_sorted, interv_times)
%% Calculate earliest spike in response to light On (aka - spike latency)
% measures the latency of spiking for each unit to the preceeding light
% stimulus On

earliest_spikes = cell(numel(units_sorted), 1);
nn_spike = [];

for m = 1:length(units_sorted)                                              % generates a cell array of the earliest spikes to light On
    for r = 1:length(interv_times)
        dist_light = units_sorted{m}(:,1) - interv_times(r,1);
        dist_light(dist_light < 0) = +Inf;
        nn_spike(r) = min(dist_light);
        earliest_spikes{m} = nn_spike;
    end
end

concat_earlyspike = cat(1, earliest_spikes{:});
early_spike = reshape(concat_earlyspike', [], 1);                         % single column of all earliest spikes to light - for export


%% Control - calculate spike latency to random time point

random_times = randi([10, 100], length(interv_times), 1);

earliest_check = cell(numel(units_sorted), 1);
nn_check = [];

for m = 1:length(units_sorted)
    for r = 1:length(interv_times)
        check_dist = units_sorted{m}(:,1) - random_times(r,1);
        check_dist(check_dist < 0) = +Inf;
        nn_check(r) = min(check_dist);
        earliest_check{m} = nn_check;
    end
end

concat_checkspike = cat(1, earliest_check{:});
check_latency = reshape(concat_checkspike', [], 1);

%% Create single 2 column array
% first column = spike latency to light, second column = random shuffle of
% reference light On

spike_latency = [early_spike check_latency];
spike_latency = spike_latency*1000;

end
