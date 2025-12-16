# Position Control Lab

This project implements a position control system using an Arduino board and analyzes the system's behavior using MATLAB. The goal is to perform system identification on a DC motor and create a report of the findings.

## Project Structure

The project is organized into the following directories:

-   `arduino/`: Contains the source code for the Arduino microcontroller. This code is responsible for controlling the motor and sending experimental data over the serial port.
-   `data/`: Stores the experimental data captured from the Arduino. Each `.txt` file represents a different test run.
-   `matlab/`: Contains the MATLAB scripts used for data analysis, system identification, and plot generation.
-   `report/`: Contains the LaTeX source files, images, and the final PDF report for the lab.

## How to Run the Project

To run this project, you will need to have the Arduino IDE and MATLAB installed.

### 1. Arduino Controller

1.  Open the `arduino/Code/main/main.ino` file in the Arduino IDE.
2.  Upload the code to your Arduino board.
3.  Open the Serial Monitor (Tools -> Serial Monitor). You will see a menu with instructions on how to start the experiment.
4.  Follow the instructions in the Serial Monitor to run a test. The Arduino will send data back to the Serial Monitor.
5.  Copy the entire output from the Serial Monitor and paste it into a new text file.
6.  Save this text file in the `data/` directory (e.g., `Lab3_2.1.txt`).

### 2. MATLAB Analysis

1.  Open MATLAB.
2.  Navigate to the `matlab/` directory within this project.
3.  Run the `lab3.m` script.

The script will:
-   Load the data from the `.txt` files in the `data/` directory.
-   Perform system identification calculations.
-   Generate and save plots of the results in the `report/img/` directory.
-   Print the estimated system parameters (Gain, Time Constant, and Bandwidth) in the MATLAB command window.
