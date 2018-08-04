ROOT=$(shell pwd)
BUILD=$(ROOT)/build
SRC=$(ROOT)/src

build: pthread_c
run: build run_pthread_c

clean:
	rm -rf $(BUILD)

PTHREAD_C_NAME=pthread_c
PTHREAD_C_SRC=$(SRC)/$(PTHREAD_C_NAME)
PTHREAD_C_BUILD=$(BUILD)/$(PTHREAD_C_NAME)
pthread_c:
	@echo "BUILDING pThreads (C)"
	mkdir -p $(PTHREAD_C_BUILD)
	cd $(PTHREAD_C_BUILD) && cmake $(PTHREAD_C_SRC) && make
run_pthread_c:
	@echo "RUNNING pThreads (C)"
	$(PTHREAD_C_BUILD)/$(PTHREAD_C_NAME)
