---
title: Using the validator
---

The validator can be run as a Docker container, with all the required software
and libraries included. You will have to install [Docker](https://www.docker.com)
if it is not available on your machine yet.

### Build the container image

You can create the Docker image for the container from scratch.

```bash
cd engine
docker build -t iati-data-validator .
```

This will create a local image tagged `iati-data-validator`.

### Run the validator

The validator uses a *workspace* volume, with directories `src`, `dest`,
`reports`, `tmp` for artifacts.

It is possible to bind the volume mount point
to a local directory, to work with local files.

For example, you can bind the workspace to your current directory:

```bash
docker run --rm -v `pwd`:/workspace iati-data-validator
```

This will run the image in a container, binding your current directory (`pwd`)
to the workspace (<code>-v `pwd`:/workspace</code>)
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

<dl>
<dt>clean</dt>
<dd>The validator only processes files where the source is newer than the
destination. If you want to make sure all steps are performed from the very
beginning, first use the <code>clean</code> target to remove any
intermediate results.</dd>
<dt>init</dt>
<dd>This will initialise the workspace, and create the directories
<code>src</code>, <code>dest</code>, <code>reports</code> and <code>tmp</code>
 if they do not yet exist.</dd>
<dt>rules</dt>
<dd>This will process all XML files in the <code>src</code> directory, and
create new XML files with added feedback in the <code>dest</code>
directory.</dd>
<dt>report</dt>
<dd>This will process all XML files in the <code>dest</code> directory, and
create HTML feedback reports in the <code>reports</code>
directory.</dd>
</dl>
