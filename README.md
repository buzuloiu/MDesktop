# mdesktop
Generating MacOS desktop wallpapers from Markdown with ruby

![](https://user-images.githubusercontent.com/20449016/33522796-dbf397c8-d7c3-11e7-93a3-0a6aba7a3b3b.png)

This is a **total** WIP right now, there are scaling issues with the markdown, and adding too many lines makes it run off the page.

The idea is to be able to put whatever you want on the desktop:
- cheat sheets for programming languages
- reminders
- random pictures

## How to use:

1. clone the git repo
2. run `bundle install`
3. edit the `EDIT_ME.md` file to contain whatever you want
4. run `ruby ./set_background.rb`

## Issues

- sometimes the scripts that sets the wallpaper has a problem changing the wallpaper. If this happens you can set the wallpaper manually to the `/lib/wallpaper.jpg` file.
  - sometimes this issues is resolved by switching to a different default desktop and then running the script again.
