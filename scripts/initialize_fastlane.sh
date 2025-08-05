#!/bin/bash

set -e

# 1. Check if project path argument is provided
if [ -z "$1" ]; then
  echo "Usage: $0 /path/to/project"
  exit 1
fi

echo "### 2. Check Xcode Command Line Tools installation"
if ! xcode-select -p > /dev/null 2>&1; then
  echo "Installing Xcode Command Line Tools..."
  xcode-select --install
else
  echo "Xcode Command Line Tools are already installed."
fi

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

echo "### 4. Install rbenv and Ruby"
if ! command -v rbenv > /dev/null 2>&1; then
  echo "Installing rbenv..."
  brew install rbenv
else
  echo "rbenv is already installed."
fi

if ! grep -q 'rbenv init' ~/.zshrc 2>/dev/null; then
  echo 'eval "$(rbenv init -)"' >> ~/.zshrc
fi

export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# Specify Ruby version
RUBY_VERSION="3.2.9"
if ! rbenv versions | grep -q "$RUBY_VERSION"; then
  echo "Installing Ruby $RUBY_VERSION..."
  rbenv install $RUBY_VERSION
else
  echo "Ruby $RUBY_VERSION is already installed."
fi

rbenv global $RUBY_VERSION
echo "Current Ruby version: $(ruby -v)"

echo "### 5. Install bundler"
gem install bundler

echo "### 6. Set locale env variables for UTF-8 Korean support"
if ! grep -q 'LC_ALL=ko_KR.UTF-8' ~/.zshrc 2>/dev/null; then
  echo 'export LC_ALL=ko_KR.UTF-8' >> ~/.zshrc
  echo 'export LANG=ko_KR.UTF-8' >> ~/.zshrc
  echo "Locale environment variables added to ~/.zshrc. Please reload your terminal or run 'source ~/.zshrc'."
fi
export LC_ALL=ko_KR.UTF-8
export LANG=ko_KR.UTF-8

echo "### 7. Move to project directory"
cd "$1"
echo "Current directory: $(pwd)"

echo "### 8. Check Gemfile and Gemfile.lock"
if [ -f Gemfile ] && [ -f Gemfile.lock ]; then
  echo "Gemfile and Gemfile.lock found. Proceeding with bundle install."
else
  echo "Gemfile or Gemfile.lock not found! Make sure you cloned the repository correctly."
  exit 1
fi

echo "### 9. Run bundle install"
bundle install

echo "### 10. Run fastlane match for certificate sync (read-only)"
bundle exec fastlane match appstore --readonly
bundle exec fastlane match development --readonly

echo "Installation complete! Use 'bundle exec fastlane [lane]' to run fastlane."
