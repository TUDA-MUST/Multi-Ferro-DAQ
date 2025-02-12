% This is a test to collect ADC data in a grid
function size = size_dataBuffer()
    size = 2000;
end
%clear workspace
clear;

% Define UDP connection parameters
udpPort = 8080; 
udpIP = '192.168.4.1'; 
% Create a UDP object
u = udpport("IPV4");
configureTerminator(u, "CR/LF");


% Initialize time and data buffer
time = 1;
dataBuffer = zeros(size_dataBuffer(), 8);

% Start listening for incoming UDP packets
fprintf('Listening for UDP packets on port %d...\n', udpPort);
write(u, "successfully connected to MATLAB", udpIP, udpPort);

% Continuous listening loop (main loop to keep the program alive)
while time <= size_dataBuffer()
    % Check if there is incoming data from UDP
    if u.BytesAvailable > 0
        % Read incoming data 
        data = read(u, 8, "single"); 
        
        % Update the data buffer
        dataBuffer(time, :) = data;
        
        % Increment time (or use actual timestamp from UDP packet)
        time = time + 1;  
        
    end
end

figure;
time = time - 1;
time_vec = (1:time)';
plot(time_vec(:,1),dataBuffer(:,:));

delete(u);
clear u;