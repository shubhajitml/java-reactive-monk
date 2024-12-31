# Function to install Java using Chocolatey
function Install-Java {
    param (
        [string]$javaVersion = "17.0.2"
    )

    # Check if Chocolatey is installed
    if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
        Write-Output "Chocolatey is not installed. Installing Chocolatey..."
        Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    }

    # Install the specified version of OpenJDK using Chocolatey
    Write-Output "Installing OpenJDK $javaVersion..."
    choco install openjdk --version=$javaVersion -y

    # Set JAVA_HOME and update PATH
    $javaHome = "C:\Program Files\OpenJDK\openjdk-$javaVersion"
    [System.Environment]::SetEnvironmentVariable("JAVA_HOME", $javaHome, [System.EnvironmentVariableTarget]::Machine)
    $env:JAVA_HOME = $javaHome
    $path = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine)
    if ($path -notlike "*$javaHome\bin*") {
        $newPath = "$javaHome\bin;$path"
        [System.Environment]::SetEnvironmentVariable("Path", $newPath, [System.EnvironmentVariableTarget]::Machine)
        $env:Path = $newPath
    }

    # Verify installation
    Write-Output "Java installation complete."
    java -version
}

# Function to install Maven using Chocolatey
function Install-Maven {
    param (
        [string]$mavenVersion = "3.8.4"
    )

    # Install Maven using Chocolatey
    Write-Output "Installing Maven $mavenVersion..."
    choco install maven --version=$mavenVersion -y

    # Verify installation
    Write-Output "Maven installation complete."
    mvn -version
}

# Prompt the user for the Java and Maven versions
$javaVersion = Read-Host "Enter the Java version you want to install (default: 17.0.2)" -Default "17.0.2"
$mavenVersion = Read-Host "Enter the Maven version you want to install (default: 3.8.4)" -Default "3.8.4"

Install-Java -javaVersion $javaVersion
Install-Maven -mavenVersion $mavenVersion
