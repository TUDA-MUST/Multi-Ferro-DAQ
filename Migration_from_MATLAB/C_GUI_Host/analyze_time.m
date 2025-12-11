close all;
clear;

%% --- Select CSV file via GUI ---
[file, path] = uigetfile('*.csv', 'Select CSV file');
if isequal(file, 0)
    disp('User canceled');
    return;
end

fullfilePath = fullfile(path, file);

%% --- Read file as plain text ---
fid = fopen(fullfilePath, 'r');
rawLines = textscan(fid, '%s', 'Delimiter', '\n', 'Whitespace', '');
fclose(fid);

rawLines = rawLines{1};
nLines = length(rawLines);

%% --- Preallocate ---
MAXN = 100000;
reqTime   = NaT(MAXN,1); reqTime.TimeZone = 'UTC';
echoTime  = NaT(MAXN,1); echoTime.TimeZone = 'UTC';
localTime = zeros(MAXN,1);

%% --- Regex pattern ---
pattern = ['Sent Timesync request at ([0-9:\-\. ]+ UTC), ' ...
           'received echo at ([0-9:\-\. ]+ UTC), ' ...
           'local time ([0-9]+),0'];

count = 0;
haveStarted = false;

%% --- Parse lines ---
for i = 1:nLines
    tokens = regexp(rawLines{i}, pattern, 'tokens', 'once');

    if ~isempty(tokens)
        count = count + 1;
        haveStarted = true;

        reqTime(count) = datetime(tokens{1}, ...
            'InputFormat','yyyy-MM-dd HH:mm:ss.SSS ''UTC''','TimeZone','UTC');

        echoTime(count) = datetime(tokens{2}, ...
            'InputFormat','yyyy-MM-dd HH:mm:ss.SSS ''UTC''','TimeZone','UTC');

        localTime(count) = str2double(tokens{3}); % raw microseconds

    elseif haveStarted
        i = i-1;
        break; % stop early when Timesync block ends
    end
end

%% --- Trim ---
reqTime   = reqTime(1:count);
echoTime  = echoTime(1:count);
localTime = localTime(1:count);

%% --- Compute midpoint ---
midTime = reqTime + (echoTime - reqTime)/2;

%% --- Convert time to numeric seconds ---
t_mid = seconds(midTime - midTime(1));     % x-values
lt     = localTime / 1e6;                  % convert µs → sec
lt     = lt - lt(1);                       % y-values, remove offset

%% --- Fit linear model: lt = a*t_mid + b ---
p = polyfit(t_mid, lt, 1);
lt_fit = polyval(p, t_mid);

%% --- Statistics ---
SS_res = sum((lt - lt_fit).^2);
SS_tot = sum((lt - mean(lt)).^2);
R2 = 1 - SS_res / SS_tot;

residuals = lt - lt_fit;
std_res = std(residuals);
var_res = var(residuals);

%% --- Print results ---
fprintf("Data for %s\n", file);
fprintf("Linear fit: localTime = midTime*t + b\n");
fprintf("  a (scale factor) = %.12f sec/sec\n", p(1));
fprintf("  b (offset)       = %.12f sec\n", p(2));
fprintf("  R²               = %.12f\n", R2);
fprintf("  Residual std     = %.12e sec\n", std_res);
fprintf("  Residual var     = %.12e sec^2\n", var_res);

%% --- Plot results ---
figure;

subplot(2,1,1);
plot(t_mid, lt, 'o'); hold on;
plot(t_mid, lt_fit, '-','LineWidth',2);
grid on;
title('LocalTime vs Midpoint Time');
xlabel('Midpoint Time (sec)');
ylabel('LocalTime (sec)');
legend('Data','Fit','Location','best');

subplot(2,1,2);
plot(t_mid, residuals * 1e3, '-o');
grid on;
title('Residuals');
xlabel('Midpoint Time (sec)');
ylabel('Error (millisec)');




if i < nLines
    remainingLines = rawLines(i+1:end);
else
    error("No channel data found after timesync block.");
end


%% --- Vectorized CHAN table parsing ---
remainingLines = rawLines(i+1:end);

% Find header line starting with 'CHAN'
headerIndex = find(startsWith(strtrim(remainingLines), 'CHAN'), 1);
if isempty(headerIndex)
    error('Cannot find CHAN header line.');
end

% Data lines are everything after the header
dataLines = remainingLines(headerIndex+1:end);
dataLines = dataLines(~cellfun(@isempty, strtrim(dataLines)));  % remove empty lines
dataLines = strrep(dataLines, ',', '.');                         % decimal commas → points
dataStr = strjoin(dataLines, '\n');                              % combine lines

% Format: 8 channels (floats) + LOCAL_TIME (float) + GLOBAL_TIME (string)
fmt = [repmat('%f',1,9) '%f %s'];

% Parse all at once
dataCell = textscan(dataStr, fmt, 'Delimiter', ';', 'CollectOutput', 1);

chanData      = dataCell{1}(:,8);   % 8 channel columns
chanLocal     = dataCell{1}(:,9);     % LOCAL_TIME column
chanGlobalStr = dataCell{2};          % GLOBAL_TIME strings

% Convert GLOBAL_TIME to datetime
chanGlobal = datetime(chanGlobalStr, ...
    'InputFormat','yyyy-MM-dd HH:mm:ss.SSSSSS ''UTC''', ...
    'TimeZone','UTC');

%% --- Compare LOCAL_TIME directly against GLOBAL_TIME ---
lt_sec = chanLocal / 1e6;                       % µs → sec
gt_sec = seconds(chanGlobal - chanGlobal(1));   % relative GLOBAL_TIME in sec
lt_sec = lt_sec - lt_sec(1);                    % Subtract initial offset from LOCAL_TIME as well

residuals = lt_sec - gt_sec;                    % LOCAL_TIME - GLOBAL_TIME
res_std   = std(residuals);
res_max   = max(abs(residuals));

%% --- Print results ---
fprintf("\n=== LOCAL_TIME vs GLOBAL_TIME ===\n");
fprintf("Residual STD    = %.6f ms\n", res_std*1e3);
fprintf("Max |residual|  = %.6f ms\n", res_max*1e3);

%% --- Plot results ---
figure;

% Compare clocks
subplot(2,1,1);
plot(gt_sec, gt_sec, 'k-', 'LineWidth', 2); hold on;  % perfect GLOBAL_TIME
plot(gt_sec, lt_sec, 'o');                             % LOCAL_TIME
grid on;
xlabel('GLOBAL_TIME (sec)');
ylabel('Time (sec)');
title('LOCAL_TIME vs GLOBAL_TIME');
legend('GLOBAL_TIME','LOCAL_TIME','Location','best');

% Residuals
subplot(2,1,2);
plot(gt_sec, residuals*1e3, '-o');
xlabel('GLOBAL_TIME (sec)');
ylabel('Residual (ms)');
grid on;
title('Residual: LOCAL_TIME - GLOBAL_TIME');


