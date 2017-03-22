(** The interface to the Pixel Pusher subsystem.

  Pixel Pushers are devices that sit on IP networks that can be sent
  commands over UDP to control LEDs and other kinds of lighting hardware.

  Each Pixel Pusher can have up to eight LED "strips" connected, and each strip
  can have up to N pixels.

  This module listens for Pixel Pushers to announce themselves, remembers
  them, and provides an interface for telling a pixel on a strip
  to turn to a color.

  Threads: while the module does not explicitly use threads, it does require the
  (jane) Async scheduler to be alive and active to handle background tasks, such
  as listening for beacons and staggering packets sent to pushers.  The module hides
  (jane) Async and will starve if your application doesn't frequently yield time
  (e.g. by calling UNIX sleep until the next display tick).
*)

open Core.Std
open Async.Std

module Controller_report : sig
  type t =
      { controller_id : int
      ; group_id : int
      ; update_period : Time.Span.t
      ; last_beacon : Time.t }
end

module Strip : sig
  type t =
      { strip_number: int
      ; strip_length : int
      ; controller_id : int
      ; group_id : int
      ; matrix : Color.t Array.t }
  val set_pixel : t -> color:Color.t -> index:int -> unit
end

type send_updates_t

(* Begins watching for Pixel Pusher presence UDP broadcasts.  *)
val start : unit -> send_updates_t Deferred.t

(* List of all seen controllers. *)
val get_controllers : unit -> Controller_report.t list

(* Returns all strips seen by the subsystem. *)
val get_strips : unit -> Strip.t list

(* Like get_strips, but strips are indexed by (controller_id, strip_id) *)
val get_strips_as_map : unit -> (int * int, Strip.t) Map.Poly.t
  
(* Instructs subsystem to release any pending updates.
   Do this every time you've finished creating your "frame". 
   You can only call this from async. *) 
val send_updates : send_updates_t -> unit

(* Same as above, but for calling from inside of an In_thread (such as the glut display func) *)
val send_updates_from_non_async_thread : send_updates_t -> unit
