type t =
    { name : string
    ; update : (unit -> unit)
    ; mutable primary_color : Color.t option
    ; mutable secondary_color : Color.t option }

(* All animations available. *)
      
val all : t list
  