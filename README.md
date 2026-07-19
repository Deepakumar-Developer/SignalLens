# SignalLens

## AR-Based Wireless Access Point Localization and Signal Visualization System

### Overview

**SignalLens** is an Augmented Reality (AR) mobile application that enables users to visualize and locate wireless network infrastructure in real time. Unlike traditional Wi-Fi analyzer applications that only display technical information such as SSID, BSSID, and RSSI in a list, SignalLens transforms these invisible radio signals into intuitive AR overlays, allowing users to "see" nearby wireless access points through their smartphone camera.

The application continuously scans nearby Wi-Fi networks, analyzes Received Signal Strength Indicator (RSSI) values, groups multiple radios belonging to the same physical Access Point (AP), estimates the AP's location using RSSI-based distance estimation and trilateration, and visualizes the result in an AR environment. This helps network engineers quickly identify access point locations, detect weak coverage areas, troubleshoot connectivity issues, and optimize Wi-Fi deployments.

### Key Features

* Real-time Wi-Fi scanning (SSID, BSSID, RSSI, Frequency)
* Intelligent clustering of multiple SSIDs belonging to the same Access Point
* RSSI-based distance estimation
* Access Point localization using trilateration
* Augmented Reality visualization of estimated AP locations
* Signal strength and coverage analysis
* Support for Wi-Fi site surveys and network troubleshooting

### Technologies

* **Flutter** – Cross-platform mobile application
* **ARCore** – Augmented Reality tracking and visualization
* **Wi-Fi Scan API** – Wireless network discovery
* **RSSI Analysis & Trilateration** – Access Point localization
* **Dart** – Application development

### Applications

SignalLens is designed for network engineers, IT administrators, educational institutions, enterprises, smart buildings, warehouses, and researchers who require an efficient and intuitive solution for wireless infrastructure visualization, Wi-Fi site surveys, and network optimization.
