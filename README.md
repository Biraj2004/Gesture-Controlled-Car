# ESP32 Gesture-Controlled 4WD Robot Car

A high-performance, gesture-controlled 4-wheel drive (4WD) robotic car developed using **dual ESP32 microcontrollers**, an **MPU6050 6-axis Inertial Measurement Unit (IMU)**, Espressif's proprietary **ESP-NOW connectionless wireless protocol**, and **dual L298N H-Bridge motor drivers**.

The user operates the robotic vehicle in real time by wearing a transmitter glove. As the wrist tilts, the MPU6050 captures physical orientation (Pitch and Roll). The transmitter ESP32 packages these angles and transmits them with ultra-low latency (<10 ms) via ESP-NOW to the receiver ESP32 mounted on the robot chassis. The receiver decodes the gesture commands and drives four independent 200 RPM DC geared BO motors to execute forward, reverse, turning, diagonal, and spot-rotation maneuvers.

---

## System Architecture & Visual Overview

```
                      +-------------------+
                      |   Hand Movement   |
                      +---------+---------+
                                |
                                v
                      +-------------------+
                      | MPU6050 6-Axis IMU |
                      +---------+---------+
                                | (I2C)
                                v
                     +---------------------+
                     | ESP32 Transmitter   |
                     +---------+-----------+
                                |
                                | ESP-NOW 2.4 GHz Peer-to-Peer
                                v
                     +---------------------+
                     |  ESP32 Receiver     |
                     +----+-----------+----+
                          |           |
            (Front GPIOs) |           | (Back GPIOs)
                          v           v
                  +---------------+ +---------------+
                  |  L298N Front  | |  L298N Back   |
                  +-------+-------+ +-------+-------+
                          |                 |
                  +-------+-------+ +-------+-------+
                  | FL & FR Motors| | BL & BR Motors|
                  +---------------+ +---------------+
```

---

## Key Features

- **Intuitive Hand Gesture Steering**: Control vehicle motion dynamically through wrist pitch and roll.
- **Ultra-Low Latency Wireless Link**: Uses Espressif **ESP-NOW** connectionless peer-to-peer protocol operating on 2.4 GHz band, achieving 5–15 ms response time without needing a Wi-Fi router.
- **4-Wheel Independent Drive (4WD)**: Dual L298N motor drivers independently power front and rear motor channels for maximum traction.
- **Multi-Directional Kinematics**: Supports Forward, Reverse, Left Turn, Right Turn, Diagonal Steering, Spot Turning (360° Wrist Rotate), and Neutral Instant Braking.
- **Academic Publication Suite**: Complete XeLaTeX source files, double-pass PowerShell compilation scripts, viva booklets, presentations, and a domain-agnostic **Universal XeLaTeX College Report Construction Guide**.

---

## Hardware Specification & Bill of Materials

| Component | Quantity | Description / Ratings |
| :--- | :---: | :--- |
| **ESP32 DevKit V1** | 2 | 32-bit Dual-Core 240 MHz, 520 KB SRAM, Onboard 2.4 GHz Antenna |
| **MPU6050 IMU** | 1 | 3-axis Accelerometer + 3-axis Gyroscope with I2C Interface |
| **L298N Motor Driver** | 2 | Dual H-Bridge Motor Driver, 2A per channel peak output |
| **DC Geared Motors** | 4 | 200 RPM Dual-Shaft Battery-Operated (BO) Motors |
| **Robotic Chassis** | 1 | Acrylic / Aluminum 4WD Robot Platform |
| **Power Source** | 1 | 18650 Li-ion Battery Pack (7.4V Series Configuration) |
| **Voltage Regulator / Switch** | 1 | Toggle Switch + Power Distribution Bus |
| **Jumper Wires & Breadboard** | - | High-grade male-to-female and male-to-male connection wires |

---

## Pinout Mapping & Circuit Connections

### 1. Transmitter Module (Hand Glove)

| ESP32 GPIO Pin | MPU6050 Module Pin | Function |
| :---: | :---: | :--- |
| **GPIO 21** | **SDA** | I2C Data Line |
| **GPIO 22** | **SCL** | I2C Clock Line |
| **3.3V** | **VCC** | Power Supply (3.3V) |
| **GND** | **GND** | Common Ground |

### 2. Receiver Module (Robot Chassis)

#### Front L298N Motor Driver (Front Left & Front Right Motors)
| ESP32 GPIO Pin | L298N Terminal | Function |
| :---: | :---: | :--- |
| **GPIO 32** | **ENA** | Front Motor Speed Control (PWM) |
| **GPIO 33** | **IN1** | Front Right Motor Direction 1 |
| **GPIO 25** | **IN2** | Front Right Motor Direction 2 |
| **GPIO 26** | **IN3** | Front Left Motor Direction 1 |
| **GPIO 27** | **IN4** | Front Left Motor Direction 2 |
| **GPIO 14** | **ENB** | Front Motor Speed Control (PWM) |

#### Rear L298N Motor Driver (Rear Left & Rear Right Motors)
| ESP32 GPIO Pin | L298N Terminal | Function |
| :---: | :---: | :--- |
| **GPIO 22** | **ENA** | Rear Motor Speed Control (PWM) |
| **GPIO 16** | **IN1** | Rear Right Motor Direction 1 |
| **GPIO 17** | **IN2** | Rear Right Motor Direction 2 |
| **GPIO 18** | **IN3** | Rear Left Motor Direction 1 |
| **GPIO 19** | **IN4** | Rear Left Motor Direction 2 |
| **GPIO 23** | **ENB** | Rear Motor Speed Control (PWM) |

---

## Kinematic Movement & Gesture Mapping

| Hand Gesture Orientation | Sensor Tilt State | Vehicle Response Action |
| :--- | :--- | :--- |
| **Wrist Pitch Down** | Forward Tilt | **Move Forward** |
| **Wrist Pitch Up** | Backward Tilt | **Move Reverse** |
| **Wrist Roll Left** | Left Tilt | **Turn Left** |
| **Wrist Roll Right** | Right Tilt | **Turn Right** |
| **Forward + Left** | Combined Angle | **Diagonal Left Move** |
| **Forward + Right** | Combined Angle | **Diagonal Right Move** |
| **Wrist Yaw Twist** | Rotation Angle | **Spot Turn (360° Spin)** |
| **Flat Neutral** | Horizontally Level | **Instant Stop (Neutral)** |

---

## Software & Firmware Setup

### 1. Arduino IDE Setup
1. Download and install **Arduino IDE 2.x**.
2. Go to **Preferences** and add the ESP32 Board Manager URL:
   `https://raw.githubusercontent.com/espressif/arduino-esp32/gh-pages/package_esp32_index.json`
3. Open **Board Manager** (`Tools -> Board -> Boards Manager`), search for `esp32` by Espressif, and install the package.

### 2. Required Libraries
Install the following libraries via the Library Manager (`Ctrl + Shift + I`):
- `WiFi` (Built-in ESP32 core)
- `esp_now` (Built-in ESP32 core)
- `Wire` (Built-in ESP32 core)
- `I2Cdev` (by Jeff Rowberg)
- `MPU6050` (by Jeff Rowberg)

### 3. Firmware Upload Workflow
1. **Find Receiver MAC Address**: Upload a MAC address scanner sketch to the Receiver ESP32 and open Serial Monitor (115200 baud) to record its 6-byte MAC address (e.g., `{0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF}`).
2. **Flash Transmitter Code**: Open [`Listing 4.2 ESP32 Transmitter Code.txt`](file:///e:/01.%20GitHub%20Repo%20Projects/Gesture-Controlled-Car/Listing%204.2%20ESP32%20Transmitter%20Code.txt), replace the `broadcastAddress` array with the target receiver MAC address, and upload to the Transmitter ESP32.
3. **Flash Receiver Code**: Open [`Listing 4.3 ESP32 Receiver Code.txt`](file:///e:/01.%20GitHub%20Repo%20Projects/Gesture-Controlled-Car/Listing%204.3%20ESP32%20Receiver%20Code.txt) and upload to the Receiver ESP32.

---

## XeLaTeX Academic Publication & Report Guide Suite

This repository includes a complete academic documentation pipeline tailored for MAKAUT and university engineering submission standards.

### Primary Academic Deliverables
- **Academic Project Report**: [`Gesture-Controlled-Car-MiniProject.tex`](file:///e:/01.%20GitHub%20Repo%20Projects/Gesture-Controlled-Car/Gesture-Controlled-Car-MiniProject.tex) (compiles to [`Gesture-Controlled-Car-MiniProject.pdf`](file:///e:/01.%20GitHub%20Repo%20Projects/Gesture-Controlled-Car/Gesture-Controlled-Car-MiniProject.pdf)).
- **Viva Voce Examination Booklet**: [`Gesture-Controlled-Car-VivaBooklet.tex`](file:///e:/01.%20GitHub%20Repo%20Projects/Gesture-Controlled-Car/Gesture-Controlled-Car-VivaBooklet.tex) (compiles to [`Gesture-Controlled-Car-VivaBooklet.pdf`](file:///e:/01.%20GitHub%20Repo%20Projects/Gesture-Controlled-Car/Gesture-Controlled-Car-VivaBooklet.pdf)).

### Universal Guides & Core Specifications
- **Universal XeLaTeX Report Construction Guide**: [`biraj-xelatex-universal-report-guide.md`](file:///e:/01.%20GitHub%20Repo%20Projects/Gesture-Controlled-Car/biraj-xelatex-universal-report-guide.md) — A domain-agnostic, step-by-step master guide for humans and AI agents (such as Antigravity / Gemini) to build publication-grade, professionally accepted academic project reports on **ANY subject or domain** for **ANY college or university worldwide** from absolute scratch. Features:
  - Zero-to-PDF From Scratch Workflow
  - Automatic MiKTeX Detection & `winget` Silent Installer
  - Root `images/` Directory Management & Native Insertion
  - Dynamic Chapter-Relative Captioning & Figure Numbering
  - Dynamic Multi-Level Heading Scaling Algorithm
  - Mandatory **Conclusion and Future Scope** & **10+ Reference Bibliography** Templates
- **Baseline XeLaTeX Specifications**: [`biraj-xelatex-general-specs.md`](file:///e:/01.%20GitHub%20Repo%20Projects/Gesture-Controlled-Car/biraj-xelatex-general-specs.md) — Core rules for 12pt body font, 1.2 line height (`\setstretch{1.2}`), left-aligned non-justified body text (`\raggedright`), list-only paragraph indentation (`parindent=0pt`), full-grid tables, inline code pills (`RGB(225,228,233)`), breakable `tcolorbox` code listings, and all-black hyperlinks with purple citations.

### Compiling the Reports
Open PowerShell in the workspace root and run:
```powershell
.\compile_xelatex.ps1
```
*Note*: [`compile_xelatex.ps1`](file:///e:/01.%20GitHub%20Repo%20Projects/Gesture-Controlled-Car/compile_xelatex.ps1) automatically detects `xelatex`, handles file locks, executes a double-pass compilation, and cleans up temporary build artifacts upon completion. If `xelatex` is not installed, the script automatically triggers `winget` to install MiKTeX silently.

---

## Repository Directory Structure

```
Gesture-Controlled-Car/
│
├── images/                                       # High-resolution hardware & schematic assets
│   ├── CGEC-Logo-colorful.jpg                    # Institution logo
│   ├── block-diagram.png                         # System architecture diagram
│   ├── comp-img1.jpeg                            # Transmitter assembly photo
│   ├── comp-img2.jpeg                            # Receiver assembly photo
│   ├── final_transmitter.png                     # Transmitter glove detail
│   ├── final_receiver_on_car.png                 # Assembled 4WD robot car photo
│   ├── l298n_motordriver_pinout_bb.png           # L298N pinout schematic
│   └── img1.jpeg - img5.jpeg                      # Component & chassis close-ups
│
├── Listing 4.2 ESP32 Transmitter Code.txt        # Complete Transmitter firmware code
├── Listing 4.3 ESP32 Receiver Code.txt           # Complete Receiver firmware code
│
├── Gesture-Controlled-Car-MiniProject.tex         # Main Academic Project Report (XeLaTeX)
├── Gesture-Controlled-Car-MiniProject.pdf         # Compiled Mini Project Report PDF
├── Gesture-Controlled-Car-VivaBooklet.tex         # Viva Voce Examination Guide (XeLaTeX)
├── Gesture-Controlled-Car-VivaBooklet.pdf         # Compiled Viva Booklet PDF
│
├── biraj-xelatex-universal-report-guide.md      # Universal Report Construction Guide (Markdown)
├── biraj-xelatex-general-specs.md                # XeLaTeX formatting reference rules
│
├── Gesture-Controlled-Car-Presentation-Final.pptx# Project Defense Slides (PPTX)
├── Gesture-Controlled-Car-Presentation.pptx      # Preliminary Presentation Slides (PPTX)
├── 3rd Year Mini Project Report Format.docx      # University formatting template
│
├── compile_xelatex.ps1                           # PowerShell double-pass compile script
├── BUILD_GUIDE.md                                # Report customization & layout guide
├── Guide-Readme.md                               # Hardware assembly & firmware guide
└── README.md                                     # Main repository documentation
```

---

## Troubleshooting

| Issue | Root Cause | Solution |
| :--- | :--- | :--- |
| **Car Not Responding** | Incorrect MAC address in transmitter | Re-scan receiver MAC address and update `broadcastAddress` array. |
| **Motors Spin Backwards** | Swapped polarity on driver outputs | Swap motor wires on L298N terminal blocks or invert logic in receiver sketch. |
| **ESP32 Resetting / Brownout** | Insufficient current supply | Ensure 18650 batteries are fully charged (7.4V min); do not power motors from ESP32 5V pin. |
| **XeLaTeX Build Lock Error** | PDF viewer holding open file handle | Close the PDF in Adobe Reader/browser before running `.\compile_xelatex.ps1`. |

---

## Authors & Academic Credits

- **Sohan Ghosh** (Roll No. 34900323050)
- **Sarupya Guha** (Roll No. 34900323046)
- **Aushi Sarkar** (Roll No. 34900323011)
- **Anupam Dutta** (Roll No. 34900323003)
- **Joydip Das** (Roll No. 34900323020)

**Under the Guidance of**: Dr. Gautam Das  
**Department**: Electronics & Communication Engineering  
**Institution**: Cooch Behar Government Engineering College (Affiliated with MAKAUT, West Bengal)

---

## License

This repository and all associated firmware, schematics, and documentation are open-source and released under the [MIT License](LICENSE).
