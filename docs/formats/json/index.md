---
title: JSON format
suborder: 2
---

This is a description of the JSON format of data quality feedback.

{:.warning}

Both the documentation and the data format are still under development.

The JSON format of data quality feedback is used in the web front-end application, and its format is currently tailored to that purpose.

## File-level feedback

For an IATI activities file, the feedback consists of several components:

```json
{
  "schemaVersion": "0.9.15",
  "filetype": "iati-activities",
  "validation": "schema-errors",
  "activities": [
    {
      "title": "Activity title",
      "identifier": "XM-IATI-123-456",
      "publisher": "XM-IATI-123",
      "feedback": [
          //... messages ...
      ]
    },
    //... more activities ...
  ]
}
```

Common elements:

* The `schemaversion` is the version of the validation rules used to create the feedback.
* The `filetype` of the file: `iati-activities`, `iati-organisations`, ...
* The file-level validation result:
  * `not-an-xml-file`: the file does not contain (valid) XML and cannot be recognised as IATI
  * `not-an-iati-file`: the file contains valid XML data but not IATI
  * `iati-with-schema-errors`: the file contains IATI data with schema errors
  * `iati-with-xml-errors`: the file has XML errors, and in a recovered version is valid IATI
  * `iati-with-xml-and-schema-errors`: the file has XML errors, and in a recovered version also has IATI schema errors
* An array of file-level feedback messages (see format below).

For an IATI activities file, this is completed with:

* The `activities` is an array, with for each activity
  * The `title`, activity `identifier`, and `publisher` identifier.
  * An array of feedback messages (see format below).

## Feedback messages

Feedback messages are given in an array, grouped by category and then message id.

```json
      "feedback": [
        {
          "category": "identifiers",
          "label": "Identification",
          "messages": [
            {
              "id": "1.2.2",
              "text": "The organisation identifier is missing.",
              "rulesets": [
                {
                  "src": "iati",
                  "severity": "info"
                }
              ],
              "context": [
                {
                  "text": "In participating-org \"Partner Organisation\" (role 4)\n  "
                },
                {
                  "text": "In transaction of 2017-12-31 for receiver-org \"XYZ\""
                }
              ]
            }
          ]
        },
        //... more messages ...
```

Elements:

* `category` and `label`: machine and human readable label for the category.
* An array of messages in that category:
  * `id` and `text`: the identifier and text for the message.
  * `rulesets`: an array with the rulesets in which the message occurs, with a `src` identifier for the ruleset and the `severity` according to that ruleset.
  * An array of `context` message objects to provide additional information on where the feedback was generated. These currently only contain a `text` element.

## About the message and the context

The feedback is organised per file and then per activity (in an activities file) or organisation (in an organisation file, which typically only contains a single organisation). The same feedback message can occur at many places within a single activity, an also in many activities within a file. The category of the message will point to the general part of the IATI activity, and the context strings are intended to provide more detailed information (a sort of debug message) to find the source of the feedback.

The context can also be empty, if the feedback applies to the file, activity or organisation.

## Full JSON sample

```json
{
  "schemaVersion": "0.9.15",
  "activities": [
    {
      "title": "Activity title",
      "identifier": "XM-IATI-123-456",
      "publisher": "XM-IATI-123",
      "feedback": [
        {
          "category": "identifiers",
          "label": "Identification",
          "messages": [
            {
              "id": "1.2.2",
              "text": "The organisation identifier is missing.",
              "rulesets": [
                {
                  "src": "iati",
                  "severity": "info"
                }
              ],
              "context": [
                {
                  "text": "In participating-org \"Partner Organisation\" (role 4)\n  "
                },
                {
                  "text": "In transaction of 2017-12-31 for receiver-org \"XYZ\""
                }
              ]
            }
          ]
        },
        {
          "category": "financial",
          "label": "Financial",
          "messages": [
            {
              "id": "7.5.3",
              "text": "The budget period is longer than a year.",
              "rulesets": [
                {
                  "src": "iati",
                  "severity": "success"
                }
              ],
              "context": [
                {
                  "text": "In the budget of 2017-01-01 to 2019-12-31"
                }
              ]
            },
            {
              "id": "6.5.1",
              "text": "The organisation type is missing.",
              "rulesets": [
                {
                  "src": "iati",
                  "severity": "warning"
                }
              ],
              "context": [
                {
                  "text": "In transaction of 2017-12-31 for provider-org XM-IATI-123-1"
                },
                {
                  "text": "In transaction of 2017-12-31 for provider-org XM-IATI-456-23"
                },
                {
                  "text": "In transaction of 2017-12-31 for provider-org XM-IATI-456-23"
                }
              ]
            }
          ]
        },
        {
          "category": "performance",
          "label": "Performance",
          "messages": [
            {
              "id": "108.1.1",
              "text": "The activity should contain a results section.",
              "rulesets": [
                {
                  "src": "dfid",
                  "severity": "info"
                },
                {
                  "src": "minbuza",
                  "severity": "warning"
                }
              ],
              "context": [
                {
                  "text": ""
                }
              ]
            }
          ]
        }
      ]
    }
  ]
}
```

