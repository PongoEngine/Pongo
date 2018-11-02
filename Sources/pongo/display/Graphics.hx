package pongo.display;

typedef Graphics = #if graphics1 pongo.display.graphics1.Graphics1 #else pongo.display.graphics1.Graphics2; #end