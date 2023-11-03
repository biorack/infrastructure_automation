# Define the GitHub repository URL
$repositoryUrl = "https://github.com/biorack/infrastructure_automation"

# Define the local directory where you want to clone the repository
$localDirectory = "C:\Scripts\"

# Location of local repository
$localRepository = Join-Path -Path $LocalDirectory -ChildPath "infrastructure_automation"

# Check if the local repository exists; if not, clone the repository into directory
if (-not (Test-Path -Path $localRepository -PathType Container)) {

    # Change to the local directory
    Set-Location -Path $localDirectory
	
    # Clone the repository
    git clone $repositoryUrl

} else {

    # Change to the local repository
    Set-Location -Path $localRepository

    # Pull updates from the main branch
    git pull origin main
}