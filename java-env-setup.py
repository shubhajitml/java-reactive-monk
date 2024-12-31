import os
import platform
import subprocess

def install_java(java_version="17.0.2"):
    os_type = platform.system()
    
    if os_type == "Linux":
        if os.path.exists("/usr/bin/apt-get"):
            subprocess.run(["sudo", "apt-get", "update"])
            subprocess.run(["sudo", "apt-get", "install", "-y", f"openjdk-{java_version}-jdk"])
        elif os.path.exists("/usr/bin/yum"):
            subprocess.run(["sudo", "yum", "install", "-y", f"java-{java_version}-openjdk"])
        elif os.path.exists("/usr/bin/pacman"):
            subprocess.run(["sudo", "pacman", "-Syu"])
            subprocess.run(["sudo", "pacman", "-S", "--noconfirm", f"jdk{java_version}-openjdk"])
        else:
            print("Unsupported Linux distribution")
            return False

    elif os_type == "Darwin":
        if subprocess.run(["which", "brew"]).returncode == 0:
            subprocess.run(["brew", "update"])
            subprocess.run(["brew", "install", f"openjdk@{java_version}"])
        else:
            print("Homebrew is not installed. Please install Homebrew first.")
            return False

    elif os_type == "Windows":
        if subprocess.run(["choco", "--version"]).returncode == 0:
            subprocess.run(["choco", "install", "openjdk", f"--version={java_version}", "-y"])
        else:
            print("Chocolatey is not installed. Please install Chocolatey first.")
            return False

    else:
        print("Unsupported OS")
        return False

    return True

def install_maven(maven_version="3.8.4"):
    os_type = platform.system()
    
    if os_type == "Linux":
        if os.path.exists("/usr/bin/apt-get"):
            subprocess.run(["sudo", "apt-get", "install", "-y", f"maven={maven_version}"])
        elif os.path.exists("/usr/bin/yum"):
            subprocess.run(["sudo", "yum", "install", "-y", "maven"])
        elif os.path.exists("/usr/bin/pacman"):
            subprocess.run(["sudo", "pacman", "-S", "--noconfirm", "maven"])
        else:
            print("Unsupported Linux distribution")
            return False

    elif os_type == "Darwin":
        if subprocess.run(["which", "brew"]).returncode == 0:
            subprocess.run(["brew", "install", f"maven@{maven_version}"])
        else:
            print("Homebrew is not installed. Please install Homebrew first.")
            return False

    elif os_type == "Windows":
        if subprocess.run(["choco", "--version"]).returncode == 0:
            subprocess.run(["choco", "install", "maven", f"--version={maven_version}", "-y"])
        else:
            print("Chocolatey is not installed. Please install Chocolatey first.")
            return False

    else:
        print("Unsupported OS")
        return False

    return True

def set_java_env():
    java_home = subprocess.check_output(["dirname", subprocess.check_output(["dirname", subprocess.check_output(["readlink", "-f", subprocess.check_output(["which", "java"]).strip()]).strip()]).strip()]).strip()
    os.environ["JAVA_HOME"] = java_home
    os.environ["PATH"] = f"{java_home}/bin:{os.environ['PATH']}"

    shell_profile = os.path.expanduser("~/.bashrc")
    if os.path.exists(shell_profile):
        with open(shell_profile, "a") as file:
            file.write(f"\nexport JAVA_HOME={java_home}\nexport PATH=$JAVA_HOME/bin:$PATH\n")

    print("Java environment variables set.")

def main():
    java_version = input("Enter the Java version you want to install (default: 17.0.2): ") or "17.0.2"
    maven_version = input("Enter the Maven version you want to install (default: 3.8.4): ") or "3.8.4"
    
    if install_java(java_version):
        print("Java installed successfully.")
        set_java_env()
    else:
        print("Java installation failed.")

    if install_maven(maven_version):
        print("Maven installed successfully.")
    else:
        print("Maven installation failed.")

if __name__ == "__main__":
    main()
