hippotech
=========

## Cygwin enhancements

### Cygwin.bat

#### Limitations / Requirements

 - User must be sure to fix line endings to \r\n (DOS)
 - File must be located in the root dir (same dir relative to the Cygwin
   /bin directory as the location that the default distributed Cygwin.bat
   is located)

#### Enhanced features

 - Allows Cygwin to be located in any directory (portable)
 - Requires no manual editing of start-shortcut properties (START-IN)
 - Sets up HOME env parameter
 - Prepends correct Window-mode PATH element for Cygwin /bin/ to PATH
   parameter so that no failures to locate Cygwin binaries can take
   place on startup.
 - Uses a sensible default for size of console if MinTTY is not found

#### Status

It is a work in progress.


