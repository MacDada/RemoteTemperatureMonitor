#include <OneWire.h>
#include <DS18B20.h>

// kiedy ma sie wlaczyc alaram?
#define TEMP_TOO_LOW_THRESHOLD 20
#define TEMP_TOO_HIGH_THRESHOLD 22

// numery pinow
#define ONEWIRE_PIN 2
#define OK_LED_PIN 3
#define ALARM_LED_PIN 13
#define BUTTON_PIN 12
#define SPEAKER_PIN 6


bool alarmIsRinging = false;
bool alarmIsSilenced = false;

// Adres czujnika temperatury
byte address[8] = {0x28, 0xDE, 0x91, 0xC0, 0x6, 0x0, 0x0, 0x5B};

OneWire onewire(ONEWIRE_PIN);
DS18B20 sensors(&onewire);

void setup() {
  pinMode(ALARM_LED_PIN, OUTPUT);
  pinMode(OK_LED_PIN, OUTPUT);
  pinMode(BUTTON_PIN, INPUT);

  while (!Serial);
  Serial.begin(9600);

  sensors.begin();
  sensors.request(address);
}

bool isTemperatureOutOfBoundries(float temperature) {
  return temperature <= TEMP_TOO_LOW_THRESHOLD
      || temperature >= TEMP_TOO_HIGH_THRESHOLD;
}

void logTemperature(float temperature) {
  Serial.print(temperature);
  Serial.println(F(" 'C"));
}

void makeAlarmSound() {
  tone(SPEAKER_PIN, 480);
  delay(500);
  noTone(SPEAKER_PIN);
  delay(200);
}

void loop() {
  if (sensors.available()) {
    float temperature = sensors.readTemperature(address);

    logTemperature(temperature);

    if (isTemperatureOutOfBoundries(temperature)) {
      alarmIsRinging = true;
    } else {
      alarmIsSilenced = false;
      alarmIsRinging = false;
    }

    sensors.request(address);
  }

  if (HIGH == digitalRead(BUTTON_PIN)) {
    alarmIsSilenced = true;
  }

  if (alarmIsRinging) {
    digitalWrite(OK_LED_PIN, LOW);
    digitalWrite(ALARM_LED_PIN, HIGH);

    if (!alarmIsSilenced) {
      makeAlarmSound();
    }
  } else {
    digitalWrite(ALARM_LED_PIN, LOW);
    noTone(SPEAKER_PIN);
    digitalWrite(OK_LED_PIN, HIGH);
  }
}
