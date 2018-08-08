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

# Results

## Test: thread_shutdown

|Description|Intel Core i7 CPU 920 2.67GHz|
|-----------|-----------------------------|
|C++ - pthread|![thread_shutdown__Intel Core i7 CPU 920 2.67GHz__C++__pthread](img/thread_shutdown__Intel_Core_i7_CPU_920_2.67GHz__CPP__pthread.png)|
|C++ - std::async|![thread_shutdown__Intel Core i7 CPU 920 2.67GHz__C++__std::async](img/thread_shutdown__Intel_Core_i7_CPU_920_2.67GHz__CPP__stdasync.png)|
|C++ - std::thread|![thread_shutdown__Intel Core i7 CPU 920 2.67GHz__C++__std::thread](img/thread_shutdown__Intel_Core_i7_CPU_920_2.67GHz__CPP__stdthread.png)|
|C - pthread|![thread_shutdown__Intel Core i7 CPU 920 2.67GHz__C__pthread](img/thread_shutdown__Intel_Core_i7_CPU_920_2.67GHz__C__pthread.png)|

## Test: thread_start

|Description|Intel Core i7 CPU 920 2.67GHz|
|-----------|-----------------------------|
|C++ - pthread|![thread_start__Intel Core i7 CPU 920 2.67GHz__C++__pthread](img/thread_start__Intel_Core_i7_CPU_920_2.67GHz__CPP__pthread.png)|
|C++ - std::async|![thread_start__Intel Core i7 CPU 920 2.67GHz__C++__std::async](img/thread_start__Intel_Core_i7_CPU_920_2.67GHz__CPP__stdasync.png)|
|C++ - std::thread|![thread_start__Intel Core i7 CPU 920 2.67GHz__C++__std::thread](img/thread_start__Intel_Core_i7_CPU_920_2.67GHz__CPP__stdthread.png)|
|C - pthread|![thread_start__Intel Core i7 CPU 920 2.67GHz__C__pthread](img/thread_start__Intel_Core_i7_CPU_920_2.67GHz__C__pthread.png)|
