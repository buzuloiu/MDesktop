require 'imgkit'
require 'redcarpet'
require 'fastimage'
require 'mini_magick'



def scale_image(image,scale)
  #scale the Image

  @size = FastImage.size(image)

  # Create a white png, 1024 x 768 pixels
  MiniMagick::Tool::Convert.new do | new_image |
    #new_image.size "#{(scale*@size[1]).to_i}x#{(scale*@size[0]).to_i}"
    new_image.size "1024x768"
    new_image << "blank.png"
  end

  MiniMagick.configure do |config|
    config.validate_on_create = false
    config.validate_on_write = false

  end


  image = MiniMagick::Image.open('/Users/paul/sandbox/mdesktop/Yosemite.jpg')
  image.combine_options do |c|
    c.extent('600x')
    c.gravity('center')
    c.background('white')
  end
  image.write('image_scaled.jpg')
end

def set_wallpaper(file)
  puts "setting wallpaper"
  directory = File.expand_path(File.dirname(File.dirname(__FILE__)))
  path = directory + "/lib/temp/#{file}.jpg"
  #'osascript -e 'tell app "finder" to get posix path of (get desktop picture as alias)'
  `./lib/setpaper.sh #{path}`
end

def get_scale(html, resolution)
  #render the html without any resulution params, return the factor
  #real_res/rendered_res
  kit  = IMGKit.new(html)
  kit.stylesheets << './lib/style.scss'
  kit.javascripts << './lib/style.js'
  file = kit.to_file("./lib/temp/unscaled.jpg")
  size = FastImage.size("./lib/temp/unscaled.jpg")
  @scale = (resolution[:height].to_f/size[1].to_f)
  return @scale
end

def prepare_html(html)
  #prepend/append/add html to the generated HTML

  split_html =  html.split('<blockquote>')
  split_html.each do |item|
    item.prepend('<div class="column">')
    item << '</div>'
  end
  @html = split_html.join(" ")
  @html.prepend('<div id="row">')
  @html << '</div>'
  puts @html
  return @html
end

def get_screen_resolution
  #returns a hash
  res = `system_profiler SPDisplaysDataType |grep Resolution`
  halfs =  res.split("x")
  screen_width = halfs[0].strip.split[-1]
  screen_height =  halfs[1].strip.split[0]
  @ret = Hash.new
  @ret[:width] = screen_width
  @ret[:height] = screen_height
  return @ret
end

def clean_temp
  FileUtils.rm_rf(Dir.glob('./lib/temp/*'))
end

clean_temp

puts "Generating HTML from Markdown"

resolution = get_screen_resolution

file_name = Array.new(10){rand(36).to_s(36)}.join

mdown = File.read('./EDIT_ME.md')
html = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true).render(mdown)

html = prepare_html(html)

puts "generating Image from HTML"
# run `wkhtmltoimage --extended-help` for a full list of option
scale = get_scale(html,resolution)

#scale_image("Yosemite.jpg", scale)


kit = IMGKit.new(html,:height => resolution[:height], :width => resolution[:width], :zoom => scale, :quality=>10000)
kit.stylesheets << './lib/style.scss'
kit.javascripts << './lib/style.js'
file = kit.to_file("./lib/temp/#{file_name}.jpg")

set_wallpaper(file_name)
