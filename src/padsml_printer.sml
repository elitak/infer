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
structure Padsml_printer =
struct
  open Ast

  fun getRefStr sep_term refined = case refined of
    StringME s => "Regexp_" ^ sep_term ^ " \"" ^ escape(s) ^"\""
  | StringConst s => if (size s) = 1 then ("Char_" ^ sep_term ^ " '" ^ s ^ "'")
			else ("String_" ^ sep_term ^ " \"" ^ s ^ "\"")
  | _ => raise TyMismatch

  fun tyNameToPML tyName =
     case tyName of 
       IRref s => s
     | IRbXML => "ppbXML"  
     | IReXML => "ppeXML"   
     | IRtime => "pptime" 
     | IRdate => "ppdate" 
     | IRpath => "pppath"
     | IRurl => "ppurl"
     | IRip => "ppip"
     | IRhostname => "pphostname"
     | IRemail => "ppemail"
     | IRmac => "ppmac"  
     | IRint => "pint64"
     | IRintrange (min, max) =>
        let val minLen = int2Bits min
            val maxLen = int2Bits max
            val maxBits = Real.max(minLen, maxLen)
            val typeName = if (min>=0) then "puint" else "pint"
        in 
            if (maxBits<= 8.0) then typeName ^ "8"
            else if maxBits <=16.0 then typeName ^ "16"
                 else if maxBits <=32.0 then typeName ^ "32"
                      else typeName ^ "64" 
        end
     | IRfloat => "pfloat64"
     | IRstring => "ppstring"
     | IRstringME s => "pstring_ME(\"" ^ s ^ "\")"
     | IRwhite => "ppwhite"
     | IRchar => "ppchar"
     | IRempty => "ppempty"

  fun fieldToPML isStruct f =
    case f of
      StringField (SOME v, s) => (upFirstChar v) ^ " of \"" ^ (String.toCString s) ^ "\""
    | StringField (NONE, s) => "\"" ^ (String.toCString s) ^ "\""
    | CharField (SOME v, s) => (upFirstChar v) ^ " of '" ^ (String.toCString s) ^ "'"
    | CharField (NONE, s) => "'" ^ (String.toCString s) ^ "'" 
    | CompField (t, (v, NONE, NONE, SOME (IntConst x))) => 
                "with pdefault " ^ (upFirstChar v) ^ " of " ^ (tyNameToPML t) ^ " = " ^ 
		(LargeInt.toString x)
    | FullField (v, t, sw, c) => 
        let val tyname = tyNameToPML t in
	(if isStruct then
          v ^ " : " ^ tyname ^ 
          (case sw of 
           SOME swv => "(" ^ swv ^ ")"
           | NONE => ""
          ) 
	else upFirstChar v ^ " of " ^ tyname)
	^ 
        (case c of 
           SOME (consv, min, max, SOME eq) => 
                let val consVal = 
                (case eq of
                   IntConst i => LargeInt.toString i
                 | FloatConst (i, f) => i ^ f
                 | _ => raise TyMismatch
                )
                in (" = " ^ consVal) 
                end
         | NONE => ""
         | _ => raise TyMismatch
        ) 
        end
     | _ => raise TyMismatch

  fun irToPML ir = 
    let val (isRecord, tyVar, tyDef) = ir
	val tyVarStr = tyNameToPML tyVar
  	val precord = if isRecord then "precord " else ""
    in
      case tyDef of
        TyBase (tyName, cons_op) =>
	  let val tyNameStr = tyNameToPML tyName
	  in
	   case cons_op of
	     NONE => "ptype " ^ tyVarStr ^ " = " ^ tyNameStr ^  " " ^ precord ^ "\n\n"
	   | SOME (var, NONE, NONE, SOME (IntConst i)) =>
		     "ptypedef " ^ tyVarStr ^ " = [" ^ var ^ ": " ^  tyNameStr ^ 
			" | " ^ var ^ " = " ^ (LargeInt.toString i) ^ "]\n\n"
	   | SOME (var, NONE, NONE, SOME (FloatConst (i, f))) =>
		     "ptypedef " ^ tyVarStr ^ " = [" ^ var ^ ": " ^  tyNameStr ^ 
			" | " ^ var ^ " = " ^ i ^ "." ^ f ^ "]\n\n"
	   | _ => raise TyMismatch
	  end
    	| TyStruct fields => "ptype " ^ tyVarStr ^ " = {\n\t" ^ 
				(String.concatWith ";\n\t" (map (fieldToPML true) fields)) ^ "\n} " ^ 
				"\n\n"
	| TyUnion fields => "ptype " ^ tyVarStr ^ " = \n\t" ^ 
				(String.concatWith "\n\t| " (map (fieldToPML false) fields)) ^ "\n\n"
	| TyEnum fields => "ptype " ^ tyVarStr ^ " = \n\t" ^ 
				(String.concatWith "\n\t| " (map (fieldToPML false) fields)) ^ "\n\n"
	| TySwitch (swVar, swTyName, branches) => 
		let
		  val swTyNameStr = tyNameToPML swTyName 
		  fun branchtoStr (e, f) = 
		  case e of
		    EnumInt i => (LargeInt.toString i) ^ " -> \t" ^ (fieldToPML false f) ^ "\n"
		  | EnumVar v => (upFirstChar v) ^ " _ -> \t" ^ (fieldToPML false f) ^ "\n"
		  | EnumDefault => "_ -> \t" ^ (fieldToPML false f) ^ "\n"
		in
		  "ptype " ^ tyVarStr ^ " (" ^ swVar ^ " : " ^ swTyNameStr ^ ") =\n" ^
		  "  pmatch " ^ swVar ^ " with\n\t" ^ 
		  (String.concatWith "\t| " (map branchtoStr branches)) ^
		  "\n" ^
		  "\n"
		end
		
	| TyArray (tyName, sep, term, len) =>
		let val tyNameStr = tyNameToPML tyName
		val sep_str = 
		  case sep of
		    SOME refsep => getRefStr "sep" refsep
		  | NONE => "No_sep"
		val term_str = 
		  case term of
		    SOME refterm => getRefStr "term" refterm
		  | NONE => "No_term"
		in "ptype " ^ tyVarStr ^ " = " ^ tyNameStr ^ 
		   " plist (" ^ sep_str ^ ", " ^ term_str ^ ") " ^ precord ^"\n\n"
		end
	| TyOption tyName => 
		let val tyNameStr = tyNameToPML tyName
		in ("ptype " ^ tyVarStr ^ " = " ^ tyNameStr ^ " popt " ^ precord ^"\n\n")
		end
    end

     fun tyToPADSML ty numHeaders numFooters includeFile =
        (* assume that if a ty has header and footer, the body is just one single Ty*)
        let
          val recordLabel = 
	    if numHeaders>0 orelse numFooters>0 then
		let val l = getLabelString (getAuxInfo ty)
	    	val id = String.extract (l, 4, NONE) in "struct_" ^ id end
	    else
		tyNameToPML (
                case ty of
                  Base _ => getBaseTyName ty
                | RefinedBase _ => getBaseTyName ty
                | _ => getTypeName ty)
          val pads = "open "^ includeFile ^"\n" ^
                (if numHeaders=0 andalso numFooters=0 then
                    let val irTys = tyToIR true nil ty
                        val body = (lconcat (map irToPML irTys))
                    in
                        body ^
                        "ptype entries_t = " ^ recordLabel ^ " precord plist (No_sep, No_term)\n"
                    end
                else 
                  case ty of 
                    Punion (_, tys) =>
                      if (numHeaders + numFooters + 1) <> length tys then
                        raise Fail "Header Footer incorrect!"
                      else 
                              let
                                val headers = List.take (tys, numHeaders)
                                val body = List.nth (tys, numHeaders)
                                val footers = List.drop (tys, (numHeaders+1))
                                val (headerVars, headerIRss) = ListPair.unzip (map 
					(fn t => 
					  let val irs = tyToIR true nil t
					      val (isR, varTy, _) = List.last irs
					  in ((isR, varTy), irs) end)  headers)
				val headerIRs = List.concat headerIRss
                                val bodyIRs = tyToIR true nil body
				val (isBodyR, bodyVar, _) = List.last bodyIRs
                                val (footerVars, footerIRss) = ListPair.unzip (map 
					(fn t => 
					  let val irs = tyToIR true nil t
					      val (isR, varTy, _) = List.last irs
					  in ((isR, varTy), irs) end)  footers)
				val footerIRs = List.concat footerIRss
                              in
                                (case headerIRs of
                                        nil => ""
                                        | _ => (lconcat (map irToPML headerIRs)) 
                                ) ^
                                (lconcat (map irToPML bodyIRs)) ^
                                (case footerIRs of
                                        nil => ""
                                        | _ => (lconcat (map irToPML footerIRs))
                                ) ^
                                "ptype " ^ recordLabel ^ " = " ^ 
				(String.concatWith " * " (map 
				  (fn (isrec, v) => 
				      if isrec then "(" ^ (tyNameToPML v) ^ " precord)"
				      else tyNameToPML v) (headerVars@[(isBodyR, bodyVar)]@footerVars))) ^
                                "\n" 
                              end
                  | _ => raise TyMismatch
                )
        in pads
        end 

end
