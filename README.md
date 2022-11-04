# RandomQuotes NewStarter
An application used for new starters to help them onboard and learn Octopus Deploy.

Please fork this to your account.  Modifications, outside of making changes to keep the application up to date with the latest versions of plug-ins or to fix a bug should be avoided.

## Get me started!

After forking this repo, run the script `get-started.ps1` as an admin.  That script will setup your local machine as a development machine you can use to run / debug / build the Random Quotes application.

The setup script assumes the following when setting this up for local runs.

1. You want to have chocolatey installed.
1. You want IIS and .NET 6 installed.
1. You want SQL Server Express installed.
1. You are running SQL Server Express with the instance name `(local)\SQLExpress`.
1. You have a database named `RandomQuotes_Local`.
1. You allow sql logins and have a user created named `svcRandomQuotes_Local`.
1. The password is the default password `Password01!`.

## Settings

The application is made up of two components, a web ui, and a database.  The database is deployed using [dbup](https://dbup.github.io/).

### Web UI Settings

The order of preference when pulling variables is:

1. appsettings.json
2. environmentname.appsettings.json
3. environment variables (useful when running as a container)

The settings that can be changed in Octopus Are:

- DefaultConnection: Connection string in the database.
- AppVersion: The release number.
- EnvironmentName: The name of the environment.

### Random Quotes DB Up Settings

This is a command line application that accepts two parameters.  Please see this [blog post](https://octopus.com/blog/dbup-database-deployment-automation) on DBUp and Octopus Integration.

- ConnectionString: the connection string to the database.  Sent in as `--ConnectionString="CONNECTION STRING"`
- PreviewReportPath: the path of the preview HTML report (useful for approvals).  Sent in as `--PreviewReportPath="PATH TO REPORT FILE"`
