require './app'

project_path          = Sinatra::Application.root
relative_assets       = true

http_images_path      = '/ui'
http_stylesheets_path = '/css'

css_dir               = File.join 'public', 'css'
sass_dir              = File.join 'views', 'sass'
images_dir            = File.join 'public', 'ui'