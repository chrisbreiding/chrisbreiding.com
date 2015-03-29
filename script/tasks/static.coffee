gulp = require 'gulp'

imagesGlob = 'src/images/*.+(png|gif|jpg|ico)'

gulp.task 'buildStatic', ['cleanBuild'], ->
  gulp.src(imagesGlob).pipe(gulp.dest('./_build/images/'))
  gulp.src('CNAME').pipe(gulp.dest('./_build/'))

gulp.task 'watchStatic', ->
  gulp.watch imagesGlob, ->
    gulp.src(imagesGlob).pipe(gulp.dest('./_dev/images/'))
