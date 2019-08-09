# pyinstaller-test
Some generic tests for PyInstaller

## pyinstaller tutorial

First, you'll need to install pyinstaller and any other packages you want
into a conda environment:

```sh
$ conda create -n bundle python=3.7 pyinstaller other-deps ...
$ conda activate bundle
```

Next you'll need a Python file that you want to create an executable
from. Let's call this `test.py`.  The exact contents of this file
are what will be run by the executable that pyinstaller creates.
This target file will normally be the script / entry point for your
application. As an overly simple example, let's say that we just
want to print the `flask` version, we'd write a script that looks like:

**test.py**

```python
import flask
print("flask version: " + flask.__version__)
```

To create a single, binary executable for this, run pyinstaller
as follows:

```sh
(bundle) $ pyinstaller --onefile test.py
```

This will create `build/` & `dist/` directories. Inside of the `dist/`
directory is a `test` executable.  You can run this as:

```sh
$ ./dist/test
flask version: 1.1.1
```

## Important Gotchas

PyInstaller is not perfect at finding all dependencies that it needs to
link in. For certain packages it needs a little help by explicitly importing
modules in the main script / entry point. Luckily, this is enough to have
pyinstaller work properly.

For example, numpy requires it `random` subpackage to be expliticly included.
So the `test.py` for numpy would look like:

```python
import numpy
import numpy.random.common
import numpy.random.bounded_integers
import numpy.random.entropy

print("numpy version:", numpy.__version__)
```

Failing to import the random modules will cause lookup failures when you
go to run the compiled binary. Unfortunately, this also affects any package
which depends on numpy. So for example, the `test.py` for `h5py` would
look like:

```python
import numpy
import numpy.random.common
import numpy.random.bounded_integers
import numpy.random.entropy
import h5py

print("h5py version:", h5py.__version__)
```

Packages that have these kinds of special cases - and what imports they
need to be handled properly - are avialble in the `entries/` directory of this
repository.

## Generate Test

This repo also contains a (xonsh) script for creating, compiling, and running
these test scripts automatically. It is called `generate.xsh`. You can pass this
a list of installed package names and it will run.  You will have to have xonsh
installed to execute this.

```sh
(bundle) $ conda install -c conda-forge xonsh
(bundle) $ ./generate.xsh numpy scikit-learn bz2
```

