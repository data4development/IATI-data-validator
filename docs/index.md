---
title: IATI data validator
order: 0
---

Get data quality feedback for files in the
[data standard of the International Aid Transparency Initiative](http://iatistandard.org).

[<img src="img/IATI.svg" style="max-width: 400px">](http://iatistandard.org)

This validator is intended to provide user-friendly feedback on data quality in 
individual IATI files. In addition to checking for XML well-formedness and compliance 
with the IATI schema, it looks at many other data quality aspects.

* Additional rules and recommendations in the IATI documentation.
* Issues encountered in "data in the wild".
* Guidelines of donors.

Data quality feedback messages have a _severity_ to indicate their relative importance.

* Errors make it hard or impossible to use the data.
* Warnings significantly reduce the value of the data.
* Improvements make the data more useful for specific uses.
* Notifications inform about potential issues and ways to optimise the data.

## Approach

The validator adds feedback as inline annotations in the original data,
and can provide other output formats to help process the feedback.

* An IATI-feedback file is an IATI file with annotations added in a separate namespace.
* An SVRL file provides a flat format XML file with all feedback messages, based on the Schematron 
Validation Reporting Language.
* A JSON file provides a bespoke representation of the feedback intended for the web front-end 
application ([the DataWorkbench provides feedback on published IATI files](http://www.dataworkbench.io/iati-feedback/)).

The validator makes an effort to recover from XML well-formedness errors, and to also 
provide feedback on files that do not pass schema validation (yet). 

It is up to the data user to decide on the basis of the severity or nature of the feedback 
whether to further process the data. 
