fs = require 'fs'
gulp = require 'gulp'
handlebars = require 'gulp-compile-handlebars'
rename = require 'gulp-rename'

scripts = require './scripts'
stylesheets = require './stylesheets'

buildIndex = (cssFiles, jsFiles, destination)->
  data =
    stylesheets: cssFiles
    scripts: jsFiles

  gulp.src('src/index.hbs')
    .pipe(handlebars(data))
    .pipe(rename('index.html'))
    .pipe(gulp.dest("./#{destination}/"))

gulp.task 'build-index', ['build-scripts', 'build-stylesheets'], ->
  buildIndex ["all-#{stylesheets.cacheBuster()}.css"], ["all-#{scripts.cacheBuster()}.js"], '_prod'

gulp.task 'build-dev-index', ->
  buildIndex stylesheets.files, scripts.files, '_dev'

gulp.task 'watch-index', ['build-dev-index'], ->
  gulp.watch 'src/index.hbs', ['build-dev-index']
