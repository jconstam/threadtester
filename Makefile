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
run: \
	run_c_pthread \
	run_cpp_pthread \
	run_cpp_stdthread \
	run_cpp_stdasync \
	run_cpp_boostthread \
	run_c_semt \
	run_c_pthreadmutex \
	run_cpp_semt \
	run_cpp_pthreadmutex \
	run_python3_thread \
	run_cpp_boostmutex \
	run_cpp_boostnamedmutex \
	run_cpp_boostmsgqueue

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
C_SEMT_NAME=$(C_SEMT_NAME)
C_SEMT_OUTPUT=$(BUILD)/$(C_SEMT_NAME)_output
run_c_semt: run_c_semt 
run_c_semt: build
	$(call run_with_timer,$(C_SEMT_NAME),$(BUILD)/$(C_SEMT_NAME) -s,$(C_SEMT_OUTPUT))
	$(call process_with_timer,$(C_SEMT_NAME),$(C_SEMT_OUTPUT))

#########################################

C_PTHREADMUTEX_NAME=c_pthreadmutex
C_PTHREADMUTEXFAST_NAME=$(C_PTHREADMUTEX_NAME)fast
C_PTHREADMUTEXFAST_OUTPUT=$(BUILD)/$(C_PTHREADMUTEXFAST_NAME)_output
C_PTHREADMUTEXRECURSIVE_NAME=$(C_PTHREADMUTEX_NAME)recursive
C_PTHREADMUTEXRECURSIVE_OUTPUT=$(BUILD)/$(C_PTHREADMUTEXRECURSIVE_NAME)_output
run_c_pthreadmutex: run_c_pthreadmutexfast run_c_pthreadmutexrecursive
run_c_pthreadmutexfast: build
	$(call run_with_timer,$(C_PTHREADMUTEXFAST_NAME),$(BUILD)/$(C_PTHREADMUTEX_NAME) -s,$(C_PTHREADMUTEXFAST_OUTPUT))
	$(call process_with_timer,$(C_PTHREADMUTEXFAST_NAME),$(C_PTHREADMUTEXFAST_OUTPUT))
run_c_pthreadmutexrecursive: build
	$(call run_with_timer,$(C_PTHREADMUTEXRECURSIVE_NAME),$(BUILD)/$(C_PTHREADMUTEX_NAME) -e,$(C_PTHREADMUTEXRECURSIVE_OUTPUT))
	$(call process_with_timer,$(C_PTHREADMUTEXRECURSIVE_NAME),$(C_PTHREADMUTEXRECURSIVE_OUTPUT))

#########################################

CPP_SEMT_NAME=cpp_semt
CPP_SEMT_NAME=$(CPP_SEMT_NAME)
CPP_SEMT_OUTPUT=$(BUILD)/$(CPP_SEMT_NAME)_output
run_cpp_semt: run_cpp_semt 
run_cpp_semt: build
	$(call run_with_timer,$(CPP_SEMT_NAME),$(BUILD)/$(CPP_SEMT_NAME) -s,$(CPP_SEMT_OUTPUT))
	$(call process_with_timer,$(CPP_SEMT_NAME),$(CPP_SEMT_OUTPUT))

#########################################

CPP_PTHREADMUTEX_NAME=cpp_pthreadmutex
CPP_PTHREADMUTEXFAST_NAME=$(CPP_PTHREADMUTEX_NAME)fast
CPP_PTHREADMUTEXFAST_OUTPUT=$(BUILD)/$(CPP_PTHREADMUTEXFAST_NAME)_output
CPP_PTHREADMUTEXRECURSIVE_NAME=$(CPP_PTHREADMUTEX_NAME)recursive
CPP_PTHREADMUTEXRECURSIVE_OUTPUT=$(BUILD)/$(CPP_PTHREADMUTEXRECURSIVE_NAME)_output
run_cpp_pthreadmutex: run_cpp_pthreadmutexfast run_cpp_pthreadmutexrecursive
run_cpp_pthreadmutexfast: build
	$(call run_with_timer,$(CPP_PTHREADMUTEXFAST_NAME),$(BUILD)/$(CPP_PTHREADMUTEX_NAME) -s,$(CPP_PTHREADMUTEXFAST_OUTPUT))
	$(call process_with_timer,$(CPP_PTHREADMUTEXFAST_NAME),$(CPP_PTHREADMUTEXFAST_OUTPUT))
run_cpp_pthreadmutexrecursive: build
	$(call run_with_timer,$(CPP_PTHREADMUTEXRECURSIVE_NAME),$(BUILD)/$(CPP_PTHREADMUTEX_NAME) -e,$(CPP_PTHREADMUTEXRECURSIVE_OUTPUT))
	$(call process_with_timer,$(CPP_PTHREADMUTEXRECURSIVE_NAME),$(CPP_PTHREADMUTEXRECURSIVE_OUTPUT))

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

CPP_BOOSTMUTEX_NAME=cpp_boostmutex
CPP_BOOSTMUTEXFAST_NAME=$(CPP_BOOSTMUTEX_NAME)fast
CPP_BOOSTMUTEXFAST_OUTPUT=$(BUILD)/$(CPP_BOOSTMUTEXFAST_NAME)_output
CPP_BOOSTMUTEXRECURSIVE_NAME=$(CPP_BOOSTMUTEX_NAME)recursive
CPP_BOOSTMUTEXRECURSIVE_OUTPUT=$(BUILD)/$(CPP_BOOSTMUTEXRECURSIVE_NAME)_output
run_cpp_boostmutex: run_cpp_boostmutexfast run_cpp_boostmutexrecursive
run_cpp_boostmutexfast: build
	$(call run_with_timer,$(CPP_BOOSTMUTEXFAST_NAME),$(BUILD)/$(CPP_BOOSTMUTEX_NAME) -s,$(CPP_BOOSTMUTEXFAST_OUTPUT))
	$(call process_with_timer,$(CPP_BOOSTMUTEXFAST_NAME),$(CPP_BOOSTMUTEXFAST_OUTPUT))
run_cpp_boostmutexrecursive: build
	$(call run_with_timer,$(CPP_BOOSTMUTEXRECURSIVE_NAME),$(BUILD)/$(CPP_BOOSTMUTEX_NAME) -e,$(CPP_BOOSTMUTEXRECURSIVE_OUTPUT))
	$(call process_with_timer,$(CPP_BOOSTMUTEXRECURSIVE_NAME),$(CPP_BOOSTMUTEXRECURSIVE_OUTPUT))

#########################################

CPP_BOOSTNAMEDMUTEX_NAME=cpp_boostnamedmutex
CPP_BOOSTNAMEDMUTEXFAST_NAME=$(CPP_BOOSTNAMEDMUTEX_NAME)fast
CPP_BOOSTNAMEDMUTEXFAST_OUTPUT=$(BUILD)/$(CPP_BOOSTNAMEDMUTEXFAST_NAME)_output
CPP_BOOSTNAMEDMUTEXRECURSIVE_NAME=$(CPP_BOOSTNAMEDMUTEX_NAME)recursive
CPP_BOOSTNAMEDMUTEXRECURSIVE_OUTPUT=$(BUILD)/$(CPP_BOOSTNAMEDMUTEXRECURSIVE_NAME)_output
run_cpp_boostnamedmutex: run_cpp_boostnamedmutexfast run_cpp_boostnamedmutexrecursive
run_cpp_boostnamedmutexfast: build
	$(call run_with_timer,$(CPP_BOOSTNAMEDMUTEXFAST_NAME),$(BUILD)/$(CPP_BOOSTNAMEDMUTEX_NAME) -s,$(CPP_BOOSTNAMEDMUTEXFAST_OUTPUT))
	$(call process_with_timer,$(CPP_BOOSTNAMEDMUTEXFAST_NAME),$(CPP_BOOSTNAMEDMUTEXFAST_OUTPUT))
run_cpp_boostnamedmutexrecursive: build
	$(call run_with_timer,$(CPP_BOOSTNAMEDMUTEXRECURSIVE_NAME),$(BUILD)/$(CPP_BOOSTNAMEDMUTEX_NAME) -e,$(CPP_BOOSTNAMEDMUTEXRECURSIVE_OUTPUT))
	$(call process_with_timer,$(CPP_BOOSTNAMEDMUTEXRECURSIVE_NAME),$(CPP_BOOSTNAMEDMUTEXRECURSIVE_OUTPUT))

#########################################

CPP_BOOSTMSGQUEUE_NAME=cpp_boostmsgqueue
CPP_BOOSTMSGQUEUESMALL_NAME=$(CPP_BOOSTMSGQUEUE_NAME)_small
CPP_BOOSTMSGQUEUESMALL_OUTPUT=$(BUILD)/$(CPP_BOOSTMSGQUEUESMALL_NAME)_output
CPP_BOOSTMSGQUEUELARGE_NAME=$(CPP_BOOSTMSGQUEUE_NAME)_large
CPP_BOOSTMSGQUEUELARGE_OUTPUT=$(BUILD)/$(CPP_BOOSTMSGQUEUELARGE_NAME)_output
run_cpp_boostmsgqueue: run_cpp_boostmsgqueuesmall run_cpp_boostmsgqueuelarge
run_cpp_boostmsgqueuesmall: build
	$(call run_with_timer,$(CPP_BOOSTMSGQUEUESMALL_NAME),$(BUILD)/$(CPP_BOOSTMSGQUEUE_NAME) -s,$(CPP_BOOSTMSGQUEUESMALL_OUTPUT))
	$(call process_with_timer,$(CPP_BOOSTMSGQUEUESMALL_NAME),$(CPP_BOOSTMSGQUEUESMALL_OUTPUT))
run_cpp_boostmsgqueuelarge: build
	$(call run_with_timer,$(CPP_BOOSTMSGQUEUELARGE_NAME),$(BUILD)/$(CPP_BOOSTMSGQUEUE_NAME) -e,$(CPP_BOOSTMSGQUEUELARGE_OUTPUT))
	$(call process_with_timer,$(CPP_BOOSTMSGQUEUELARGE_NAME),$(CPP_BOOSTMSGQUEUELARGE_OUTPUT))

#########################################
