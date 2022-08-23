# Jupyter Notebooks
---
## Overview
- Intent
- Installation
- Running Jupyter
- Python Package Management Simplified With Pipenv
---

### Intent
This section is dedicated to getting started with data manipulation and visualization using interactive jupyter notebooks, pandas, and matplotlib.

While it may be simpler to install and begin with the [Anaconda/Miniconda](https://www.anaconda.com/) python distribution, this guide assumes that you will be using [vanilla python](https://www.python.org/) running in a *nix environment.


### Installation
**Note**: *Before installing packages in this project review the contents of python-environment and follow the setup instructions detailed there to ensure proper utilization of python virtual environments.*

**Python Version**: For the purposes of this exercise, I am using python 3.7 as indicated in jupyter-notebook/Pipfile. If your version of python does not match, then you will need to update the version stated in Pipfile to match yours and delete Pipfile.lock before proceeding. To quickly **determine your version of python**, with your virtual environment active run `python --version` in a terminal.

With hello-world/jupyter-notebook as your working directory in a terminal session and the python virtual environment containing pipenv active, run the following command: `pipenv install`

If errors occur, please review [Python Package Management Simplified With Pipenv]().

### Running Jupyter
Jupyter is a metapackage that resolves to installing the minimum basic packages, requirements, and dependencies for running jupyter notebooks. Jupyter provides a command line interface(CLI) tool for serving a collaborative interactive development environment(IDE) in a web browser like Chrome or Firefox.

See example script below:
```bash
# run a jupyter notebook
# [jupyter notebook command may determine current working directory to be the --notebook-dir automatically; verify]
jupyter notebook --ip=IP_ADDRESS \
		         --port=PORT \
		         --certfile=PUBLIC_CERTIFICATE_FILE \
		         --keyfile=PRIVATE_KEY_FILE \
		         --no-browser \
		         --notebook-dir=NOTEBOOK_DIRECTORY;


```

#### Basic Security
Jupyter provides out-of-the-box security which either:

**a)** requires a password for access

```bash
# hashed passwords are stored locally in: $HOME/.jupyter/jupyter_notebook_config.json
# set a new password or reset it
jupyter notebook password
# generate a config file for use with [python](https://jupyter-notebook.readthedocs.io/en/stable/public_selmnodocious9!
rver.html#running-a-public-notebook-server)
jupyter notebook --generate-config

```

**b)** generates a special link for access

```bash
# [needs reference/source]
# NOTE: Unable to presently recreate the behavior, but if memory serves correct Conda automatically does this though it may not be a direct feature of jupyter


```

**c)** requires a certificate/key pair for access
```bash
# [see generating-selfsigned-certificates]
```


### Python Package Management Simplified With Pipenv

[requires updates/sources to support why new vs. old-fashioned]

Previously it was common among python developers to use requirements.txt files to share details about their installed packages. While some still use this approach and its still applicable/practical. We will be using pipenv in our projects to manage dependencies, pin required versions of software, and isolate development packages that we don't want deployed to production environments.

**NOTE:** Where python environments are concerned, I will provide both Pipfile and requirements.txt formats for dependencies within any projects. This practice should aid in more easy detection of package mismatch/version errors, minimize personal inconvenience, and hopefully increase the lifespan of each respective project. This is also intentional to allow the user to choose whichever approach they prefer.

#### The *Old-fashioned* Way: requirements.txt
```bash
# # to create requirements.txt
# 1) activate the preferred virtual environment
# 2) run the following command to create a requirements.txt file in the current working directory
pip freeze > requirements.txt

# # to install from requirements.txt
# 1) activate the preferred virtual environment
# 2) assuming 'requirements.txt' is in your current directory, run the following command to install from a provided requirements.txt
pip install -r requirements.txt


```

#### The *New* Way: Pipenv

**Requirements**: pipenv python package

First, ensure that pipenv is installed in your active virtual environment.
  1. Review the output from the terminal command `$> pip freeze`
  2. If 'pipenv' is not listed, install it using the terminal: `$> pip install pipenv`

Pipenv provides useful help text by running a bare `pipenv` command in a terminal without any modifications, but below you'll find the most common and frequent usage.
```bash
# create a new virtual environment if one does not already exist and install the packages
# if a virtual environment already exists, pipenv installs the packages and updates Pipfile then regenerates Pipfile.lock accordingly
pipenv install [package_1] [package_2] ... [package_n]
# install packages as dev dependencies
pipenv install --dev [package_1] [package_2] ... [package_n]

# install/create virtual environment from existing Pipfile
pipenv install
# install dev packages also
pipenv install --dev

# alternatively, to uninstall packages
pipenv uninstall [package_to_remove]
# if it is a dev package, the '--dev' flag is required
pipenv uninstall --dev [package_to_remove]

# Running commands
# activate the pipenv virtual environment in the active terminal session
pipenv shell
# run a single command from pipenv
pipenv run [command]


```
