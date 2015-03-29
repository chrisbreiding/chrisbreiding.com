deploy = require '../lib/deploy'
gulp = require 'gulp'
server = require '../lib/server'

buildProdIndex = require('./html').prod

gulp.task 'dev-server', -> server '_dev', 8080

gulp.task 'dev', ['watch-index', 'dev-server']

gulp.task 'build', ['build-static', 'build-stylesheets'], -> buildProdIndex()

gulp.task 'prod', ['build'], -> server '_prod', 8081

gulp.task 'deploy', ['build'], -> deploy()
