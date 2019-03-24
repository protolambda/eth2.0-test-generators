# Eth2.0 Test Generators

This repository contains generators that build tests for Eth 2.0 clients.
The test files themselves can be found in [ethereum/eth2.0-tests](https://github.com/ethereum/eth2.0-tests/).

Whenever a release is made, the new tests are automatically built and
[eth2TestGenBot](https://github.com/eth2TestGenBot) commits the changes to the test repository.

## How to run generators

pre-requisites:
- Python 3 installed
- PIP 3
- GNU make

### Cleaning

This removes the existing virtual environments (`.venvs/`), and tests (`tests/`).

```bash
make clean 
```

### Running all test generators

This runs all the generators.

```bash
make all
```

### Running a single generator

The make file auto-detects generators in the `test_generators/` directory,
 and provides a tests-gen target for each generator, see example.

```bash
make ./tests/shuffling/
```

## Developing a generator

Simply open up the generator (not all at once) of choice in your favorite IDE/editor, and run:

```bash
# Create a virtual environment (any venv/.venv/.venvs is git-ignored)
python3 -m venv .venv
# Activate the venv, this is where dependencies are installed for the generator
. .venv/bin/activate
```

Now that you have a virtual environment, write your generator.
It's recommended to extend the base-generator.

Create a `requirements.txt` in the root of your generator directory:
```
eth-utils==1.4.1
../test_libs/gen_helpers
```

Install all the necessary requirements (re-run when you add more):
```bash
pip3 install -r requirements.txt --user
```

And write your initial test generator, extending the base generator:

Write a `main.py` file, here's an example:

```python
from gen_base import gen_runner, gen_suite, gen_typing

from eth_utils import (
    to_dict, to_tuple
)


@to_dict
def bar_test_case(v: int):
    yield "bar_v", v
    yield "bar_v_plus_1", v + 1
    yield "bar_list", list(range(v))


@to_tuple
def generate_bar_test_cases():
    for i in range(10):
        yield bar_test_case(i)


def bar_test_suite() -> gen_typing.TestSuite:
    return gen_suite.render_suite(
        title="bar_minimal",
        summary="Minimal example suite, testing bar.",
        fork="v0.5.1",
        config="minimal",
        test_cases=generate_bar_test_cases())


if __name__ == "__main__":
    gen_runner.run_generator("foo", [bar_test_suite])

```

Recommendations:
- you can have more than just 1 generator, e.g. ` gen_runner.run_generator("foo", [bar_test_suite, abc_test_suite, example_test_suite])`
- you can concatenate lists of test cases, if you don't want to split it up in suites.
- you can split your suite generators into different python files/packages, good for code organization.
- use config "minimal" for performance. But also implement a suite with the default config where necessary
- the test-generator accepts `--output` and `--force` (overwrite output)

## How to add a new test generator

In order to add a new test generator that builds `New Tests`:

1. Create a new directory `new_tests`, within the `test_generators` directory.
 Note that `new_tests` is also the name of the directory in which the tests will appear in the tests repository later.
2. Your generator is assumed to have a `requirements.txt` file,
 with any dependencies it may need. Leave it empty if your generator has none.
3. Your generator is assumed to have a `main.py` file in its root.
 By adding the base generator to your requirements, you can make a generator really easily. See docs below.
4. Your generator is called with `-o some/file/path/for_testing/can/be_anything`.
 The base generator helps you handle this; you only have to define suite headers,
 and a list of tests for each suite you generate.
5. Finally, add any linting or testing commands to the
 [circleci config file](https://github.com/ethereum/eth2.0-test-generators/blob/master/.circleci/config.yml)
 if desired to increase code quality.
 
Note: you do not have to change the makefile.
However, if necessary (e.g. not using python, or mixing in other languages), submit an issue, and it can be a special case.
Do note that generators should be easy to maintain, lean, and based on the spec.

All of this should be done in a pull request to the master branch.

To deploy new tests to the testing repository:

1. Create a release tag with a new version number on Github.
2. Increment either the:
 - major version, to indicate a change in the general testing format
 - minor version, if a new test generator has been added
 - path version, in other cases.

## How to remove a test generator

If a test generator is not needed anymore, undo the steps described above and make a new release:

1. remove the generator folder
2. remove the generated tests in the `eth2.0-tests` repository by opening a PR there.
3. make a new release
