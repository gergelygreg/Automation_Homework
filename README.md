Installation Instruction
  Only Python 3.7 or newer is supported.

   1. Install node.js e.g. from https://nodejs.org/en/download/
   2. Update pip pip install -U pip to ensure latest version is used
   3. Install robotframework-browser from the commandline: pip install robotframework-browser
   4. Install the node dependencies: run rfbrowser init in your shell
   * if rfbrowser is not found, try python -m Browser.entry init
  Please note that by default Chromium, Firefox and WebKit browser are installed,
  even those would be already installed in the system. The installation size depends
  on the operating system, but usually is +700Mb. It is possible to skip browser binaries
  installation with rfbrowser init --skip-browsers command, but then user is responsible
  for browser binary installation.

Update Instructions
  To upgrade your already installed robotframework-browser library

   1. Update from commandline: pip install -U robotframework-browser
   2. Clean old node side dependencies and browser binaries: rfbrowser clean-node
   3. Install the node dependencies for the newly installed version: rfbrowser init

Uninstall instructions
  To completely install library, including the browser binaries installed by Playwright, run following commands:

   1. Clean old node side dependencies and browser binaries: rfbrowser clean-node
   2. Uninstall with pip: pip uninstall robotframework-browser
   
   
*********************************************************************************


Installing requirements. 
Run it on your Command Line Interface: pip install -r requirements.txt


*********************************************************************************


The test suite must be able to run at least Chrome and Firefox (the browser
must be switchable through the command line)

Use Terminal in your IDE

Chrome: robot -d Results -v BROWSER: chromium  Tests/AutomationHomework.robot

Firefox: robot -d Results -v BROWSER: firefox  Tests/AutomationHomework.robot


*********************************************************************************

Running Test cases individually using Tags:
Use Terminal in your IDE
robot -d Results -i "Registration" Tests/AutomationHomework.robot
robot -d Results -i "Search" Tests/AutomationHomework.robot
robot -d Results -i "Add to cart" Tests/AutomationHomework.robot
robot -d Results -i "Delete from cart" Tests/AutomationHomework.robot
robot -d Results -i "Purchase" Tests/AutomationHomework.robot
robot -d Results -i "Order reference" Tests/AutomationHomework.robot
