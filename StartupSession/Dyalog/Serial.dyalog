 old←Serial new
 ⍝ This sets/queries the current serial number on all platforms
 ⍝       Serial ⍬ returns current serial number
 ⍝       Serial 123456 sets serial number to 123456
 ⍝       Serial 'unregistered' removes the current serial number
 ⍝ Contact sales@dyalog.com to obtain a serial number

 ;⎕ML ⍝ sysvars
 ;Env;Set;Norm;Signal ⍝ fns
 ;nixdir;nixfile;file;pat;msg;dir;envvar;regkey ⍝ vars

 ⎕ML←1

 regkey←envvar←'DYALOG_SERIAL' ⍝ envvar/registry key
 nixfile←'serial'              ⍝ *nix default file name
 nixdir←'/.dyalog'             ⍝ *nix default location under $HOME

 msg←'unregistered'        ⍝ what to use to indicate unregistered
 pat←'^\d{1,6}$|^',msg,'$' ⍝ what constitutes a valid serial number

 Norm←⊃pat ⎕S'\l0'⍠1 ⍝ anycase → lowercase
 Env←2 ⎕NQ #'GetEnvironment',⊂

 old←Norm(Env envvar)msg ⍝ default to msg

 :If ×≢new ⍝ has content: set
     new←Norm' '~⍨⍕new ⍝ allow separated digits too
     ⎕SIGNAL(' '≡new)/⊂('EN' 11)('Message'('Serial number must be 6 digits or ''',msg,''''))
     new←(-6⌈≢new)↑new,⍨5⍴'0'  ⍝ pad left with 0s

     Signal←⎕SIGNAL{('EN'(10×⎕EN))('EM'(⎕EM ⎕EN))('Message'⍵)}

     :If 'Win'≡3↑⊃# ⎕WG'APLVersion' ⍝ Windows
         Set←{⎕USING←'Microsoft' ⋄ Win32.Registry.SetValue(⊃4070⌶⍬)⍺ ⍵} ⍝ ask APL where it gets its registry values from
         :Trap 0
             regkey Set new
         :Else
             Signal'Could not write to registry using .NET'
         :EndTrap

     :Else ⍝ *nix
         file←Env'DYALOG_SERIALFILE'
         :If ×≢file
             dir←⊃⎕NPARTS file
         :Else
             dir←nixdir,⍨Env'HOME'
             file←dir,'/',nixfile
         :EndIf
         :Trap 0
             3 ⎕MKDIR dir
             file 1 ⎕NPUT⍨⊂new
         :Else
             Signal'Could not write serial number file "',file,'"'
         :EndTrap

     :EndIf
     old,←'; is now ' '; is still '⊃⍨1+old≡new
     old,←new
     old,⍨←'Was '
 :Else ⍝ Just report
     old,⍨←'Is '
 :EndIf