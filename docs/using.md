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

Using an alias will make it easier to use the targets:

```bash
alias iati-validator='docker run --rm -u=`id -u`:`id -g` -v `pwd`:/workspace data4development/iati-data-validator'
```

### Initialise the local workspace in the current folder.

```
iati-validator init
```

### Add the raw input files to the folder `input`, and create the feedback files:

```
iati-validator feedback
```

1. This will run `xml-check` to check whether the XML files are well-formed and validate 
   according to the IATI schema, and put the files in the `src` folder.
2. Next, it will run `rules` to apply the validation rules to the these files, to create 
   the feedback files in the `dest` folder.

### Create JSON and SVRL versions of the feedback files

```
iati-validator json
iati-validator svrl
```

The files will be put in the `json` and `svrl` folders.

### Create a static HTML page with feedback

```
iati-validator report
```

The reports will be available as `report/<filename>.feedback.html`.


## Run the validator as a stand-alone service

TBC

## Run the validator in a cluster as a batch processor

TBC

## Run the validator in a cluster as a service

TBC