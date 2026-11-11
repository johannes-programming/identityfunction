from __future__ import annotations

__all__: list[str] = ["identityfunction", "main", "parse_args", "run"]

import sys

from identityfunction.core import identityfunction, main

if __name__ == "__main__":
    sys.exit(main())
