# winget-toolbox

Streamline your setup:

This project is a work-in-progress PowerShell helper script designed to simplify your experience with the Winget package manager. It streamlines the setup process, allows you to effortlessly install your favorite applications, and enables auto-updates to keep everything fresh and up to date. Get ready to enhance your productivity with minimal hassle!

## Usage

1. Clone the repo
   ```sh
   git clone https://github.com/simon-baumgaertel/winget-toolbox.git
   ```

2. Use the default package list `winget_package.json` or provide your own in a json file like this:
   ```json
    [
        {
            "Name":  "Software name",
            "Id":  "Publisher.Software",
            "Category": "Category"
        }
    }
   ```

3. Run the script in PowerShell (depending on your version used)
    * PowerShell 7+: `./Setup-WinGet.ps1`
    * PowerShell <= 5: `powershell -ExecutionPolicy Bypass -File .\Setup-WinGet.ps1` 



## License 

Distributed under the MIT License. See LICENSE.txt for more information.