RUN_COUNT		?=	10000

ROOT			=	$(shell pwd)
BUILD			=	$(ROOT)/build
SRC				=	$(ROOT)/src
IMG				=	$(ROOT)/img
DATA			=	$(ROOT)/data

OUTPUT_PARSER	=	python $(SRC)/outputparser.py
DATA_FILE		=	$(DATA)/data.json
MD_HEADER_FILE	=	$(ROOT)/README_HEADER.md
MD_FILE			=	$(ROOT)/README.md

#########################################

define cmake_build_with_timer
	@echo "BUILDING $(1)"
	@mkdir -p $(2)
	@d=$$(date +%s); cd $(2) && cmake $(3) >/dev/null && make >/dev/null && echo "\tTook $$(($$(date +%s)-d)) seconds"
endef

define run_with_timer
	@echo "RUNNING $(1)"
	@d=$$(date +%s); $(2) -c $(RUN_COUNT) > $(3) && echo "\tTook $$(($$(date +%s)-d)) seconds"
endef

define run_parser
	$(OUTPUT_PARSER) \
			--name $(1) \
			--jsonfile $(DATA_FILE) \
			--markdownheader $(MD_HEADER_FILE) \
			--markdownfile $(MD_FILE) \
			--graphPath $(IMG)
endef

define process_with_timer
	@echo "PROCESSING $(1)"
	@d=$$(date +%s); cat $(2) | $(call run_parser,$(1))	&& echo "\tTook $$(($$(date +%s)-d)) seconds"
endef

#########################################

build: c_pthread cpp_pthread cpp_stdthread cpp_stdasync
run: run_c_pthread run_cpp_pthread run_cpp_stdthread run_cpp_stdasync
	@echo "COMPILING RESULTS"
	@$(call run_parser,compile_results)

clean:
	@echo "Cleaning up $(BUILD)"
	@rm -rf $(BUILD)
	
clean_results:
	@echo "Cleaning up $(DATA)"
	@rm -rf $(DATA)/*
	@echo "Cleaning up $(IMG)"
	@rm -rf $(IMG)/*

#########################################

C_PTHREAD_NAME=c_pthread
C_PTHREAD_SRC=$(SRC)/$(C_PTHREAD_NAME)
C_PTHREAD_BUILD=$(BUILD)/$(C_PTHREAD_NAME)
C_PTHREAD_NAME_START=$(C_PTHREAD_NAME)_start
C_PTHREAD_OUTPUT_START=$(BUILD)/$(C_PTHREAD_NAME_START)_output
C_PTHREAD_NAME_SHUTDOWN=$(C_PTHREAD_NAME)_shutdown
C_PTHREAD_OUTPUT_SHUTDOWN=$(BUILD)/$(C_PTHREAD_NAME_SHUTDOWN)_output
c_pthread:
	$(call cmake_build_with_timer,$(C_PTHREAD_NAME),$(C_PTHREAD_BUILD),$(C_PTHREAD_SRC))
run_c_pthread: run_c_pthread_start run_c_pthread_shutdown
run_c_pthread_start: c_pthread
	$(call run_with_timer,$(C_PTHREAD_NAME_START),$(C_PTHREAD_BUILD)/$(C_PTHREAD_NAME) -s,$(C_PTHREAD_OUTPUT_START))
	$(call process_with_timer,$(C_PTHREAD_NAME_START),$(C_PTHREAD_OUTPUT_START))
run_c_pthread_shutdown: c_pthread
	$(call run_with_timer,$(C_PTHREAD_NAME_SHUTDOWN),$(C_PTHREAD_BUILD)/$(C_PTHREAD_NAME) -e,$(C_PTHREAD_OUTPUT_SHUTDOWN))
	$(call process_with_timer,$(C_PTHREAD_NAME_SHUTDOWN),$(C_PTHREAD_OUTPUT_SHUTDOWN))

#########################################

CPP_PTHREAD_NAME=cpp_pthread
CPP_PTHREAD_SRC=$(SRC)/$(CPP_PTHREAD_NAME)
CPP_PTHREAD_BUILD=$(BUILD)/$(CPP_PTHREAD_NAME)
CPP_PTHREAD_NAME_START=$(CPP_PTHREAD_NAME)_start
CPP_PTHREAD_OUTPUT_START=$(BUILD)/$(CPP_PTHREAD_NAME_START)_output
CPP_PTHREAD_NAME_SHUTDOWN=$(CPP_PTHREAD_NAME)_shutdown
CPP_PTHREAD_OUTPUT_SHUTDOWN=$(BUILD)/$(CPP_PTHREAD_NAME_SHUTDOWN)_output
cpp_pthread:
	$(call cmake_build_with_timer,$(CPP_PTHREAD_NAME),$(CPP_PTHREAD_BUILD),$(CPP_PTHREAD_SRC))
run_cpp_pthread: run_cpp_pthread_start run_cpp_pthread_shutdown
run_cpp_pthread_start: cpp_pthread
	$(call run_with_timer,$(CPP_PTHREAD_NAME_START),$(CPP_PTHREAD_BUILD)/$(CPP_PTHREAD_NAME) -s,$(CPP_PTHREAD_OUTPUT_START))
	$(call process_with_timer,$(CPP_PTHREAD_NAME_START),$(CPP_PTHREAD_OUTPUT_START))
run_cpp_pthread_shutdown: cpp_pthread
	$(call run_with_timer,$(CPP_PTHREAD_NAME_SHUTDOWN),$(CPP_PTHREAD_BUILD)/$(CPP_PTHREAD_NAME) -e,$(CPP_PTHREAD_OUTPUT_SHUTDOWN))
	$(call process_with_timer,$(CPP_PTHREAD_NAME_SHUTDOWN),$(CPP_PTHREAD_OUTPUT_SHUTDOWN))

#########################################

CPP_STDTHREAD_NAME=cpp_stdthread
CPP_STDTHREAD_SRC=$(SRC)/$(CPP_STDTHREAD_NAME)
CPP_STDTHREAD_BUILD=$(BUILD)/$(CPP_STDTHREAD_NAME)
CPP_STDTHREAD_NAME_START=$(CPP_STDTHREAD_NAME)_start
CPP_STDTHREAD_OUTPUT_START=$(BUILD)/$(CPP_STDTHREAD_NAME_START)_output
CPP_STDTHREAD_NAME_SHUTDOWN=$(CPP_STDTHREAD_NAME)_shutdown
CPP_STDTHREAD_OUTPUT_SHUTDOWN=$(BUILD)/$(CPP_STDTHREAD_NAME_SHUTDOWN)_output
cpp_stdthread:
	$(call cmake_build_with_timer,$(CPP_STDTHREAD_NAME),$(CPP_STDTHREAD_BUILD),$(CPP_STDTHREAD_SRC))
run_cpp_stdthread: run_cpp_stdthread_start run_cpp_stdthread_shutdown
run_cpp_stdthread_start: cpp_stdthread
	$(call run_with_timer,$(CPP_STDTHREAD_NAME_START),$(CPP_STDTHREAD_BUILD)/$(CPP_STDTHREAD_NAME) -s,$(CPP_STDTHREAD_OUTPUT_START))
	$(call process_with_timer,$(CPP_STDTHREAD_NAME_START),$(CPP_STDTHREAD_OUTPUT_START))
run_cpp_stdthread_shutdown: cpp_stdthread
	$(call run_with_timer,$(CPP_STDTHREAD_NAME_SHUTDOWN),$(CPP_STDTHREAD_BUILD)/$(CPP_STDTHREAD_NAME) -e,$(CPP_STDTHREAD_OUTPUT_SHUTDOWN))
	$(call process_with_timer,$(CPP_STDTHREAD_NAME_SHUTDOWN),$(CPP_STDTHREAD_OUTPUT_SHUTDOWN))

#########################################

CPP_STDASYNC_NAME=cpp_stdasync
CPP_STDASYNC_SRC=$(SRC)/$(CPP_STDASYNC_NAME)
CPP_STDASYNC_BUILD=$(BUILD)/$(CPP_STDASYNC_NAME)
CPP_STDASYNC_NAME_START=$(CPP_STDASYNC_NAME)_start
CPP_STDASYNC_OUTPUT_START=$(BUILD)/$(CPP_STDASYNC_NAME_START)_output
CPP_STDASYNC_NAME_SHUTDOWN=$(CPP_STDASYNC_NAME)_shutdown
CPP_STDASYNC_OUTPUT_SHUTDOWN=$(BUILD)/$(CPP_STDASYNC_NAME_SHUTDOWN)_output
cpp_stdasync:
	$(call cmake_build_with_timer,$(CPP_STDASYNC_NAME),$(CPP_STDASYNC_BUILD),$(CPP_STDASYNC_SRC))
run_cpp_stdasync: run_cpp_stdasync_start run_cpp_stdasync_shutdown
run_cpp_stdasync_start: cpp_stdasync
	$(call run_with_timer,$(CPP_STDASYNC_NAME_START),$(CPP_STDASYNC_BUILD)/$(CPP_STDASYNC_NAME) -s,$(CPP_STDASYNC_OUTPUT_START))
	$(call process_with_timer,$(CPP_STDASYNC_NAME_START),$(CPP_STDASYNC_OUTPUT_START))
run_cpp_stdasync_shutdown: cpp_stdasync
	$(call run_with_timer,$(CPP_STDASYNC_NAME_SHUTDOWN),$(CPP_STDASYNC_BUILD)/$(CPP_STDASYNC_NAME) -e,$(CPP_STDASYNC_OUTPUT_SHUTDOWN))
	$(call process_with_timer,$(CPP_STDASYNC_NAME_SHUTDOWN),$(CPP_STDASYNC_OUTPUT_SHUTDOWN))

#########################################
