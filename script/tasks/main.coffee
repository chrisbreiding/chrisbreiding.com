deploy = require '../lib/deploy'
gulp = require 'gulp'
server = require '../lib/server'

buildProdIndex = require('./html').prod

gulp.task 'devServer', -> server '_dev', 8080

gulp.task 'dev', ['watchIndex', 'devServer']

gulp.task 'build', ['buildStatic', 'buildStylesheets'], -> buildProdIndex()

gulp.task 'prod', ['build'], -> server '_build', 8081

gulp.task 'deploy', ['build'], -> deploy()
