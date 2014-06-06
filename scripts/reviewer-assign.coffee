# Description:
#   Assign reviewer to github pull-request
#
# Dependencies:
#   node-guthub
#
# Configuration:
#   HUBOT_GITHUB_ACCESS_TOKEN
#   HUBOT_GITHUB_ORG
#
# Commands:
#   hubot <pull-request-url>
#
GitHubApi = require 'github'

shuffle = (array) ->
  for i in [array.length-1 .. 1]
    j = Math.floor Math.random() * (i + 1)
    [array[i], array[j]] = [array[j], array[i]]
  array

substructArray = (src, target) ->
  result = []

  for m in src
    tmp_f = true

    for n in target
      if m == n
        tmp_f = false
        break

    result.push(m) if tmp_f
  result

removeWrongMembers = (array) ->
  target = [
  # excluded members
  ]
  substructArray(array, target)

module.exports = (robot) ->
  robot.respond /(https?:\/\/github\.com\/.+\/.+\/pull\/[0-9]+)/i, (msg) ->

    github = new GitHubApi({
      version: "3.0.0",
      timeout: 5000
    })

    github.authenticate(
      type: "oauth",
      token: process.env.HUBOT_GITHUB_ACCESS_TOKEN
    )

    github.orgs.getMembers(
      org: process.env.HUBOT_GITHUB_ORG,
      per_page: 40,
      (err, res) ->
        json    = JSON.stringify(res)
        obj     = JSON.parse(json)

        members = []
        for member in obj
          members.push(member.login)

        core_members = removeWrongMembers(members)
        shuffle core_members
        msg.send "@#{core_members[0]} レビューしてください :bow: \n #{msg.match[1]}"
    )
