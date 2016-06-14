In this Lab we will look at how to install the OpenShift CLI tools.

**Installing the Command-line Tools**

After completing this section, you should be able to:

- Locate the binaries for the OpenShift Enterprise command-line interface
(OSE CLI)
- Install the OSE CLI tools.
- CLI basic configuration

**Locating the binaries**

The OSE CLI exposes commands for managing applications, as well as lower-level 
tools to interact with each component of a system. The binaries for Mac, Windows,
and Linux are available for download from the Red Hat Customer Portal via the
following link:

Portal https://access.redhat.com/downloads/content/290

**Installing the CLI tools**

The CLI is provided as compressed files that can be decompressed to any
directory. In order to make it simple for any user to access the OSE CLI, it is
recommended that it is made available in a directory mapped to the environment
variable called PATH from the OS.

- OSX and Linux:

Copy the binary to the /usr/local/bin directory.

- Windows:

a) Use oc.exe to open an OpenShift shell.
If you getting error from running oc, go to git-scm.com to download git bash for Windows (during installation you need to specify in the selection to integrate with the command prompt)

b) Download and install Notepad++ and install the JSON plugin or use
   http://jsonlint.com/ to edit and validate JSON.

  http://ammonsonline.com/formatted-json-in-notepad/

c) Configure your default editor to be Notepad++


**CLI basic configuration**

The easiest way to initially setup the OpenShift CLI is to use the "oc login"
command. It'll interactively ask you a server URL, username and password. The
information is automatically saved in a CLI configuration file that is then used
for subsequent commands.

To login to a remote server use:

```
oc login <hostname>:<port>
```