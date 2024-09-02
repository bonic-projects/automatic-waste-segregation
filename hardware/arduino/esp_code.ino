#include <NewPing.h>
#include <ESP32Servo.h>

#define drytrig 27
#define dryecho 26
#define wettrig 25
#define wetecho 33
#define metalecho 35
#define metaltrig 32
#define starttrig 18
#define startecho 19

#define wet 34
#define sliderPin 2
#define flapPin 16
#define metal 23

void mmetald();
void mdry();
void mwetd();

#define maxdistance 200

bool isAutomatic = false;
int ddist = 0, wdist = 0, mdist = 0;

NewPing sonardry(drytrig, dryecho, maxdistance);
NewPing sonarwet(wettrig, wetecho, maxdistance);
NewPing sonarmetal(metaltrig, metalecho, maxdistance);
NewPing sonarstart(starttrig, startecho, maxdistance);

Servo flap;
Servo slider;

//Firebase
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
#define API_KEY "AIzaSyCHqjJoe1X8kVpswvCQKa81Cz7v8RpRC44"
/* 3. Define the RTDB URL */
#define DATABASE_URL "https://autowaste-41d5a-default-rtdb.firebaseio.com/"
//<databaseName>.firebaseio.com or <databaseName>.<region>.firebasedatabase.app
/* 4. Define the user Email and password that alreadey registerd or added in your project */
#define USER_EMAIL "device@gmail.com"
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





FirebaseData stream;
void streamCallback(StreamData data) {
  Serial.println("NEW DATA!");

  String p = data.dataPath();

  Serial.println(p);
  printResult(data);  // see addons/RTDBHelper.h

  FirebaseJson jVal = data.jsonObject();
  FirebaseJsonData direction;
  FirebaseJsonData isAuto;

  jVal.get(direction, "direction");
  jVal.get(isAuto, "isAuto");

  if (direction.success) {
    Serial.println("Success data direciton");
    String value = direction.to<String>();
    if (value == "m") {
      mmetald();
    }
    if (value == "d") {
      mdry();
    }
    if (value == "w") {
      mwetd();
    }
  }

  if (isAuto.success) {
    Serial.println("Succes data is automatic");
    bool value = isAuto.to<bool>();
    isAutomatic = value;
  }
}

void streamTimeoutCallback(bool timeout) {
  if (timeout)
    Serial.println("stream timed out, resuming...\n");

  if (!stream.httpConnected())
    Serial.printf("error code: %d, reason: %s\n\n", stream.httpCode(), stream.errorReason().c_str());
}


void setup() {
  Serial.begin(115200);
  flap.attach(flapPin);
  slider.attach(sliderPin);

  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wi-Fi");
  unsigned long ms = millis();
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(300);
  }
  Serial.println();
  Serial.print("Connected with IP: ");
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
  config.token_status_callback = tokenStatusCallback;  // see addons/TokenHelper.h

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

  if (!Firebase.beginStream(stream, "devices/" + uid + "/data"))
    Serial.printf("sream begin error, %s\n\n", stream.errorReason().c_str());

  Firebase.setStreamCallback(stream, streamCallback, streamTimeoutCallback);
}

void updateData() {
  if (Firebase.ready() && (millis() - sendDataPrevMillis > 1000 || sendDataPrevMillis == 0)) {
    sendDataPrevMillis = millis();
    FirebaseJson json;
    json.set("dry", ddist);
    json.set("metal", mdist);
    json.set("wet", wdist);
    json.set(F("ts/.sv"), F("timestamp"));
    Serial.printf("Set data with timestamp... %s\n", Firebase.setJSON(fbdo, path.c_str(), json) ? fbdo.to<FirebaseJson>().raw() : fbdo.errorReason().c_str());
    Serial.println("");
  }
}

void readdistance() {
  ddist = sonardry.ping_cm();
  wdist = sonarwet.ping_cm();
  mdist = sonarmetal.ping_cm();
  Serial.print("Wet: ");
  Serial.println(wdist);
  Serial.print("Metal: ");
  Serial.println(mdist);
  Serial.print("Dry: ");
  Serial.println(ddist);
}
void automatic() {
  Serial.println("Automatic mode turned on !");
  normal();
  int sdist = sonarstart.ping_cm();
  Serial.print("Distance:");
  Serial.println(sdist);
  if (sdist < 8 && sdist > 2) {
    delay(3000);  //delaying for detecting the meterial
    int metalStatus = digitalRead(metal);
    int wetValue = analogRead(wet);
    Serial.print("Metal Status:");
    Serial.println(metalStatus);
    Serial.print("WetValue:");
    Serial.print(wetValue);
    if (metalStatus == 1) {
      metald();
      Serial.println("Automatic metal ");
    } else if (wetValue < 4000) {
      Serial.println("Automatic wet ");
      wetd();
    } else {
      Serial.println("Automatic dry ");
      dry();
    }
  }
}


void metald() {       //slider start position is 90 and flap start position is 0
  slider.write(135);  //slider open
  Serial.println("Automatic metal slider open");
  delay(1000);
  flap.write(90);  //flap open
  Serial.println("Automatic metal flap open");
  delay(2000);
  // slider.write(130);  //slider starts to clean
  // delay(100);
  // slider.write(135);
  // delay(100);
  slider.write(90);  //slider close
  Serial.println("Automatic metal slider close");
  delay(500);
  flap.write(0);  //flap close
  Serial.println("Automatic metal flap close");
}

void wetd() {        //slider start position is 90 and flap start position is 0
  slider.write(90);  //slider open
  Serial.println("Automatic wetd slider open");
  delay(1000);
  flap.write(90);  //flap open
  Serial.println("Automatic wetd flap open");
  delay(2000);
  // slider.write(95);  //slider starts to clean
  // delay(100);
  // slider.write(90);
  // delay(100);
  Serial.println("Automatic wetd slider close");
  slider.write(90);  //slider close
  delay(500);
  flap.write(0);  //flap close
  Serial.println("Automatic wetd flap close");
}

void dry() {         //slider start position is 90 and flap start position is 0
  slider.write(50);  //slider open
  delay(1000);
  flap.write(120);  //flap open
  delay(2000);
  // slider.write(55);  //slider starts to clean
  // delay(100);
  // slider.write(50);
  // delay(100);
  slider.write(90);  //slider close
  Serial.println("Automatic dry slider close");
  delay(500);
  flap.write(0);  //flap close
  Serial.println("Automatic dry flap close");
}
void mdry() {        //slider start position is 90 and flap start position is 0
  slider.write(50);  //slider open
  Serial.println("manual-dry slider");
  delay(1000);
  flap.write(90);
  Serial.println("Manual-dry flap");  //flap open
  delay(2000);
  // slider.write(55);  //slider starts to clean
  // delay(100);
  // slider.write(50);
  // delay(100);
  //  slider.write(90);  //slider close
  //  delay(500);
  //  flap.write(0);  //flap close
}

void mwetd() {       //slider start position is 90 and flap start position is 0
  slider.write(90);  //slider open
  Serial.println("WetSlider-90");
  delay(1000);
  flap.write(90);
  Serial.println("manual-wet-flap");  //flap open
  delay(2000);
  // slider.write(95);  //slider starts to clean
  // delay(100);
  // slider.write(90);
  // delay(100);
  //  slider.write(90);  //slider close
  //  delay(500);
  //  flap.write(0);  //flap close
}   
  void mmetald() {       //slider start position is 90 and flap start position is 0
    slider.write(135);  //slider open
    Serial.println("Metal-slider 135");
    delay(1000);
    flap.write(90);  //flap open
    delay(2000);
    Serial.println("Metal-flap");
    // slider.write(130);  //slider starts to clean
    // delay(100);
    // slider.write(135);
    // delay(100);
  //  slider.write(90);  //slider close
  //  delay(500);
  //  flap.write(0);  //flap close
  }
  void normal()
  {
    Serial.println("Normal mode");
    slider.write(90);  //slider close
    delay(500);
    flap.write(0);  //flap close
  }
  void loop() {
    readdistance();
    updateData();
    if (isAutomatic) {
      automatic();
    }
  }
