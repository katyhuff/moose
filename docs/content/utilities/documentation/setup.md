# MOOSE Documentation Setup and Configuration
MOOSE contains a single-source documentation system for creating websites, slideshows, and pdfs (coming soon)
using [markdown](https://en.wikipedia.org/wiki/Markdown) syntax, including a custom syntax aimed to simply the
process: [Moose Flavored Markdown](moose_flavored_markdown.md).

---

## Dependencies
If you are using a current MOOSE package then a majority of the setup is complete. Simply install Git LFS (Large File
storage) as detailed below and you are ready.

### Git LFS
Install the latest Git Large File Storage package for your system: [git-lfs.github.com/](https://git-lfs.github.com/).
Following the getting started instructions on this page after the package has installed and you are ready.

If you are writing documentation for MOOSE or another application that has existing documentation, then you will likely
need to pull in any existing documents stored with Git LFS using:

```
git lfs pull
```

### Manual Setup
If you are not using a MOOSE package, then the following steps may be performed to install the necessary dependencies
for using the documentation system.

(1) Create a new python environment.

```text
conda create --name docs --clone root
```

(2) Activate the new environment.

```text
source activate docs
```

(3) Install the additional python packages.

```text
pip install markdown-include python-markdown-math mkdocs-bootstrap mkdocs-bootswatch
```

(4) Install development version of [mkdocs](http://www.mkdocs.org/).

Currently, MOOSE requires the development version of [mkdocs](http://www.mkdocs.org/). To install the following must be performed.

```text
cd ~/projects
git clone https://github.com/mkdocs/mkdocs.git
cd mkdocs
python setup.py install
```

## Configuration
If you are adding documentation to an existing project then you will need to add a few files to configure the
documentation system to work properly for you application.

As mentioned the MOOSE documentation system relies on [mkdocs](http://www.mkdocs.org/), thus a configuration file must exist for it. MOOSE
uses the "moosedocs.yml" file for this purpose as well. Therefore, any configuration options for [mkdocs](http:://www.mkdocs.org) is simply added
to the "mooosedocs.yml" file.

The [mkdocs](http://www.mkdocs.org/) uses the python [markdown](http://pythonhosted.org/Markdown/) package and adds a custom extension to add the
necessary functionality. This custom extension is located in `python/MooseDocs/extensions/MooseMarkdown.py` and includes
three configuration options, which are set as done in the `moosedocs.yml` file.

!text docs/moosedocs.yml start=markdown_extensions end=# MooseDocs

| Option   | Description |
| -------- | ----------- |
| root     | The root directory of the repository, if not provided the root is found using git. |
| make     | The location of the Makefile responsible for building the application (default: 'root'). |
| executable | The MOOSE application to execute to generate syntax. |
| repo     | The location for the remote repository for creating hyperlinks. |
| docs_dir | The location of the markdown to be used for generating the site. |
| slides   | Enable the parsing for creating reveal.js slides (default: False). |
| package  | Enable the use of the MoosePackageParser (default: False). |
| graphviz | The location of graphviz executable for use with diagrams. |
| links      | Source code paths for generating code links. This options could contain headings (e.g., Tests), under each heading is a list of  directories that will be searched for input files and source code. |
| locations | A list of locations to search for objects and systems that should be documented. |

The 'locations' option contains should contain sub-items, as shown above in the MOOSE configuration file. These sub-items
include:

| Option   | Description |
| -------- | ----------- |
| doxygen  | The path to the doxygen website, used for developer links. |
| paths    | A list of paths to the source code (i.e., source and include directories).|
| install  | The location where the markdown is located for this documentation sub-item. |
