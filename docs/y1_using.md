---
title: Using the validator
---

The validator can be run as a Docker container, with all the required software and libraries included. You will have to install [Docker](https://www.docker.com) if it is not available on your machine yet.

### Build the container image

You can create the Docker image for the container from scratch.

```bash
cd engine
docker build -t iati-data-validator .
```

This will create a local image tagged `iati-data-validator`.

### Run the validator

The validator uses a *workspace* volume, with directories `src`, `dest`, `reports`, `tmp` for artifacts.

It is possible to bind the volume mount point to a local directory, to work with local files.

For example, you can bind the workspace to your current directory:

```bash
docker run --rm -v `pwd`:/workspace iati-data-validator
```

This will run the image in a container, binding your current directory (`pwd`)
to the workspace (```-v `pwd`:/workspace```)
and remove that container after it is finished (`--rm`).

If you are using a Linux system, you can use the `iati-data-validator` script.
This will run the command as shown above, and run the validator under your own
user name so that all files will be owned by you.

```bash
# run the rules validation
iati-data-validator rules
# and create HTML report pages
iati-data-validator report
```

If you don't specify what the validator should do, it will print out a list
of known *targets*. These targets include:

- **clean**
  The validator only processes files where the source is newer than the destination. If you want to make sure all steps are performed from the very beginning, first use the `clean` target to remove any intermediate results.
- **init**
  This will initialise the workspace, and create the directories `src`, `dest`, `reports` and `tmp`  if they do not yet exist.
- **rules**
  This will process all XML files in the `src` directory, and create new XML files with added feedback in the `dest` directory.
- **report**
  This will process all XML files in the `dest` directory, and create HTML feedback reports in the `reports` directory.

