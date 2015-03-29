concat = require 'gulp-concat'
gulp = require 'gulp'
gutil = require 'gulp-util'
minifyCss = require 'gulp-minify-css'

cacheBuster = ''
files = ['styles.css']
srcFiles = files.map (file)-> "src/#{file}"

gulp.task 'buildSass', ['createProdSprites', 'buildJs'], ->
  cacheBuster = (new Date()).valueOf()

  gulp.src(srcFiles)
    .pipe(minifyCss())
    .pipe(concat("all-#{cacheBuster}.css"))
    .pipe(gulp.dest('./_build/'))

gulp.task 'copyStylesheets', ->
  gulp.src('./src/**/*.css').pipe(gulp.dest('./_dev/'))

gulp.task 'watchStylesheets', ['copyStylesheets', 'createDevSprites'], ->
  gulp.watch srcFiles, ['copyStylesheets']

module.exports =
  files: files
  cacheBuster: -> cacheBuster
