(***********************************************************************
*                                                                      *
*              This software is part of the infer package              *
*              Copyright (c) 2007 AT&T Knowledge Ventures              *
*                      and is licensed under the                       *
*                        Common Public License                         *
*                      by AT&T Knowledge Ventures                      *
*                                                                      *
*                A copy of the License is available at                 *
*                    www.padsproj.org/License.html                     *
*                                                                      *
*  This program contains certain software code or other information    *
*  ("AT&T Software") proprietary to AT&T Corp. ("AT&T").  The AT&T     *
*  Software is provided to you "AS IS". YOU ASSUME TOTAL RESPONSIBILITY*
*  AND RISK FOR USE OF THE AT&T SOFTWARE. AT&T DOES NOT MAKE, AND      *
*  EXPRESSLY DISCLAIMS, ANY EXPRESS OR IMPLIED WARRANTIES OF ANY KIND  *
*  WHATSOEVER, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF*
*  MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, WARRANTIES OF  *
*  TITLE OR NON-INFRINGEMENT.  (c) AT&T Corp.  All rights              *
*  reserved.  AT&T is a registered trademark of AT&T Corp.             *
*                                                                      *
*                   Network Services Research Center                   *
*                          AT&T Labs Research                          *
*                           Florham Park NJ                            *
*                                                                      *
*              Kathleen Fisher <kfisher@research.att.com>              *
*                 Kenny Q. Zhu <kzhu@cs.princeton.edu>                 *
*                    Peter White <peter@galois.com>                    *
*                                                                      *
***********************************************************************)
structure Utils =
struct
    fun doTranspose m =
	let fun transposeOne (dc, acc) = 
	    let fun tO' (dc,acc) result = 
		case (dc,acc) 
		    of ([], [])          => List.rev result
		  |  (nt::tks, na::accs) => tO' (tks, accs) ((nt :: na)::result)
		  | _                    => raise Fail "UnequalLengths"
	    in
		tO' (dc,acc) []
	    end
	    fun listify ls = List.map (fn x => [x]) ls 
	    val revTrans = case m
		of [] => []
	      |  [dc] => listify dc
	      |  (dc::rest) => List.foldl transposeOne (listify dc) rest 
	in
	    List.map List.rev revTrans
	end

    fun lconcat ls = 
	let fun doit l a = 
	    case l of [] => a
            | (s::ss) => doit ss (s^a)
	in
	    doit (List.rev ls) ""
	end
   
    (*funtion to join a list of strings with a string token*)
    fun join ls s =
	let fun doit l a = 
	    case l of 
	     nil => ""
	    | (s::nil)=> s
            | (s::ss) => (s^a) ^ (doit ss a)
	in
	    doit ls s
	end

    (* position in a list *)
    fun position ( a : ''a ) ( l : ''a list ): int option =
    let fun position' ( n : int ) ( a : ''a ) ( l : ''a list ): int option =
        ( case l of
               []      => NONE
             | (x::xs) => if x = a then SOME n else position' (n+1) a xs
        )
    in position' 0 a l
    end

   (* replace reserved char in a string with escapes for use in PADS re *)
   fun escape s =
     let
	fun escapeChar (c:char) : string = case c of
	  #"?" => "\\\\?"
	| #"*" => "\\\\*"
	| #"+" => "\\\\+"
	| #"|" => "\\\\|"
	| #"$" => "\\\\$"
	| #"^" => "\\\\^"
	| #";" => "\\\\;"
	| #"." => "\\\\."
	| #"=" => "\\\\="
	| #"-" => "\\\\-"
	| #"/" => "\\\\/"
	| #"\\" => "\\\\\\"
  	| #"(" => "\\\\("
  	| #")" => "\\\\)"
  	| #"[" => "\\\\["
  	| #"]" => "\\\\]"
  	| #"<" => "\\\\<"
  	| #">" => "\\\\>"
  	| #"{" => "\\\\{"
  	| #"}" => "\\\\}"
	| _ => Char.toString c
     in
        String.translate escapeChar s
     end

    (* this function checks if a string is a valid C identifier *)
    fun isCIdentifier s =
      let
	fun isWordChar c = (Char.isAlphaNum c) orelse (c = #"_")
	fun isWord s = if isWordChar (String.sub (s, 0)) then 
			if size s = 1 then true
			else isWord (String.extract (s, 1, NONE))
		       else false
      in
	if Char.isAlpha (String.sub (s, 0)) then 
		if size s = 1 then true
		else isWord (String.extract (s, 1, NONE))
	else false
      end

     fun sumInts ( ns : int list ) : LargeInt.int = 
         foldl ( fn ( x : int, y : LargeInt.int ) => y + Int.toLarge x ) 0 ns

     fun avgInts ( ns : int list ) : real = 
        ( Real.fromLargeInt ( sumInts ns ) ) / ( Real.fromInt ( length ns ) )

     (* convert a large int to C style string form *)
     fun intToCString (i:LargeInt.int) : string =
	if (i>=0) then LargeInt.toString i
	else "-" ^ (LargeInt.toString (~i))

    (* function to find the min and max from a list given an order function and a list*)
    (* less (a, b) is true is a < b in some way *)
    fun min less l =
	case l of
	  x::nil => x
	| x::(y::tail) => if less x y then min less (x::tail)
			  else min less (y::tail)
	| [] => raise Fail "Empty list"
    (* greater (a, b) is true is a > b in some way *)
    fun max greater l =
	case l of
	  x::nil => x
	| x::(y::tail) => if greater x y then min greater (x::tail)
			  else max greater (y::tail)
	| [] => raise Fail "Empty list"

    (* turn the first char of a string s into upper case *)
    fun upFirstChar s =
      let val first = String.substring (s, 0, 1)
	  val tail = String.extract (s, 1, NONE)
	  val upped = case (Char.fromString first) of
		        SOME c => Char.toUpper c
		      | NONE => raise Fail "Not a character!"
      in ((String.str upped) ^ tail)
      end
    (* turn the first char of a string s into lower case *)
    fun lowerFirstChar s =
      let val first = String.substring (s, 0, 1)
	  val tail = String.extract (s, 1, NONE)
	  val lowered = case (Char.fromString first) of
		        SOME c => Char.toLower c
		      | NONE => raise Fail "Not a character!"
      in ((String.str lowered) ^ tail)
      end
end
