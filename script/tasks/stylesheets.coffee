gulp = require 'gulp'
gutil = require 'gulp-util'
minifyCss = require 'gulp-minify-css'
prefix = require 'gulp-autoprefixer'
plumber = require 'gulp-plumber'
sass = require 'gulp-sass'
watch = require 'gulp-watch'

cacheBuster = ''

compileSass = ->
  gulp.src('src/stylesheets/*.scss')
    .pipe(plumber())
    .pipe(sass().on('error', gutil.log))
    .pipe(prefix('last 3 versions', 'ie 8'))
    .pipe(gulp.dest('./_dev/stylesheets/'))

gulp.task 'buildSass', ['createProdSprites', 'buildJs'], ->
  cacheBuster = (new Date()).valueOf()

  gulp.src('src/stylesheets/!(_)*.scss')
    .pipe(sass().on('error', gutil.log))
    .pipe(minifyCss())
    .pipe(concat("all-#{cacheBuster}.css"))
    .pipe(gulp.dest('./_build/stylesheets/'))

gulp.task 'watchSass', ['createDevSprites'], ->
  watch glob: 'src/stylesheets/*.scss', ->
    compileSass()
  return

module.exports =
  cacheBuster: -> cacheBuster
  compile: compileSass
