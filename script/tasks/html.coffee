fs = require 'fs'
gulp = require 'gulp'
jade = require 'gulp-jade'
plumber = require 'gulp-plumber'
watch = require 'gulp-watch'

getScriptsCacheBuster = require './scripts'
getStylesheetsCacheBuster = require('./stylesheets').cacheBuster

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
    "scripts/jquery.js"
    "scripts/jquery.xdomainrequest.js"
    "scripts/scripts.js"
  ]
  buildIndex ['stylesheets/all.css'], jsFiles, '_dev'

gulp.task 'watchIndex', ['watchCoffee', 'watchSass', 'watchImages', 'watchStatic'], ->
  watch glob: 'src/index.jade', buildDevIndex
  watch glob: 'src/content/*.json', buildDevIndex
  watch glob: 'src/scripts/**/*.coffee', buildDevIndex

module.exports =
  dev: buildDevIndex
  prod: ->
    buildIndex ["stylesheets/all-#{getScriptsCacheBuster()}.css"], ["scripts/all-#{getStylesheetsCacheBuster}.js"], '_build'
