# Define the GitHub repository URL
$repositoryUrl = "https://github.com/biorack/infrastructure_automation"

# Define the local directory where you want to clone or update the repository
$localDirectory = "C:\Path\To\Your\Local\Directory"

# Check if the local directory exists; if not, clone the repository
if (-not (Test-Path -Path $localDirectory -PathType Container)) {
    # Clone the repository
    git clone $repositoryUrl $localDirectory
} else {
    # Change to the local directory
    Set-Location -Path $localDirectory

    # Pull updates from the main branch
    git pull origin main
}