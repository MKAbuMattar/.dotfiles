# `.dotfiles`

>>underwork

***

## Arch Linux KDE | ZEN

```bash
#                             .
#         ..                .''
#         .,'..,.         ..,;,'
#          ,;;;;,,       .,,;;;
#           ,;;;;;'    .',;;;
#            ,;;;;,'...,;;;,
#             ,;;;;;,,;;;;.
#              ,;;;;;;;;;
#              .,;;;;;;;
#              .,;;;;;;;'
#              .,;;;;;;;,'
#            .',;;;;;;;;;;,.
#          ..,;;;;;;;;;;;;;,.
#         .';;;;;.   ';;;;;;,'
#        .,;;;;.      ,; .;; .,
#        ',;;;.        .
#        .,;;.
#        ,;
#
#       Mohammad Abu Mattar
```

***

add this alias to your `.bashrc`, `.zshrc` or `config.fish`

```bash
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
```

create bare git

```bash
git init --bare $HOME/.dotfiles

config config --local status.showUntrackedFiles no
```

link your config to your github

```bash
## add readme file
echo "# `.dotfiles`" >> README.md
config add README.md
config commit -m 'add README'

## push to your github
config branch -M main
config remote add origin git@github.com:YOUR_USERNAME/.dotfiles.git
config push -u origin main 
```

sample how to add to your `.dotfiles`

```bash
config add .bashrc
config commit -m 'add my .bashrc'
config push
```

check the status for your `.dotfiles`

```bash
config status
```

***

## Install your `.dotfiles` onto a new system

add this alias to your `.bashrc`, `.zshrc` or `config.fish`

```bash
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
```

```bash
echo ".dotfiles" >> .gitignore
```

clone your dotfiles into a bare repo.

```bash
git clone --bare <git-repo-url> $HOME/.dotfiles

config checkout
```
