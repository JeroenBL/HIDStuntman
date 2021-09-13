# HIDStuntman

<p align="center">
  <img src="https://raw.githubusercontent.com/JeroenBl/Stuntman/main/assets/logo.png">
</p>

## Table of contents

- [Introduction](#Introduction)
- [Prerequisites](#Prerequisites)
- [Installation](#Installation)
- [Contributing](#Contributing)
- [HelloID Docs](#HelloIDDocs)

## Introduction

The _HIDStuntman_ is a source connector for HelloID. You can use this connector to import stuntman created with the _PSStuntman_ module into HelloID to develop/test target connectors.

## Prerequisites

- [ ] Windows PowerShell 5.1 installed on the server  where the HelloID agent / provisioning agent are running
- [ ] .NET 4.8 is installed [Download .NET Framework 4.7.2 | Free official downloads (microsoft.com)](https://dotnet.microsoft.com/download/dotnet-framework/net472)
- [ ] The PowerShell module 'PSStuntman' is required for this connector. https://github.com/JeroenBl/Stuntman

## Installation

1. Download all files from this repository

2. Make sure to configure the __Primary Manager__ in HelloID to: __From department of primary contract__.

3. Add a new source connector in HelloID

4. Import the required files

5. Fill in the required parameters. For an overview of all parameters, refer to the table below

   | _Parameter_                | _Description_                                                | Mandatory |
   | -------------------------- | ------------------------------------------------------------ | --------- |
   | PSStuntman module location | The path to the location where the PSStuntman dll files are saved | yes |

6. Make sure to toggle the switch 'Execute on-premises' before importing the data

7. Import and have fun!

> The _mappings.json_ contains both the person and contract mapping. You will have to import this file twice for both the person and contract mapping in HelloID.

## Contributing

Find a bug or have an idea! Open an issue or submit a pull request!

## HelloID Docs

The official HelloID documentation can be found at: https://docs.helloid.com/