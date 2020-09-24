function [trig_timesRaw] = loadtrigger(File)
%% Acquire timestamps of light intervals from trigger times
% Trigger filename must exactly match the .xlsx spike sorted data

trigFile = strrep(File, '.xlsx', '.txt');                            % imports the corresponding .txt trigger file
fidTrig = fopen(trigFile);

delimiter = '\t';
formatSpec = '%*s%s%[^\n\r]';
trig_timesArray = textscan(fidTrig, ...                                % opens .txt trigger file (from MC_Rack data tool) and parses raw text file
    formatSpec, 'Delimiter', delimiter, ...                           % into a 1x2 array with 1st cell being 3 ms trigger record
    'TextType', 'string',  'ReturnOnError', false);                   % and 2nd cell being the bias voltage (-1 or null)

fclose(fidTrig);

trig_timesRaw = trig_timesArray{1,1}(:,1);                              % creates new numerical array with only the 3 ms trigger record
trig_timesRaw(1:4,:) = [];
trig_timesRaw = double(trig_timesRaw);

end