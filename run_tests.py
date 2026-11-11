from __future__ import annotations

__all__: list[str] = []

import sys

import identityfunction.tests


def main() -> int:
    return int(not identityfunction.tests.test())


if __name__ == "__main__":
    sys.exit(main())
