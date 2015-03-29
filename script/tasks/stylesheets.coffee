concat = require 'gulp-concat'
gulp = require 'gulp'
gutil = require 'gulp-util'
minify = require 'gulp-minify-css'

cacheBuster = ''
files = ['styles.css']
srcFiles = files.map (file)-> "src/#{file}"

gulp.task 'build-stylesheets', ->
  cacheBuster = (new Date()).valueOf()

  gulp.src(srcFiles)
    .pipe(minify())
    .pipe(concat("all-#{cacheBuster}.css"))
    .pipe(gulp.dest('./_prod/'))

gulp.task 'copy-stylesheets', ->
  gulp.src('./src/**/*.css').pipe(gulp.dest('./_dev/'))

gulp.task 'watch-stylesheets', ['copy-stylesheets'], ->
  gulp.watch srcFiles, ['copy-stylesheets']

module.exports =
  files: files
  cacheBuster: -> cacheBuster
