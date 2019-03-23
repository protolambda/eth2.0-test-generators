from eth_utils import (
    to_dict,
)

from gen_base.gen_typing import TestSuiteTestCases


@to_dict
def render_suite(*, title: str, summary: str, fork: str, config: str, test_cases: TestSuiteTestCases):
    yield "title", title
    if summary is not None:
        yield "summary", summary
    yield "fork", fork
    yield "config", config
    yield "test_cases", test_cases
