### How to use **Custom** build / release tasks

Follow the below steps to upload this task to your account:

* Download the tasks repo as [zip file] or clone it using git:
* Extract the zip file of the desired task
* Open command prompt and navigate to the folder that contains a json and powershell files.

## License
Copyright 2016 Kevin Mack & Brandon Rohrer

Licensed under the Apache License, Version 2.0 (the "License");
you may not use these tasks except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

## Install / Upload Custom Task

*Follow instructions on how to upload the task using - https://github.com/Microsoft/tfs-cli/blob/master/docs/buildtasks.md or use the below instructions.

* Install ```tfx-cli``` utility
```
> npm install -g tfx-cli
```
* To avoid providing credentials in every command, you can login once. Currently supported credential types are Personal Access Tokens and basic auth. [Create a personal access token](http://roadtoalm.com/2015/07/22/using-personal-access-tokens-to-access-visual-studio-online) and paste it in the login command
```
> tfx login
Copyright Microsoft Corporation
Enter collection url > https://youraccount.visualstudio.com/DefaultCollection
Enter personal access token >
logged in successfully
```
You can alternatively use basic auth by passing ```--authType basic``` (read [Configuring Basic Auth](https://github.com/Microsoft/tfs-cli/blob/master/docs/configureBasicAuth.md)).
* Upload the task to your account:
```
> tfx build tasks upload --task-path ./task
```
* Once the task is uploaded, you would be able to view your task under the build or release.
