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
|pthread_c|100000|3.414|0.000|0.120|0.020|

## Thread Shutdown
Each measurement is the time (in ms) between task exiting and the main receiving notification that the task has exited

|Name|Count|Max|Min|Average|Std Dev|
|----|-----|---|---|-------|-------|
|pthread_c|100000|3.414|0.000|0.120|0.020|
