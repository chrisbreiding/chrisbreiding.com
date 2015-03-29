fs = require 'fs'
gulp = require 'gulp'
handlebars = require 'gulp-compile-handlebars'
rename = require 'gulp-rename'

scripts = require './scripts'
stylesheets = require './stylesheets'

getJSON = (name)->
  JSON.parse fs.readFileSync "src/content/#{name}.json"

buildIndex = (cssFiles, jsFiles, destination)->
  data =
    stylesheets: cssFiles
    scripts: jsFiles
    social: getJSON 'social'
    projects: getJSON 'projects'
    skills: getJSON 'skills'

  gulp.src('src/index.hbs')
    .pipe(handlebars(data))
    .pipe(rename('index.html'))
    .pipe(gulp.dest("./#{destination}/"))

buildDevIndex = ->
  buildIndex stylesheets.files, scripts.files, '_dev'

gulp.task 'watch-index', ['watch-scripts', 'watch-stylesheets', 'watch-static'], ->
  gulp.watch 'src/index.hbs', buildDevIndex
  gulp.watch 'src/content/*.json', buildDevIndex
  buildDevIndex()

module.exports =
  dev: buildDevIndex
  prod: ->
    buildIndex ["all-#{stylesheets.cacheBuster()}.css"], ["all-#{scripts.cacheBuster()}.js"], '_prod'
