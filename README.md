# BeI-MultiModel
## initializing the data
To initialize the data to a small test set use
```
d ##class(BeI.Utils).BuildFirstTestSet(100)
```
This will delete all entries in the database and repopulate the database.

Next Some logic is ran to build up the sort and filter indices.
## Setting up the Api
To set up the API, some steps need to be taken:
1. Creating a Role
   * Go to the system management portal > System > Security Management > Roles
   * and click the "Create New Role" button
   * In the "Name" field type "BeI" (or anything else you would like)
   * Optionaly provide a "Description"
   * Add The Resources
      * %DB_USER
      * %Service_Webgateway
   * Click the "Save" button
2. Add the role to the unknown user
   * Go to the system management portal > System > Security Management > Users
   * Click on the "UnknownUser"
   * Go to the "Roles" tab
   * Assign the BeI role to this user (or use the other name you chose in the previous point)
3. Create a webapplication
   * Go to the system management portal > System > Security Management > Web Applications
   * Click the "Create New Web Application"
   * Fill out these field:
      * Name: /BeI
      * Description: *optional*
      * Namespace: USER
      * Enable Application: checked
      * Enable: choose REST
      * Dispatch Class: BeI.API
   * Click the "Save" Button


