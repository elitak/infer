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
structure Ast = 
struct
open Types
  datatype TypeName = 
       IRref of string (*string is name of a non-base type*)
     | IRbXML   
     | IReXML    
     | IRtime     
     | IRdate  
     | IRpath 
     | IRurl 
     | IRip 
     | IRhostname 
     | IRemail   
     | IRmac    
     | IRint   
     | IRintrange of LargeInt.int * LargeInt.int   
     | IRfloat
     | IRstring 
     | IRstringME of string
     | IRwhite 
     | IRchar 
     | IRempty 

  fun tokenToTypeName (t : Token ) : TypeName = 
	case t 
        of Ptime _     => IRtime
	|  Pdate _     => IRdate
	|  Pip _       => IRip
	|  Phostname _ => IRhostname
	|  Ppath _     => IRpath
	|  Purl _      => IRurl
	|  Pemail _      => IRemail
	|  Pmac _      => IRmac
        |  PbXML (f,s) => IRbXML
        |  PeXML (f,s) => IReXML
	|  Pint _    => IRint  
	|  Pfloat _    => IRfloat           
        |  Pstring _ => IRstring       
        |  Pwhite _  => IRwhite         
        |  Other _   => IRchar
        |  Pempty    => IRempty
        |  _ => raise TyMismatch

  type VarName = string

  type IRConstraint = VarName * 
			Refined option (*min*) * 
			Refined option (*max*) * 
			Refined option (*eq val*)

  datatype Enumerable = EnumInt of LargeInt.int | EnumVar of string | EnumDefault

  datatype Field = 
	  StringField of VarName option * string
	| CharField of VarName option * string (*still string because printing needs string anyway*) 
        | CompField of TypeName * IRConstraint
	| FullField of VarName * TypeName * VarName option (*param for switch*) * IRConstraint option 

  datatype TypeDef = 
	  TyBase of TypeName * IRConstraint option
	| TyStruct of Field list
	| TyUnion of Field list
	| TyEnum of Field list (*same as Union*)
	| TySwitch of VarName (*switch var*) * TypeName (*switch type*) * (Enumerable * Field) list
	| TyArray of TypeName * Refined option (*sep*) * Refined option (*term*) * Refined option (*len*)
	| TyOption of TypeName 

  type IRType = bool (*isRecord*) * TypeName * TypeDef

  fun notInlineTy ty = case ty of 
	Base _ => false 
	| RefinedBase (_, Enum _, _) => true 
	| RefinedBase _ => false
	| TBD _ => false
	| Bottom _  => false
	| _ => true

  fun isArrayBodyTy ty = case ty of 
	Base _ => true
	| RefinedBase (_, StringME _, _) => true
	| RefinedBase (_, StringConst _, _) => true
	| RefinedBase (_, Int _, _) => true	(* convert tp int32/int16, etc*)
	(*IntConst FloatConst are not inline of array and option*)
	| _ => false

  fun getBaseTyName ty : TypeName =
        let
	  val label = getLabelString (getAuxInfo ty)
	  val id = String.extract (label, 4, NONE)
	in
	  case ty of 
	    Base (_, (t, l)::_) => IRref ((tokenTyToName t) ^ "_" ^ id)
	  | RefinedBase(_, re, _) => (
		case re of 
		  StringME _ => IRref ("stringME_" ^ id) 
		| StringConst _ => IRref ("stringconst_" ^ id) 
		| Int _ => IRref ("intrange_" ^ id) 
		| IntConst _ => IRref ("intconst" ^ id) 
		| FloatConst _ => IRref ("floatconst" ^ id) 
		| Enum _ => (print "Enum!\n"; raise TyMismatch)
		| _ => raise TyMismatch (*enum and labelref shouldn't appear*)
		)
	  | _ => raise TyMismatch
	end

  fun getTypeName ty : TypeName =
	let
	  val label = getLabelString (getAuxInfo ty)
	  val id = String.extract (label, 4, NONE)
	in
	  case ty of
	   Base (_, (t, l)::_) => tokenToTypeName t
        |  Pstruct _             => IRref ("struct_" ^ id)
        |  Punion _              => IRref ("union_" ^ id)
        |  RefinedBase (aux, re, ((t, l)::_)) => 
		(case re of Enum _ => IRref ("enum_" ^ id)
			| StringME s => IRstringME s
			| StringConst s => if (size s) = 1 then IRchar
					   else IRstring
			| Int (min, max) => IRintrange (min, max)
			| IntConst i => IRintrange (i, i)
			| FloatConst _ => IRfloat
			| _ => raise TyMismatch
		)
        |  Switch _        	 => IRref ("switch_"^id)
        |  RArray _ 		 => IRref ("array_"^id)
        |  Poption _           	 => IRref ("opt_"^id)
	| _ => raise TyMismatch
	end

  fun getArrayBodyTyName ty : TypeName = 
	case ty of
	  RefinedBase(_, StringConst s, _) => IRstringME ("/" ^ escape s ^ "/")
	  |_ => getTypeName ty

  fun getVar ty : VarName = 
        let
	  val label = getLabelString (getAuxInfo ty)
	  val id = String.extract (label, 4, NONE)
	in
	  case ty of
	    Base _ => 
		(
		case (getBaseTyName ty) of
		IRref s => ("v_" ^ s)
		| _ => raise TyMismatch
		)
	  | RefinedBase (_, Enum _, _) =>
		(
		case (getTypeName ty) of 
		IRref s => ("v_" ^ s)
		| _ => raise TyMismatch
		)
	  | RefinedBase _ =>
		(
		case (getBaseTyName ty) of
		IRref s => ("v_" ^ s)
		| _ => raise TyMismatch
		)
	  |  _ => 
		(
		case (getTypeName ty) of 
		IRref s => ("v_" ^ s)
		| _ => raise TyMismatch
		)
	end

  fun tyToStructField siblings ty = 
    let
 	val tyName = getTypeName ty
	val var = getVar ty
    in
    	case ty of
	  RefinedBase (_, StringConst s, _) => 
		if (size s) = 1 then CharField (NONE, s)
		else StringField (NONE, s)
	| RefinedBase (_, IntConst i, _) => FullField (var, tyName, NONE, SOME(var, NONE, NONE, SOME (IntConst i)))
	| RefinedBase (_, FloatConst x, _) => FullField (var, tyName, NONE, 
						SOME(var, NONE, NONE, SOME (FloatConst x)))
	| RefinedBase _ => FullField (var, tyName , NONE, NONE) 
	| Switch (aux, id, retys) => 
	    let val switchTyOp = getTyById siblings id
	    in
		case switchTyOp of
		  SOME switchTy => FullField (var, tyName, SOME (getVar switchTy), NONE)
		| NONE => tyToStructField nil (Punion(aux, nil))
	    end
	| _ => FullField (var, tyName , NONE, NONE) 
     end

  fun tyToUnionField var_suffix ty = 
    let
 	val tyName = getTypeName ty
	val var = (getVar ty) ^ var_suffix
    in
    	case ty of
	  RefinedBase (_, StringConst s, _) => 
		if (size s) = 1 then CharField (SOME var, s)
		else StringField (SOME var, s)
	| RefinedBase (_, IntConst i, _) => FullField (var, tyName, NONE, 
						SOME(var, NONE, NONE, SOME (IntConst i)))
	| RefinedBase (_, FloatConst x, _) => FullField (var, tyName, NONE, 
						SOME(var, NONE, NONE, SOME (FloatConst x)))
	| Base (_, ((Pempty, _)::_)) => CompField (IRintrange (0, 0), (getVar ty, NONE, NONE, SOME (IntConst 0)))
	| _ => FullField (var, tyName, NONE, NONE) 
    end	

  fun reToEnumField id (branch, re) = 
    let
	val suffix = id ^ "_" ^ (Int.toString branch)
    in
      case re of
      StringConst s => 
	let
	  val var = if isCIdentifier s then (s ^ id)
		else "string" ^ suffix
	in
	  if (size s) = 1 then CharField (SOME var, s)
	  else StringField (SOME var, s)
	end
    | StringME s => 
	let
	  val var = "stringME" ^ suffix
	  val tyName = IRstringME s
	in FullField (var, tyName, NONE, NONE)
	end
    | Int (min, max) => 
	let
	  val var = "int" ^ suffix
	  val tyName = IRintrange (min, max) 
	in FullField (var, tyName, NONE, NONE)
	end
    | IntConst i => 
	let
	  val var = "int" ^ suffix
	  val tyName = IRintrange (i, i)
	in 
	  FullField (var, tyName, NONE, SOME(var, NONE, NONE, SOME (IntConst i)))
	end
    | FloatConst x => 
	let
	  val var = "float" ^ suffix
	  val tyName = IRfloat 
	in 
	  FullField (var, tyName, NONE, SOME(var, NONE, NONE, SOME (FloatConst x)))
	end
    | _ => raise TyMismatch
    end

  fun getVarsFromEnum (res, re, enumIdStr) : string list =
    (*first int is the branch no if re is an enum, string is var name*)
    let
  	fun getIndex refinedlist re index =
  	  case refinedlist of 
  	    nil => (~1) (*not found*)
  	  | head::tail =>
  		if refine_equal (head, re) then index
  		else getIndex tail re (index+1)
    in
  	case re of
  	  StringConst "*" => ["P_DEFAULT"]
  	| Enum l => List.concat (map (fn x => getVarsFromEnum (res, x, enumIdStr)) l)
	| _ => 
	  let
	     val branchInRes = getIndex res re 0
	  in
	     if branchInRes = (~1) then nil
	     else
	       let
	         val f = reToEnumField enumIdStr (branchInRes, re) 
	       in
		 case f of 
		   CharField (SOME var, _) => [var]
		 | StringField (SOME var, _) => [var]
		 | FullField (var, _, _, _) => [var]
		 | _ => raise TyMismatch
	       end
	  end
    end

  (* one orig branch can become a list of new branches *)
  fun toSwitchBranches switchedTy (branchno, (re, targetTy)) : (Enumerable * Field) list =
    let
      fun indexes n = List.tabulate (n, (fn x => x))
      fun getPairs res = ListPair.zip (res, (indexes (length res)))
      val suffix = "_" ^ (Int.toString branchno)
    in
    (case switchedTy of
	Base (aux, (Pint _, l)::ts) => 
	  (case re of IntConst x => [(EnumInt x, tyToUnionField suffix targetTy)]
	  	   | StringConst "*" => [(EnumDefault, tyToUnionField suffix targetTy)]
		   | Enum res => List.concat (map (fn (re, i) => 
				toSwitchBranches switchedTy (i, (re, targetTy))) (getPairs res)) 
		   | _ => raise TyMismatch
	  )
	| RefinedBase (aux, Int _, _) =>
	  (case re of IntConst x => [(EnumInt x, tyToUnionField suffix targetTy)]
	  	   | StringConst "*" => [(EnumDefault, tyToUnionField suffix targetTy)]
		   | Enum res => List.concat (map (fn (re, i) => 
					toSwitchBranches switchedTy (i, (re, targetTy))) (getPairs res)) 
		   | _ => raise TyMismatch
	  )
	(* we assume the Enum will only contain IntConst or StringConst and not another Enum *)
	| RefinedBase (aux, Enum res, _) =>
		let
		  val vars = getVarsFromEnum (res, re, (getIdString aux))
		  val indexes = List.tabulate (length res, (fn x => x))
		  val indexed_vars = ListPair.zip (indexes, vars)
		in
		  case vars of
		    ["P_DEFAULT"] => [(EnumDefault, tyToUnionField suffix targetTy)]
		  | _ => map (fn (i, v) => 
			      let val suffix = if (i>0) then "_" ^ (Int.toString i) else ""
			      in (EnumVar v, tyToUnionField suffix targetTy)
			      end) indexed_vars
		end
	| _ => raise TyMismatch
    ) 
    end

  (*function to translate a Ty to a sequence of IRTypes, 
    the last IRType in the sequence is the name and def of this Ty *)
  fun tyToIR (isRecord: bool) (siblings: Ty list) (ty: Ty) : IRType list =
    let val tyname = getTypeName ty in 
      case ty of
	Base(aux, (t, loc)::_) =>
	  let val basetyName = getBaseTyName ty
	  in [(isRecord, basetyName, TyBase(tyname, NONE))]
	  end
      | RefinedBase(aux, Enum res, _) =>
	  let 
	    val idStr = getIdString aux
	    val indexes = List.tabulate (length res, (fn x => x))
	    val indexed_res = ListPair.zip (indexes, res)
	  in 
	    if allStringConsts res then
 	    let
	      val fields = map (reToEnumField idStr) indexed_res (*similar to tyToUnionFeields*)
	    in [(isRecord, tyname, TyEnum fields)]
	    end
	    else 
	    let val fields = map (reToEnumField idStr) indexed_res 
	    in [(isRecord, tyname, TyUnion fields)]
	    end
	  end
      | RefinedBase(aux, re, _) =>
	  let val basetyName = getBaseTyName ty
	      val idStr = getIdString aux
	  in
	  (
	    case re of 
	      StringME _ => [(isRecord, basetyName, TyBase(tyname, NONE))]
	    | Int _ => [(isRecord, basetyName, TyBase(tyname, NONE))]
	    | IntConst i =>[(isRecord, basetyName, TyBase(tyname, SOME("x", NONE, NONE, SOME (IntConst i))))]
	    | FloatConst x => [(isRecord, basetyName, 
				TyBase(tyname, SOME("x", NONE, NONE, SOME(FloatConst x))))]
	    | StringConst s => [(isRecord, basetyName, 
				TyBase(tyname, SOME("x", NONE, NONE, SOME(StringConst s))))]
	    | _ => raise TyMismatch
	   )
	   end
      | Pstruct (aux, tys) =>
	  let
	    val nonInlineTys = List.filter notInlineTy tys
	    val liftedIRs = List.concat (map (tyToIR false tys) nonInlineTys)
	    val fields = map (tyToStructField tys) tys
	  in liftedIRs @[(isRecord, tyname, TyStruct fields)]	
	  end
      | Punion (aux, tys) =>
	  let
	    val nonInlineTys = List.filter notInlineTy tys
	    val liftedIRs = List.concat (map (tyToIR false tys) nonInlineTys)
	    val fields = map (tyToUnionField "") tys
	  in liftedIRs @[(isRecord, tyname, TyUnion fields)]	
	  end
      | Switch (aux, id, retys) =>
	  let
	    val switchedTyOp = getTyById siblings id
	    val tys = map #2 retys
	  in
	    (
	    case switchedTyOp of 
	      NONE => tyToIR false nil (Punion (aux, tys)) 
	    | SOME switchedTy =>
		let
	    	  val nonInlineTys = List.filter notInlineTy tys
	    	  val liftedIRs = List.concat (map (tyToIR false tys) nonInlineTys)
		  val switchTyName = getTypeName switchedTy
		  val switchVar = getVar switchedTy
		  val indexes = List.tabulate (length retys, (fn x => x))
		  val branches = ListPair.zip (indexes, retys)
		  val irbranches = List.concat (map (toSwitchBranches switchedTy)  branches)
		in liftedIRs @[(isRecord, tyname, TySwitch(switchVar, switchTyName, irbranches))] 
		end
	    )
	  end
      | RArray (aux, sep, term, ty, len, _) =>
	  if not (isArrayBodyTy ty) then 
		let val liftedIRs = tyToIR false nil ty
		    val bodyName = (case ty of 
				   RefinedBase (_, Enum _, _) => getTypeName ty
				   | RefinedBase _ => getBaseTyName ty
				   | _ => getTypeName ty)
		in liftedIRs @ [(isRecord, tyname, TyArray (bodyName, sep, term, len))]
		end
	  else [(isRecord, tyname, TyArray ((getArrayBodyTyName ty), sep, term, len))]
      | Poption (aux, ty) =>
	  if not (isArrayBodyTy ty) then 
		let val liftedIRs = tyToIR false nil ty
		    val bodyName = (case ty of 
				   RefinedBase (_, Enum _, _)  => getTypeName ty
				   | RefinedBase _ => getBaseTyName ty
				   | _ => getTypeName ty)
		in liftedIRs @ [(isRecord, tyname, TyOption bodyName)]
		end
	  else [(isRecord, tyname, TyOption (getArrayBodyTyName ty))]
      | _ => raise TyMismatch 
      end
end
