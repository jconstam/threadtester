# Thread Tester
Some tests of various Linux threading libraries.

# Requirements
* A POSIX-compatible system with pthread
* CMake 2.8 or later
* Python 2.7.x
* NumPy 1.8 or later
* MatPlotLib 2.2 or later
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
|Language|Library|Type|Count|Max|Min|Average|Std Dev|Graph|
|--------|-------|----|-----|---|---|-------|-------|-----|
|C|pthread|thread_shutdown|10000|1.130|0.053|0.084|0.015|[Graph](img/C__pthread__thread_shutdown.png)|
|C|pthread|thread_start|10000|0.396|0.073|0.089|0.010|[Graph](img/C__pthread__thread_start.png)|
|C++|pthread|thread_shutdown|10000|0.288|0.051|0.083|0.011|[Graph](img/CPP__pthread__thread_shutdown.png)|
|C++|pthread|thread_start|10000|0.458|0.074|0.090|0.011|[Graph](img/CPP__pthread__thread_start.png)|
|C++|std::async|thread_shutdown|10000|0.074|0.012|0.021|0.005|[Graph](img/CPP__stdasync__thread_shutdown.png)|
|C++|std::async|thread_start|10000|0.254|0.009|0.009|0.004|[Graph](img/CPP__stdasync__thread_start.png)|
|C++|std::thread|thread_shutdown|10000|0.431|0.057|0.087|0.011|[Graph](img/CPP__stdthread__thread_shutdown.png)|
|C++|std::thread|thread_start|10000|0.249|0.078|0.092|0.010|[Graph](img/CPP__stdthread__thread_start.png)|
