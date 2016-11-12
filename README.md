# DeployBot

DeployBot is a chat bot built on the [Hubot][hubot] framework. It was
initially generated by [generator-hubot][generator-hubot], and configured to be
deployed on [DCOS][dcos] to get you up and running as quick as possible.

[dcos]: http://dcos.io
[hubot]: http://hubot.github.com
[generator-hubot]: https://github.com/github/generator-hubot
[hubot-slack]: https://github.com/slackhq/hubot-slack

### Important
DeployBot uses a downgraded version of the [hubot-slack][hubot-slack] client 3.4.2 (latest is 4.1.x)
due to [bug](https://github.com/slackhq/hubot-slack/issues/326)

### Setup

Go to your [Custom Integrations](https://www.slack.com/apps/manage/custom-integrations)
page for your Slack instance and set up a new Bot integration. Copy the API
token and save for later.

If running locally, set the following environment variables on your host directly.

- `HUBOT_SLACK_TOKEN` - Enter your Slack token
- `HUBOT_AUTH_ADMIN` - Enter your comma separated list of admin Slack user ids (ex. U12345678)
- `REDIS_URL` - Enter your Redis url
- `HUBOT_SEMAPHOREAPP_TRIGGER` - Comma-separated list of additional keywords that will trigger status (e.g. "deploy")
- `HUBOT_SEMAPHOREAPP_NOTIFY_RULES` - Comma-separated list of rules (e.g. "room:branch:status")
- `HUBOT_SEMAPHOREAPP_AUTH_TOKEN` - Enter your Semaphore authorization token
- `HUBOT_SEMAPHOREAPP_DEPLOY` - Enter something non-zero to enable deployment commands
- `HUBOT_SEMAPHOREAPP_DEFAULT_PROJECT` - Your default semaphore project or 'proj'
- `HUBOT_SEMAPHOREAPP_DEFAULT_SERVER` - Your default semaphore server or 'prod'

### Run

Install `brew install redis` and run `brew services start redis` Redis server.

Run `npm install` if you have just cloned the repo for the first time, to
install the required dependencies.

Run `sh run.sh` to start DeployBot.

### Usage

The bot will now join your Slack instance if you specified the correct API
token. You can invite the bot to whatever channel you want it to be present in.

#### Authentication

Users **must** be assigned to the 'deploy' role by and an admin before it is activated.

- `deploybot <user> has <role> role` - Assigns a role to a user
- `deploybot <user> doesn't have <role> role` - Removes a role from a user
- `deploybot list assigned roles` - List all assigned roles
- `deploybot what roles do I have` - Find out what roles you have
- `deploybot what roles does <user> have` - Find out what roles a user has
- `deploybot who has <role> role` - Find out who has the given role

#### Deploy

- `deploybot deploy project` - deploys project/master to 'prod'
- `deploybot deploy project to server` - deploys project/master to server
- `deploybot deploy project/branch` - deploys project/branch to 'prod'
- `deploybot deploy project/branch to server` - deploys project/branch to server

#### Rollback

- `deploybot rollback project` - rolls back project/master by 1 to 'prod'
- `deploybot rollback project by n_builds` - rolls back project/master by n_builds to 'prod'
- `deploybot rollback project by n_builds to server` - rolls back project/master by n_builds to server
- `deploybot rollback project to server` - rolls back project/master by 1 to server
- `deploybot rollback project/branch` - rolls back project/branch by 1 to 'prod'
- `deploybot rollback project/branch by n_builds` - rolls back project/branch by n_builds to 'prod'
- `deploybot rollback project/branch by n_builds to server` - rolls back project/branch by n_builds to server
- `deploybot rollback project/branch to server` - rolls back project/branch by 1 to server

#### Status

- `deploybot semaphoreapp status [<project> [<branch>]]` - Reports build status for projects branches
- `deploybot deployed commit` - check if commit has been deployed to default server on default project
- `deploybot deployed commit on project` - check if commit has been deployed to default server on project
- `deploybot deployed commit on project to server` - check if commit has been deployed to server on project
- `deploybot deployed msg` - check if commit message has been deployed to default server on default project
- `deploybot deployed msg on project` - check if commit message has been deployed to default server on project
- `deploybot deployed msg on project to server` - check if commit message has been deployed to server on project

#### Debug

- `deploybot brain show storage` - Display the contents that are persisted in the brain
- `deploybot brain show storage --key=[key]` - Display the contents that are persisted with specified key in the brain
- `deploybot brain show users` - Display all users that hubot knows about

#### Help

- `deploybot help` - Displays all of the help commands that Hubot knows about.
- `deploybot help <query>` - Displays all help commands that match <query>.
