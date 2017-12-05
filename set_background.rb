require 'imgkit'
require 'redcarpet'
require 'fastimage'

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

puts html

puts "generating Image from HTML"
# run `wkhtmltoimage --extended-help` for a full list of options
kit  = IMGKit.new(html)
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


`./lib/setpaper.sh #{path}`
