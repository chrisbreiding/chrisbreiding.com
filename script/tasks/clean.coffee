del = require 'del'
gulp = require 'gulp'

gulp.task 'clean-prod', -> del '_prod'

gulp.task 'clean-dev', -> del '_dev'

gulp.task 'clean', ['clean-prod', 'clean-dev']
