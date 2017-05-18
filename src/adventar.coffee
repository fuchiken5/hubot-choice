# Description
#   A hubot script that does the things
#
# Configuration:
#   LIST_OF_ENV_VARS_TO_SET
#
# Commands:
#   hubot hello - <what the respond trigger does>
#   orly - <what the hear trigger does>
#
# Notes:
#   <optional notes required for the script>
#
# Author:
#   fuchiken5 <fuchiken5@gmail.com>

cheerio = require 'cheerio'
request = require 'request'

module.exports = (robot) ->

  robot.respond /adventar(?: (\S+))?/, (msg) ->
    query = msg.match[1]

    baseUrl = 'http://www.adventar.org'
    request baseUrl + '/', (_, res) ->

      $ = cheerio.load res.body
      calendars = []
      $('.mod-calendarList .mod-calendarList-title a').each ->
        a = $ @
        url = baseUrl + a.attr('href')
        name = a.text()
        calendars.push { url, name }

      filtered = calendars.filter (c) ->
        if query? then c.name.match(new RegExp(query, 'i')) else true

      message = filtered
        .map (c) ->
          "#{c.name} #{c.url}"
        .join '\n'

      msg.send message
