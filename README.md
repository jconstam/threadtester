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
|Description|Graph|
|-----------|-----|
|C - pthread - thread_shutdown|![C__pthread__thread_shutdown](img/C__pthread__thread_shutdown.png)|
|C - pthread - thread_start|![C__pthread__thread_start](img/C__pthread__thread_start.png)|
|C++ - pthread - thread_shutdown|![C++__pthread__thread_shutdown](img/CPP__pthread__thread_shutdown.png)|
|C++ - pthread - thread_start|![C++__pthread__thread_start](img/CPP__pthread__thread_start.png)|
|C++ - std::async - thread_shutdown|![C++__std::async__thread_shutdown](img/CPP__stdasync__thread_shutdown.png)|
|C++ - std::async - thread_start|![C++__std::async__thread_start](img/CPP__stdasync__thread_start.png)|
|C++ - std::thread - thread_shutdown|![C++__std::thread__thread_shutdown](img/CPP__stdthread__thread_shutdown.png)|
|C++ - std::thread - thread_start|![C++__std::thread__thread_start](img/CPP__stdthread__thread_start.png)|
