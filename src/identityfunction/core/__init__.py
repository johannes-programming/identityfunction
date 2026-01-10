from typing import *

import click
import preparse
from funclibs.elementary.identity import identity

__all__ = ["identityfunction", "main"]


identityfunction = identity


@preparse.PreParser().click()
@click.command(add_help_option=False)
@click.help_option("-h", "--help")
@click.version_option(None, "-V", "--version")
@click.argument("value", type=str)
def main(value: str) -> None:
    "This command applies the identity function to value."
    click.echo(identityfunction(value))
