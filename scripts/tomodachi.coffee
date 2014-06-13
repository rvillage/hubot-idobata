# Description:
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   None
#
# Notes:
#
# Author:
#   Iori ONDA

module.exports = (robot) ->
  robot.hear /おはよう/i, (msg) ->
    msg.send "おはよう"

  robot.hear /ウケる|うける|ウケル|笑$/i, (msg) ->
    words = ["冷静になれよ", "www", "そう？", ":trollface:"]
    msg.send msg.random words

  robot.hear /？$/i, (msg) ->
    words = ["どうだろ", "いいんじゃない？", "それは違うんじゃないのかな？", "ggrks", ":worried:"]
    msg.send msg.random words
