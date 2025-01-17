import unittest

from identityfunction.core import identityfunction


class TestIdentityFunction(unittest.TestCase):
    def test_with_integers(self):
        """Test the identity function with integer values."""
        self.assertEqual(identityfunction(42), 42)
        self.assertEqual(identityfunction(-1), -1)
        self.assertEqual(identityfunction(0), 0)

    def test_with_strings(self):
        """Test the identity function with string values."""
        self.assertEqual(identityfunction("hello"), "hello")
        self.assertEqual(identityfunction(""), "")  # Empty string

    def test_with_lists(self):
        """Test the identity function with list values."""
        self.assertEqual(identityfunction([1, 2, 3]), [1, 2, 3])
        self.assertEqual(identityfunction([]), [])  # Empty list

    def test_with_dictionaries(self):
        """Test the identity function with dictionary values."""
        self.assertEqual(identityfunction({"key": "value"}), {"key": "value"})
        self.assertEqual(identityfunction({}), {})  # Empty dictionary

    def test_with_none(self):
        """Test the identity function with None."""
        self.assertIs(identityfunction(None), None)

    def test_with_custom_objects(self):
        """Test the identity function with custom objects."""

        class CustomObject:
            pass

        obj = CustomObject()
        self.assertIs(identityfunction(obj), obj)

    def test_with_booleans(self):
        """Test the identity function with boolean values."""
        self.assertIs(identityfunction(True), True)
        self.assertIs(identityfunction(False), False)

    def test_with_floats(self):
        """Test the identity function with float values."""
        self.assertEqual(identityfunction(3.14), 3.14)
        self.assertEqual(identityfunction(-2.718), -2.718)


if __name__ == "__main__":
    unittest.main()
