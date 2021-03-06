(* Eliom-base-app
 * http://www.ocsigen.org/eliom-base-app
 *
 * Copyright (C) 2014
 *      Vincent Balat
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, with linking exception;
 * either version 2.1 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 *)

(** Wait spinner image. *)

[%%shared.start]
module D : sig

  (** Display spinner with DOM semantics *)
  val spinner :
    ?a:Html_types.i_attrib Eliom_content.Html.attrib list ->
    unit -> [> Html_types.i ] Eliom_content.Html.D.elt

end

module F : sig

  (** Display spinner with functional semantics *)
  val spinner :
    ?a:Html_types.i_attrib Eliom_content.Html.attrib list ->
    unit -> [> Html_types.i ] Eliom_content.Html.F.elt

end

(** On client side, [with_spinner th] returns immediately a spinner
    while Lwt thread [th] is not finished, that will automatically
    be replaced by the result of [th] when finished.
    It has class "spinning" while the spinner is present.

    On server side, it will wait for [th] to be finished before returning
    its result (and never display a spinner).
*)
val with_spinner :
  ?a:[< Html_types.div_attrib > `Class ] Eliom_content.Html.F.attrib list ->
  ?fail:(exn -> [< Html_types.div_content_fun > `Em `I ]
           Eliom_content.Html.F.elt list Lwt.t) ->
  [< Html_types.div_content_fun ] Eliom_content.Html.F.elt list Lwt.t ->
  [> Html_types.div ] Eliom_content.Html.F.elt Lwt.t
