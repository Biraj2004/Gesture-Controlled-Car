# ESP32 Gesture Controlled 4WD Robot Car

A gesture-controlled 4-wheel robotic car built using two ESP32 development boards, an MPU6050 motion sensor, ESP-NOW wireless communication, dual L298N motor drivers, and four DC geared motors.

The transmitter ESP32 reads hand gestures using the MPU6050 and wirelessly sends the orientation data to the receiver ESP32 using ESP-NOW. The receiver interprets these gestures and controls the four motors accordingly.

---

## Features

- Gesture-based wireless control
- ESP-NOW communication (No Wi-Fi router required)
- 4WD robot drive
- Forward, Backward, Left, Right movement
- Diagonal movement
- Spot turning (Left/Right rotation)
- Real-time wireless response
- Low latency communication
- Modular design

---

# Hardware Requirements

| Component | Quantity |
|------------|----------|
| ESP32 Dev Board | 2 |
| MPU6050 | 1 |
| L298N Motor Driver | 2 |
| DC Geared Motor | 4 |
| Mecanum Wheels / Normal Wheels | 4 |
| 18650 Battery Pack (7.4V–12V) | 1 |
| Jumper Wires | As Required |
| Robot Chassis | 1 |
| Switch | 1 |

---

# Software Requirements

- Arduino IDE 2.x
- ESP32 Board Package
- ESP-NOW Library
- MPU6050 Library (Jeff Rowberg)
- I2Cdev Library

---

# Libraries Used

Install the following libraries using the Arduino Library Manager:

```
esp_now
WiFi
Wire
I2Cdev
MPU6050
```

---

# Working Principle

## Transmitter

1. Reads MPU6050 orientation.
2. Calculates:
   - Pitch
   - Roll
   - Yaw
3. Maps values between 0–254.
4. Sends data via ESP-NOW.

## Receiver

1. Receives ESP-NOW packet.
2. Decodes gesture.
3. Determines robot movement.
4. Controls two L298N drivers.
5. Drives four motors.

---

# Robot Movements

| Gesture | Robot Action |
|----------|--------------|
| Tilt Forward | Move Forward |
| Tilt Backward | Move Backward |
| Tilt Left | Move Left |
| Tilt Right | Move Right |
| Forward + Left | Diagonal Left |
| Forward + Right | Diagonal Right |
| Backward + Left | Reverse Left |
| Backward + Right | Reverse Right |
| Rotate Wrist Left | Rotate Left |
| Rotate Wrist Right | Rotate Right |
| Neutral Position | Stop |

---

# Pin Connections

## Front L298N

| ESP32 GPIO | L298N |
|------------|--------|
| GPIO32 | ENA |
| GPIO33 | IN1 |
| GPIO25 | IN2 |
| GPIO26 | IN3 |
| GPIO27 | IN4 |
| GPIO14 | ENB |

---

## Back L298N

| ESP32 GPIO | L298N |
|------------|--------|
| GPIO22 | ENA |
| GPIO16 | IN1 |
| GPIO17 | IN2 |
| GPIO18 | IN3 |
| GPIO19 | IN4 |
| GPIO23 | ENB |

---

# Motor Connections

## Front Driver

| Motor | L298N Output |
|---------|--------------|
| Front Right | OUT1 & OUT2 |
| Front Left | OUT3 & OUT4 |

## Back Driver

| Motor | L298N Output |
|---------|--------------|
| Back Right | OUT1 & OUT2 |
| Back Left | OUT3 & OUT4 |

---

# Power Connections

Battery Positive
→ Both L298N 12V Pins

Battery Negative
→ Both L298N GND

ESP32 GND
→ L298N GND (Common Ground)

---

# Folder Structure

```
ESP32-Gesture-Controlled-Robot/
│
├── Receiver/
│   └── Receiver.ino
│
├── Transmitter/
│   └── Transmitter.ino
│
├── Images/
│   ├── Circuit_Diagram.png
│   ├── Wiring.png
│   └── Robot.jpg
│
├── README.md
└── LICENSE
```

---

# Installation

1. Install Arduino IDE.
2. Install ESP32 Board Package.
3. Install all required libraries.
4. Upload the transmitter code to the transmitter ESP32.
5. Upload the receiver code to the receiver ESP32.
6. Replace the receiver MAC address in the transmitter code.
7. Assemble the robot.
8. Power both ESP32 boards.
9. Start controlling the robot using hand gestures.

---

# Troubleshooting

## Robot Not Moving

- Verify wiring connections.
- Check ESP32 MAC address.
- Ensure common ground between ESP32 and L298N.
- Verify battery voltage.
- Check motor polarity.
- Ensure ESP-NOW pairing is successful.

---

## ESP-NOW Not Working

- Confirm correct MAC address.
- Ensure both ESP32 boards are in STA mode.
- Verify ESP-NOW initialization.
- Check Serial Monitor for transmission status.

---

## Motors Rotating in Wrong Direction

Swap motor wires or reverse the corresponding motor logic in the receiver code.

---

## Motors Not Running

- Check ENA and ENB connections.
- Verify battery voltage.
- Ensure L298N power LED is ON.
- Test motors individually.

---

# Future Improvements

- Replace L298N with TB6612FNG MOSFET driver.
- Add obstacle avoidance.
- Add ultrasonic sensors.
- Add line following mode.
- Add autonomous navigation.
- Integrate camera module.
- Mobile App control.
- ROS compatibility.

---

# Applications

- Educational Robotics
- Gesture-Controlled Robot
- IoT Projects
- Warehouse Automation
- Robotics Competitions
- Embedded Systems Learning

---

# Author

**Sohan Ghosh**

B.Tech Electronics & Communication Engineering

Cooch Behar Government Engineering College

---

# License

This project is open-source and available under the MIT License.