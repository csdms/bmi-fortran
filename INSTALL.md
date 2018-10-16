# Install

To build the BMI Fortran bindings, sample implementation, tests,
and examples, run

    mkdir _build && cd _build
    cmake .. -DCMAKE_INSTALL_PREFIX=<path-to-installation>
    make

where `<path-to-installation>` is the base directory where you want
to install things (`/usr/local` is the default).

Then, to install:

    $ make install

The installation will look like:

```bash
.
|-- bin
|   `-- run_heatf
`-- lib
    |-- bmif.mod
    |-- bmiheatf.mod
    |-- heatf.mod
    |-- libbmif.so
    |-- libbmiheatf.so
    `-- pkgconfig
        |-- bmif.pc
        `-- heatf.pc
```

On macOS, after install, be sure to update runtime paths with

    $ source ../scripts/update_rpaths

Run unit tests and examples of using the sample implementation with

    $ ctest
