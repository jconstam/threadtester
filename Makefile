RUN_COUNT		?=	10000

ROOT			=	$(shell pwd)
BUILD			=	$(ROOT)/build
SRC				=	$(ROOT)/src
IMG				=	$(ROOT)/docs/img
DATA			=	$(ROOT)/data
DOCS			=	$(ROOT)/docs

OUTPUT_PARSER	=	python $(SRC)/outputparser.py
GEN_HTML		=	python $(SRC)/generateHTML.py
DATA_FILE		=	$(DATA)/data.json
LOOKUP_FILE		=	$(DATA)/lookup.json
HTML_FILE		=	$(DOCS)/index.html
HTML_TEMPLATE	=	$(DOCS)/template.html

SILENT_MAKE		=	>/dev/null

#########################################

define run_with_timer
	@echo "RUNNING $(1)"
	@d=$$(date +%s); $(2) -c $(RUN_COUNT) > $(3) && echo "\tTook $$(($$(date +%s)-d)) seconds"
endef

define run_parser
	$(OUTPUT_PARSER) \
		--name $(1) \
		--jsonfile $(DATA_FILE) \
		--graphPath $(IMG) \
		--rootPath $(ROOT) \
		--lookupjsonFile $(LOOKUP_FILE)
endef

define run_generateHTML
	$(GEN_HTML) \
		--jsonfile $(DATA_FILE) \
		--lookupjsonFile $(LOOKUP_FILE) \
		--htmlFile $(HTML_FILE) \
		--htmlTemplate $(HTML_TEMPLATE) \
		--graphPath $(IMG) 
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
	@d=$$(date +%s); cd $(BUILD) && cmake $(SILENT_MAKE) $(SRC) && make $(SILENT_MAKE) && echo "\tTook $$(($$(date +%s)-d)) seconds"

.PHONY: run
run: run_c_pthread run_cpp_pthread run_cpp_stdthread run_cpp_stdasync run_cpp_boostthread run_c_semt run_c_pthreadmutex run_cpp_semt run_cpp_pthreadmutex run_python3_thread

.PHONY: results
results:
	@echo "COMPILING FINAL RESULTS"
	@d=$$(date +%s); $(call run_generateHTML) && echo "\tTook $$(($$(date +%s)-d)) seconds"
	
clean:
	@echo "Cleaning up $(BUILD)"
	@rm -rf $(BUILD)
	
clean_results:
	@echo "Cleaning up $(DATA_FILE)"
	@rm -rf $(DATA_FILE)
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

CPP_BOOSTTHREAD_NAME=cpp_boostthread
CPP_BOOSTTHREAD_NAME_START=$(CPP_BOOSTTHREAD_NAME)_start
CPP_BOOSTTHREAD_OUTPUT_START=$(BUILD)/$(CPP_BOOSTTHREAD_NAME_START)_output
CPP_BOOSTTHREAD_NAME_SHUTDOWN=$(CPP_BOOSTTHREAD_NAME)_shutdown
CPP_BOOSTTHREAD_OUTPUT_SHUTDOWN=$(BUILD)/$(CPP_BOOSTTHREAD_NAME_SHUTDOWN)_output
run_cpp_boostthread: run_cpp_boostthread_start run_cpp_boostthread_shutdown
run_cpp_boostthread_start: build
	$(call run_with_timer,$(CPP_BOOSTTHREAD_NAME_START),$(BUILD)/$(CPP_BOOSTTHREAD_NAME) -s,$(CPP_BOOSTTHREAD_OUTPUT_START))
	$(call process_with_timer,$(CPP_BOOSTTHREAD_NAME_START),$(CPP_BOOSTTHREAD_OUTPUT_START))
run_cpp_boostthread_shutdown: build
	$(call run_with_timer,$(CPP_BOOSTTHREAD_NAME_SHUTDOWN),$(BUILD)/$(CPP_BOOSTTHREAD_NAME) -e,$(CPP_BOOSTTHREAD_OUTPUT_SHUTDOWN))
	$(call process_with_timer,$(CPP_BOOSTTHREAD_NAME_SHUTDOWN),$(CPP_BOOSTTHREAD_OUTPUT_SHUTDOWN))

#########################################

C_SEMT_NAME=c_semt
C_SEMT_NAME_UNLOCK=$(C_SEMT_NAME)_unlock
C_SEMT_OUTPUT_UNLOCK=$(BUILD)/$(C_SEMT_NAME_UNLOCK)_output
run_c_semt: run_c_semt_unlock 
run_c_semt_unlock: build
	$(call run_with_timer,$(C_SEMT_NAME_UNLOCK),$(BUILD)/$(C_SEMT_NAME) -s,$(C_SEMT_OUTPUT_UNLOCK))
	$(call process_with_timer,$(C_SEMT_NAME_UNLOCK),$(C_SEMT_OUTPUT_UNLOCK))

#########################################

C_PTHREADMUTEX_NAME=c_pthreadmutex
C_PTHREADMUTEXFAST_NAME_UNLOCK=$(C_PTHREADMUTEX_NAME)fast_unlock
C_PTHREADMUTEXFAST_OUTPUT_UNLOCK=$(BUILD)/$(C_PTHREADMUTEXFAST_NAME_UNLOCK)_output
C_PTHREADMUTEXRECURSIVE_NAME_UNLOCK=$(C_PTHREADMUTEX_NAME)recursive_unlock
C_PTHREADMUTEXRECURSIVE_OUTPUT_UNLOCK=$(BUILD)/$(C_PTHREADMUTEXRECURSIVE_NAME_UNLOCK)_output
run_c_pthreadmutex: run_c_pthreadmutexfast_unlock run_c_pthreadmutexrecursive_unlock
run_c_pthreadmutexfast_unlock: build
	$(call run_with_timer,$(C_PTHREADMUTEXFAST_NAME_UNLOCK),$(BUILD)/$(C_PTHREADMUTEX_NAME) -s,$(C_PTHREADMUTEXFAST_OUTPUT_UNLOCK))
	$(call process_with_timer,$(C_PTHREADMUTEXFAST_NAME_UNLOCK),$(C_PTHREADMUTEXFAST_OUTPUT_UNLOCK))
run_c_pthreadmutexrecursive_unlock: build
	$(call run_with_timer,$(C_PTHREADMUTEXRECURSIVE_NAME_UNLOCK),$(BUILD)/$(C_PTHREADMUTEX_NAME) -e,$(C_PTHREADMUTEXRECURSIVE_OUTPUT_UNLOCK))
	$(call process_with_timer,$(C_PTHREADMUTEXRECURSIVE_NAME_UNLOCK),$(C_PTHREADMUTEXRECURSIVE_OUTPUT_UNLOCK))

#########################################

CPP_SEMT_NAME=cpp_semt
CPP_SEMT_NAME_UNLOCK=$(CPP_SEMT_NAME)_unlock
CPP_SEMT_OUTPUT_UNLOCK=$(BUILD)/$(CPP_SEMT_NAME_UNLOCK)_output
run_cpp_semt: run_cpp_semt_unlock 
run_cpp_semt_unlock: build
	$(call run_with_timer,$(CPP_SEMT_NAME_UNLOCK),$(BUILD)/$(CPP_SEMT_NAME) -s,$(CPP_SEMT_OUTPUT_UNLOCK))
	$(call process_with_timer,$(CPP_SEMT_NAME_UNLOCK),$(CPP_SEMT_OUTPUT_UNLOCK))

#########################################

CPP_PTHREADMUTEX_NAME=cpp_pthreadmutex
CPP_PTHREADMUTEXFAST_NAME_UNLOCK=$(CPP_PTHREADMUTEX_NAME)fast_unlock
CPP_PTHREADMUTEXFAST_OUTPUT_UNLOCK=$(BUILD)/$(CPP_PTHREADMUTEXFAST_NAME_UNLOCK)_output
CPP_PTHREADMUTEXRECURSIVE_NAME_UNLOCK=$(CPP_PTHREADMUTEX_NAME)recursive_unlock
CPP_PTHREADMUTEXRECURSIVE_OUTPUT_UNLOCK=$(BUILD)/$(CPP_PTHREADMUTEXRECURSIVE_NAME_UNLOCK)_output
run_cpp_pthreadmutex: run_cpp_pthreadmutexfast_unlock run_cpp_pthreadmutexrecursive_unlock
run_cpp_pthreadmutexfast_unlock: build
	$(call run_with_timer,$(CPP_PTHREADMUTEXFAST_NAME_UNLOCK),$(BUILD)/$(CPP_PTHREADMUTEX_NAME) -s,$(CPP_PTHREADMUTEXFAST_OUTPUT_UNLOCK))
	$(call process_with_timer,$(CPP_PTHREADMUTEXFAST_NAME_UNLOCK),$(CPP_PTHREADMUTEXFAST_OUTPUT_UNLOCK))
run_cpp_pthreadmutexrecursive_unlock: build
	$(call run_with_timer,$(CPP_PTHREADMUTEXRECURSIVE_NAME_UNLOCK),$(BUILD)/$(CPP_PTHREADMUTEX_NAME) -e,$(CPP_PTHREADMUTEXRECURSIVE_OUTPUT_UNLOCK))
	$(call process_with_timer,$(CPP_PTHREADMUTEXRECURSIVE_NAME_UNLOCK),$(CPP_PTHREADMUTEXRECURSIVE_OUTPUT_UNLOCK))

#########################################

PYTHON3_THREAD_NAME=python3_thread
PYTHON3_THREAD_SCRIPT=python3 $(SRC)/$(PYTHON3_THREAD_NAME)/$(PYTHON3_THREAD_NAME).py
PYTHON3_THREAD_NAME_START=$(PYTHON3_THREAD_NAME)_start
PYTHON3_THREAD_OUTPUT_START=$(BUILD)/$(PYTHON3_THREAD_NAME_START)_output
PYTHON3_THREAD_NAME_SHUTDOWN=$(PYTHON3_THREAD_NAME)_shutdown
PYTHON3_THREAD_OUTPUT_SHUTDOWN=$(BUILD)/$(PYTHON3_THREAD_NAME_SHUTDOWN)_output
run_python3_thread: run_python3_thread_start run_python3_thread_shutdown
run_python3_thread_start:
	$(call run_with_timer,$(PYTHON3_THREAD_NAME_START),$(PYTHON3_THREAD_SCRIPT) -s,$(PYTHON3_THREAD_OUTPUT_START))
	$(call process_with_timer,$(PYTHON3_THREAD_NAME_START),$(PYTHON3_THREAD_OUTPUT_START))
run_python3_thread_shutdown:
	$(call run_with_timer,$(PYTHON3_THREAD_NAME_SHUTDOWN),$(PYTHON3_THREAD_SCRIPT) -e,$(PYTHON3_THREAD_OUTPUT_SHUTDOWN))
	$(call process_with_timer,$(PYTHON3_THREAD_NAME_SHUTDOWN),$(PYTHON3_THREAD_OUTPUT_SHUTDOWN))

#########################################
