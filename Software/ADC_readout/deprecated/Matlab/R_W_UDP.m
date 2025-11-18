serverAdress = "192.168.4.1";
serverPort = 8080;

u = udpport("IPV4");
configureTerminator(u, "CR/LF");

write(u, "first MATLAB Message", serverAdress, serverPort);
data = read(u,80,"char");

disp(data);


delete(u);
clear u;