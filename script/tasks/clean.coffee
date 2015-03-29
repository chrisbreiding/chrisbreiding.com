clean = require 'gulp-clean'
gulp = require 'gulp'
gutil = require 'gulp-util'

gulp.task 'cleanBuild', ->
  gutil.log gutil.colors.yellow 'removing _build'
  gulp.src('_build', read: false).pipe(clean())

gulp.task 'cleanDev', ->
  gutil.log gutil.colors.yellow 'removing _dev'
  gulp.src('_dev', read: false).pipe(clean())
  gutil.log gutil.colors.yellow 'removing src/stylesheets/generated'
  gulp.src('src/stylesheets/generated', read: false).pipe(clean())

gulp.task 'clean', ['cleanBuild', 'cleanDev']
