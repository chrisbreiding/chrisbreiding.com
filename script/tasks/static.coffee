gulp = require 'gulp'

glob = 'src/static/**/*'

gulp.task 'buildStatic', ->
  gulp.src(glob).pipe(gulp.dest('./_build/'))

gulp.task 'copyStatic', ->
  gulp.src(glob).pipe(gulp.dest('./_dev/'))

gulp.task 'watchStatic', ['copyStatic'], ->
  gulp.watch glob, ['copyStatic']
