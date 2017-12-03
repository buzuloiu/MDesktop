require 'imgkit'
require 'redcarpet'


puts "Generating HTML from Markdown"
#getting screen resolution
res = `system_profiler SPDisplaysDataType |grep Resolution`
halfs =  res.split("x")
screen_width = halfs[0].strip.split[-1]
screen_height =  halfs[1].strip.split[0]


#parsing user's markdown to HTML
mdown = File.read('EDIT_ME.md')
html = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true).render(mdown)
File.write('./converted.html', html)

puts "generating Image from HTML"
# run `wkhtmltoimage --extended-help` for a full list of options
kit = IMGKit.new(File.new('./converted.html'),:height => screen_height, :width => screen_width)

file = kit.to_file('./lib/wallpaper.jpg')


puts "setting wallpaper"
directory = File.expand_path(File.dirname(File.dirname(__FILE__)))
path = directory + "/lib/wallpaper.jpg"

`./lib/setpaper.sh #{path}`
