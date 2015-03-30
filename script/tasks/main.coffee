deploy = require '../lib/deploy'
gulp = require 'gulp'
server = require '../lib/server'

gulp.task 'dev', [
  'watch-index'
  'watch-scripts'
  'watch-stylesheets'
  'watch-static'
], -> server '_dev', 8080

gulp.task 'build', [
  'build-index'
  'build-scripts'
  'build-stylesheets'
  'build-static'
]

gulp.task 'prod', ['build'], -> server '_prod', 8081

gulp.task 'deploy', ['build'], -> deploy()
