# Description:
#   A Hacker News watcher.
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_HN_ROOM - the room to post in.
#   HUBOT_HN_LIMIT - max number of posts to check (from 0 to 500). Defaults to
#     90.
#
# Commands:
#   hubot hn watch url "<regex>" - add <regex> to url watch list
#   hubot hn watch title "<regex>" - add <regex> to title watch list
#   hubot hn list url - list url regexes that are being watched
#   hubot hn list title - list title regexes that are being watched
#   hubot hn remove url <id> - remove url regex <id> from watch list
#   hubot hn remove title <id> - remove title regex <id> from watch list

REFRESH_RATE = 5 * 60 * 1000
HN_ID = "https://news.ycombinator.com/item?id="

firebase = require 'firebase'

module.exports = (robot) ->
  config = require('hubot-conf')('hn', robot)

  cache = {}
  robot.brain.on 'loaded', () ->
    if robot.brain.data.hn
      cache = robot.brain.data.hn
    else
      robot.brain.data.hn = cache

  seen = {} # things we've already posted (not persistent)

  firebase.initializeApp(databaseURL: "hacker-news.firebaseio.com")
  api = firebase.database().ref("/v0")

  matchesAny = (patterns, str) ->
    if not patterns?
      return false
    for pattern in patterns
      re = new RegExp(pattern, 'i')
      if re.test str
        return true
    return false

  check = () ->
    room = config('room')
    api.child('topstories').once('value').then (s) ->
      storyIds = s.val()
      max = parseInt(config('limit', '90'))
      for id, index in storyIds[...max]
        api.child('item').child(id).once('value').then (s) ->
          item = s.val()
          if item.type != "story"
            return
          # check if it matches
          title = item.title
          url = item.url
          if matchesAny(cache['title'], title) or matchesAny(cache['url'], url)
            if not seen[item.id]?
              msg = "HN Story: \"#{title}\" (#{HN_ID}#{item.id}, score #{item.score})"
              robot.send {room: room}, msg
              seen[item.id] = true

  setInterval check, REFRESH_RATE

  robot.respond /hn\s+watch\s+url\s+"(.*)"/, (res) ->
    pattern = res.match[1]
    if not cache['url']?
      cache['url'] = []
    cache['url'].push pattern
    res.send "Added url pattern `#{pattern}`"

  robot.respond /hn\s+watch\s+title\s+"(.*)"/, (res) ->
    pattern = res.match[1]
    if not cache['title']?
      cache['title'] = []
    cache['title'].push pattern
    res.send "Added title pattern `#{pattern}`"

  robot.respond /hn\s+list\s+url/, (res) ->
    if not cache['url']?
      return
    msgs = []
    for elem, index in cache['url']
      msgs.push "#{index}: `#{elem}`"
    res.send msgs.join "\n"

  robot.respond /hn\s+list\s+title/, (res) ->
    if not cache['title']?
      return
    msgs = []
    for elem, index in cache['title']
      msgs.push "#{index}: `#{elem}`"
    res.send msgs.join "\n"

  robot.respond /hn\s+remove\s+url\s+(\d+)/, (res) ->
    if not cache['url']?
      return
    index = parseInt(res.match[1])
    if not (0 <= index and index < cache['url'].length)
      res.send "No url pattern with index #{index}"
      return
    removed = cache['url'][index]
    cache['url'].splice index, 1
    res.send "Removed url pattern `#{removed}`"

  robot.respond /hn\s+remove\s+title\s+(\d+)/, (res) ->
    if not cache['title']?
      return
    index = parseInt(res.match[1])
    if not (0 <= index and index < cache['title'].length)
      res.send "No title pattern with index #{index}"
      return
    removed = cache['title'][index]
    cache['title'].splice index, 1
    res.send "Removed title pattern `#{removed}`"
