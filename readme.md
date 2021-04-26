# HIDStuntman

![image](https://raw.githubusercontent.com/JeroenBl/PSStuntman/main/assets/logo.png)

This is a very simple source connector for HelloID. 

## Prerequisites

- [ ] Windows PowerShell 5.1 installed on the server  where the HelloID agent / provisioning agent are running
- [ ] .NET 4.8 is installed [Download .NET Framework 4.7.2 | Free official downloads (microsoft.com)](https://dotnet.microsoft.com/download/dotnet-framework/net472)
- [ ] The PowerShell module 'PSStuntman' is required for this connector. https://github.com/JeroenBl/PSStuntman

## Installation

1. Download all files from this repository

2. Add a new source connector in HelloID

3. Import the required files

4. Fill in the required parameters. For an overview of all parameters, refer to the table below

   | _Parameter_                | _Description_                                                | Mandatory |
   | -------------------------- | ------------------------------------------------------------ | --------- |
   | PSStuntman module location | The path to the location where the PSStuntman dll files are saved | yes       |
   | _Amount_                   | _The amount of stuntman you want to create, e.g. 10_         | no        |
   | _CompanyName_              | _The CompanyName. e.g. 'Contoso'. When left empty, a random CompanyName will be picked_ | no        |
   | _DomainName_               | _The DomainName. e.g. 'contoso.com'. The default DomainName is set to 'enyoi'_ | no        |
   | _DomainSuffix_             | _The DomainSuffix e.g. 'com'_                                | no        |
   | _Locale_                   | _The locale for the stuntman e.g. 'fr' (for French) or 'en' (for English). The default locale is set to 'nl'. To find more locales: https://github.com/bchavez/Bogus_ | no        |
   | _SaveToSqlite_             | _Saves the generated Stuntman to a SQlite database. You will find it in root folder from where this module is loaded_ | no        |

5. Make sure to toggle the switch 'Execute on-premises' before importing the data

6. Import and have fun!

## Contributing

Find a bug or have an idea! Open an issue or submit a pull request!
