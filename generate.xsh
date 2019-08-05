#!/usr/bin/env xonsh
import os
import argparse

from xonsh.tools import print_color
from xonsh.lib.os import rmtree


DEFAULT_ENTRY = """import {pkg}
print("{pkg} version: " + {pkg}.__version__)
"""

CLEAN_PATHS = ("build", "dist", "test.py", "test.spec")


def make_parser():
    p = argparse.ArgumentParser('generate')
    p.add_argument("-c", "--clean", default=False, dest="clean",
                   action="store_true", help="removes existing output before building")
    p.add_argument("pkgs", nargs="+", help="packages to include")
    return p


def main(args=None):
    $RAISE_SUBPROC_ERROR = True
    parser = make_parser()
    ns = parser.parse_args(args)
    pkgs = ns.pkgs

    if ns.clean:
        print_color("{CYAN}Cleaning existing files:{NO_COLOR}")
        for path in CLEAN_PATHS:
            print(f"  removing {path}")
            rmtree(path, force=True)

    print_color("{CYAN}Generating test.py for " + ", ".join(pkgs) + "{NO_COLOR}")
    test_py = ""
    for pkg in pkgs:
        entry = os.path.join("entries", pkg + ".py")
        if os.path.exists(entry):
            with open(entry) as f:
                test_py += f.read()
        else:
            test_py += DEFAULT_ENTRY.format(pkg=pkg)
        test_py += "" if test_py.endswith("\n") else "\n"
    with open("test.py", "w") as f:
        f.write(test_py)

    print_color("{CYAN}Generating binary from test.py{NO_COLOR}")
    ![pyinstaller --onefile test.py]

    print_color("{CYAN}Executing binary ./dist/test{NO_COLOR}")
    ![./dist/test]

    print_color("{GREEN}Success!{NO_COLOR}")


if __name__ == "__main__":
    main()