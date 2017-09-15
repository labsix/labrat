# Description:
#   Deadlines
#
# Configuration:
#   HUBOT_DEADLINE_NAME - the name of the deadline.
#   HUBOT_DEADLINE_TIME - the time
#
# Commands:
#   hubot deadline - Print information about next deadline

moment = require 'moment'

module.exports = (robot) ->
  config = require('hubot-conf')('deadline', robot)

  robot.respond /deadline/i, (res) ->
    name = config 'name'
    time = moment(config 'time')
    res.send "#{name} #{time.fromNow()}"
