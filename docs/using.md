---
title: Using the validator
order: 2
---

The validator can be run as a Docker container, with all the required software and libraries included.

This page documents the main use cases.

1. Run the validator on a local machine, using local files.
2. Run the validator as a stand-alone service.
3. Run the validator in a cluster, as a batch processor. 
4. Run the validator in a cluster, as a service.

The validator uses a *workspace* volume, with folders `src`, `dest`, `tmp`, et 
cetera for artifacts.

## Run the validator on a local machine

It is possible to bind the volume mount point to a local folder, to work with local files.

For example, to use your current directory:

```bash
docker run --rm \
  -u=`id -u`:`id -g` \
  -v `pwd`:/workspace \
  data4development/iati-data-validator
```

This will show the available _targets_ in the system, using the local folder as 
a workspace.

* `init` will set up the necessary folders.
* `feedback` will do the XML checks and check the rules (these steps can also be run 
independently)
* `report`, `svrl` and `json` will transform the feedback file into a static HTML page, 
an SVRL file and a JSON file respectively.

## Run the validator as a stand-alone service

TBC

## Run the validator in a cluster as a batch processor

TBC

## Run the validator in a cluster as a service

TBC