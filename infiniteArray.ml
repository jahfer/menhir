(**************************************************************************)
(*                                                                        *)
(*  Menhir                                                                *)
(*                                                                        *)
(*  Fran�ois Pottier and Yann R�gis-Gianas, INRIA Rocquencourt            *)
(*                                                                        *)
(*  Copyright 2005 Institut National de Recherche en Informatique et      *)
(*  en Automatique. All rights reserved. This file is distributed         *)
(*  under the terms of the Q Public License version 1.0, with the         *)
(*  change described in file LICENSE.                                     *)
(*                                                                        *)
(**************************************************************************)

(* $Id: infiniteArray.ml,v 1.5 2005/12/01 16:20:06 regisgia Exp $ *)

(** This module implements infinite arrays, that is, arrays that grow
    transparently upon demand. *)

type 'a t = {
    default: 'a;
    mutable table: 'a array
  } 

let default_size =
  16384 (* must be non-zero *)

let make x = {
  default = x;
  table = Array.make default_size x
} 

let rec new_length length i =
  if i < length then
    length
  else
    new_length (2 * length) i

let ensure a i =
  let table = a.table in
  let length = Array.length table in
  if i >= length then begin
    let table' = Array.make (new_length (2 * length) i) a.default in
    Array.blit table 0 table' 0 length;
    a.table <- table'
  end

let get a i =
  ensure a i;
  a.table.(i)

let set a i x =
  ensure a i;
  a.table.(i) <- x

let iteri f a =
  Array.iteri f a.table
