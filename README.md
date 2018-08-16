IATI Data Validator
===================

Create data quality feedback for activity files in the
[data standard of the International Aid Transparency Initiative](http://iatistandard.org).

The validator can be run as a Docker container, with all the required software
and libraries.

Internally, the engine uses Ant for the workflow, and Saxon HE for the data
processing.

* Ant provides *build targets* to transform input files into processed files.
  Targets can be simple steps, or complete workflows consisting of multiple
  *sub targets*.

* Saxon HE provides *XSLT transformations* to process XML files.
  The result can be other XML files, or HTML or JSON outputs.
  We provide an HTML feedback report as one target.

Tests
-----

Xspec provides the tests, and is included as git submodule.

Run `./develop/xspec/bin/xspec.sh tests/iati-activities-1.0x.xspec` to do all tests on IATI 1.0x data.

If you have a Saxon PE or EE license and use it as your Saxon processor, it is possible to include the `-c` parameter to get a code coverage report.

For more information see
the [online documentation](https://data4development.github.io/IATI-data-validator/)
