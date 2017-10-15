concat = require 'gulp-concat'
gulp = require 'gulp'
gutil = require 'gulp-util'
minify = require 'gulp-uglify'
rename = require 'gulp-rename'
rev = require 'gulp-rev'

files = [
  'vendor/ga.js'
  'vendor/jquery.js'
  'scripts.js'
]
srcFiles = files.map (file)-> "src/#{file}"

gulp.task 'build-scripts', ->
  gulp.src(srcFiles)
    .pipe concat('app.js')
    .pipe minify()
    .pipe rev()
    .pipe gulp.dest('./_prod/')
    .pipe rev.manifest()
    .pipe rename('scripts-manifest.json')
    .pipe gulp.dest('./_prod/')

gulp.task 'copy-scripts', ->
  gulp.src('./src/**/*.js').pipe(gulp.dest('./_dev/'))

gulp.task 'watch-scripts', ['copy-scripts'], ->
  gulp.watch srcFiles, ['copy-scripts']

module.exports = files: files
