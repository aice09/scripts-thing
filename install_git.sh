#!/bin/bash

# Prompt user for Git version
echo -n "Enter Git version to install (e.g., 2.9.5): "
read git_version

# Define download URL
git_url="https://mirrors.edge.kernel.org/pub/software/scm/git/git-$git_version.tar.gz"

# Check if the version exists
if curl --head --silent --fail "$git_url" > /dev/null; then
    echo "Downloading Git version $git_version..."
    cd /tmp || exit
    wget "$git_url"
    tar -xvzf "git-$git_version.tar.gz"
    cd "git-$git_version" || exit
    
    echo "Building Git..."
    make prefix=/usr/local all
    sudo make prefix=/usr/local install
    
    echo "Installation complete! Installed Git version:"
    git --version
else
    echo "Git version $git_version is not available. Please try a different version."
fi
