type t = { r: int; g: int; b: int }
let black = { r=0; g=0; b=0 }
let white = { r=255; g=255; b=255 }
let ri () = Random.int 256
let rand () = { r=ri (); g=ri (); b=ri () }