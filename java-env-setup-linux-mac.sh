#!/bin/bash

# Function to install Java on Linux
install_java_linux() {
    local java_version=$1
    if [ -x "$(command -v apt-get)" ]; then
        sudo apt-get update
        sudo apt-get install -y openjdk-${java_version}-jdk
    elif [ -x "$(command -v yum)" ]; then
        sudo yum install -y java-${java_version}-openjdk
    elif [ -x "$(command -v pacman)" ]; then
        sudo pacman -Syu
        sudo pacman -S --noconfirm jdk${java_version}-openjdk
    else
        echo "Unsupported Linux distribution"
        exit 1
    fi
}

# Function to install Maven on Linux
install_maven_linux() {
    local maven_version=$1
    if [ -x "$(command -v apt-get)" ]; then
        sudo apt-get install -y maven=$maven_version
    elif [ -x "$(command -v yum)" ]; then
        sudo yum install -y maven
    elif [ -x "$(command -v pacman)" ]; then
        sudo pacman -S --noconfirm maven
    else
        echo "Unsupported Linux distribution"
        exit 1
    fi
}

# Function to install Java on macOS
install_java_macos() {
    local java_version=$1
    if [ -x "$(command -v brew)" ]; then
        brew update
        brew install openjdk@$java_version
    else
        echo "Homebrew is not installed. Please install Homebrew first."
        exit 1
    fi
}

# Function to install Maven on macOS
install_maven_macos() {
    local maven_version=$1
    if [ -x "$(command -v brew)" ]; then
        brew install maven@$maven_version
    else
        echo "Homebrew is not installed. Please install Homebrew first."
        exit 1
    fi
}

# Detect the operating system and install Java and Maven
case "$(uname -s)" in
    Linux*)     os_type="Linux";;
    Darwin*)    os_type="macOS";;
    *)          echo "Unsupported OS"; exit 1 ;;
esac

# Prompt the user for the Java and Maven versions
read -p "Enter the Java version you want to install (default: 17): " java_version
java_version=${java_version:-17}
read -p "Enter the Maven version you want to install (default: 3.8.4): " maven_version
maven_version=${maven_version:-3.8.4}

# Install Java and Maven based on the OS
if [ "$os_type" == "Linux" ]; then
    install_java_linux $java_version
    install_maven_linux $maven_version
elif [ "$os_type" == "macOS" ]; then
    install_java_macos $java_version
    install_maven_macos $maven_version
fi

# Set JAVA_HOME and update PATH
set_java_env() {
    JAVA_HOME=$(dirname $(dirname $(readlink -f $(which java))))
    export JAVA_HOME
    export PATH=$JAVA_HOME/bin:$PATH

    # Add JAVA_HOME and PATH to shell profile
    if [ -f ~/.bashrc ]; then
        echo "export JAVA_HOME=$JAVA_HOME" >> ~/.bashrc
        echo "export PATH=\$JAVA_HOME/bin:\$PATH" >> ~/.bashrc
    elif [ -f ~/.zshrc ]; then
        echo "export JAVA_HOME=$JAVA_HOME" >> ~/.zshrc
        echo "export PATH=\$JAVA_HOME/bin:\$PATH" >> ~/.zshrc
    elif [ -f ~/.profile ]; then
        echo "export JAVA_HOME=$JAVA_HOME" >> ~/.profile
        echo "export PATH=\$JAVA_HOME/bin:\$PATH" >> ~/.profile
    fi
}

# Set the environment variables
set_java_env

echo "Java and Maven installation and environment setup complete."
