RUN_COUNT		?=	10000

ROOT			=	$(shell pwd)
BUILD			=	$(ROOT)/build
SRC				=	$(ROOT)/src

OUTPUT_PARSER	=	python $(SRC)/outputparser.py
DATA_FILE		=	$(BUILD)/data.json
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
			--markdownfile $(MD_FILE)
endef

define process_with_timer
	@echo "PROCESSING $(1)"
	@d=$$(date +%s); cat $(2) | $(call run_parser,$(1))	&& echo "\tTook $$(($$(date +%s)-d)) seconds"
endef

#########################################

build: pthread_c pthread_cpp
run: build run_pthread_c run_pthread_cpp
	@echo "COMPILING RESULTS"
	@$(call run_parser,compile_results)

clean:
	@echo "Cleaning up $(BUILD)"
	@rm -rf $(BUILD)

#########################################

PTHREAD_C_NAME=pthread_c
PTHREAD_C_SRC=$(SRC)/$(PTHREAD_C_NAME)
PTHREAD_C_BUILD=$(BUILD)/$(PTHREAD_C_NAME)
PTHREAD_C_OUTPUT=$(BUILD)/output
pthread_c:
	$(call cmake_build_with_timer,$(PTHREAD_C_NAME),$(PTHREAD_C_BUILD),$(PTHREAD_C_SRC))
run_pthread_c:
	$(call run_with_timer,$(PTHREAD_C_NAME),$(PTHREAD_C_BUILD)/$(PTHREAD_C_NAME),$(PTHREAD_C_OUTPUT))
	$(call process_with_timer,$(PTHREAD_C_NAME),$(PTHREAD_C_OUTPUT))

#########################################

PTHREAD_CPP_NAME=pthread_cpp
PTHREAD_CPP_SRC=$(SRC)/$(PTHREAD_CPP_NAME)
PTHREAD_CPP_BUILD=$(BUILD)/$(PTHREAD_CPP_NAME)
PTHREAD_CPP_OUTPUT=$(BUILD)/output
pthread_cpp:
	$(call cmake_build_with_timer,$(PTHREAD_CPP_NAME),$(PTHREAD_CPP_BUILD),$(PTHREAD_CPP_SRC))
run_pthread_cpp:
	$(call run_with_timer,$(PTHREAD_CPP_NAME),$(PTHREAD_CPP_BUILD)/$(PTHREAD_CPP_NAME),$(PTHREAD_CPP_OUTPUT))
	$(call process_with_timer,$(PTHREAD_CPP_NAME),$(PTHREAD_CPP_OUTPUT))

#########################################
