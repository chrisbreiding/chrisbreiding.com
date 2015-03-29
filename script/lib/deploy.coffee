gutil = require 'gulp-util'
fs = require 'fs'
exec = require('child_process').execSync

module.exports = ->

  log = (message)->
    prefix = '. '
    gutil.log gutil.colors.green "#{prefix}#{message}"

  execInDir = (command)->
    exec command, cwd: '_prod'

  initRepo = ->
    return if fs.existsSync '_prod/.git'

    originUrl = exec 'git config --get remote.origin.url'
    execInDir 'git init'
    log 'create repo in _prod'
    url = originUrl.stdout.replace gutil.linefeed, ''
    execInDir "git remote add origin #{url}"

  checkoutBranch = ->
    log 'checkout gh-pages branch'
    branches = execInDir 'git branch'
    branchExists = branches.stdout.split('\n').some (branch)->
      /gh\-pages/.test branch
    flag = if branchExists then '' else '-b'
    execInDir "git checkout #{flag} gh-pages"

  addAll = ->
    log 'add all files'
    execInDir 'git add -A'

  commit = ->
    log 'commit'
    commitMessage = "automated commit by deployment at #{(new Date()).toUTCString()}"
    execInDir "git commit --allow-empty -am '#{commitMessage}'"

  push = ->
    log 'push to gh-pages branch'
    execInDir 'git push -f origin gh-pages'

  initRepo()
  checkoutBranch()
  addAll()
  commit()
  push()
