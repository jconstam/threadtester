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
			--graphPath $(IMG) \
			--rootPath $(ROOT)
endef

define process_with_timer
	@echo "PROCESSING $(1)"
	@d=$$(date +%s); cat $(2) | $(call run_parser,$(1))	&& echo "\tTook $$(($$(date +%s)-d)) seconds"
endef

#########################################

.PHONY: build
build:
	@echo "BUILDING"
	@mkdir -p $(BUILD)
	@d=$$(date +%s); cd $(BUILD) && cmake >/dev/null $(SRC) && make >/dev/null && echo "\tTook $$(($$(date +%s)-d)) seconds"

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
C_PTHREAD_NAME_START=$(C_PTHREAD_NAME)_start
C_PTHREAD_OUTPUT_START=$(BUILD)/$(C_PTHREAD_NAME_START)_output
C_PTHREAD_NAME_SHUTDOWN=$(C_PTHREAD_NAME)_shutdown
C_PTHREAD_OUTPUT_SHUTDOWN=$(BUILD)/$(C_PTHREAD_NAME_SHUTDOWN)_output
run_c_pthread: run_c_pthread_start run_c_pthread_shutdown
run_c_pthread_start: build
	$(call run_with_timer,$(C_PTHREAD_NAME_START),$(BUILD)/$(C_PTHREAD_NAME) -s,$(C_PTHREAD_OUTPUT_START))
	$(call process_with_timer,$(C_PTHREAD_NAME_START),$(C_PTHREAD_OUTPUT_START))
run_c_pthread_shutdown: build
	$(call run_with_timer,$(C_PTHREAD_NAME_SHUTDOWN),$(BUILD)/$(C_PTHREAD_NAME) -e,$(C_PTHREAD_OUTPUT_SHUTDOWN))
	$(call process_with_timer,$(C_PTHREAD_NAME_SHUTDOWN),$(C_PTHREAD_OUTPUT_SHUTDOWN))

#########################################

CPP_PTHREAD_NAME=cpp_pthread
CPP_PTHREAD_NAME_START=$(CPP_PTHREAD_NAME)_start
CPP_PTHREAD_OUTPUT_START=$(BUILD)/$(CPP_PTHREAD_NAME_START)_output
CPP_PTHREAD_NAME_SHUTDOWN=$(CPP_PTHREAD_NAME)_shutdown
CPP_PTHREAD_OUTPUT_SHUTDOWN=$(BUILD)/$(CPP_PTHREAD_NAME_SHUTDOWN)_output
run_cpp_pthread: run_cpp_pthread_start run_cpp_pthread_shutdown
run_cpp_pthread_start: build
	$(call run_with_timer,$(CPP_PTHREAD_NAME_START),$(BUILD)/$(CPP_PTHREAD_NAME) -s,$(CPP_PTHREAD_OUTPUT_START))
	$(call process_with_timer,$(CPP_PTHREAD_NAME_START),$(CPP_PTHREAD_OUTPUT_START))
run_cpp_pthread_shutdown: build
	$(call run_with_timer,$(CPP_PTHREAD_NAME_SHUTDOWN),$(BUILD)/$(CPP_PTHREAD_NAME) -e,$(CPP_PTHREAD_OUTPUT_SHUTDOWN))
	$(call process_with_timer,$(CPP_PTHREAD_NAME_SHUTDOWN),$(CPP_PTHREAD_OUTPUT_SHUTDOWN))

#########################################

CPP_STDTHREAD_NAME=cpp_stdthread
CPP_STDTHREAD_NAME_START=$(CPP_STDTHREAD_NAME)_start
CPP_STDTHREAD_OUTPUT_START=$(BUILD)/$(CPP_STDTHREAD_NAME_START)_output
CPP_STDTHREAD_NAME_SHUTDOWN=$(CPP_STDTHREAD_NAME)_shutdown
CPP_STDTHREAD_OUTPUT_SHUTDOWN=$(BUILD)/$(CPP_STDTHREAD_NAME_SHUTDOWN)_output
run_cpp_stdthread: run_cpp_stdthread_start run_cpp_stdthread_shutdown
run_cpp_stdthread_start: build
	$(call run_with_timer,$(CPP_STDTHREAD_NAME_START),$(BUILD)/$(CPP_STDTHREAD_NAME) -s,$(CPP_STDTHREAD_OUTPUT_START))
	$(call process_with_timer,$(CPP_STDTHREAD_NAME_START),$(CPP_STDTHREAD_OUTPUT_START))
run_cpp_stdthread_shutdown: build
	$(call run_with_timer,$(CPP_STDTHREAD_NAME_SHUTDOWN),$(BUILD)/$(CPP_STDTHREAD_NAME) -e,$(CPP_STDTHREAD_OUTPUT_SHUTDOWN))
	$(call process_with_timer,$(CPP_STDTHREAD_NAME_SHUTDOWN),$(CPP_STDTHREAD_OUTPUT_SHUTDOWN))

#########################################

CPP_STDASYNC_NAME=cpp_stdasync
CPP_STDASYNC_NAME_START=$(CPP_STDASYNC_NAME)_start
CPP_STDASYNC_OUTPUT_START=$(BUILD)/$(CPP_STDASYNC_NAME_START)_output
CPP_STDASYNC_NAME_SHUTDOWN=$(CPP_STDASYNC_NAME)_shutdown
CPP_STDASYNC_OUTPUT_SHUTDOWN=$(BUILD)/$(CPP_STDASYNC_NAME_SHUTDOWN)_output
run_cpp_stdasync: run_cpp_stdasync_start run_cpp_stdasync_shutdown
run_cpp_stdasync_start: build
	$(call run_with_timer,$(CPP_STDASYNC_NAME_START),$(BUILD)/$(CPP_STDASYNC_NAME) -s,$(CPP_STDASYNC_OUTPUT_START))
	$(call process_with_timer,$(CPP_STDASYNC_NAME_START),$(CPP_STDASYNC_OUTPUT_START))
run_cpp_stdasync_shutdown: build
	$(call run_with_timer,$(CPP_STDASYNC_NAME_SHUTDOWN),$(BUILD)/$(CPP_STDASYNC_NAME) -e,$(CPP_STDASYNC_OUTPUT_SHUTDOWN))
	$(call process_with_timer,$(CPP_STDASYNC_NAME_SHUTDOWN),$(CPP_STDASYNC_OUTPUT_SHUTDOWN))

#########################################
