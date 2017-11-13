---
title: IATI data validator
---

Get data quality feedback for activity files written in the
[data standard of the International Aid Transparency Initiative](http://iatistandard.org).

![](img/IATI.png)

This data validator is intended to provide user-friendly feedback on IATI files.

The validator first adds feedback annotations to the original data file,
and then can provide various output formats to help process the feedback.
Included right now is a web page with detailed feedback per activity.

Currently, the engine expects valid XML, and assumes the data
is using the IATI standard. This makes it possible to offer feedback on IATI
files that do not conform to the technical standard yet.
It assumes the data is using version 2.01 or 2.02 of the standard, although
several tests will also work on data in version 1.0x.

It does not validate the data in a technical sense yet.
Additional tests for both well-formed XML and for validity according to
the IATI schema will be added still.

Thanks
------

| Run                                      | Style                                    | Make                                     |
| ---------------------------------------- | ---------------------------------------- | ---------------------------------------- |
| [International Aid Transparency Initiative](http://iatistandard.org) | [Twitter Bootstrap](https://getbootstrap.com) | [Github and Github Pages](https://github.com) |
| [Saxonica's Saxon-HE XSLT processor](http://saxonica.com) | [Fuelux extension](http://getfuelux.com) | [Jekyll](https://jekyllrb.com)           |
| [Apache Ant build tool](https://ant.apache.org) | [Flatly theme from Bootswatch](https://bootswatch.com/flatly) | [Typora markdown editor](https://typora.io/) |
| [Docker containers](https://www.docker.com) | [Native theme syntax highlighting](http://richleland.github.io/pygments-css/) | [Oxygen XML Editor](https://oxygenxml.com) |


