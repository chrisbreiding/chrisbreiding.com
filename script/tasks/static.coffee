gulp = require 'gulp'

glob = 'src/static/**/*'

gulp.task 'build-static', ->
  gulp.src(glob).pipe(gulp.dest('./_prod/'))

gulp.task 'copy-static', ->
  gulp.src(glob).pipe(gulp.dest('./_dev/'))

gulp.task 'watch-static', ['copy-static'], ->
  gulp.watch glob, ['copy-static']
