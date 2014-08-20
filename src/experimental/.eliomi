(* OJWidgets
   https://github.com/ocsigen/ojwidgets.git
   Copyright (C) 2013 Arnaud Parant
   Laboratoire PPS - CNRS Université Paris Diderot
  
   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU Lesser General Public License as published by
   the Free Software Foundation, with linking exception;
   either version 2.1 of the License, or (at your option) any later version.
  
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
   GNU Lesser General Public License for more details.
  
   You should have received a copy of the GNU Lesser General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 *)

(** First is moves event
    Second is end event
    Third is move_func call at each move event
    Fourth is end event call at end event

    Theses events are catch on document *)
val slide_without_start :
  (Dom_html.document Js.t ->
   ('a -> 'b Lwt.t -> 'b Lwt.t) -> 'b Lwt.t) ->
  (Dom_html.document Js.t -> 'c Lwt.t) ->
  ('a -> 'b Lwt.t -> 'b Lwt.t) ->
  ('c -> 'b Lwt.t) ->
  'b Lwt.t

(** First is start event
    Second is function which take move_func and end_func
    (partial slide_without_start)
    Third is html element where catch start event
    Fourth is start_func call at start event
    Fifth is move_func call at each move event
    Sixth is end_func call at end event *)
val slide_event :
  ((#Dom_html.eventTarget Js.t as 'a) -> 'b Lwt.t) ->
  (('c -> 'd Lwt.t -> 'd Lwt.t) -> ('e -> 'd Lwt.t) -> 'd Lwt.t) ->
  (#Dom_html.eventTarget Js.t as 'a) ->
  ('b -> 'd Lwt.t) ->
  ('c -> 'd Lwt.t -> 'd Lwt.t) ->
  ('e -> 'd Lwt.t) ->
  'd Lwt.t

(** Same as slide_event but catch all start event instead of only one *)
val slide_events :
  ((#Dom_html.eventTarget as 'a) Js.t ->
   ('b -> 'c Lwt.t -> 'c Lwt.t) -> 'c Lwt.t) ->
  (('d -> 'c Lwt.t -> 'c Lwt.t) -> ('e -> 'c Lwt.t) -> 'c Lwt.t) ->
  (#Dom_html.eventTarget as 'a) Js.t ->
  ('b -> 'c Lwt.t -> 'c Lwt.t) ->
  ('d -> 'c Lwt.t -> 'c Lwt.t) ->
  ('e -> 'c Lwt.t) ->
  'c Lwt.t

(** First is html element where catch start event
    Second is start_func call at start event
    Third is move_func call at each move event
    Fourth is end event call at end event *)
val mouseslide :
  #Dom_html.eventTarget Js.t ->
  (Dom_html.mouseEvent Js.t -> unit Lwt.t) ->
  (Dom_html.mouseEvent Js.t -> unit Lwt.t -> unit Lwt.t) ->
  (Dom_html.mouseEvent Js.t -> unit Lwt.t) ->
  unit Lwt.t

(** Same as mouseslide but catch all start event instead of only one *)
val mouseslides :
  #Dom_html.eventTarget Js.t ->
  (Dom_html.mouseEvent Js.t -> unit Lwt.t -> unit Lwt.t) ->
  (Dom_html.mouseEvent Js.t -> unit Lwt.t -> unit Lwt.t) ->
  (Dom_html.mouseEvent Js.t -> unit Lwt.t) ->
  unit Lwt.t

(** Same as mouseslide but with touchevent *)
val touchslide :
  #Dom_html.eventTarget Js.t ->
  (Dom_html.touchEvent Js.t -> unit Lwt.t) ->
  (Dom_html.touchEvent Js.t -> unit Lwt.t -> unit Lwt.t) ->
  (Dom_html.touchEvent Js.t -> unit Lwt.t) ->
  unit Lwt.t

(** Same as mouseslides but with touchevent *)
val touchslides :
  #Dom_html.eventTarget Js.t ->
  (Dom_html.touchEvent Js.t -> unit Lwt.t -> unit Lwt.t) ->
  (Dom_html.touchEvent Js.t -> unit Lwt.t -> unit Lwt.t) ->
  (Dom_html.touchEvent Js.t -> unit Lwt.t) ->
  unit Lwt.t

type slide_event =
    Touch_event of Dom_html.touchEvent Js.t
  | Mouse_event of Dom_html.mouseEvent Js.t

(** Based on get_mouse_ev_coord and get_touch_ev_coord

    First arg is the way to get touch with JS API
    Second arg is the id for touch event

    It get client positions *)
val get_slide_coord :
  ?t_type:Ojw_event_tools.touch_type ->
  int ->
  ?p_type:Ojw_event_tools.position_type ->
  slide_event ->
  int * int

(** Based on get_local_mouse_ev_coord and get_local_touch_ev_coord

    First arg is the way to get touch with JS API
    Second arg is the target
    Third arg is the id for touch event

    It get client positions *)
val get_local_slide_coord :
  #Dom_html.element Js.t ->
  ?t_type:Ojw_event_tools.touch_type ->
  int ->
  ?p_type:Ojw_event_tools.position_type ->
  slide_event ->
  int * int

(** Same as mouseslide or touchslide but handle the both *)
val touch_or_mouse_slide:
  #Dom_html.eventTarget Js.t ->
  (slide_event -> unit Lwt.t) ->
  (slide_event -> unit Lwt.t -> unit Lwt.t) ->
  (slide_event -> unit Lwt.t) ->
  unit Lwt.t

(** Same as touch_or_mouse_slide
    but catch all event instead of only the first *)
val touch_or_mouse_slides:
  #Dom_html.eventTarget Js.t ->
  (slide_event -> unit Lwt.t -> unit Lwt.t) ->
  (slide_event -> unit Lwt.t -> unit Lwt.t) ->
  (slide_event -> unit Lwt.t) ->
  unit Lwt.t
