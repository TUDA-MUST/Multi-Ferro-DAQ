#include <WiFi.h>
#include <WiFiUdp.h>

// AP credentials
const char *ssid = "ESP32_Hotspot";
const char *password = "123456789";  // Minimum 8 characters
byte buffer[16]; // 4 floats * 4 bytes each = 16 bytes
// Define the four 32-bit floats
float data1 = 3.14;
float data2 = 2.71;
float data3 = 1.61;
float data4 = 0.5772;

// UDP settings
WiFiUDP udp;
const int udpPort = 8080;  // Listen on port 8080
char incomingPacket[255];  // Buffer to store incoming data

void setup() {
  // Start the serial communication
  Serial.begin(115200);
  while (!Serial) {};

  // Start the ESP32 as an Access Point (Hotspot)
  Serial.println("Setting up Access Point...");
  WiFi.softAP(ssid, password);
  
  // Print the ESP32 AP IP address
  Serial.println("Access Point Started!");
  Serial.print("IP Address: ");
  Serial.println(WiFi.softAPIP());  // Print the AP's IP address (usually 192.168.4.1)

  // Start the UDP communication
  udp.begin(udpPort);
  Serial.println("UDP listening on port 8080 - start MATLAB script");
}

void loop() {
  // Check if there is any incoming UDP packet
  int packetSize = udp.parsePacket();
  
  if (packetSize) {
    // Read the incoming packet into the buffer
    int len = udp.read(incomingPacket, 255);
    if (len > 0) {
      incomingPacket[len] = 0;  // Null-terminate the string
    }
    
    // Print the received data to the Serial Monitor
    //Serial.print("Received packet: ");
    Serial.println(incomingPacket);
    int remoteIP = 0;
    remoteIP = udp.remoteIP();
    if (remoteIP != 0){
      // Convert the floats to byte array using typecast
      while(1){
      memcpy(buffer, &data1, sizeof(data1));  // Copy data1 (float) into buffer
      memcpy(buffer + 4, &data2, sizeof(data2));  // Copy data2 (float) into buffer
      memcpy(buffer + 8, &data3, sizeof(data3));  // Copy data3 (float) into buffer
      memcpy(buffer + 12, &data4, sizeof(data4));  // Copy data4 (float) into buffer

      // Send the buffer over UDP
      udp.beginPacket(udp.remoteIP(), udp.remotePort());
      udp.write(buffer, sizeof(buffer));  // Send the 16-byte buffer
      udp.endPacket();
      }
    }
  }
}


/*#include <WiFi.h>

// AP credentials
const char *ssid = "ESP32_Hotspot";
const char *password = "123456789";  // Minimum 8 characters

// TCP Server settings
WiFiServer server(8080);  // Listen on port 8080

void setup() {
  // Start the serial communication
  Serial.begin(115200);
  while(!Serial){};

  // Start the ESP32 as an Access Point (Hotspot)
  Serial.println("Setting up Access Point...");
  WiFi.softAP(ssid, password);
  
  // Print the ESP32 AP IP address
  Serial.println("Access Point Started!");
  Serial.print("IP Address: ");
  Serial.println(WiFi.softAPIP());  // Print the AP's IP address (usually 192.168.4.1)

  // Start the TCP server
  server.begin();
  Serial.println("TCP Server started.");
}

void loop() {
  // Listen for incoming clients
  WiFiClient client = server.available();
  
  if (client) {
    Serial.println("New client connected.");

    // Send a welcome message to the client
    client.println("Hello from ESP32-S3 TCP Server!");

    // Wait for client data
    while (client.connected()) {
      if (client.available()) {
        char c = client.read();
        Serial.write(c);  // Print received data to the Serial Monitor
      }
    }

    // Close the connection when the client disconnects
    client.stop();
    Serial.println("Client disconnected.");
  }
}
*/