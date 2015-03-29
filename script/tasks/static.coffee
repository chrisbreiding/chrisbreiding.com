gulp = require 'gulp'
watch = require 'gulp-watch'

gulp.task 'buildStatic', ['cleanBuild'], ->
  gulp.src('src/images/*.+(png|gif|jpg|ico)').pipe(gulp.dest('./_build/images/'))
  gulp.src('CNAME').pipe(gulp.dest('./_build/'))

gulp.task 'watchStatic', ->
  watch(glob: 'src/images/*.+(png|gif|jpg|ico)').pipe(gulp.dest('./_dev/images/'))
  watch(glob: 'src/scripts/*.js').pipe(gulp.dest('./_dev/scripts/'))
  return
