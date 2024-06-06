# Love2D Project Builder
This is a simple powershell script to build a Love2D project. 

## Usage
To use the builder, run the script. The script will prompt for the path main project folder, and a name for the build.
The script will then:
- Create a Builds folder in the project parent folder
- Create a folder for the build in the Builds folder
- Zip the project files into a .love file
- Merge the .love file with the Love2D executable file
- Copy the dlls from the Love2D install folder into to the build folder

The script will also prompt for if you want to create a zip file for the build. This will create a zip file with all files in the build folder.

Since the script is unsigned, you will need to set the execution policy before running it:
```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```

## Example
Here I use the script to build my [Perlin Noise Visualizer](https://github.com/FiniteUI/Lua-Perlin-Noise) project:

![image](https://github.com/FiniteUI/Love2D-Project-Builder/assets/33558498/f6ad5baf-0b9e-4a4d-aaf9-be03444d5630)

And here is the resulting folder:

![image](https://github.com/FiniteUI/Love2D-Project-Builder/assets/33558498/7f9fc804-e088-439c-bad5-3c708755ce56)
