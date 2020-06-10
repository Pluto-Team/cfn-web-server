# perform linting of the yaml files
# Install-Module -Name AWS.Tools.S3 -Verbose
Import-Module -Name AWS.Tools.S3
$branch = $args[ 0 ]

try {
    Write-Host "######## CHECKING FOR ERRORS IN YAML FILES ########"
    $listOfYamlFilesToLint = (Get-ChildItem -Filter "*.yaml").Name

    $listOfYamlFilesToLint | ForEach-Object {
        $fileName = $_
        Write-Host "Checking file --> " $fileName

        cfn-lint -t $fileName > output.txt
        
        Write-Host "##### CONTENTS AFTER LINTING #####"
        Get-Content output.txt | ForEach-Object {

            if( $_ -match "E\d\d\d\d" ) {
                Write-Host "ERROR FOUND! Line content is " $_
                throw "Linter found an error in " + $fileName
            }
            else {
                Write-Host "ERROR NOT FOUND! Line content is " $_

            }
        } # end of Get-Content output.txt | ForEach-Object
        Write-Host "##### NO ERRORS HAVE BEEN DETECTED IN YAML FILE. PUSHING FILESTO S3 BUCKET #####"
        aws s3 cp $fileName s3://server-standup-files-pluto-app/web-server/$branch/
    }
    rm -f output.txt
}
catch {
    Write-Host "Error found!"
}