from __future__ import annotations

__all__: list[str] = ["test"]

import unittest


def test() -> unittest.TextTestResult:
    "This function runs all the tests."
    loader: unittest.TestLoader
    runner: unittest.TextTestRunner
    suite: unittest.TestSuite
    loader = unittest.TestLoader()
    suite = loader.discover(start_dir="identityfunction.tests")
    runner = unittest.TextTestRunner()
    return runner.run(suite)
