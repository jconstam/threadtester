# Thread Tester
Some tests of various Linux threading libraries.

# Requirements
* A POSIX-compatible system with pthread
* CMake 2.8 or later
* Python 2.7.x
* NumPy 1.8 or later
* MatPlotLib 2.2 or later
* Boost thread library 1.54 or later
* gcc + standard libraries

# Summary
This project is designed to compare the performance of various threading systems.

Each line in the table represents the execution of one of the binaries in this repository.
For each one, the following information is listed:
* The language the program was written in.
* The library (if any) used to run the tests.
* The test that was performed.
* Details on the timing of the results.

# Results

## Test: Semaphore Unlock
Time between when one thread posts a semaphore and a waiting thread is running.

|Description|1st Gen Intel Core i7|Raspberry Pi B2|
|-----------|---------------------|---------------|
|C++ - pthread_mutex_fast|![sem_unlock__Intel Core i7 CPU 920 2.67GHz__C++__pthread_mutex_fast](img/sem_unlock__Intel_Core_i7_CPU_920_2.67GHz__CPP__pthread_mutex_fast.png)|
|C++ - pthread_mutex_recursive|![sem_unlock__Intel Core i7 CPU 920 2.67GHz__C++__pthread_mutex_recursive](img/sem_unlock__Intel_Core_i7_CPU_920_2.67GHz__CPP__pthread_mutex_recursive.png)|
|C++ - semt|![sem_unlock__Intel Core i7 CPU 920 2.67GHz__C++__semt](img/sem_unlock__Intel_Core_i7_CPU_920_2.67GHz__CPP__semt.png)|
|C - pthread_mutex_fast|![sem_unlock__Intel Core i7 CPU 920 2.67GHz__C__pthread_mutex_fast](img/sem_unlock__Intel_Core_i7_CPU_920_2.67GHz__C__pthread_mutex_fast.png)|
|C - pthread_mutex_recursive|![sem_unlock__Intel Core i7 CPU 920 2.67GHz__C__pthread_mutex_recursive](img/sem_unlock__Intel_Core_i7_CPU_920_2.67GHz__C__pthread_mutex_recursive.png)|
|C - semt|![sem_unlock__ARMv6-compatible processor rev 7 v6l__C__semt](img/sem_unlock__ARMv6-compatible_processor_rev_7_v6l__C__semt.png)|![sem_unlock__Intel Core i7 CPU 920 2.67GHz__C__semt](img/sem_unlock__Intel_Core_i7_CPU_920_2.67GHz__C__semt.png)|

## Test: Thread Shutdown
Time between immediately before a thread terminates and when the creator of the thread receives notification that the thread shut down.

|Description|Raspberry Pi B2|1st Gen Intel Core i7|
|-----------|---------------|---------------------|
|C++ - boost::thread|![thread_shutdown__ARMv6-compatible processor rev 7 v6l__C++__boost::thread](img/thread_shutdown__ARMv6-compatible_processor_rev_7_v6l__CPP__boostthread.png)|![thread_shutdown__Intel Core i7 CPU 920 2.67GHz__C++__boost::thread](img/thread_shutdown__Intel_Core_i7_CPU_920_2.67GHz__CPP__boostthread.png)|
|C++ - pthread|![thread_shutdown__ARMv6-compatible processor rev 7 v6l__C++__pthread](img/thread_shutdown__ARMv6-compatible_processor_rev_7_v6l__CPP__pthread.png)|![thread_shutdown__Intel Core i7 CPU 920 2.67GHz__C++__pthread](img/thread_shutdown__Intel_Core_i7_CPU_920_2.67GHz__CPP__pthread.png)|
|C++ - std::async|![thread_shutdown__ARMv6-compatible processor rev 7 v6l__C++__std::async](img/thread_shutdown__ARMv6-compatible_processor_rev_7_v6l__CPP__stdasync.png)|![thread_shutdown__Intel Core i7 CPU 920 2.67GHz__C++__std::async](img/thread_shutdown__Intel_Core_i7_CPU_920_2.67GHz__CPP__stdasync.png)|
|C++ - std::thread|![thread_shutdown__ARMv6-compatible processor rev 7 v6l__C++__std::thread](img/thread_shutdown__ARMv6-compatible_processor_rev_7_v6l__CPP__stdthread.png)|![thread_shutdown__Intel Core i7 CPU 920 2.67GHz__C++__std::thread](img/thread_shutdown__Intel_Core_i7_CPU_920_2.67GHz__CPP__stdthread.png)|
|C - pthread|![thread_shutdown__ARMv6-compatible processor rev 7 v6l__C__pthread](img/thread_shutdown__ARMv6-compatible_processor_rev_7_v6l__C__pthread.png)|![thread_shutdown__Intel Core i7 CPU 920 2.67GHz__C__pthread](img/thread_shutdown__Intel_Core_i7_CPU_920_2.67GHz__C__pthread.png)|

## Test: Thread Startup
Time between immediately before the thread creation function is called and the first execution of that thread.

|Description|Raspberry Pi B2|1st Gen Intel Core i7|
|-----------|---------------|---------------------|
|C++ - boost::thread|![thread_start__ARMv6-compatible processor rev 7 v6l__C++__boost::thread](img/thread_start__ARMv6-compatible_processor_rev_7_v6l__CPP__boostthread.png)|![thread_start__Intel Core i7 CPU 920 2.67GHz__C++__boost::thread](img/thread_start__Intel_Core_i7_CPU_920_2.67GHz__CPP__boostthread.png)|
|C++ - pthread|![thread_start__ARMv6-compatible processor rev 7 v6l__C++__pthread](img/thread_start__ARMv6-compatible_processor_rev_7_v6l__CPP__pthread.png)|![thread_start__Intel Core i7 CPU 920 2.67GHz__C++__pthread](img/thread_start__Intel_Core_i7_CPU_920_2.67GHz__CPP__pthread.png)|
|C++ - std::async|![thread_start__ARMv6-compatible processor rev 7 v6l__C++__std::async](img/thread_start__ARMv6-compatible_processor_rev_7_v6l__CPP__stdasync.png)|![thread_start__Intel Core i7 CPU 920 2.67GHz__C++__std::async](img/thread_start__Intel_Core_i7_CPU_920_2.67GHz__CPP__stdasync.png)|
|C++ - std::thread|![thread_start__ARMv6-compatible processor rev 7 v6l__C++__std::thread](img/thread_start__ARMv6-compatible_processor_rev_7_v6l__CPP__stdthread.png)|![thread_start__Intel Core i7 CPU 920 2.67GHz__C++__std::thread](img/thread_start__Intel_Core_i7_CPU_920_2.67GHz__CPP__stdthread.png)|
|C - pthread|![thread_start__ARMv6-compatible processor rev 7 v6l__C__pthread](img/thread_start__ARMv6-compatible_processor_rev_7_v6l__C__pthread.png)|![thread_start__Intel Core i7 CPU 920 2.67GHz__C__pthread](img/thread_start__Intel_Core_i7_CPU_920_2.67GHz__C__pthread.png)|
