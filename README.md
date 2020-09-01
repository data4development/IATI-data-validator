IATI Data Validator
===================

This branch of the IATI Data Validator contains the feedback rules and messages as in use
on the DataWorkbench:

 - Version 1.0x feedback is still included
 - Feedback for additional guidelines provided by The Netherlands and the UK is included.
 - General practice feedback is included.
 - Reconciliation with the IATI rules is work in progress: there are differences in
   severities and wording, and there are different rules.
   
About (general)
---------------   

Create data quality feedback for activity files in the
[data standard of the International Aid Transparency Initiative](http://iatistandard.org).

Technical
---------

The validator can be run as a Docker container, with all the required software
and libraries.

Internally, the engine uses Ant for the workflow, and Saxon HE for data
processing.

* Ant provides *build targets* to transform input files into processed files.
  Targets can be simple steps, or complete workflows consisting of multiple
  *sub targets*.

* Saxon HE provides *XSLT transformations* to process XML files, and produce XML,
  HTML and JSON outputs.

For more information see the [online documentation](https://data4development.github.io/IATI-data-validator/)

Using git
---------

After cloning this repository, update the submodules recursively:

`git submodule update --recursive`

This will download the IATI-Rulesets, and within that, the Xspec testing library

Alternatively, clone the repository and submodules in one go with

`git clone --recurse-submodules https://github.com/data4development/IATI-data-validator.git`

Building the container
----------------------

Use the conventional docker build command:

`docker build -t my_validator:latest .`

Run the test suites:

`docker run --rm my_validator test`
