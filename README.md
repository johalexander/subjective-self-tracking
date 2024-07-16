# Subjective Self Tracking

This repository hosts code for a self-tracking prototype and an accompanied macOS app for experimental usage. The work is completed as part of a MSc thesis for DTU Compute during Spring/Summer 2024, with completion in August 2024.

## Features

**macOS App**
* Learn: offers contextual knowledge related to use of the prototype and hints at how data is processed.
* Practice: allows an app user to practice using the prototype for physical analogue input and the app for visual analogue input, on both number stimuli and greyscale stimuli.
* Experiments: fully featured experiments screen that will run through 6 different experiments in a Latin square order. Experiment data is saved to disk. Participant survey available online as a link when experiments are completed.
* Settings: interface allowing for exporting of data, resetting of data and other functionality. Server status for accepting prototype communication is available.

**Prototype**
* Prototype continuously reads sensor chip ([Adafruit BNO085](https://www.adafruit.com/product/4754)) for quaternions, activity and stability
* Records to on-disk memory on click: sensor reading, calibration status, timestamp and click duration -- attempts to send to app server (communicated through REST)
* Device reads battery level and logs to on-disk memory at a 180 second interval
* Device may be restarted on board failure (caught exceptions) -- small delay of non-interactivity

## How to run

### macOS App
The `experiments-macos` project has been built using Xcode 15.4 and can be run locally. The project is dependant on [Vapor](https://vapor.codes/). To install Vapor, use File -> Add Package Dependencies... in Xcode.

`Server.swift` hardcodes an IP address to bind the web server to. The web server will accept requests at https://ipaddress:8080 per default.

The Experiments screen allows for forcing an experiment start through **CMD + F**. This will bring up a prompt that asks which participant id and experiment index to begin with.

### Prototype
The prototype is built using an [Adafruit Huzzah32](https://www.adafruit.com/product/3405) microcontroller and a [Adafruit BNO085](https://www.adafruit.com/product/4754) sensor board. This section assumes knowledge of how to flash and install CircuitPython, and physical assembly. The device may be restarted from REPL with **CTRL + D**. Code execution can be interrupted with **CTRL + C**.

Code under `/prototype/code/controller/` is CircuitPython code that can be deployed to the microcontroller. The code is dependant on a few CircuitPython [libraries](https://circuitpython.org/libraries):
* adafruit_connection_manager
* adafruit_requests
* adafruit_ntp
* adafruit_bno08x
* adafruit_debouncer

There are three different main files:
* **tracking_quaternion_no_motor.py**
  * **Default** main file to be used (as code.py)
  * No motor pin considered
  * Raw data output
* tracking_quaternion_no_motor_euler_calc.py
  * Calculates and prints roll, pitch in REPL on click
  * Expensive math operations, delays main loop
  * Raw data output
* tracking_quaternion_with_motor.py
  * Motor pin is considered
  * Raw data output
 
The main file can be replaced depending on need. **Note: backend.py defines an URI resource to send device data to.**

The prototype code has been tested and run with CircuitPython 9.0.5.

#### Schematics and models
The prototype assembly is detailed in the published thesis paper.

Fritzing schematics (wiring) for the prototype are available under `/prototype/schematics/`.

Blender models for the prototype are available under `/prototype/models/`.

### Visualisations
Visualisation tools for generated data can be found in the code folder under `/prototype/code/visualisations/`.

To run the Python Jupyter Notebooks, from the directory you will have to:
1. Create a [virtual environment](https://docs.python.org/3/library/venv.html)
2. Run `pip install -r requirements.txt`
3. Notebooks are now runnable with the created kernel

To view visualisations without running them locally, [NBViewer](https://nbviewer.org/) can be utilised.
Enter the desired URL into the web page, and _voila_!

Example: https://nbviewer.org/github/johalexander/subjective-self-tracking/blob/main/prototype/code/visualisations/visualisations_app.ipynb
