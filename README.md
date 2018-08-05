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
|C|pthread|thread_shutdown|100000|1.734|0.053|0.061|0.013|
|C|pthread|thread_start|100000|1.346|0.071|0.082|0.013|
|C++|pthread|thread_shutdown|100000|1.590|0.052|0.060|0.012|
|C++|pthread|thread_start|100000|2.136|0.071|0.082|0.016|
