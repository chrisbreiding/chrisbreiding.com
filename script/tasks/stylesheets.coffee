concat = require 'gulp-concat'
gulp = require 'gulp'
gutil = require 'gulp-util'
minifyCss = require 'gulp-minify-css'
prefix = require 'gulp-autoprefixer'
watch = require 'gulp-watch'

cacheBuster = ''
files = ['styles.css']

gulp.task 'buildSass', ['createProdSprites', 'buildJs'], ->
  cacheBuster = (new Date()).valueOf()

  gulp.src(files.map (file)-> "src/#{file}")
    .pipe(minifyCss())
    .pipe(concat("all-#{cacheBuster}.css"))
    .pipe(gulp.dest('./_build/'))

gulp.task 'watchStylesheets', ['createDevSprites'], ->
  watch(glob: 'src/*.css').pipe(gulp.dest('./_dev/'))
  return

module.exports =
  files: files
  cacheBuster: -> cacheBuster
