GENERATOR_DIR = .
TEST_DIR = ./tests
VENV_DIR = ./.venvs
# Collect a list of generator names
GENERATOR_NAMES = $(sort $(dir $(wildcard ../test_generators/*/)))
# Map this list of names to a list of test outputs
TEST_TARGETS = $(patsubst %, $(TEST_DIR)/%, $(GENERATOR_NAMES))

.PHONY: clean all

all: $(TEST_DIR) $(TEST_TARGETS)


clean:
	rm -rf $(TEST_DIR)
	rm -rf $(VENV_DIR)

# The function that builds a set of suite files, by calling a generator for the given type (param 1)
define build_test_type
	# Create the output
    mkdir -p $(TEST_DIR)/$(1)

	# Create a virtual environment
	python3 -m venv $(VENV_DIR)/$(1)
	# Activate the venv, this is where dependencies are installed for the generator
	. $(VENV_DIR)/$(1)/bin/activate
	# Install all the necessary requirements
	pip3 install -r $(GENERATOR_DIR)/$(1)/requirements.txt --user

	# Run the generator. The generator is assumed to have an "main.py" file.
	# We output to the tests dir (generator program should accept a "-p <filepath>" argument.
	python3 $(GENERATOR_DIR)/$(1)/main.py -o $(TEST_DIR)/$(1)
endef

# The tests dir is simply build by creating the directory (recursively creating deeper directories if necessary)
$(TEST_DIR):
	mkdir -p $@

# For any target within the tests dir, build it using the build_test_type function.
$(TEST_DIR)/%:
	$(call build_test_type,$*)
