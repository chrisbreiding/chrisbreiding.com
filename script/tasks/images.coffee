gulp = require 'gulp'
Q = require 'q'
spritesmith = require 'gulp.spritesmith'

imageCategories = [
  'header',   'header-2x'
  'projects', 'projects-2x'
  'skills',   'skills-2x'
  'contact',  'contact-2x'
]

spriteAndCopyImages = (imageCategory, destination)->
  spriteData = gulp.src("src/images/#{imageCategory}/*.png")
    .pipe spritesmith
      imgName: "../images/#{imageCategory}.png"
      cssName: "_#{imageCategory}-sprite.scss"
      cssFormat: 'scss'
      cssVarMap: (sprite)->
        sprite.name = sprite.name.replace '@', '-'
        return
  spriteData.img.pipe(gulp.dest("#{destination}/images/"))
  spriteData

createSprite = (imageCategory, destination)->
  spriteData = spriteAndCopyImages imageCategory, destination
  spriteData.css.pipe(gulp.dest('src/stylesheets/generated/'))

createSprites = (destination)->
  createSprite imageCategory, destination for imageCategory in imageCategories
  # ensure sprite scss gets written before dependent tasks run
  Q.delay 3000

gulp.task 'createProdSprites', ->
  createSprites '_build'

gulp.task 'createDevSprites', ->
  createSprites '_dev'

gulp.task 'watchImages', ['createDevSprites'], ->
  for imageCategory in imageCategories
    do (imageCategory)->
      gulp.watch "src/images/#{imageCategory}/*.png", ->
        createSprite imageCategory, '_dev'
