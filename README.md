# Eth2.0 Test Generators

This repository contains generators that build tests for Eth 2.0 clients.
The test files themselves can be found in [ethereum/eth2.0-tests](https://github.com/ethereum/eth2.0-tests/).

Whenever a release is made, the new tests are automatically built and
[eth2TestGenBot](https://github.com/eth2TestGenBot) commits the changes to the test repository.

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
