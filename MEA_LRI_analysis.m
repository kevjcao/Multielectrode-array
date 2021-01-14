%% Notes
% 1. This code requires sorted spike data from Plexon saved in an excel
% format delineated as: 'SpikeTimes', 'Unit no.', 'channels. no.'; in that order. 

% 2. If file is exported with 'ISI times', they need to be in the 4th column. 

%% Clear workspace
tic
clear;
close all;

%% Conditions
% Analysis duration
Duration = 0;                                                               % 1 = analysis performed for a segment of the recording
spike_start = 00;                                                           % in seconds
spike_end = 120;                                                            % in seconds

% Light stimulus 
Trigger = 1;                                                                % Light stimulus with trigger times = 1, other wise = 0

% Parameters for PI & LRI calculation
BW = 0.1;                                                                   % bin width, in seconds, for histogram of raw unsorted spike data
BW2 = 0.05;                                                                 % bin width, in LRI values, for histogram of PI/LRI values; is not the binwidth for spiking frequency BW

% Plots and graphs
Histoplot = 0;                                                              % set 0 (no histogram) or 1 (histogram)
Sort = 1;                                                                   % if 1 = sort units, if 0 = no sorting

% Parameters for ISI analysis
ISIexport = 0;                                                              % 0 = calculate interspike intervals (ISIs) from spike times (1st column); 1 = ISIs exported from Plexon
ISI = 1;                                                                    % 1 = run analysis for ISIs
BW_ISI = 10;                                                                 % bin width for ISI histograms, in ms
ISIcutoff = 2000;                                                           % maximum ISI, in ms, used in ISI analysis (i.e., low pass filter)

%% Import raw sorted spike data from Plexon 

[FileName, FilePath] = uigetfile( ...
       {'*.xlsx','New Excel (*.xlsx)'; ...
       '*.xls','Old Excel (*.xls)';
       '*.txt', 'Text file (*.txt)'}, ...
        'Pick a file', ...
        'MultiSelect', 'on');
File = fullfile(FilePath, FileName);
[num, txt, raw] = xlsread(File);

fprintf('%s \n\n', FileName);                                               % Display file name / experiment details

clearvars txt FilePath FileName

%% Sets start and end times for analysis

if Duration == 1
    num = num(num(:,1)>=spike_start & num(:,1)<=spike_end, :);
    raw = cellfun(@(z) z(z(:,1)>=spike_start & z(:,1)<=spike_end, :), raw, 'UniformOutput', false);
    
    fprintf('Record analyzed from %d to %ds \n\n', spike_start, spike_end);
end

if Duration == 0
    fprintf('Full record analyzed \n\n');
end

%% Acquire timestamps of light intervals from trigger times
% Trigger filename must exactly match the .xlsx spike sorted data

if Trigger == 1
    [trig_timesRaw] = loadtrigger(File);
    [interv_times, interv_duration, dark_time] = exptimes(trig_timesRaw, Duration, spike_start, spike_end);
else
    fprintf('No trigger times loaded \n\n');
    [interv_times] = 0;
end

clearvars trig_timesRaw 

%% Bin raw spike data into 100ms slices

fprintf('Bin size = %d ms \n', BW * 1000)

spike_timeHist = cell2mat(raw(:,1));
[N, EDGES] = histcounts(spike_timeHist, 'BinWidth', BW);                    % N is the counts for each bin, EDGES are the bin edges

if Histoplot == 1
    hold on;
    histogram_plot = figure(1);
    HistoSpikes = histogram(spike_timeHist, 'BinWidth', BW);
    xlabel('Time (s)');
    ylabel('Number of spikes');
    set(gca, 'TickDir', 'out');
    hold off
else 
    fprintf('No histogram for raw spike data plotted\n\n');
end

%% Arrange raw spike data into units and generate raster plot of unit activity

[unit_raster, units_sorted] = rawunits(num, Sort, ISIexport, ISIcutoff);

clearvars num

%% Calculate firing frequencies and PI per unit

if Trigger == 1
    [unit_PI, PI_histo] = spikefreq(units_sorted, interv_times, interv_duration, dark_time, BW2);
end
        
clearvars interv_duration dark_time;

%% Plot normalized firing frequency of recording

[freq_plot] = freqplot(N, BW, EDGES, units_sorted, Trigger, interv_times);

clearvars N BW EDGES

%% Create light response index plot 

if Trigger == 1
    [LRI_histo] = lri(unit_PI, BW2);
end

clearvars BW2

%% Analyze ISI for each unit

if ISI == 1
    [isi_histo, isi_3d, ISI_raw] = interspikeinterv(units_sorted, BW_ISI, ISIexport, ISIcutoff);
end

toc
