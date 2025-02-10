% This is a test to read 

% Define UDP connection parameters
udpPort = 8080; 
udpIP = '192.168.4.1'; 
% Create a UDP object
u = udpport("IPV4");
configureTerminator(u, "CR/LF");


% Define global variables for storing data
global time dataBuffer;

% Initialize time and data buffer
time = 0;
dataBuffer = [];

% Start listening for incoming UDP packets
fprintf('Listening for UDP packets on port %d...\n', udpPort);
write(u, "successfully connected to MATLAB", udpIP, udpPort);

% Continuous listening loop (main loop to keep the program alive)
while true
    % Check if there is incoming data from UDP
    if u.BytesAvailable > 0
        % Read incoming data 
        data = read(u, 4, "single"); 
        
        % Update the data buffer
        dataBuffer = [dataBuffer; data];
        
        % Increment time (or use actual timestamp from UDP packet)
        time = time + 1;  
        
    end
    
end

delete(u);
clear u;