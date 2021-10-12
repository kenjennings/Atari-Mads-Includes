# Atari-Mads-Includes
A collection of assembly language include files for use with the MADs assembler.  The include files cover Atari DOS, OS, custom chips, etc.

I'm sure someone else has done a better version of includes.  These are the OS values and macros I need for the programs I have written.

Primarily, this is the standard custom chips, OS shadow values, CIO, and common interfaces/vectors in the OS.  

There are some memory management and bitmap macros for creating tables of shifted byte values at Assembly time.   

Macros are entirely optional as they become a source of frustration.  (Math macros are work in progress.)  Still trying to figure out if square brackets should be around the arguments when the macro is used, or if they are supposed to be in the macro.  Small disagrements between these results in yards of obtuse failures and debugging.   Skip including macros, and/or remove them from the ANTIC file if so desired.

There is not so much here for lower level Serial I/O and device-specific functionality.
