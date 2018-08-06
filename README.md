# Thread Tester
Some tests of various Linux threading libraries.

# Requirements
* A POSIX-compatible system with pthread
* CMake v2.8 or later
* Python 2.7.x
* NumPy 1.8 or later
* gcc + standard libraries

# Summary
This project is designed to compare the performance of various threading systems.

## Test Descriptions
|Name|Description|
|----|-----------|
|thread_start|Time between immediately before the thread creation function is called and the first execution of that thread.|
|thread_shutdown|Time between immediately before a thread terminates and when the creator of the thread receives notification that the thread shut down.|

## Details
Each line in the following table represents the execution of one of the binaries in this repository.
For each one, the following information is listed:
* The language the program was written in.
* The library (if any) used to run the tests.
* The test that was performed.
* Details on the timing of the results.

# Data
|Language|Library|Type|Count|Max|Min|Average|Std Dev|
|--------|-------|----|-----|---|---|-------|-------|
|C|pthread|thread_shutdown|1000000|21.571|0.054|0.084|0.032|
|C|pthread|thread_start|1000000|3.528|0.069|0.085|0.011|
|C++|pthread|thread_shutdown|1000000|29.308|0.053|0.088|0.042|
|C++|pthread|thread_start|1000000|1.628|0.070|0.087|0.008|
|C++|std::async|thread_shutdown|1000000|1.616|0.012|0.021|0.006|
|C++|std::async|thread_start|1000000|4.335|0.008|0.009|0.006|
|C++|std::thread|thread_shutdown|1000000|29.828|0.068|0.094|0.055|
|C++|std::thread|thread_start|1000000|2.606|0.081|0.112|0.013|
