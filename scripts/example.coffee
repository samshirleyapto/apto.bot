# Description:
#   Example scripts for you to examine and try out.
#
# Notes:
#   They are commented out by default, because most of them are pretty silly and
#   wouldn't be useful and amusing enough for day to day huboting.
#   Uncomment the ones you want to try and experiment with.
#
#   These are from the scripting documentation: https://github.com/github/hubot/blob/master/docs/scripting.md

module.exports = (robot) ->

  robot.hear /@nefsky WFH/i, (res) ->
    res.send "Days since @nefsky has worked from home: 0"

  robot.hear /DEPLOY!/i, (res) ->
    res.send "https://media.giphy.com/media/GwRBmXyEOvFtK/giphy.gif"

  robot.hear /@nefsky sick/i, (res) ->
    res.send "https://media.giphy.com/media/nhklNniaxTXoI/giphy.gif"

  robot.hear /donald trump/i, (res) ->
    res.send "http://i.imgur.com/YMC6hSf.gif"

   robot.hear /badger/i, (res) ->
     res.send "Badgers? BADGERS? WE DON'T NEED NO STINKIN BADGERS"

    robot.hear /fake news/i, (res) ->
      res.send "The phrase you are looking for is 'alt-fact'"

   robot.respond /open the (.*) doors/i, (res) ->
     doorType = res.match[1]
     if doorType is "pod bay"
       res.reply "I'm afraid I can't let you do that."
     else
       res.reply "Opening #{doorType} doors"

   robot.hear /I like pie/i, (res) ->
     res.emote ":cake:"

   lulz = ['lol', 'rofl', 'lmao']

   robot.hear /lulz/i, (res) ->
     res.send res.random lulz

   robot.topic (res) ->
     res.send "#{res.message.text}? That's a Paddlin'"




   answer = process.env.HUBOT_ANSWER_TO_THE_ULTIMATE_QUESTION_OF_LIFE_THE_UNIVERSE_AND_EVERYTHING

   robot.hear /what is the answer to the ultimate question of life/, (res) ->
     unless answer?
       res.send "42"
       return
     res.send "#{answer}, but what is the question?"

   robot.respond /you are a little slow/, (res) ->
     setTimeout () ->
       res.send "Who you calling 'slow'?"
     , 60 * 1000

   annoyIntervalId = null

   robot.hear /troll this channel/, (res) ->
     if annoyIntervalId
       res.send "https://media.giphy.com/media/5xtDarEbygs3Pu7p3jO/giphy.gif"
       return

     res.send "Hey, want to hear the most annoying sound in the world?"
     annoyIntervalId = setInterval () ->
       res.send "EEEEEEEEOOOOOOOOOOEEEEEEEEEEEOOOOOOOOOOEEEEEEEEEEOOOOOO"
     , 1000

   robot.hear /stop/, (res) ->
     if annoyIntervalId
       res.send "GUYS, GUYS, GUYS!"
       clearInterval(annoyIntervalId)
       annoyIntervalId = null
     else
       res.send "Not annoying you right now, am I?"


   robot.router.post '/hubot/chatsecrets/:room', (req, res) ->
     room   = req.params.room
     data   = JSON.parse req.body.payload
     secret = data.secret

     robot.messageRoom room, "I have a secret: #{secret}"

     res.send 'OK'

   robot.error (err, res) ->
     robot.logger.error "DOES NOT COMPUTE"

     if res?
       res.reply "DOES NOT COMPUTE"

   robot.hear /have a soda/i, (res) ->
     # Get number of sodas had (coerced to a number).
     sodasHad = robot.brain.get('totalSodas') * 1 or 0

     if sodasHad > 4
       res.reply "I'm too fizzy.."

     else
       res.reply 'Sure!'

       robot.brain.set 'totalSodas', sodasHad+1

   robot.respond /sleep it off/i, (res) ->
     robot.brain.set 'totalSodas', 0
     res.reply 'zzzzz'
