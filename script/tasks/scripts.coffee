concat = require 'gulp-concat'
gulp = require 'gulp'
gutil = require 'gulp-util'
minify = require 'gulp-uglify'

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
    .pipe(minify())
    .pipe(concat("all-#{cacheBuster}.js"))
    .pipe(gulp.dest('./_prod/'))

gulp.task 'copy-scripts', ->
  gulp.src('./src/**/*.js').pipe(gulp.dest('./_dev/'))

gulp.task 'watch-scripts', ['copy-scripts'], ->
  gulp.watch srcFiles, ['copy-scripts']

module.exports =
  files: files
  cacheBuster: -> cacheBuster
