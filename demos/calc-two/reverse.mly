/**************************************************************************/
/*                                                                        */
/*  Menhir                                                                */
/*                                                                        */
/*  Fran�ois Pottier and Yann R�gis-Gianas, INRIA Rocquencourt            */
/*                                                                        */
/*  Copyright 2005 Institut National de Recherche en Informatique et      */
/*  en Automatique. All rights reserved. This file is distributed         */
/*  under the terms of the Q Public License version 1.0, with the         */
/*  change described in file LICENSE.                                     */
/*                                                                        */
/**************************************************************************/

(* This partial grammar specification defines the syntax of
   expressions in reverse Polish notation. Parentheses are
   meaningless, and unary minus is not supported (some other symbol
   than MINUS would be required in order to avoid an ambiguity). *)

%start <int> main

%%

main:
| e = expr EOL
    { e }

expr:
| i = INT
    { i }
| e1 = expr e2 = expr PLUS
    { e1 + e2 }
| e1 = expr e2 = expr MINUS
    { e1 - e2 }
| e1 = expr e2 = expr TIMES
    { e1 * e2 }
| e1 = expr e2 = expr DIV
    { e1 / e2 }

