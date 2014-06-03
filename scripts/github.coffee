# Description:
#   GitHub Notification
#
# Dependencies:
#   "<module name>": "<module version>"
#
# Configuration:
#   HUBOT_GITHUB_USER
#   HUBOT_GITHUB_ORGANIZE
#   HUBOT_GITHUB_TOKEN
#   HUBOT_GITHUB_REPOSITORY
#   HUBOT_IDOBATA_ROOM_ID
#
# Commands:
#   hubot <trigger> - <what the respond trigger does>
#   <trigger> - <what the hear trigger does>
#
# Notes:
#   <optional notes required for the script>
#
# Author:
#   rvillage

cronJob = require('cron').CronJob

module.exports = (robot) ->
  send = (roomId, msg) ->
    robot.send {message: {data: {room_id: roomId}}}, msg

  new cronJob('00 00 10 * * 1-5', () ->
  # new cronJob('*/10 * * * * *', () ->
    request = robot.http("https://api.github.com/repos/#{process.env.HUBOT_GITHUB_ORGANIZE}/#{process.env.HUBOT_GITHUB_REPOSITORY}/pulls")
                   .auth(process.env.HUBOT_GITHUB_USER, process.env.HUBOT_GITHUB_TOKEN)
                   .get()
    request (err, res, body) ->
      prNum = body.split('\{\"url\"').length - 1
      if prNum > 0
        # [TODO] string to arrayをスマートにしたい
        send process.env.HUBOT_IDOBATA_ROOM_ID, "@all\nそろそろレビュータイムだわー。#{prNum} 件あるけど、余裕だよね？\nじっくり確認して11時から本気出す！\nhttps://github.com/#{process.env.HUBOT_GITHUB_ORGANIZE}/#{process.env.HUBOT_GITHUB_REPOSITORY}/pulls"
  ).start()
