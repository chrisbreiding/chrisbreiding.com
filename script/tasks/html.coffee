fs = require 'fs'
gulp = require 'gulp'
jade = require 'gulp-jade'
plumber = require 'gulp-plumber'
watch = require 'gulp-watch'

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
    .pipe(plumber())
    .pipe(jade(jadeOptions))
    .pipe(gulp.dest("./#{destination}/"))

buildDevIndex = ->
  jsFiles = [
    "vendor/jquery.js"
    "vendor/jquery.xdomainrequest.js"
    "scripts.js"
  ]
  buildIndex stylesheets.files, scripts.files, '_dev'

gulp.task 'watchIndex', ['watchScripts', 'watchStylesheets', 'watchImages', 'watchStatic'], ->
  watch glob: 'src/index.jade', buildDevIndex
  watch glob: 'src/content/*.json', buildDevIndex

module.exports =
  dev: buildDevIndex
  prod: ->
    buildIndex ["all-#{stylesheets.cacheBuster()}.css"], ["all-#{scripts.cacheBuster()}.js"], '_build'
