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

{shared{
open Eliom_content
}}

(** Wait spinner image. *)
{shared{
module D = struct
   let spinner = Ow_icons.D.spinner
end
module F = struct
   let spinner = Ow_icons.F.spinner
end

let default_fail a e =
  let c = if %(Ocsigen_config.get_debugmode ())
    then Html5.F.em [Html5.F.pcdata (Printexc.to_string e)]
    else Ow_icons.F.question ()
  in
  Lwt.return (Html5.D.div ?a [c])

 }}

{server{

let with_spinner ?a ?(fail=default_fail a) thread =
  lwt v = try_lwt
      lwt v = thread in
      Lwt.return
        (v :> [ Html5_types.div_content_fun ] Html5.F.elt list)
    with e ->
      lwt v = fail e in
      Lwt.return
        [(v :> [ Html5_types.div_content_fun ] Html5.F.elt)]
  in
  Lwt.return (Html5.D.div ?a v)

}}

{client{

let with_spinner ?a ?(fail=default_fail a) thread =
  match Lwt.state thread with
  | Lwt.Return v -> Lwt.return (Html5.D.div ?a v)
  | Lwt.Sleep ->
    let d = Html5.D.div ?a [Ow_icons.F.spinner ()] in
    Lwt.async
      (fun () ->
         lwt v = try_lwt
             lwt v = thread in
             Lwt.return
               (v :> [ Html5_types.div_content_fun ] Html5.F.elt list)
           with e ->
             lwt v = fail e in
             Lwt.return
               [(v :> [ Html5_types.div_content_fun ] Html5.F.elt)]
         in
         Eliom_content.Html5.Manip.replaceChildren d v ;
         Lwt.return ()) ;
    Lwt.return d
  | Lwt.Fail e -> lwt c = fail e in Lwt.return (Html5.D.div ?a [c])

}}
