fs = require 'fs'
gulp = require 'gulp'
jade = require 'gulp-jade'

scripts = require './scripts'
stylesheets = require './stylesheets'

getJSON = (name)->
  JSON.parse fs.readFileSync "src/content/#{name}.json"

buildIndex = (cssFiles, jsFiles, destination)->
  jadeOptions =
    locals:
      stylesheets: cssFiles
      scripts: jsFiles
      social: getJSON 'social'
      projects: getJSON 'projects'
      skills: getJSON 'skills'
    pretty: true

  gulp.src('src/index.jade')
    .pipe(jade(jadeOptions))
    .pipe(gulp.dest("./#{destination}/"))

buildDevIndex = ->
  buildIndex stylesheets.files, scripts.files, '_dev'

gulp.task 'watchIndex', ['watchScripts', 'watchStylesheets', 'watchStatic'], ->
  gulp.watch 'src/index.jade', buildDevIndex
  gulp.watch 'src/content/*.json', buildDevIndex
  buildDevIndex()

module.exports =
  dev: buildDevIndex
  prod: ->
    buildIndex ["all-#{stylesheets.cacheBuster()}.css"], ["all-#{scripts.cacheBuster()}.js"], '_build'
