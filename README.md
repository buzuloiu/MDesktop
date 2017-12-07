# mdesktop
Generating MacOS desktop wallpapers from Markdown with ruby


This is a **total** WIP right now

The idea is to be able to put whatever you want on the desktop:
- cheat sheets for programming languages
- reminders
- random pictures

## How to use:

1. clone the git repo
2. run `install.sh`
3. edit the `EDIT_ME.md` file to contain whatever you want
4. run `ruby ./render.rb`
5. you can add columns with the `>` character instead of blockquotes
6. you can set a theme by passing it as the first argument: `ruby ./render.rb <theme_name>`

## Sample Desktops:

### a nice big word with `big_text` theme

![](https://user-images.githubusercontent.com/20449016/33695845-57abd2de-dacd-11e7-9ead-fd02e9c439f7.png)

### a cheat sheet for whatever with `default` theme

![](https://user-images.githubusercontent.com/20449016/33695846-59210c42-dacd-11e7-931d-006dfc996fe8.png)
