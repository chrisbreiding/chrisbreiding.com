concat = require 'gulp-concat'
gulp = require 'gulp'
gutil = require 'gulp-util'
uglify = require 'gulp-uglify'

cacheBuster = ''
files = [
  'vendor/jquery.js'
  'vendor/jquery.xdomainrequest.js'
  'scripts.js'
]
srcFiles = files.map (file)-> "src/#{file}"

gulp.task 'buildScripts', ->
  cacheBuster = (new Date()).valueOf()

  gulp.src(srcFiles)
    .pipe(uglify())
    .pipe(concat("all-#{cacheBuster}.js"))
    .pipe(gulp.dest('./_build/'))

gulp.task 'copyScripts', ->
  gulp.src('./src/**/*.js').pipe(gulp.dest('./_dev/'))

gulp.task 'watchScripts', ['copyScripts'], ->
  gulp.watch srcFiles, ['copyScripts']

module.exports =
  files: files
  cacheBuster: -> cacheBuster
