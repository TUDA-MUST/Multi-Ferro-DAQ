#include <WiFi.h>

// AP credentials
const char *ssid = "ESP32_Hotspot";
const char *password = "123456789";  // Minimum 8 characters

// TCP Server settings
WiFiServer server(8080);  // Listen on port 8080

void setup() {
  // Start the serial communication
  Serial.begin(115200);

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