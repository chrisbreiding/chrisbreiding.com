concat = require 'gulp-concat'
gulp = require 'gulp'
gutil = require 'gulp-util'
uglify = require 'gulp-uglify'
watch = require 'gulp-watch'

cacheBuster = ''
files = [
  'vendor/jquery.js'
  'vendor/jquery.xdomainrequest.js'
  'scripts.js'
]

gulp.task 'buildJs', ['buildStatic'], ->
  cacheBuster = (new Date()).valueOf()

  gulp.src(files.map (file)-> "src/#{file}")
    .pipe(uglify())
    .pipe(concat("all-#{cacheBuster}.js"))
    .pipe(gulp.dest('./_build/'))

gulp.task 'watchScripts', ->
  watch(glob: 'src/**/*.js').pipe(gulp.dest('./_dev/'))
  return

module.exports =
  files: files
  cacheBuster: -> cacheBuster
