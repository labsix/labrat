# labrat

labrat is a chat bot built on the [Hubot][hubot] framework.

## Running labrat locally

You can test your hubot by running the following, however some plugins will not
behave as expected unless the [environment variables](#configuration) they rely
upon have been set.

You can start labrat locally by running:

    % bin/hubot

You'll see some start up output and a prompt:

    [Sat Feb 28 2015 12:38:27 GMT+0000 (GMT)] INFO Using default redis on localhost:6379
    labrat>

Then you can interact with labrat by typing `labrat help`.

    labrat> labrat help
    labrat help - Displays all of the help commands that labrat knows about.
    ...

## Configuration

A few scripts require environment variables to be set as a simple form of
configuration. Other scripts use the
[hubot-conf](https://github.com/anishathalye/hubot-conf) framework and can be
configured either via environment variables or through Slack.

Environment variables can be set in `./env` (see `./env.sample` for a
template). The `run.bash` script sources `./env` before running the bot.

## Scripting

You can write your own scripts in `./scripts/{name}.coffee`.

## External scripts

If you want to install an existing Hubot plugin, make sure to `npm install
--save` it and then add it to `./external-scripts.json`.
