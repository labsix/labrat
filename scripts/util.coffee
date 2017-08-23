# Description:
#   Utilities
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot restart - Restarts the bot.

module.exports = (robot) ->

  robot.respond /restart/i, (res) ->
    setTimeout () ->
      process.exit 0
    , 500 # give process some time to send the message

  # fix bug (?) with slack adapter
  # not sure if this is necessary anymore with the current adapter version
  if robot.adapterName is 'slack'
    robot.logger.info 'adapter is slack: will terminate on client close'
    robot.adapter.client.on 'close', () ->
      process.exit 1
