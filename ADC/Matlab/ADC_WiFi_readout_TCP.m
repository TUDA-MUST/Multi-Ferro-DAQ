% This is a test to collect ADC data in a grid

% You use this script by turning on the Schlaubischlumpf-board and waiting
% until the led turns magenta. This indicates that the ESP32 is ready to
% beigin collecting data. Make sure you are in the WiFi network broadcast
% by the ESP32 (PW should be 123456789) and start the MATLAB script. When
% the LED on the board turns green, the connecion is established and the
% measurement underway. After completing the measurement the ESP32 will
% reset itself and the LED will turn yellow while it is busy.
% In order to configure the device the sample rate currently has to be
% programmed into the ESP, while the length of measurement and the pregain
% of the channels can be set via MATLAB


%set the number of datasets to be collected 
function size = size_dataBuffer()
    size = 10000; %needs to be in range for int64
end

%Channel amplification can be set to 1, 2, 4, 8 or 12
function CHAN_ARRAY = getCHAN_ARRAY()
    CHAN1_AMP = uint8(1);
    CHAN2_AMP = uint8(2);
    CHAN3_AMP = uint8(1);
    CHAN4_AMP = uint8(1);
    CHAN5_AMP = uint8(1);
    CHAN6_AMP = uint8(1);
    CHAN7_AMP = uint8(1);
    CHAN8_AMP = uint8(12);
    CHAN_ARRAY = {CHAN1_AMP, CHAN2_AMP, CHAN3_AMP, CHAN4_AMP, CHAN5_AMP, CHAN6_AMP, CHAN7_AMP, CHAN8_AMP};
end

%clear workspace
clear;

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

%tell esp how many datapoints to measure
write(u, size_dataBuffer(),"int64");
%tell esp how to set preamp
tempchanarr = getCHAN_ARRAY();
for i = 1: 8
    write(u, tempchanarr{i}, "uint8");
end
disp("initiadted tcp client");

% Start listening for incoming packets
%f0 = figure;
% Continuous listening loop (main loop to keep the program alive)
while time <= size_dataBuffer()
    % Check if there is incoming data from UDP
    if u.NumBytesAvailable > 0
        % Read incoming data 
        data = read(u, 576, "single"); 
        
        for i = 0 : 63
            % Update the data buffer
            dataBuffer(time, :) = data(1,i*9+1:(i+1)*9);
            
            % Increment time (or use actual timestamp from UDP packet)
            time = time + 1;  
        end
         
        %liveplot is working and doesn't obstruct programm, but is too slow,
        %to be useful...
        %plot(dataBuffer(1:time-1,9),dataBuffer(1:time-1,1:8));
        %lgd = legend('CHAN1', 'CHAN2', 'CHAN3', 'CHAN4', 'CHAN5', 'CHAN6', 'CHAN7', 'CHAN8');
        %lgd.NumColumns = 2;
        %%lgd.Title.String = 'sensitivecoarse';
        %xlabel('Zeit in µs');
        %ylabel('Messauschlag in mV');
        %drawnow;
    end
end
%close(f0);


%from here on out it's plots to visualize the tested data

%plot the eight Channels regarding aplitude in mv/ time in µs
figure;
time = time - 1;
time_vec = (1:time)';
plot(dataBuffer(1:time,9),dataBuffer(1:time,1:8));
lgd = legend('CHAN1', 'CHAN2', 'CHAN3', 'CHAN4', 'CHAN5', 'CHAN6', 'CHAN7', 'CHAN8');
lgd.NumColumns = 2;
%lgd.Title.String = 'sensitivecoarse';
xlabel('Zeit in µs');
ylabel('Messauschlag in mV');
%close(f1);

%plot the time in µs/ number of dataset in array to visually check if packets are missing
%(in theory a tcp connection shouldn't lose packtets, in reality a packageloss was 
% observed over greater distances)
f2 = figure;
plot(time_vec(:,1),dataBuffer(:,9));
xlabel('Samples');
ylabel('Zeit in µs');
%close(f2);


for j = 1 : size_dataBuffer()-2
    time_delta(j) = dataBuffer(j+1,9) -dataBuffer(j,9);
end


%calculate some statistics
delta_mean = mean(time_delta);
delta_max = max(time_delta);
delta_min = min(time_delta);
delta_deviataion = std(time_delta);
approx_sample_rate = 1 / (delta_mean*10^-6);
% measurement = "1kSPS";

delete(u);
clear u;