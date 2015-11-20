### How to use **Tokenization** build / release tasks

Follow the below steps to upload this task to your account:

* Download the tasks repo as [zip file] or clone it using git:
* Extract the zip file of the desired task
* Open command prompt and navigate to the folder that contains a json and powershell files.

## Install / Upload Custom Task

*Follow instructions on how to upload the task using - https://github.com/TotalALM/VSO-Tasks

## How to use

* Add a new task and select Tokenization.

![tfs-cli](docs/SelectTask.png "Build Task")

* Type of select the Source Path to search. 
* Input Target Filenames.  This can be a single value or comma-delimited list of names.  Wild Card searches are supported using "*"

```bash
Web.config
*.config
Settings.xml, *.config
```

* Recursive  - When checked, tokenization task will recursively go through all folders in the Source Path.

![tfs-cli](docs/TokenizationValues.png "Tokenization Options")

* Add your environment variables

![tfs-cli](docs/SelectEnv.png "Configure Variables")

* If your Web.config has a value '__Environment__' you would only enter the 'Environment' leaving out the '__' at the beginning and end. 

![tfs-cli](docs/TokenizationValues.png "Tokenization Values")

* Simply check the lock if you wish to encrypt the value.  Decryption will happen automatically and requires to extract effort. 
