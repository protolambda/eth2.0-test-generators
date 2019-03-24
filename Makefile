GENERATOR_DIR = .
TEST_DIR = ./tests
VENV_DIR = ./.venvs
GENERATOR_DIR = ./test_generators
# Collect a list of generator names
GENERATORS = $(sort $(dir $(wildcard $(GENERATOR_DIR)/*/)))
# Map this list of generator paths to a list of test output paths
TEST_TARGETS = $(patsubst $(GENERATOR_DIR)/%, $(TEST_DIR)/%, $(GENERATORS))

.PHONY: clean all

all: $(TEST_DIR) $(TEST_TARGETS)


clean:
	rm -rf $(TEST_DIR)
	rm -rf $(VENV_DIR)

# The function that builds a set of suite files, by calling a generator for the given type (param 1)
define build_test_type
	$(info running generator $(1))
	# Create the output
	mkdir -p $(TEST_DIR)$(1)

	# Create a virtual environment
	python3 -m venv $(VENV_DIR)$(1)
	# Activate the venv, this is where dependencies are installed for the generator
	. $(VENV_DIR)$(1)bin/activate
	# Install all the necessary requirements
	pip3 install -r $(GENERATOR_DIR)$(1)requirements.txt --user

	# Run the generator. The generator is assumed to have an "main.py" file.
	# We output to the tests dir (generator program should accept a "-p <filepath>" argument.
	python3 $(GENERATOR_DIR)$(1)main.py -o $(TEST_DIR)$(1)
	$(info generator $(1) finished)
endef

# The tests dir is simply build by creating the directory (recursively creating deeper directories if necessary)
$(TEST_DIR):
	$(info ${TEST_TARGETS})
	mkdir -p $@

# For any target within the tests dir, build it using the build_test_type function.
$(TEST_DIR)%:
	$(call build_test_type,$*)
