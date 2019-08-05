#!/usr/bin/env xonsh
import os

from xonsh.tools import print_color


DEFAULT_ENTRY = """import {pkg}
print("{pkg} version: " + {pkg}.__version__)
"""

def main(args=None):
    args = $ARGS[1:] if args is None else args
    pkgs = args

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
    print_color("{GREEN}Success!{NO_COLOR}")


if __name__ == "__main__":
    main()