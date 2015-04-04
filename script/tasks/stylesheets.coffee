concat = require 'gulp-concat'
gulp = require 'gulp'
gutil = require 'gulp-util'
minify = require 'gulp-minify-css'
rename = require 'gulp-rename'
rev = require 'gulp-rev'

files = ['styles.css']
srcFiles = files.map (file)-> "src/#{file}"

gulp.task 'build-stylesheets', ->
  gulp.src(srcFiles)
    .pipe minify()
    .pipe rename('app.css')
    .pipe rev()
    .pipe gulp.dest('./_prod/')
    .pipe rev.manifest()
    .pipe rename('stylesheets-manifest.json')
    .pipe gulp.dest('./_prod/')

gulp.task 'copy-stylesheets', ->
  gulp.src('./src/**/*.css').pipe(gulp.dest('./_dev/'))

gulp.task 'watch-stylesheets', ['copy-stylesheets'], ->
  gulp.watch srcFiles, ['copy-stylesheets']

module.exports = files: files
