# Thread Tester
Some tests of various Linux threading libraries.

# Requirements
* A POSIX-compatible system with pthread
* CMake v2.8 or later
* Python 2.7.x
* NumPy 1.8 or later
* gcc + standard libraries

# Thread Start/Stop
## Thread Start
Each measurement is the time (in ms) between the call to start the task and the task actually running

|Name|Count|Max|Min|Average|Std Dev|
|----|-----|---|---|-------|-------|
|pthread_cpp|1000000|4.333|0.078|0.122|0.013|
|pthread_c|1000000|4.522|0.077|0.114|0.011|

## Thread Shutdown
Each measurement is the time (in ms) between task exiting and the main receiving notification that the task has exited

|Name|Count|Max|Min|Average|Std Dev|
|----|-----|---|---|-------|-------|
|pthread_cpp|1000000|1.730|0.072|0.090|0.010|
|pthread_c|1000000|1.420|0.072|0.089|0.009|
