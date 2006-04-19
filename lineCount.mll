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

(* This simple function counts the number of newline characters
   in a string. *)

let newline = ('\010' | '\013' | "\013\010")

rule count n = parse
| newline
    { count (n + 1) lexbuf }
| eof
    { n }
| _
    { count n lexbuf }

