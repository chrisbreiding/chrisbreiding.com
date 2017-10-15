gutil = require 'gulp-util'
fs = require 'fs'
exec = require('child_process').execSync

module.exports = ->

  log = (message)->
    prefix = '. '
    gutil.log gutil.colors.green "#{prefix}#{message}"

  execInDir = (command)->
    exec command, cwd: './_prod'

  initRepo = ->
    return if fs.existsSync '_prod/.git'

    originUrl = exec 'git config --get remote.origin.url'
    execInDir 'git init'
    log 'create repo in _prod'
    url = originUrl.toString().replace gutil.linefeed, ''
    execInDir "git remote add origin #{url}"

  checkoutBranch = ->
    log 'checkout production branch'
    branches = execInDir 'git branch'
    branchExists = /gh\-pages/.test branches.toString()
    flag = if branchExists then '' else '-b'
    execInDir "git checkout #{flag} production"

  addAll = ->
    log 'add all files'
    execInDir 'git add -A'

  commit = ->
    log 'commit'
    commitMessage = "automated commit by deployment at #{(new Date()).toUTCString()}"
    execInDir "git commit --allow-empty -am '#{commitMessage}'"

  push = ->
    log 'push to production branch'
    execInDir 'git push -f origin production'
    exec 'git checkout master'

  initRepo()
  checkoutBranch()
  addAll()
  commit()
  push()
