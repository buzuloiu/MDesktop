require_relative './lib/background.rb'

def parse_args
    theme = ARGV[0]
    return theme
end

background =  Background.new

background.clean_temp


theme = background.set_theme(parse_args.to_s)

puts "Generating HTML from Markdown"

resolution = background.get_screen_resolution
file_name = background.generate_file_name(10)

raw_html = background.mdown_to_html(File.read('./EDIT_ME.md'))
html = background.prepare_html(raw_html)

puts "generating Image from HTML"
# run `wkhtmltoimage --extended-help` for a full list of option
scale = background.get_scale(html,resolution)
background.render_to_image(html,scale,resolution,file_name)

background.set_wallpaper(file_name)
