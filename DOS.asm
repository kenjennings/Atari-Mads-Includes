;=================================================
; DOS memory and vectors
; For Mads assembler
; Ken Jennings
;=================================================
; Misc values related to DOS and file loading
;
LOMEM_DOS =     $2000 ; First memory after DOS
LOMEM_DOS_DUP = $3308 ; First memory after DOS and DUP 
;
; Atari RUN ADDRESS.  
; The binary load file has a segmented structure 
; specifying starting address, and ending address, 
; followed by the bytes to load in that memory range.  
; DOS observes two special addresses when loading data.
; If the contents of the INIT address changes ater loading
; a segment DOS calls that address immediately. If the routine
; returns to DOS cleanly then file loading continues.
; If the contents of the RUN address changes DOS waits until
; all segments from the file are loaded and then calls the RUN
; address target.
;
DOS_RUN_ADDR =  $02e0 ; Execute here when file loading completes.
DOS_INIT_ADDR = $02e2 ; Execute here immediately then resume loading.

