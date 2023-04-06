//Servo
#include <Servo.h>
Servo myservo1;  // create servo object to control a servo
Servo myservo2;  // create servo object to control a servo
Servo myservo3;  // create servo object to control a servo
#define servoPin1 13
#define servoPin2 27
#define servoPin3 26
int pos1 = 0;    // variable to store the servo position
int pos2 = 0;    // variable to store the servo position
int pos3 = 0;    // variable to store the servo position

//WiFi
#define wifiLedPin 2

//Firebase
#include <Arduino.h>
#include <WiFi.h>
#include <FirebaseESP32.h>
// Provide the token generation process info.
#include <addons/TokenHelper.h>
// Provide the RTDB payload printing info and other helper functions.
#include <addons/RTDBHelper.h>
/* 1. Define the WiFi credentials */
#define WIFI_SSID "Autobonics_4G"
#define WIFI_PASSWORD "autobonics@27"
// For the following credentials, see examples/Authentications/SignInAsUser/EmailPassword/EmailPassword.ino
/* 2. Define the API Key */
#define API_KEY "AIzaSyB3NltJlaUaGdHfEpJAUY6FxtXGDUktJPI"
/* 3. Define the RTDB URL */
#define DATABASE_URL "https://doctor-robo-default-rtdb.asia-southeast1.firebasedatabase.app/" //<databaseName>.firebaseio.com or <databaseName>.<region>.firebasedatabase.app
/* 4. Define the user Email and password that alreadey registerd or added in your project */
#define USER_EMAIL "device1@autobonics.com"
#define USER_PASSWORD "12345678"
// Define Firebase Data object
FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;
unsigned long sendDataPrevMillis = 0;
// Variable to save USER UID
String uid;
//Databse
String path;


unsigned long printDataPrevMillis = 0;

FirebaseData stream;
void streamCallback(StreamData data)
{
  Serial.println("NEW DATA!");

  String p = data.dataPath();

  Serial.println(p);
  // printResult(data); // see addons/RTDBHelper.h

  // Serial.println();
  FirebaseJson jVal = data.jsonObject();
  FirebaseJsonData servo1Fb;
  FirebaseJsonData servo2Fb;
  FirebaseJsonData servo3Fb;
  FirebaseJsonData isReadSensorFb;

  jVal.get(servo1Fb, "servo1");
  jVal.get(servo2Fb, "servo2");
  jVal.get(servo3Fb, "servo3");
  jVal.get(isReadSensorFb, "isReadSensor");
 

  if (servo1Fb.success)
  {
    Serial.println("Success data servo1Fb");
    pos1 = servo1Fb.to<int>();   
    myservo1.write(pos1);
  } 
  if (servo2Fb.success)
  {
    Serial.println("Success data servo2Fb");
    pos2 = servo2Fb.to<int>();   
    myservo2.write(pos2);
  } 
    if (servo3Fb.success)
  {
    Serial.println("Success data servo3Fb");
    pos3 = servo3Fb.to<int>();   
    myservo3.write(pos3);
  } 
  
}


void streamTimeoutCallback(bool timeout)
{
  if (timeout)
    Serial.println("stream timed out, resuming...\n");

  if (!stream.httpConnected())
    Serial.printf("error code: %d, reason: %s\n\n", stream.httpCode(), stream.errorReason().c_str());
}

void setup() {

  Serial.begin(115200);
  //Servo
  myservo1.attach(servoPin1);  // attaches the servo on pin 13 to the servo objec/t
  myservo2.attach(servoPin2);  // attaches the servo on pin 13 to the servo objec/t
  myservo3.attach(servoPin3);  // attaches the servo on pin 13 to the servo objec/t
 
  //WIFI
  pinMode(wifiLedPin, OUTPUT);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wi-Fi");
  unsigned long ms = millis();
  while (WiFi.status() != WL_CONNECTED)
  {
    digitalWrite(wifiLedPin, LOW);
    Serial.print(".");
    delay(300);
  }
  Serial.println();
  Serial.print("Connected with IP: ");
  digitalWrite(wifiLedPin, HIGH);
  Serial.println(WiFi.localIP());
  Serial.println();

  //FIREBASE
  Serial.printf("Firebase Client v%s\n\n", FIREBASE_CLIENT_VERSION);
  /* Assign the api key (required) */
  config.api_key = API_KEY;

  /* Assign the user sign in credentials */
  auth.user.email = USER_EMAIL;
  auth.user.password = USER_PASSWORD;

  /* Assign the RTDB URL (required) */
  config.database_url = DATABASE_URL;

  /* Assign the callback function for the long running token generation task */
  config.token_status_callback = tokenStatusCallback; // see addons/TokenHelper.h

  // Limit the size of response payload to be collected in FirebaseData
  fbdo.setResponseSize(2048);

  Firebase.begin(&config, &auth);

  // Comment or pass false value when WiFi reconnection will control by your code or third party library
  Firebase.reconnectWiFi(true);

  Firebase.setDoubleDigits(5);

  config.timeout.serverResponse = 10 * 1000;

  // Getting the user UID might take a few seconds
  Serial.println("Getting User UID");
  while ((auth.token.uid) == "") {
    Serial.print('.');
    delay(1000);
  }
  // Print user UID
  uid = auth.token.uid.c_str();
  Serial.print("User UID: ");
  Serial.println(uid);

  path = "devices/" + uid + "/reading";

//Stream setup
  if (!Firebase.beginStream(stream, "devices/" + uid + "/data"))
    Serial.printf("sream begin error, %s\n\n", stream.errorReason().c_str());

  Firebase.setStreamCallback(stream, streamCallback, streamTimeoutCallback);
}

void loop() {

  // if(isReadSensor){
  
  // }
  
    //Servo
    // runServo();
  
    //Stepper
    // runStepper();
    updateData();
}

void updateData(){
  if (Firebase.ready() && (millis() - sendDataPrevMillis > 3000 || sendDataPrevMillis == 0))
  {
    sendDataPrevMillis = millis();
    FirebaseJson json;
    json.set("d1", 0);
    json.set("d2", 1);
    json.set(F("ts/.sv"), F("timestamp"));
    Serial.printf("Set json... %s\n", Firebase.RTDB.set(&fbdo, path.c_str(), &json) ? "ok" : fbdo.errorReason().c_str());
    Serial.println("");
  }
}

// void printData(){
//   if (millis() - printDataPrevMillis > 2000 || printDataPrevMillis == 0)
//   {
//     printDataPrevMillis = millis();
//     //Print EC
//     Serial.print("EC:");
//     Serial.println(ecValue);
//   }
// }