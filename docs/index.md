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

<div class="row">
  <div class="col-md-4">
    <ul>
      <li><a href="http://iatistandard.org">International Aid Transparency Initiative</a></li>
      <li><a href="http://saxonica.com/">Saxonica's Saxon-HE XSLT processor</a></li>
      <li><a href="https://ant.apache.org/">Apache Ant build tool</a></li>
      <li><a href="https://www.docker.com">Docker containers</a></li>
    </ul>
  </div>
  <div class="col-md-4">
    <ul>
      <li><a href="https://jekyllrb.com">Jekyll</a></li>
      <li><a href="https://getbootstrap.com">Twitter Bootstrap</a></li>
      <li><a href="http://getfuelux.com">Fuelux extension</a></li>
      <li>Site theme: <a href="https://bootswatch.com/flatly/">Flatly from Bootswatch</a></li>
      <li>Syntax highlighting: <a href="http://richleland.github.io/pygments-css/">Native theme</a></li>
    </ul>
  </div>
</div>
