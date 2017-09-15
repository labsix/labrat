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

format = (ms) ->
  day = 24*60*60*1000
  if ms < day
    moment.duration(ms).humanize()
  else
    days = Math.floor(ms / day)
    if days == 1 then "a day" else "#{days} days"

module.exports = (robot) ->
  config = require('hubot-conf')('deadline', robot)

  robot.respond /deadline/i, (res) ->
    name = config 'name'
    diff = moment(config 'time').diff(moment())
    prefix = if diff >= 0 then 'in ' else ''
    suffix = if diff < 0 then ' ago' else ''
    res.send "#{name} #{prefix}#{format diff}#{suffix}"
