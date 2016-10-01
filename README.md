# dirlist-bitbar

## What is this?

Dirlist-bitbar is a small ruby plugin for [@matryer's BitBar application](https://github.com/matryer/bitbar) which aims to make working with a large number of active repositories/workspaces a bit easier.

It adds a dropdown list of all your repo/workspace dirs ordered by `mtime` of the dirs contents to let you quickly get at recent dirs, click to open a dir in an editor of your choice (defaults to Visual Studio Code).

![dirlist-bitbar in action](https://raw.githubusercontent.com/johnmccabe/dirlist-bitbar/gh-pages/images/https://raw.githubusercontent.com/johnmccabe/dirlist-bitbar/gh-pages/images/dirlist_bitbar.png)

## Features

- shows all directories in the specified workspace dir ordered `mtime` of the most recent file in the dir (dotfiles are ignored)
- click to open the directory in your specified editor
- breaks dirs into groups based on days since last activity, 1 day, 2 days, 3 days, 7 days, with a submenu for all older dirs.

## Getting Started

### Install BitBar
If you don't already have BitBar installed you can install using `brew` or by grabbing a release directly from [GitHub](https://github.com/matryer/bitbar/releases/tag/v1.9.1). If you already have BitBar installed you can jump to installing and running the plugin.

    brew cask install bitbar

You can now start BitBar from the `Applications` folder or:

    open /Applications/BitBar.app

If this is your first time installing BitBar you will be prompted to choose/create a plugins directory, for example `~/Documents/bitbar_plugins/`.

Any executable scripts copied to this directory will be rendered in the menubar by BitBar and it is here we will copy the vmpooler-bitbar script.

### Add and configure the dirlist-bitbar plugin

Copy `vmpooler-bitbar.60s.rb` to your BitBar plugins directory.

Change the default `REPO_DIR` to point to your own workspace directory, for example if you keep all your repos under the directory `/data/my_workspace` then you would set:

    REPO_DIR = "/data/my_workspace".freeze

If you wish you use an editor other than Visual Studio Code, you should update the following line:

    puts "#{submenu_prefix}#{repo_basename}|bash=/usr/bin/vim param1=-n param2=#{repo} terminal=false"

For example to use Sublime Text (if you really must..)

    puts "#{submenu_prefix}#{repo_basename}|bash='/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl' param1=-n param2=#{repo} terminal=false"

From the BitBar menu select `refresh all` to have BitBar rescan the plugins directory and you should see `<n> repos` appear in your menubar.