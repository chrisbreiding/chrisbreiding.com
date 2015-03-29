gutil = require 'gulp-util'
fs = require 'fs'
exec = require('child_process').execSync

module.exports = ->

  log = (message)->
    prefix = '. '
    gutil.log gutil.colors.green "#{prefix}#{message}"

  execInBuild = (command)->
    exec command, cwd: '_build'

  initRepo = ->
    return if fs.existsSync '_build/.git'

    originUrl = exec 'git config --get remote.origin.url'
    execInBuild 'git init'
    log 'create repo in _build'
    url = originUrl.stdout.replace gutil.linefeed, ''
    execInBuild "git remote add origin #{url}"

  checkoutBranch = ->
    log 'checkout gh-pages branch'
    branches = execInBuild 'git branch'
    branchExists = branches.stdout.split('\n').some (branch)->
      /gh\-pages/.test branch
    flag = if branchExists then '' else '-b'
    execInBuild "git checkout #{flag} gh-pages"

  addAll = ->
    log 'add all files'
    execInBuild 'git add -A'

  commit = ->
    log 'commit'
    commitMessage = "automated commit by deployment at #{(new Date()).toUTCString()}"
    execInBuild "git commit --allow-empty -am '#{commitMessage}'"

  push = ->
    log 'push to gh-pages branch'
    execInBuild 'git push -f origin gh-pages'

  initRepo()
  checkoutBranch()
  addAll()
  commit()
  push()
