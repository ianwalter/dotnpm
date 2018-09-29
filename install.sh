#!/bin/bash

if [[ $(uname) == 'Linux' ]]; then

  # Change NPM default directory if necessary to avoid permission problems.
  if [[ $(npm config get prefix) == '/usr' ]]; then
    mkdir ~/.npm-global
    npm config set prefix '~/.npm-global'
  fi

fi

# Copy global-package-list file to .npm directory.
mkdir -p ~/.npm
cp ./global-package-list ~/.npm

# Install npm packages from .npm file.
package_dir="$(npm config get prefix)/lib"
packages=$(npm ls -g --parseable --depth=0)
packages=${packages//$package_dir/}
packages=${packages//\/node_modules\//}
while read p; do
  installed=$(echo "$packages" | grep -ce "^$p\$")
  if [ $installed == "0" ]; then
    npm install -g $p
  fi
done < ~/.npm/global-package-list

if [[ $? == 0 ]]; then
  echo "Installed npm packages successfully."
fi
