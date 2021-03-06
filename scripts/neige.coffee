# Description
#   Get a succinct snow report for the ski resort of your choice
#   Works with France and US resorts
#
# Dependencies:
#   "cheerio": "*"
#   "fuzzy": "*"
#
# Configuration:
#   None
#
# Commands:
#   hubot neige [French resort name]
#   hubot snow  [US resort name]
#
# Notes:
#   Other countries could be implemented quickly !
#
# Author:
#   laem

cheerio = require('cheerio')
fuzzy = require('fuzzy')

i18n = {
    'neige': {
      url : 'http://www.skiinfo.fr/france/bulletin-neige.html',
      intro: (name) -> '*** Bulletin pour ' + name + ' ***',
      state: (state) -> 'Enneigement bas - haut : ' + state,
      fall: (snowFall24h) -> 'Elle a tombé : ' + snowFall24h + ' de neige hier',
      lifts: (lifts) -> 'Remontées: ' + lifts,
      slopes: (slopes) -> 'Pistes: ' + slopes
    },
    'snow': {
      url: 'http://www.onthesnow.com/united-states/skireport.html',
      intro: (name) -> '*** Snow report for ' + name + ' ***',
      state: (state) -> 'Snow report down - up : ' + state,
      fall: (snow24h) -> 'Snowfall !! : ' + snow24h + ' of snow yesterday',
      lifts: (lifts) -> 'Lifts: ' + lifts,
      slopes: (slopes) -> 'Slopes: ' + slopes
    }
}

# Would be handy to have a free token for this API :
# "http://clientservice.onthesnow.com/externalservice/resort/2212/snowreport?token=a5bae8eea465aae810130937a29cebaa6cd92ce60336d8e3&language=fr&country=FR"

module.exports = (robot) ->

  robot.respond /neige (.*)/i, (msg) ->
     inform(robot, msg, 'neige', msg.match[1])

  robot.hear /snow (.*)/i, (msg) ->
    inform(robot, msg, 'snow', msg.match[1])


inform = (robot, msg, keyword, resortQuery) ->

  lang = i18n[keyword]
  robot.http(lang.url)
   .get() (err, res, body) ->
     $ = cheerio.load(body)

     messages = []

     names =
       $('.resortList .name a').map (i, el) ->
         $(this).attr('title')

     candidates = fuzzy.filter(resortQuery, names.get())
     candidate = candidates[0].string

     row = $('.resortList tr').filter (i, el) ->
         $(this).find('.name a').attr('title') == candidate

     name = $(row).find('.name a').attr('title')

     messages.push lang.intro(name)

     state = $(row).find('.rMid.c b').text()

     messages.push lang.state(state)

     snowFallElements = $(row).find('.rLeft.b b')
     snowFall = ($(el).text() for el in snowFallElements)

     snow24h = snowFall[0]
     snow72h = snowFall[1]

     unless snow24h.match(/\d+/)[0] == "0"
       messages.push lang.fall(snow24h)

     liftsAndSlopes = $(row).find('.rMid').filter (i, el) ->
        return $(this).text().match(/\d+\/\d+/)

     lifts = $(liftsAndSlopes[0]).text().trim()
     messages.push lang.lifts(lifts)
     slopes = $(liftsAndSlopes[1]).text().trim()
     if(slopes)
       messages.push lang.slopes(slopes)

     delay = (s, i) ->
       setTimeout () ->
         msg.send s
       , 100 * i

     for s, i in messages
       delay s, i
