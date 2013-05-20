setMode -bs
setCable -port svf -file ktlink.svf
addDevice -p 1 -file ise/toplevel.jed
program -e -v -p 1
closeCable
quit
