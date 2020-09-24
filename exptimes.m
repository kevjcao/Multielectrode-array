function [interv_times, interv_duration, dark_time] = exptimes(trig_timesRaw, Duration, spike_start, spike_end)
%% use trig_timesRaw to determine total record time and light/dark periods

if Duration == 1                                                             % if looking at a specific time window of the recording
    trig_timesRaw = trig_timesRaw(trig_timesRaw(:,1)>=(spike_start*1000) & trig_timesRaw(:,1)<=(spike_end*1000), :);
end

if Duration == 0
    record_time = max(trig_timesRaw)/1000;                                   % if looking at the total recording
end

if Duration == 1
    record_time = spike_end - spike_start;
end

parsed_trigTimes = [];

for i = 1:length(trig_timesRaw)-1                                           % creates an array with the trigger times before and after the TTL signal
    diff_trig = trig_timesRaw(i + 1) - trig_timesRaw(i);
    if diff_trig > 4
        parsed_trigTimes = [parsed_trigTimes; trig_timesRaw(i); trig_timesRaw(i + 1)];
    end
end

parsed_trigTimes = parsed_trigTimes/1000;

interv_times = [parsed_trigTimes(1:2:end,:), parsed_trigTimes(2:2:end,:)];  % splits numTime array into two columns - column 1 for light on and column 2 for light off
interv_duration = diff(interv_times, 1, 2);                                 % returns the total length of each light stim interval, in seconds
interv_duration = interv_duration.';
lighton_time = sum(interv_duration);                                        % returns the total time that the light stim was on, in seconds
dark_time = record_time - lighton_time;                                     % length of time, in seconds, without light stimulus

end