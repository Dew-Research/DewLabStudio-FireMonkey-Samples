<a href="https://www.dewresearch.com/products/mtxvec/mtxvec-for-delphi-c-builder">
<img align="right" src="https://www.dewresearch.com/templates/yootheme/cache/mtxvex-icon-ef5151c5.png">
</a>  

# Dew Lab Studio FMX for RAD Studio Delphi samples.
  
Sample programs showing how to use Dew Lab Studio FMX for (RAD Studio Delphi)

Dew Lab Studio contains four products. For each product there is a separate "main" demo project, which contains multiple examples. The VCL samples are in a separate repository. 

You'll need Dew Lab Studio for Delphi FMX evaluation or registered version to run the examples on this repository. Fully functional evaluation version can be obtained at https://www.dewresearch.com/downloads-site/delphi-cbuilder-download

Support for Firemonkey is implemented for all supported platforms:

* Linux 64bit
* iOS 64bit
* MacOS 64bit (10 and 11)
* Android 64bit
* Win32 and Win64

To build for Mac OS it is neccessary to add the following frameworks to the SDK Manager 
in the Rad Studio IDE:

* Accelerate
* CoreAudio
* AudioToolbox
* AudioUnit

To build for iOS, the following is needed additionaly to what the SDK Manager includes by default:

* Accelerate
* CoreAudio
* AudioToolbox

Depending on the SDK version, some of the frameworks may not be available. If a framework is missing, the name
of the framework will be listed in the error reported by the Linker and needs to be added to the SDK Manager before
the next compile.


