from typing import Tuple, Callable, Dict, Any

TestSuite = Dict[str, Any]
TestSuiteCreator = Callable[[], TestSuite]

TestCase = Dict[str, Any]
TestSuiteTestCases = Tuple[TestCase]
