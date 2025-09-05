# **AcuDrop \- Smart Eye Drop Assistant**

Hackathon project made by [Krithik Raghavendar](https://github.com/KrithikRaghavendar), [Hari](https://github.com/rougeDAG), Mithiiren T, and [Raagul](https://github.com/RaagulG865)

**AcuDrop** is a comprehensive solution designed to empower patients, particularly the elderly and those with dexterity challenges, to manage their eye drop medication with confidence and precision. This hackathon project combines a smart hardware cap, a feature-rich mobile application, and AI-powered analytics to improve medication adherence and facilitate better communication between patients and doctors.

---

## **📜 Table of Contents**

* [The Problem](https://www.google.com/search?q=https://github.com/rougeDAG/VMedithon_2025_HackMakers_Rising/blob/main/README.md%23-the-problem)  
* [Our Solution: A Hardware-First Approach](https://www.google.com/search?q=https://github.com/rougeDAG/VMedithon_2025_HackMakers_Rising/blob/main/README.md%23-our-solution-a-hardware-first-approach)  
* [⚙️ Hardware Design & Prototyping](https://github.com/rougeDAG/VMedithon_2025_HackMakers_Rising/blob/main/README.md#%EF%B8%8F-hardware-design--prototyping)  
* [🤖 IoT & System Architecture](https://github.com/rougeDAG/VMedithon_2025_HackMakers_Rising/blob/main/README.md#-iot--system-architecture)  
* [🛠️ Tech Stack](https://github.com/rougeDAG/VMedithon_2025_HackMakers_Rising/blob/main/README.md#%EF%B8%8F-tech-stack)
* [⚙️ AcuDrop Gimbal Mechanism Explained](https://github.com/rougeDAG/VMedithon_2025_HackMakers_Rising/blob/main/README.md#%EF%B8%8F-acudrop-gimbal-mechanism-explained)
* [🎨 3D Assets & Project Status](https://github.com/rougeDAG/VMedithon_2025_HackMakers_Rising/blob/main/README.md#-3d-assets--project-status)  
* [📱 Mobile App Setup Guide](https://github.com/rougeDAG/VMedithon_2025_HackMakers_Rising/blob/main/README.md#-mobile-app-setup-guide)  
* [🧠 Machine Learning Integration & Credits](https://github.com/rougeDAG/VMedithon_2025_HackMakers_Rising/blob/main/README.md#-machine-learning-integration--credits)  
 

---



## **🎯 The Problem**

Administering eye drops can be a significant challenge for many individuals. Difficulties in aiming the bottle, dispensing a single drop, and maintaining a steady hand can lead to wasted medication, incorrect dosages, and increased anxiety for patients requiring regular treatment for conditions like glaucoma.

## **💡 Our Solution: A Hardware-First Approach**

AcuDrop tackles these physical challenges with a custom-designed, IoT-enabled smart cap that automates the most difficult parts of administering eye drops. The device is designed to be ergonomic, reusable, and intuitive. It connects via Bluetooth to a companion mobile app for tracking and scheduling, but its primary function is to provide physical assistance.

---

## **⚙️ Hardware Design & Prototyping**

The core of the AcuDrop project is our 3D-printed prototype, which consists of two main electromechanical systems. All 3D models were procedurally generated in Blender using Python scripts.

### **1\. The Biomimetic Stabilizing Gimbal**

To guarantee a perfect drop every time, the device features a novel gimbal system inspired by the ciliary muscles of the human eye. This system actively aims the dropper nozzle, making micro-adjustments based on real-time eye tracking data. Even if the device is pointed generally at the face (e.g., cheeks, nose, or eyebrows), the gimbal will fine-tune the nozzle's position to be directly over the eye.

* **Mechanism:** The gimbal is composed of V-shaped flaps that gently rest on the user's face. Between these flaps, a small fiber cloth is suspended. A long-throw linear servo motor contracts and extends this cloth, dynamically changing the position of the nozzle with incredible precision.  
* **Sensing:** An **MPU-6050** gyroscope provides initial stability, while the primary aiming data comes from the integrated eye-tracking system.  
* **How It Works:**  
  * *(Space for a diagram/image showing the V-flaps, fiber cloth, and linear servo)*  
  * **Label 1 (Eye Tracking Input):** The AI model provides coordinates of the eye's position.  
  * **Label 2 (Linear Servo):** The ESP8266 translates these coordinates into precise movements for the linear servo.  
  * **Label 3 (Fiber Cloth Actuation):** The servo's push/pull action on the cloth minutely adjusts the nozzle's angle.  
  * **Label 4 (Nozzle Alignment):** The nozzle is perfectly aligned over the eye, ready for dispensing.

### **2\. The Precision Dosing Mechanism**

To solve the problem of dispensing too much medication, we integrated a high-tech micropump.

* **Mechanism:** When the user is ready, a button on the device is pressed. This activates a **piezoelectric diaphragm micropump**.  
* **Actuation:** The micropump delivers a single, perfectly metered drop of liquid through the nozzle. This system is far more accurate than manually squeezing a bottle.

### **3\. Electronic Components**

* **Microcontroller:** **ESP8266**. We chose this efficient and cost-effective microcontroller for its reliability and built-in Wi-Fi, which is used for on-demand communication with the mobile app to conserve power.  
* **Sensors:**  
  * **Camera Module:** A small camera provides the video feed for the eye-tracking model.  
  * **MPU-6050:** For initial orientation and stability data.  
* **Actuators:**  
  * **Long Throw Linear Servo:** Controls the gimbal mechanism with high precision.  
  * **Piezoelectric Micropump:** Dispenses a single, accurate fluid dose.  
* **Power:** A rechargeable **5V Lithium-Ion battery**. The device remains in a low-power state and only establishes a full connection with the app when required (e.g., syncing dose history or updating schedules), maximizing battery life.

---

## **🤖 IoT & System Architecture**

The device operates as a Wi-Fi peripheral, communicating its status to the Flutter mobile app on-demand.

**Device (ESP8266) \-\> (WiFi, on-demand) \-\> Firebase Cloud \<- (WiFi) \<- Flutter App**

The ESP8266 firmware handles all real-time sensor reading and motor/pump control. The Flutter app is used for initial setup, scheduling, and viewing historical data.

## **🛠️ Tech Stack**

| Category | Technology |
| :---- | :---- |
| **Electronics** | ESP8266, MPU-6050, Long Throw Linear Servo, Piezoelectric Micropump |
| **Mobile App** | Flutter, Dart, Provider |
| **Backend** | Firebase (Authentication, Cloud Firestore) |
| **3D Prototyping** | Blender, Python Scripting |

## 

---
## **⚙️ AcuDrop Gimbal Mechanism Explained**

### **Labeled Components:** ###
1.	Long-Throw Linear Servo: This is the actuator that drives the entire system. Its black slider moves vertically (up and down in this orientation) based on signals from the microcontroller.
2.	V-Shaped Flaps: These are the two main arms of the gimbal. They are designed to be flexible and rest gently on the user's face, providing a stable frame of reference.
3.	Flexible Fiber Cloth: This is the "muscle" of the gimbal. It is strung between the two flaps, and the servo's arm is attached to its center. The nozzle of the eye dropper would be mounted to this cloth.
   
### **How the Mechanism Moves** ###
The system works by converting the linear up-and-down motion of the servo into a precise contraction and expansion of the V-flaps, which in turn aims the nozzle.
A) **Contraction** (Aiming the Nozzle Down)
1.	Signal: The eye-tracking model determines the nozzle needs to aim lower.
2.	Actuation: The microcontroller tells the Long-Throw Linear Servo (1) to EXTEND its arm (move UP).
3.	Movement: As the servo arm moves up, it pushes the center of the Flexible Fiber Cloth (3) upwards. This increased tension pulls the tips of the V-Shaped Flaps (2) inwards, causing them to CONTRACT or move closer together.
4.	Result: The nozzle, which is mounted on the cloth, is tilted downwards, precisely aiming the drop.
B)  **Expansion** (Aiming the Nozzle Up)
1.	Signal: The eye-tracking model determines the nozzle needs to aim higher.
2.	Actuation: The microcontroller tells the Long-Throw Linear Servo (1) to RETRACT its arm (move DOWN).
3.	Movement: As the servo arm moves down, it pulls the center of the Flexible Fiber Cloth (3) downwards. This releases tension on the V-Shaped Flaps (2), allowing them to EXPAND or move apart.
4.	Result: The nozzle, mounted on the cloth, is tilted upwards.
This elegant push-pull system, happening in fractions of a second, allows the device to make continuous, minute adjustments to ensure the eye drop is delivered perfectly every time. A similar mechanism would control the left-right movement to complete the 2-axis aiming system.

<img width="1843" height="690" alt="image" src="https://github.com/user-attachments/assets/31ec9a7a-2b0a-427b-a4b5-542acf993bbc" />


---

## **🎨 3D Assets & Project Status**

The 3D models of the AcuDrop device were designed and assembled in Blender. The Python scripts used to generate the internal components are included in the 3d\_assets/source\_files directory.

**Project Limitations:** Due to the time constraints of the hackathon, our focus was on demonstrating the core internal mechanisms, especially the innovative gimbal system. The following components are part of the future vision but are not yet implemented in the 3D model:

* A complete outer housing for the device.  
* The physical "self-medicate" button.  
* The battery charging port and circuitry.

---

## **📱 Mobile App Setup Guide**

While the core innovation is the hardware, the Flutter mobile app is required for scheduling and data tracking.
Our primary goal was to create a codebase that is robust, scalable, and easy to maintain, which we achieved by adhering to Clean Architecture and the SOLID principles.

### **🏛️ What is Clean Architecture?** ###
Clean Architecture is a way of organizing code into distinct layers to separate concerns. Think of it like the departments in a company: the design team doesn't need to know the specifics of the manufacturing process, they just need a contract for what can be built.
Our app is divided into three layers:
**Domain Layer (The Core Rules):** The very center of our application. It holds the business logic and knows what the app does (e.g., a user has a schedule, a dose can be logged), but not how this is accomplished.
**Data Layer (The Implementation):** This layer knows how to get and store data. It implements the rules defined in the Domain layer. This is where all the Firebase code lives.
**Presentation Layer (The User Interface):** This is everything the user sees and interacts with. It's the Flutter part of the app.
The most important rule is the Dependency Rule: Outer layers can depend on inner layers, but inner layers cannot know anything about the outer layers.
_Domain <--- Data Domain <--- Presentation_
This means our core business logic (Domain) could be reused with a completely different UI or database without changing a single line of its code.

### **💎 How We Implemented SOLID Principles** ###
SOLID is a set of five design principles that help us write better, more maintainable code. Here's how they apply to the AcuDrop app:

**1. (S) - Single Responsibility Principle**:
Each class should have only one reason to change.
Example: _UserRepositoryImpl_ is only responsible for getting and saving user data from Firebase. _AuthProvider_ is only responsible for managing the user's login state. _HomeScreen_ is only responsible for displaying the home screen UI. If we need to change how we fetch data, only the _UserRepositoryImpl_ changes; the UI remains untouched.

**2. (O) - Open/Closed Principle**
Software entities should be open for extension, but closed for modification.
Example: Our UI code depends on the _UserRepository_ contract (the abstract class). Right now, we are "extending" it with a _UserRepositoryImpl_ that uses Firebase. If we wanted to add offline support later, we could create a new _UserRepositoryLocalImpl_ that also fulfills the contract. We can add new functionality without ever modifying the original, tested code.

**3. (L) - Liskov Substitution Principle**
Objects of a superclass should be replaceable with objects of a subclass without affecting the correctness of the program.
Example: The _HomeScreen_ requires a _UserRepository_. Because _UserRepositoryImpl_ is a valid subtype of _UserRepository_, we can provide it, and the app works. Any other implementation we create in the future will also work, as long as it follows the same contract.

**4. (I) - Interface Segregation Principle**
Clients should not be forced to depend on methods they do not use.
Example: We created two separate contracts: _AuthRepository_ and _UserRepository_. We didn't create one giant _FirebaseRepository_ with both authentication and user data methods. This is because the _ProfileScreen_ needs user data but has no need for login or sign-up functions. It only depends on the _UserRepository_ interface, keeping it clean and focused.

**5. (D) - Dependency Inversion Principle**
High-level modules should not depend on low-level modules. Both should depend on abstractions.
Example: This is the heart of our Clean Architecture. The high-level UI (Presentation layer) does not directly depend on the low

<img width="1242" height="874" alt="image" src="https://github.com/user-attachments/assets/ec893241-8d69-40e0-86f1-bc261e58cc45" />


### **Prerequisites**

* Flutter SDK installed.  
* An editor like VS Code or Android Studio.  
* Node.js and npm (for installing the Firebase CLI).

### **Step 1: Clone the Repository & Get Dependencies**

1. **Clone the repo:**  
   _git clone \[https://github.com/rougeDAG/VMedithon\_2025\_HackMakers\_Rising.git\](https://github.com/rougeDAG/VMedithon\_2025\_HackMakers\_Rising.git)_

2. **Navigate into the Flutter app directory:**  
   _cd VMedithon\_2025\_HackMakers\_Rising/flutter\_app_

3. **Install all the required packages:**  
   _flutter pub get_

### **Step 2: Connect to Firebase (Crucial)**

This app requires a Firebase backend to function.

1. **Create a Firebase Project:** Go to the [Firebase Console](https://console.firebase.google.com/) and create a new project.  
2. **Install Firebase Tools:** If you haven't already, install the necessary command-line tools.  
_   npm install \-g firebase-tools  
   firebase login  
   dart pub global activate flutterfire\_cli_

3. **Configure Flutter App:** From the flutter\_app directory, run the configuration tool. It will ask you to select the Firebase project you just created.  
   _flutterfire configure_

   This command will generate the _lib/firebase\_options.dart_ file, which contains your project's unique Firebase keys.  
4. **Enable Firebase Services:**  
   * In the Firebase Console, go to **Authentication** \-\> **Sign-in method** and enable the **Email/Password** provider.  
   * Go to **Firestore Database**, click **Create database**, and start in **Test Mode**.  
5. **Set Up Firestore Security Rules:**  
   * In the Firestore Database section, click on the **Rules** tab.  
   * Replace the default rules with the secure rules provided in the project. This is critical to allow users to access their own data.  
6. **Create Firestore Index:**  
   * The first time you run the app after logging in, the debug console will show a _FAILED\_PRECONDITION_ error with a long URL.  
   * **You must click this URL.** It will take you to the Google Cloud console with the required index pre-configured. Just click the **"Create Index"** button. This may take a few minutes to build.

### **Step 3: Run the App**

Connect an Android emulator or a physical device and run the application:

_flutter run  _



---

## **🧠 Machine Learning Integration & Credits**

Our project's AI capabilities are built upon the excellent work of the open-source community. We gratefully acknowledge the following projects which serve as the foundation for our eye-tracking and disease-detection features.

### **1\. Gaze and Face Tracking**

* **Project:** Python-Gaze-Face-Tracker  
* **Author:** [alireza787b](https://github.com/alireza787b)  
* **Repository:** [https://github.com/alireza787b/Python-Gaze-Face-Tracker](https://github.com/alireza787b/Python-Gaze-Face-Tracker)  
* **Usage & Modifications:** This project provides the foundational algorithms for real-time head and eye movement detection. For AcuDrop, **we have tweaked the model to isolate its eye-tracking capabilities, focusing specifically on identifying the center of the eye.** This allows our gimbal system to receive precise coordinates for fine-tuned nozzle alignment.

### **2\. Eye Disease Detection**

* **Project:** Eyes-disease-detector  
* **Author:** [shivansh00011](https://github.com/shivansh00011)  
* **Repository:** [https://github.com/shivansh00011/Eyes-disease-detector](https://github.com/shivansh00011/Eyes-disease-detector)  
* **Usage:** This model is the basis for our eye redness analysis feature. The app captures an image of the eye just before dispensing a dose and uses this model to provide a preliminary analysis score. This data is logged and can be shared with a doctor to track treatment progress over time.
