# MapDrawing

A Minimalistic GUI Application to communicate with the car, with 3 Main Goals:
- Send Control signals to the car
- Read Sensor Data from the car
- Plot a Surroundings Map based on the readings

The main interface is created using Qt and C++, while the map drawing part is delegated to a python script.

Communication is set up using a TCP Port, where the car acts as an Access Point, and the App connects to it
(the user must first connect to it from the system's WiFi before openning the app, then listen on the port from the app)

The sensor readings are transmitted through JSON for now, if it is a performance issue it can be encoded later.

As for the Map Drawing part, the application calls a python script as a system process (this includes activating a virtual environment)
And the communication is file-based, i.e. received data are written to a file, and the python script reads data from the same file then plots them.

these are non critical tasks to be done. for work-in-progress tasks; check the issues tab
Todo:
- [ ] Make The Code OS agnostic (run on linux OR windows)
- [ ] Specify a Well documented format for data transmittion
- [ ] Use CMake instead of QMake
