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
|C|pthread|thread_shutdown|100000|1.070|0.054|0.066|0.010|
|C|pthread|thread_start|100000|0.405|0.070|0.081|0.004|
|C++|pthread|thread_shutdown|100000|0.274|0.052|0.072|0.012|
|C++|pthread|thread_start|100000|0.397|0.074|0.082|0.004|
|C++|std::thread|thread_shutdown|100000|0.588|0.057|0.075|0.012|
|C++|std::thread|thread_start|100000|0.950|0.073|0.085|0.004|
