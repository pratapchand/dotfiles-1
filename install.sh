#!/bin/zsh 
source include/shared_vars.sh

#install pip and friends
install_pip()
{
    if test ! $(`which pip`)
    then
        echo "     [-] There is no pip. Going to install pip. This will ask for your root password."
        sudo easy_install pip
    fi
}

BREWED_TOOLS=(python python3 golang rbenv ruby-build tree zsh htop tmux aspell --lang=en direnv fzf highlight)
BREWED_APPS=(google-chrome karabiner-elements vlc) # Applications to install
PIP_TOOLS=(virtualenvwrapper) #tools to install via pipi
RUBY_GEMS=(bundler foreman)
BACKUP_DIR='' # where we will backup this instance of install

install_homebrew()
{
    if ! type "brew" &> /dev/null; then
        echo "     [-] There is no Homebrew. Going to install Homebrew."
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi

    brew update
    brew upgrade
    brew install $BREWED_TOOLS
    brew cask install $BREWED_APPS
    brew tap universal-ctags/universal-ctags
    brew install --HEAD universal-ctags
    brew tap burntsushi/ripgrep https://github.com/BurntSushi/ripgrep.git
    brew install burntsushi/ripgrep/ripgrep-bin

    /usr/local/opt/fzf/install --all
}

# Install system-wide Ruby Gems
install_rubygems()
{
    if ! type "$gem" &> /dev/null; then
      echo "     [-] There is no Gem. You need to install Ruby. (brew install ruby)"
    else
      gem update --system
      gem install $RUBY_GEMS --no-rdoc --no-ri
    fi
}

install_zsh () {
# Test to see if zshell is installed.  If it is:
if [ -f /bin/zsh -o -f /usr/local/bin/zsh ]; then
    # Clone my oh-my-zsh repository from GitHub only if it isn't already present
    if [[ ! -d $HOME_DIR/.zsh/ ]]; then
        git clone http://github.com/robbyrussell/oh-my-zsh.git ~/.zsh
    fi
    # Set the default shell to zsh if it isn't currently set to zsh
    if [[ ! $(echo $SHELL) == $(`which zsh`) ]]; then
        chsh -s $(`which zsh`)
    fi
else
    echo "Please install zsh, then re-run this script!"
    exit
fi
}

# install go
install_go_nth()
{
    brew update
    brew install go --cross-compiler-common
    export GOPATH=$HOME_DIR/go
    go get golang.org/x/tools/cmd/godoc
    go get github.com/golang/lint/golint
}

# install Janus
install_janus()
{
    vim_home=$HOME/.vim
    janus_plugin_dir=$HOME/.janus
    if [ ! -d $vim_home/janus ]
    then
        curl -Lo- https://bit.ly/janus-bootstrap | sh
    else
        # There must be a better way to do this! (like make -C)
        # bundle exec rake default -f $vim_home
        cd $vim_home
        rake default
        cd -
    fi

    # install plugins
    mkdir -p $janus_plugin_dir
    git clone git@github.com:junegunn/fzf.vim.git $janus_plugin_dir/fzf
    git clone git@github.com:vim-airline/vim-airline.git $janus_plugin_dir/vim-airline
    git clone git@github.com:tpope/vim-rails.git $janus_plugin_dir/vim-rails
}

install_cli_font()
{
    # Using Inconsolata http://www.levien.com/type/myfonts/inconsolata.html
    font_source=http://www.levien.com/type/myfonts/Inconsolata.otf
    font_target=$HOME_DIR/Library/Fonts/Inconsolata.otf

    if [ ! -f $font_target ]
    then
        curl -L $font_source -o $font_target
    fi
}

create_backup_dir()
{
    timestamp=`date "+%Y-%h-%d-%H-%M-%S"`
    backup_dir="$BACKUP_ROOT/$timestamp"
    mkdir -p $backup_dir
    if [ -d $backup_dir ]
    then
        BACKUP_DIR=$backup_dir
    else
        echo "     [x] Could not create backup directory $backup_dir"
        return 1
    fi
}

#create user folder
create_folder()
{
    #create folder for the following
    for f in $USER_FOLDERS; do
        mkdir -p "$f"
    done
}

#backup a file
backup_file()
{
    backup_dir=$1/
    source_file=$2
    mv $source_file $backup_dir
}

# check dependencies and create backup directories
initialize()
{
    echo "     [+] Installing Homebrew and friends"
    install_homebrew
    echo "     [+] Installing Ruby Gems"
    install_rubygems
    echo "     [+] Installing OMZ"
    install_zsh
    echo "     [+] Installing Janus for vim"
    install_janus
    echo "     [+] Installing CLI font"
    install_cli_font
    echo "     [+] Creating backup folders"
    create_backup_dir
    echo "     [+] Creating User folders"
    create_folder
}

# install the dot files in $HOME_DIR
install_dotfiles()
{

    # glob *.SYMLINK_EXT from directories and create equivalent symlinks in $HOME_DIR
    for f in `find $PWD -name "*.$SYMLINK_EXT"`; do
        target=$HOME_DIR/.`basename -s .$SYMLINK_EXT $f`

        # if the target exists then back it up
        if [ -e $target ]
        then
            backup_file $BACKUP_DIR $target
        fi

       ln -fs $f $target;
    done
}

# Unleash the dots!
initialize
if [ $? -eq 0 ]
then
    install_dotfiles
    echo "     [+] dotfile installation complete"
    echo "     [+] Your old dot files are backed up in $BACKUP_DIR"
    echo "     [+] You can revert the changes with revert.sh"
else
    echo "     [x] There was an error initializing... will revert changes now"
    source revert.sh
    echo "     [x] Done."
fi
