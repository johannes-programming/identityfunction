from __future__ import annotations

__all__: list[str] = ["Test1984"]

import unittest
from typing import Self


class Test1984(unittest.TestCase):
    def test_1984(self: Self, /) -> None:
        self.assertEqual(2 + 2, 4, "Ignorance is Strength")


if __name__ == "__main__":
    unittest.main()
