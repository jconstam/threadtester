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
## Processor: ARMv6-compatible processor rev 7 v6l
### Test: thread_shutdown
|Description|Graph|
|-----------|-----|
|C++ - pthread|![thread_shutdown__C++__pthread](img/ARMv6-compatible_processor_rev_7_v6l__thread_shutdown__CPP__pthread.png)|
|C++ - std::async|![thread_shutdown__C++__std::async](img/ARMv6-compatible_processor_rev_7_v6l__thread_shutdown__CPP__stdasync.png)|
|C++ - std::thread|![thread_shutdown__C++__std::thread](img/ARMv6-compatible_processor_rev_7_v6l__thread_shutdown__CPP__stdthread.png)|
|C - pthread|![thread_shutdown__C__pthread](img/ARMv6-compatible_processor_rev_7_v6l__thread_shutdown__C__pthread.png)|
### Test: thread_start
|Description|Graph|
|-----------|-----|
|C++ - pthread|![thread_start__C++__pthread](img/ARMv6-compatible_processor_rev_7_v6l__thread_start__CPP__pthread.png)|
|C++ - std::async|![thread_start__C++__std::async](img/ARMv6-compatible_processor_rev_7_v6l__thread_start__CPP__stdasync.png)|
|C++ - std::thread|![thread_start__C++__std::thread](img/ARMv6-compatible_processor_rev_7_v6l__thread_start__CPP__stdthread.png)|
|C - pthread|![thread_start__C__pthread](img/ARMv6-compatible_processor_rev_7_v6l__thread_start__C__pthread.png)|
## Processor: Intel Core i7 CPU 920 2.67GHz
### Test: thread_shutdown
|Description|Graph|
|-----------|-----|
|C++ - pthread|![thread_shutdown__C++__pthread](img/Intel_Core_i7_CPU_920_2.67GHz__thread_shutdown__CPP__pthread.png)|
|C++ - std::async|![thread_shutdown__C++__std::async](img/Intel_Core_i7_CPU_920_2.67GHz__thread_shutdown__CPP__stdasync.png)|
|C++ - std::thread|![thread_shutdown__C++__std::thread](img/Intel_Core_i7_CPU_920_2.67GHz__thread_shutdown__CPP__stdthread.png)|
|C - pthread|![thread_shutdown__C__pthread](img/Intel_Core_i7_CPU_920_2.67GHz__thread_shutdown__C__pthread.png)|
### Test: thread_start
|Description|Graph|
|-----------|-----|
|C++ - pthread|![thread_start__C++__pthread](img/Intel_Core_i7_CPU_920_2.67GHz__thread_start__CPP__pthread.png)|
|C++ - std::async|![thread_start__C++__std::async](img/Intel_Core_i7_CPU_920_2.67GHz__thread_start__CPP__stdasync.png)|
|C++ - std::thread|![thread_start__C++__std::thread](img/Intel_Core_i7_CPU_920_2.67GHz__thread_start__CPP__stdthread.png)|
|C - pthread|![thread_start__C__pthread](img/Intel_Core_i7_CPU_920_2.67GHz__thread_start__C__pthread.png)|
