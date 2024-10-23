# Go Dev Container

<!-- cSpell:ignore devcontainer Fira FiraCode Caskaydia Consolas -->

A general purpose development container for GoLang (Go) projects using Rocky Linux as a base

- [Files and Directories](#files-and-directories)
  - [`Dockerfile`](#dockerfile)
  - [`mise`](#mise)
  - [`.devcontainer`](#devcontainer)
    - [Host Environment Variables](#host-environment-variables)
  - [`scripts`](#scripts)
  - [`cspell.json`](#cspelljson)
  - [`dev.sh`](#devsh)
  - [`run.sh`](#runsh)
- [Starship Powerline Prompt](#starship-powerline-prompt)
- [Using the Dev Container Outside of VS Code](#using-the-dev-container-outside-of-vs-code)
  - [With the `./run.sh` Command](#with-the-runsh-command)
  - [Manually](#manually)
- [Initial Worksation Setup](#initial-worksation-setup)
  - [WSL](#wsl)
  - [Windows Font Install](#windows-font-install)
    - [Windows Terminal Font Setup](#windows-terminal-font-setup)
    - [Visual Studio Code Font Setup](#visual-studio-code-font-setup)
- [Initial Dev Container and Project Setup](#initial-dev-container-and-project-setup)
  - [`dev.sh`](#devsh-1)
  - [Dev Container Setup](#dev-container-setup)


## Files and Directories

### `Dockerfile`

Is used to build the dev container image, which is used by the devcontainer.

### `mise`

`mise` is used to install most of the applications that are not `dnf` packages.  
The list of base applications is located in `home/vscode/.config/mise/config.toml`.  
To install different versions of `go` or other tools edit the `.mise.toml` file.  

### `.devcontainer` 

This project's dev container configuration.  
The file in this repo uses its own dev container to provide all the tooling needed to manage and upgrade itself.  

You can use the `.devcontainer` folder as a template for new repositories by copying it into your VS Code project. 

When using this `devcontainer.json` file as a template for a new project you must change the following:

- `"name": "Go Dev Container"` should be updated to match the target repository / project.
- `"mounts": [` All instances of `go-dev-*` should be changed to match the target repository / project.
- `"runArgs": [` `"--name=go-dev"` should be changed the match the target repository / project.
- Copy over the `cspell.json` to the root of the new repo and edit as needed.

#### Host Environment Variables

We have some environment variables that can be set on your host and automatically passed into the dev container configured in the `devcontainer.json`

-  `ZSH_THEME` If you already have a Oh My ZSH theme set on your Linux host than we will use that in the dev container.

### `scripts`

This directory contains all scripts used to build the dev container.

### `cspell.json`

The cspell config file that stores common words we want cspell to ignore.

### `dev.sh`

This script will open VS Code and wait for the dev container to open then `docker exec` into the target container.  
This makes getting into the dev container from your main terminal window much easier.

This file can be copied to other projects and reused, when doing so the `docker_exec_command`, `project_name` and `container_name` need to be changed to match your project.

## Starship Powerline Prompt

The terminal in the dev container is using [Starship](https://starship.rs/) to display a *smart* powerline style prompt that includes the git branch, kubernetes context and namespace and other useful information.  This prompt requires special nerd fonts that include glyphs to display properly.  See directions below for installing nerd fonts.

## Initial Worksation Setup

Instructions to set up your worksation.
For more information on Dev Containers check out the [official docs](https://code.visualstudio.com/docs/devcontainers/containers).

### WSL

1. If you will be building Docker containers in Windows, then install Docker Desktop for Windows following [Docker's instructions](https://docs.docker.com/desktop/install/windows-install/).  If you do not need Docker for Windows support then you can [directly install Docker inside of Ubuntu](https://docs.docker.com/engine/install/ubuntu/) **AFTER** you install WSL and Ubuntu in the following steps. 
1. Install VS Code from the [Visual Studio Code website](https://code.visualstudio.com/download) or from the Microsoft Store.
1. Open VS Code and click on the "Extensions" button to the left.  
   1. Search for "Dev Containers" and install it.
   1. Search for "WSL" and install it.
1. WSL is the Windows Subsystem for Linux and facilitates the use of a Linux distruction on Windows.  
Follow the [Microsoft insructions](https://learn.microsoft.com/en-us/windows/wsl/install) to install WSL and a Linux distribution.

### Windows Font Install

To get the full functionality of font ligatures and icons you will need to install a [Nerd Font](https://www.nerdfonts.com/) from [Nerd Fonts Downloads](https://www.nerdfonts.com/font-downloads).  If you skip this step the Dev Container terminal command line will look weird and not have icons thus making it harder to read.

Many of us use [FiraCode Nerd Font](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/FiraCode.zip) or [FiraMono Nerd Font](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/FiraMono.zip) but you can [preview](https://www.programmingfonts.org/#firacode) any of the fonts and choose which one is best for you.

Download your chosen font and [install it in Windows](https://support.microsoft.com/en-us/office/add-a-font-b7c5f17c-4426-4b53-967f-455339c564c1) then proceed to the next step.

#### Windows Terminal Font Setup

1. Open Windows Terminal, select the menu chevron to the right of the last tab and select settings.
1. On the left select `Profiles` --> `Defaults`
1. Under `Additional Settings` select `Appearance`
1. Under `Font Face` select the name of the font you downloaded, for example if you chose the "Firacode Nerd Font" then you'd choose `Firacode NF`  You may need to check `Show all items` or restart Windows Terminal to see the new fonts.

#### Visual Studio Code Font Setup

1. Select `File` --> `Preferences` --> `Settings`
1. Expand `Text Editor` --> select `Font`
1. In the `Font Family` text box paste the following:  
> **NOTE:** This assumes you chose "FiraCode NF", if not, replace the first font name with the name of the font you installed in Windows.
   ```
   'FiraCode NF', 'CaskaydiaCove NF', Consolas, 'Courier New', monospace
   ```

## Initial Dev Container and Project Setup

The following contains initial project setup.

### `dev.sh`

This script is used to more easily start Visual Studio code and hop into the Dev Container from the terminal that it is ran from.

- Open the `dev.sh` file and set a `docker_exec_command` if desired, this is optional but if this repo is used a lot, it is a nice to have.  This will create a command in the users `.bashrc` and `.zshrc` to quickly exec into this running dev container.
- Change `project_name` to match the name of the repository.

To use the `./dev.sh` script, simply run it, then when VS Code opens, there should be a prompt at the bottom right of the editor saying "Folder contains a Dev Container . . .".  Click the "Reopen in Container" button and VS Code will open the dev container and attach to it.
![Reopen in Container](.devcontainer/reopen_in_container.png)
> **NOTE:** If you have not opened the dev container before or if it has been updated it will download the container from Artifactory, which can take a while.

### Dev Container Setup

Edit the `devcontainer.json` file to make the following changes.

- Change the `name`, by replacing "Template" to the name of your project.
- Replace all instances of `template-` with your projects name and a dash.  Example: `my-project-`

The rest of this doc is typically kept in all projects that use the dev container.