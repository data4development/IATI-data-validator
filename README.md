IATI Data Validator
===================

Create data quality feedback for activity files in the
[data standard of the International Aid Transparency Initiative](http://iatistandard.org).

The IATI Validator is available for a month of testing between 11 November and 10 December.

* [IATI Validator test](https://test-validator.iatistandard.org/)
* [Q&A: New IATI Validator launch (testing phase)](https://docs.google.com/document/d/1qUOgGQGFbKwmwk5RXNMleTL_3OTpMo_A58UhbjlYw_M/edit)

Please provide your feedback by using the Validator Feedback form on the tool or raise issues 
here on Github. Users who are unable to access Github or use the Validator Feedback form are 
welcome to share their feedback by emailing support@iatistandard.org. 

Provide feedback on specific issues
-----------------------------------

To help the Technical Team and Data4development sort through feedback efficiently, please provide 
separate comments/issues on:

* Reporting a bug (where something is not working e.g. broken links)
* Requesting a feature/enhancement e.g. improvement in visual design
* Questions/comments on how the rules and guidance are being checked by the new IATI Validator

Technical
---------

Developer documentation is still work in progress.

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
