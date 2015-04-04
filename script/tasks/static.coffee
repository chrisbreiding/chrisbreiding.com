gulp = require 'gulp'
rename = require 'gulp-rename'
rev = require 'gulp-rev'

glob = 'src/static/**/*'

gulp.task 'rev-favicon', ->
  gulp.src('src/favicon.ico')
    .pipe rev()
    .pipe gulp.dest('./_prod/')
    .pipe rev.manifest()
    .pipe rename('favicon-manifest.json')
    .pipe gulp.dest('./_prod/')

gulp.task 'build-static', ['rev-favicon'], ->
  gulp.src(glob).pipe gulp.dest('./_prod/')

gulp.task 'copy-favicon', ->
  gulp.src('src/favicon.ico').pipe gulp.dest('./_dev/')

gulp.task 'copy-static', ['copy-favicon'], ->
  gulp.src(glob).pipe gulp.dest('./_dev/')

gulp.task 'watch-static', ['copy-static'], ->
  gulp.watch glob, ['copy-static']

module.exports = favicon: 'favicon.ico'
