from __future__ import annotations

__all__: list[str] = ["identityfunction", "main", "parse_args", "run"]

import argparse
from collections import abc
from importlib import metadata
from typing import Any, TypeVar

Value = TypeVar("Value")


def identityfunction(value: Value, /) -> Value:
    "This function returns the value given to it."
    return value


def main(args: abc.Iterable[str] | None = None) -> int:
    "This command applies the identity function to value."
    kwargs: dict[str, Any]
    space: argparse.Namespace
    value: str
    try:
        space = parse_args(args)
        kwargs = vars(space)
        value = kwargs.pop("value")
        run(value, **kwargs)
    except SystemExit as exit:
        if isinstance(exit.code, int):
            return int(exit.code)
        else:
            return int(bool(exit.code))
    except BaseException:
        return 1
    else:
        return 0


def parse_args(args: abc.Iterable[str] | None = None) -> argparse.Namespace:
    parser: argparse.ArgumentParser
    version: str
    parser = argparse.ArgumentParser(
        add_help=False,
        description="This command applies the identity function.",
        fromfile_prefix_chars="@",
        prog="identityfunction",
    )
    version = "%(prog)s, version " + metadata.version("identityfunction")
    parser.add_argument(
        "-V",
        "--version",
        action="version",
        help="show the version and abort",
        version=version,
    )
    parser.add_argument(
        "-h",
        "--help",
        action="help",
        help="show this message and abort",
    )
    parser.add_argument("value")
    return parser.parse_args(args)


def run(value: object, /) -> None:
    print(value)
