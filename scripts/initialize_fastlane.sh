#!/bin/bash

set -e

GREEN="\033[0;32m"
RED="\033[0;31m"
NC="\033[0m" # No Color

echo "### 1. Check if project path argument is provided"
if [ -z "$1" ]; then
  echo -e "${RED}Error: Usage: $0 /path/to/project${NC}"
  exit 1
else
  echo "Project path argument received: $1"
  echo -e "${GREEN}Project path check complete.${NC}"
fi

echo "### 2. Check Xcode Command Line Tools installation"
if ! xcode-select -p > /dev/null 2>&1; then
  echo "Installing Xcode Command Line Tools..."
  xcode-select --install
else
  echo "Xcode Command Line Tools are already installed."
fi
echo -e "${GREEN}Xcode Command Line Tools check complete.${NC}"

echo "### 3. Check Homebrew installation"
if ! command -v brew > /dev/null 2>&1; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  
  echo "Setting up Homebrew environment in shell profile..."
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  echo "Homebrew is already installed."
fi
echo -e "${GREEN}Homebrew setup complete.${NC}"

echo "### 4. Install rbenv and Ruby"
if ! command -v rbenv > /dev/null 2>&1; then
  echo "Installing rbenv..."
  brew install rbenv
else
  echo "rbenv is already installed."
fi

if ! grep -q 'rbenv init' ~/.zshrc 2>/dev/null; then
  echo 'eval "$(rbenv init - zsh)"' >> ~/.zshrc
fi

if [[ "$PATH" != *"$HOME/.rbenv/bin"* ]]; then
  export PATH="$HOME/.rbenv/bin:$PATH"
fi
eval "$(rbenv init - zsh)"
echo -e "${GREEN}rbenv is installed and initialized.${NC}"

# Specify Ruby version
RUBY_VERSION="3.2.9"
if ! rbenv versions | grep -q "$RUBY_VERSION"; then
  echo "Installing Ruby $RUBY_VERSION..."
  rbenv install $RUBY_VERSION
else
  echo "Ruby $RUBY_VERSION is already installed."
fi

echo "$RUBY_VERSION" > "$1/.ruby-version"
rbenv install -s "$RUBY_VERSION"
echo "Current Ruby version: $(ruby -v)"
echo -e "${GREEN}Ruby $RUBY_VERSION setup complete.${NC}"

echo "### 5. Install bundler"
if ! gem list bundler -i > /dev/null 2>&1; then
  gem install bundler
fi
echo -e "${GREEN}Bundler installation complete.${NC}"

echo "### 6. Set locale env variables for UTF-8"

LOCALE_SET=false

if grep -q '^export LC_ALL=en_US.UTF-8$' ~/.zshrc 2>/dev/null; then
  echo "LC_ALL already set in ~/.zshrc."
else
  echo 'export LC_ALL=en_US.UTF-8' >> ~/.zshrc
  LOCALE_SET=true
fi

if grep -q '^export LANG=en_US.UTF-8$' ~/.zshrc 2>/dev/null; then
  echo "LANG already set in ~/.zshrc."
else
  echo 'export LANG=en_US.UTF-8' >> ~/.zshrc
  LOCALE_SET=true
fi

if [ "$LOCALE_SET" = true ]; then
  echo "Locale environment variables added to ~/.zshrc."
else
  echo "Locale environment variables already configured in ~/.zshrc."
fi

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

echo -e "${GREEN}Locale environment variables are now ensured in ~/.zshrc.${NC}"
echo "Please run 'source ~/.zshrc' or restart your terminal to apply changes."

echo "### 7. Move to project directory and set bundler local path to vendor/bundle"
cd "$1"
echo "Current directory: $(pwd)"
bundle config set --local path 'vendor/bundle'
echo -e "${GREEN}Bundler local path set to vendor/bundle.${NC}"

echo "### 8. Check Gemfile and Gemfile.lock"
if [ -f Gemfile ] && [ -f Gemfile.lock ]; then
  echo "Gemfile and Gemfile.lock found."
else
  echo -e "${RED}Gemfile or Gemfile.lock not found!${NC}"
  exit 1
fi
echo -e "${GREEN}Gemfile check complete.${NC}"

echo "### 9. Run bundle install"
if bundle install; then
  echo -e "${GREEN}bundle install completed successfully.${NC}"
else
  echo -e "${RED}bundle install failed!${NC}"
  exit 1
fi

echo "### 10. Run fastlane match for certificate sync (read-only)"
if bundle exec fastlane match appstore --readonly; then
  echo -e "${GREEN}fastlane match (appstore) completed.${NC}"
else
  echo -e "${RED}fastlane match failed!${NC}"
  exit 1
fi

echo -e "${GREEN}Installation complete. Use 'bundle exec fastlane [lane]' to run fastlane.${NC}"
