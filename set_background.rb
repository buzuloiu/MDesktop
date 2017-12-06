require 'imgkit'
require 'redcarpet'
require 'fastimage'
require 'mini_magick'



def scale_image(image)
  #scale the Image

  MiniMagick.configure do |config|
    config.validate_on_create = false
    config.validate_on_write = false
    config.validate_on_read = false

  end


  image = MiniMagick::Image.open('Yosimete.jpg')
  image.combine_options do |c|
    c.extent('600x')
    c.gravity('center')
    c.background('white')
  end
  image.write('image_scaled.jpg')
end

def set_wallpaper(file)
  #set the wallpaper
end

def get_scale(html)
  #render the html without any resulution params, return the factor
  #real_res/rendered_res
end

def prepare_html(html)
  #prepend/append/add html to the generated HTML
end

def get_screen_resolution
  #returns a hash
end

def clean_temp
end

FileUtils.rm_rf(Dir.glob('./lib/temp/*'))
puts "Generating HTML from Markdown"
#getting screen resolution
res = `system_profiler SPDisplaysDataType |grep Resolution`
halfs =  res.split("x")
screen_width = halfs[0].strip.split[-1]
screen_height =  halfs[1].strip.split[0]

file_name = Array.new(10){rand(36).to_s(36)}.join


#parsing user's markdown to HTML
mdown = File.read('./EDIT_ME.md')
html = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true).render(mdown)


split_html =  html.split('<blockquote>')
split_html.each do |item|
  item.prepend('<div class="column">')
  item << '</div>'
end
html = split_html.join(" ")
html.prepend('<div id="row">')
html << '</div>'

#puts html
scale_image('/Users/paul/sandbox/mdesktop/Yosemite.jpg')

puts "generating Image from HTML"
# run `wkhtmltoimage --extended-help` for a full list of options
kit  = IMGKit.new(html)
kit.stylesheets << './lib/style.scss'
kit.javascripts << './lib/style.js'
file = kit.to_file("./lib/temp/unscaled.jpg")
size = FastImage.size("./lib/temp/unscaled.jpg")
scale = (screen_height.to_f/size[1].to_f)

kit = IMGKit.new(html,:height => screen_height, :width => screen_width, :zoom => scale, :quality=>10000)
kit.stylesheets << './lib/style.scss'
kit.javascripts << './lib/style.js'

file = kit.to_file("./lib/temp/#{file_name}.jpg")


puts "setting wallpaper"
directory = File.expand_path(File.dirname(File.dirname(__FILE__)))
path = directory + "/lib/temp/#{file_name}.jpg"

#'osascript -e 'tell app "finder" to get posix path of (get desktop picture as alias)'
`./lib/setpaper.sh #{path}`
