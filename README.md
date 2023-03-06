# qSE

This repository contains things that initialise `⎕SE` and end up there, as a sort of boot-strapping.

Note that `⎕SE` is currently populated as follows:

- The interpreter loads a session .dse file which is created by the buildse.dws workspace and contains (on Windows) mostly GUI objects.
- The interpreter automatically loads and executes StartupSession.aplf which in turn:
  - Loads Link
  - Uses that to load things from various StartupSession folders
  - Boots SALT
    - Loads and executes setup.dyalog if it exists
    - Loads and executes a .dyapp file if specified
  - Calls any `Run` functions in the Link-loaded directories
