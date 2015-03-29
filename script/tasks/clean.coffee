del = require 'del'
gulp = require 'gulp'

gulp.task 'cleanBuild', -> del '_build'

gulp.task 'cleanDev', -> del ['_dev', 'src/stylesheets/generated']

gulp.task 'clean', ['cleanBuild', 'cleanDev']
