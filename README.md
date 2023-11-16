# Taskify!

A Modern, Aesthetic To-Do App with Cross-Platform Device Support (Web Browser, Android, iPhone, Tablet etc) created with Flutter and Back4App!

## Features
- Add, Edit, and Delete Tasks
- Mark Tasks as Done or To Do
- Set Due Dates for Tasks - And see them Sorted by Date
- Clean and User-Friendly Interface

## Stand-Out Features:
- Paper-like Feel as Background
- Calming and Aesthetic Colour Scheme
- Satisfaction of “Crossing Off” Virtual Tasks



## Setup

Please follow these steps to set up and run Taskify! :


### Prerequisites

- Make sure you have Flutter and Dart installed on your machine. If not, follow the [official installation guide](https://flutter.dev/docs/get-started/install).
- Ensure you have Parse Server set up. Please use [Back4App](https://www.back4app.com/) for this. Have your ClientKey ready to go from Back4App.


### Clone the Repository

git clone https://github.com/shloka06/taskify.git


### Navigate to the Project Directory

cd taskify


### Install Dependencies

flutter pub get


### Configure Parse Server

Update the Parse Server configuration in lib/main.dart with your Parse Server details:

// lib/main.dart

    await Parse().initialize(

      'fA8MsaGKCPupUCXY13weBoPEhhbU63HDEAoGS6Sd',
      
      'https://parseapi.back4app.com',
      
      clientKey: {**ADD YOUR BACK4APP CLIENT KEY HERE**},
      
      autoSendSessionId: true,
      
      debug: true,
    
    );


### Run the App

flutter run



**Taskify! should now be running on your device or emulator.**
