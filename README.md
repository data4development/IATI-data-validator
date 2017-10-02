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

For more information see
the [online documentation](https://data4development.github.io/IATI-data-validator/)
