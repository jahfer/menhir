(**************************************************************************)
(*                                                                        *)
(*  Menhir                                                                *)
(*                                                                        *)
(*  Fran�ois Pottier, INRIA Rocquencourt                                  *)
(*  Yann R�gis-Gianas, PPS, Universit� Paris Diderot                      *)
(*                                                                        *)
(*  Copyright 2005-2008 Institut National de Recherche en Informatique    *)
(*  et en Automatique. All rights reserved. This file is distributed      *)
(*  under the terms of the Q Public License version 1.0, with the change  *)
(*  described in file LICENSE.                                            *)
(*                                                                        *)
(**************************************************************************)

open Ocamlbuild_plugin
open Command

(* ---------------------------------------------------------------------------- *)

(* Compilation flags. *)

let flags () =
  (* -inline 1000 *)
  flag ["ocaml"; "compile"; "native"] (S [A "-inline"; A "1000"])

(* ---------------------------------------------------------------------------- *)

(* A command for copying a file. *)

let copy_file_from_tag src dst env build =
  Cmd (S [A "cp"; T (tags_of_pathname src); P dst])

(* ---------------------------------------------------------------------------- *)

(* Dealing with the two parsers. *)

(* Just for fun, Menhir comes with two parsers for its own input files. One is
   called [yacc-parser.mly] and is built using [ocamlyacc]. The other is called
   [fancy-parser.mly] and is built using Menhir. It depends on [standard.mly].
   The choice between the two parsers is determined by the presence of the tag
   [yacc_parser] or [fancy_parser]. *)

let parser_rule () =
  (* The three dependencies. *)  
  flag_and_dep ["origin_parser"; "yacc_parser"]  (P "yacc-parser.mly");
  flag_and_dep ["origin_parser"; "fancy_parser"] (P "fancy-parser.mly");
  dep ["origin_parser"; "fancy_parser"] ["standard.mly"];
  (* The two rules. *)
  rule  "yacc-parser -> parser" ~prod:"parser.mly" (copy_file_from_tag  "yacc-parser.mly" "parser.mly");
  rule "fancy-parser -> parser" ~prod:"parser.mly" (copy_file_from_tag "fancy-parser.mly" "parser.mly")

(* ---------------------------------------------------------------------------- *)

(* Define custom compilation rules. *)

let () =
  dispatch (function After_rules ->
    (* Add our rules after the standard ones. *)
    parser_rule();
    flags();
  | _ -> ()
  )
