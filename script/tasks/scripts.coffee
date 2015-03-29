coffee = require 'gulp-coffee'
concat = require 'gulp-concat'
es = require 'event-stream'
gulp = require 'gulp'
gutil = require 'gulp-util'
order = require 'gulp-order'
plumber = require 'gulp-plumber'
uglify = require 'gulp-uglify'
watch = require 'gulp-watch'

cacheBuster = ''

gulp.task 'buildJs', ['buildCopy'], ->
  cacheBuster = (new Date()).valueOf()

  coffeeJs = gulp.src('src/scripts/*.coffee').pipe(coffee().on('error', gutil.log))
  libJs = gulp.src('src/scripts/*.js')

  es.merge(coffeeJs, libJs)
    .pipe(order([
      'src/scripts/jquery.js'
      'src/scripts/jquery.xdomainrequest.js'
      'src/scripts/scripts.js'
    ]))
    .pipe(uglify())
    .pipe(concat("all-#{cacheBuster}.js"))
    .pipe(gulp.dest('./_build/scripts/'))

gulp.task 'watchCoffee', ->
  watch(glob: 'src/scripts/**/*.coffee')
    .pipe(plumber())
    .pipe(coffee().on('error', gutil.log))
    .pipe(gulp.dest('./_dev/scripts/'))
  return

module.exports = -> cacheBuster
