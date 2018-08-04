RUN_COUNT		?=	10000

ROOT			=	$(shell pwd)
BUILD			=	$(ROOT)/build
SRC				=	$(ROOT)/src

OUTPUT_PARSER	=	python $(SRC)/outputparser.py

#########################################

define cmake_build_with_timer
	@d=$$(date +%s); cd $(1) && cmake $(2) >/dev/null && make >/dev/null && echo "\tTook $$(($$(date +%s)-d)) seconds"
endef

define run_with_timer
	@d=$$(date +%s); $(1) -c $(RUN_COUNT) > $(2) && echo "\tTook $$(($$(date +%s)-d)) seconds"
endef

#########################################

build: pthread_c
run: build run_pthread_c

clean:
	@echo "Cleaning up $(BUILD)"
	@rm -rf $(BUILD)

#########################################

PTHREAD_C_NAME=pthread_c
PTHREAD_C_SRC=$(SRC)/$(PTHREAD_C_NAME)
PTHREAD_C_BUILD=$(BUILD)/$(PTHREAD_C_NAME)
PTHREAD_C_OUTPUT=$(BUILD)/output
pthread_c:
	@echo "BUILDING pThreads (C)"
	@mkdir -p $(PTHREAD_C_BUILD)
	$(call cmake_build_with_timer,$(PTHREAD_C_BUILD),$(PTHREAD_C_SRC))
run_pthread_c:
	@echo "RUNNING pThreads (C)"
	$(call run_with_timer,$(PTHREAD_C_BUILD)/$(PTHREAD_C_NAME),$(PTHREAD_C_OUTPUT))
	@cat $(PTHREAD_C_OUTPUT) | $(OUTPUT_PARSER)

#########################################
