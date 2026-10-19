% This is a test to collect ADC data in a grid

% You use this script by turning on the Multi-Ferro-DAQ board and waiting
% until the led turns magenta. This indicates that the ESP32 is ready to
% beigin collecting data. Make sure you are in the WiFi network broadcast
% by the ESP32 (PW should be 123456789) and start the MATLAB script. When
% the LED on the board turns green, the connecion is established and the
% measurement underway. After completing the measurement the ESP32 will
% reset itself and the LED will turn yellow while it is busy.
% In order to configure the device change the settings struct. Ohterwise
% the programmed default values of the ESP32 will be used

function settings = getSettings()
    % set the sample rate to 1000, 2000, 4000, 8000, 16000, 32000, 64000
    % values above 2000 are not recommended
    settings.sample_rate = 2000;
    
    % set the duration of the measurement in seconds
    settings.duration = 300;
    
    % set the preamp of the cannels to 1, 2, 4, 8 or 12
    % this setting is for fast changes and will overwrite the
    % channel config regs set below
    % the amplification will be divided out by the ESP32 before sending
    % the data
    settings.CHAN1_AMP = uint8(2);
    settings.CHAN2_AMP = uint8(2);
    settings.CHAN3_AMP = uint8(2);
    settings.CHAN4_AMP = uint8(2);
    settings.CHAN5_AMP = uint8(2);
    settings.CHAN6_AMP = uint8(2);
    settings.CHAN7_AMP = uint8(2);
    settings.CHAN8_AMP = uint8(2);
    
    % change the config regs of the individual channels
    % for further reference read the datasheet
    % the preamp value set seperately will overwrite the
    % preampvalue set here
    
    settings.conf1 = 0x10;          % 0x10 = measurement input with gain 1
    settings.conf2 = 0x10;
    settings.conf3 = 0x10;
    settings.conf4 = 0x10;
    settings.conf5 = 0x10;
    settings.conf6 = 0x10;
    settings.conf7 = 0x10;
    settings.conf8 = 0x10;

end

% the number of datasets to be collected 
function size = size_dataBuffer()
    size = getSettings().duration * getSettings().sample_rate;           %needs to be in range for int64
end



% overwrite the config regs of the channels with new values
% look into the datasheet for further reference

%clear workspace
clear;
close all;

% Define TCP connection parameters
tcpPort = 8080; 
tcpIP = '192.168.4.1'; 
% Create a UDP object
disp("starting TCP connection...");
u = tcpclient(tcpIP, tcpPort);
configureTerminator(u, "CR/LF");


% Initialize time and data buffer
time = 1;
dataBuffer = zeros(size_dataBuffer(), 9);



% there is no "protocol" the esp uses to determine the datasets
% the order and size of the values have to match what it expects
% tell esp how many datapoints to measure
write(u, size_dataBuffer(),"int64");
% tell esp which sample size to set
write(u, getSettings().sample_rate, "uint32");
% tell esp to set the cannels individually
tempchanarr = uint16([getSettings().conf1, getSettings().conf2, getSettings().conf3, getSettings().conf4, getSettings().conf5, getSettings().conf6, getSettings().conf7, getSettings().conf8]);
for i = 1: 8    
    write(u, tempchanarr(i),"uint16");
end
% tell esp how to set preamp
tempchanarr = [getSettings().CHAN1_AMP, getSettings().CHAN2_AMP, getSettings().CHAN3_AMP, getSettings().CHAN4_AMP, getSettings().CHAN5_AMP, getSettings().CHAN6_AMP, getSettings().CHAN7_AMP, getSettings().CHAN8_AMP];
for i = 1: 8
    write(u, tempchanarr(i), "uint8");
end
disp("initiadted tcp client");

% Start listening for incoming packets
f0 = figure('Position', [100 100 400 300]);

% Create a struct to hold shared state
stateStruct.stop = false;

% Store it in the figure using guidata
guidata(f0, stateStruct);


% Get the figure size
figPos = get(f0, 'Position');
figWidth = figPos(3);
figHeight = figPos(4);

% Define button size
btnWidth = 150;
btnHeight = 50;

% Calculate centered position
btnX = (figWidth - btnWidth) / 2;
btnY = (figHeight - btnHeight) / 2;

% Create button 
btn = uicontrol('Style', 'pushbutton', ...
                'String', 'Stop Measurement', ...
                'Position', [btnX btnY btnWidth btnHeight], ...
                'FontSize', 12, ...
                'Callback', @(src, event) stopCallback(f0));

% Continuous listening loop (main loop to keep the program alive)
drwcnt = 0;
while time <= size_dataBuffer()

    currentState = guidata(f0);
    if currentState.stop
        disp("Sende Abbruch-Befehl per TCP...");
        % send signal per TCP
        write(u, "STOP", "string");
        break; 
    end

    % Check if there is incoming data from UDP
    if u.NumBytesAvailable > 0
        % Read incoming data 
        data = read(u, 576, "single"); 
        
        for i = 0 : 63
            % Update the data buffer
            dataBuffer(time, :) = data(1,i*9+1:(i+1)*9);
            
            % Increment time (or use actual timestamp from TCP packet)
            time = time + 1;  
        end
        % drwcnt = mod((drwcnt + 1),20);
    end
    %liveplot is working and doesn't obstruct programm, but is too slow,
    %to be useful...
    % if drwcnt == 0
    %     plot(dataBuffer(1:time-1,9),dataBuffer(1:time-1,1:8));
    %     % generating legend in loop will create warnings; to not overshadow
    %     % relevant warnings, the lgd is commented out
    %     %lgd = legend('CHAN1', 'CHAN2', 'CHAN3', 'CHAN4', 'CHAN5', 'CHAN6', 'CHAN7', 'CHAN8');
    %     %lgd.NumColumns = 2;
    %     xlabel('Zeit in µs');
    %     ylabel('Messauschlag in mV');
    %     ylim([-3000 3000]);
    %     drawnow;
    % end
end
close(f0);


% Find the first row that is all zeros
zeroRow = find(all(dataBuffer == 0, 2), 1);
% If such a row exists, keep data only up to the row before it
if ~isempty(zeroRow)
    dataToSave = dataBuffer(1:zeroRow-1, :);
else
    dataToSave = dataBuffer;   % No zero row found → save entire matrix
end

% Create a table with column names
colNames = {'CAHN1','CHAN2','CHAN3','CHAN4','CHAN5','CHAN6','CHAN7','CHAN8','TIME'};  
saveTable = array2table(dataToSave, 'VariableNames', colNames);

% Save Updated Data
[saveFileName, savePath] = uiputfile('*.csv', 'Save updated data as');
if isequal(saveFileName, 0)
    disp('User canceled saving.');
else
    writetable(saveTable, fullfile(savePath, saveFileName));
    fprintf('Saved updated data to %s\n', fullfile(savePath, saveFileName));
end

%from here on out it's plots to visualize the tested data

%plot the eight Channels regarding aplitude in mv/ time in µs
figure;
time = time - 1;
time_vec = (1:time)';
plot(dataBuffer(1:time,9)*1E-6,dataBuffer(1:time,1:8));
lgd = legend('CHAN1', 'CHAN2', 'CHAN3', 'CHAN4', 'CHAN5', 'CHAN6', 'CHAN7', 'CHAN8');
lgd.NumColumns = 2;
%lgd.Title.String = 'sensitivecoarse';
xlabel('Zeit in s');
ylabel('Messauschlag in mV');
ylim([-3000 3000]);
%close(f1);

%plot the time in µs/ number of dataset in array to visually check if packets are missing
%(in theory a tcp connection shouldn't lose packtets, in reality a packageloss was 
% observed over greater distances)
if(currentState.stop == false)
    f2 = figure;
    plot(time_vec(:,1),dataBuffer(:,9)*1E-6);
    xlabel('Samples');
    ylabel('Zeit in s');
%close(f2);
end

for j = 1 : size_dataBuffer()-2
    time_delta(j) = dataBuffer(j+1,9) -dataBuffer(j,9);
end


%calculate some statistics
delta_mean = mean(time_delta);
delta_max = max(time_delta);
delta_min = min(time_delta);
delta_deviataion = std(time_delta);
approx_sample_rate = 1 / (delta_mean*10^-6);
measured_time_sec = (dataBuffer(time, 9) - dataBuffer(1,9))/(10^6);

delete(u);
clear u;



function stopCallback(figHandle)
    % Get the state from the figure
    state = guidata(figHandle);
    state.stop = true;
    % Save it back
    guidata(figHandle, state);
    disp("Stop button pressed!");
end

