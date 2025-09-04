AcuDrop - Smart Eye Drop Assistant
AcuDrop is a comprehensive solution designed to empower patients, particularly the elderly and those with dexterity challenges, to manage their eye drop medication with confidence and precision. This hackathon project combines a smart hardware cap, a feature-rich mobile application, and AI-powered analytics to improve medication adherence and facilitate better communication between patients and doctors.

📜 Table of Contents
The Problem

Our Solution: A Hardware-First Approach

⚙️ Hardware Design & Prototyping

🤖 IoT & System Architecture

🛠️ Tech Stack

🎨 3D Assets & Project Status

📱 Mobile App Setup Guide

🧠 Machine Learning Integration & Credits

🎯 The Problem
Administering eye drops can be a significant challenge for many individuals. Difficulties in aiming the bottle, dispensing a single drop, and maintaining a steady hand can lead to wasted medication, incorrect dosages, and increased anxiety for patients requiring regular treatment for conditions like glaucoma.

💡 Our Solution: A Hardware-First Approach
AcuDrop tackles these physical challenges with a custom-designed, IoT-enabled smart cap that automates the most difficult parts of administering eye drops. The device is designed to be ergonomic, reusable, and intuitive. It connects via Bluetooth to a companion mobile app for tracking and scheduling, but its primary function is to provide physical assistance.

⚙️ Hardware Design & Prototyping
The core of the AcuDrop project is our 3D-printed prototype, which consists of two main electromechanical systems. All 3D models were procedurally generated in Blender using Python scripts.

1. The Biomimetic Stabilizing Gimbal
To guarantee a perfect drop every time, the device features a novel gimbal system inspired by the ciliary muscles of the human eye. This system actively aims the dropper nozzle, making micro-adjustments based on real-time eye tracking data. Even if the device is pointed generally at the face (e.g., cheeks, nose, or eyebrows), the gimbal will fine-tune the nozzle's position to be directly over the eye.

Mechanism: The gimbal is composed of V-shaped flaps that gently rest on the user's face. Between these flaps, a small fiber cloth is suspended. A long-throw linear servo motor contracts and extends this cloth, dynamically changing the position of the nozzle with incredible precision.

Sensing: An MPU-6050 gyroscope provides initial stability, while the primary aiming data comes from the integrated eye-tracking system.

How It Works:

(Space for a diagram/image showing the V-flaps, fiber cloth, and linear servo)

Label 1 (Eye Tracking Input): The AI model provides coordinates of the eye's position.

Label 2 (Linear Servo): The ESP8266 translates these coordinates into precise movements for the linear servo.

Label 3 (Fiber Cloth Actuation): The servo's push/pull action on the cloth minutely adjusts the nozzle's angle.

Label 4 (Nozzle Alignment): The nozzle is perfectly aligned over the eye, ready for dispensing.

2. The Precision Dosing Mechanism
To solve the problem of dispensing too much medication, we integrated a high-tech micropump.

Mechanism: When the user is ready, a button on the device is pressed. This activates a piezoelectric diaphragm micropump.

Actuation: The micropump delivers a single, perfectly metered drop of liquid through the nozzle. This system is far more accurate than manually squeezing a bottle.

3. Electronic Components
Microcontroller: ESP8266. We chose this efficient and cost-effective microcontroller for its reliability and built-in Wi-Fi, which is used for on-demand communication with the mobile app to conserve power.

Sensors: An MPU-6050 for initial orientation and data from the eye-tracking camera feed.

Power: A rechargeable 5V Lithium-Ion battery. The device remains in a low-power state and only establishes a full connection with the app when required (e.g., syncing dose history or updating schedules), maximizing battery life.

🤖 IoT & System Architecture
The device operates as a Wi-Fi peripheral, communicating its status to the Flutter mobile app on-demand.

Device (ESP8266) -> (WiFi, on-demand) -> Firebase Cloud <- (WiFi) <- Flutter App

The ESP8266 firmware handles all real-time sensor reading and motor/pump control. The Flutter app is used for initial setup, scheduling, and viewing historical data.

🛠️ Tech Stack
Category

Technology

Microcontroller

ESP8266

Pump

Piezoelectric Diaphragm Micropump

Sensors

MPU-6050 (Gyro/Accel)

Actuators

Linear Servo Motor

Mobile App

Flutter, Dart, Provider

Backend

Firebase (Authentication, Cloud Firestore)

3D Prototyping

Blender, Python Scripting

🎨 3D Assets & Project Status
The 3D models of the AcuDrop device were designed and assembled in Blender. The Python scripts used to generate the internal components are included in the 3d_assets/source_files directory.

Project Limitations: Due to the time constraints of the hackathon, our focus was on demonstrating the core internal mechanisms, especially the innovative gimbal system. The following components are part of the future vision but are not yet implemented in the 3D model:

A complete outer housing for the device.

The physical "self-medicate" button.

The battery charging port and circuitry.

📱 Mobile App Setup Guide
While the core innovation is the hardware, the Flutter mobile app is required for scheduling and data tracking.

Step 1: Connect to Firebase
The app requires a Firebase backend. Follow the setup guide in the flutter_app directory to:

Create a Firebase project.

Run flutterfire configure to link the app.

Enable Authentication and Firestore services.

Set up the necessary Firestore security rules and indexes as prompted by the app's error logs on first run.

Step 2: Run the App
Connect an emulator or device and run the app from the flutter_app directory:

flutter run
