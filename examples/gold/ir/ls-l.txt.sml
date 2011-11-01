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
structure LS = struct
    open Model
    val aux: AuxInfo = {coverage = 35, label = NONE, tycomp = zeroComps }
    val loc : location = {lineNo = 0, beginloc = 0, endloc = 0, recNo = 0}
    val dirLabel = Atom.atom("dirLabel")
    val dirAux: AuxInfo = {coverage = 34, label = SOME dirLabel, tycomp = zeroComps }
    val dashR:Refined = StringConst "-"
    val dR:Refined = StringConst "d"
(*
    val dir: Ty = RefinedBase(dirAux, Enum([dashR, dR]), [(Pstring "-", loc)])
    val uread: Ty = RefinedBase(aux, Enum([StringConst "-", StringConst "r"]), [(Pstring "-", loc)])
    val uwrite: Ty = RefinedBase(aux, Enum([StringConst "-", StringConst "w"]), [(Pstring "-", loc)])
    val uexe: Ty = RefinedBase(aux, Enum([StringConst "-", StringConst "x"]), [(Pstring "-", loc)])
    val gread: Ty = RefinedBase(aux, Enum([StringConst "-", StringConst "r"]), [(Pstring "-", loc)])
    val gwrite: Ty = RefinedBase(aux, Enum([StringConst "-", StringConst "w"]), [(Pstring "-", loc)])
    val gexe: Ty = RefinedBase(aux, Enum([StringConst "-", StringConst "x"]), [(Pstring "-", loc)])
    val oread: Ty = RefinedBase(aux, Enum([StringConst "-", StringConst "r"]), [(Pstring "-", loc)])
    val owrite: Ty = RefinedBase(aux, Enum([StringConst "-", StringConst "w"]), [(Pstring "-", loc)])
    val oexe: Ty = RefinedBase(aux, Enum([StringConst "-", StringConst "x"]), [(Pstring "-", loc)])
    val permission: Ty = Pstruct (aux, [dir, uread, uwrite, uexe, gread, gwrite, gexe,
		oread, owrite, oexe])
*)
    val permission: Ty = RefinedBase(aux, StringME "/(\\-|d)[\\-rwx]+/", [(Pstring "drwxrxwx", loc)])
    val space : Ty = Base(aux, [(Pwhite " ", loc)])
    val date : Ty = Base(aux, [(Pdate "15/Oct/1997", loc)])
    val time : Ty = RefinedBase(aux, StringME "/[0-9][0-9]:[0-9][0-9]/", [(Pstring "12:34", loc)])
    val year : Ty = Base(aux, [(Pint (2005, "2005"), loc)])
    val timestamp: Ty = Punion(aux, [Pstruct(aux, [date, space, time]), 
			Pstruct(aux, [date, space, year])])
    val total: Ty = Pstruct (aux, [RefinedBase(aux, StringConst "total", [(Pstring "total", loc)]),
		space, Base(aux, [(Pint (235656, "235656"), loc)])])
    val owner: Ty = RefinedBase(aux, StringConst "dpw", [(Pstring "dpw", loc)])
    val group: Ty = RefinedBase(aux, StringConst "fac", [(Pstring "fac", loc)])
    val filename: Ty = RefinedBase(aux, StringME "/[0-9a-zA-Z\\-_ ~.]+/", [(Pstring "xyz", loc)])
    val bytes: Ty = Base(aux, [(Pint (1234, "1234"), loc)])
    val oneBase: Ty = RefinedBase(aux, IntConst 1, [(Pint (1, "1"), loc)])
    val intBase: Ty = Base(aux, [(Pint (5, "5"), loc)])
    val files: Ty = Punion(aux, [oneBase, intBase])
    val entry_t : Ty = Pstruct(aux, [permission, space, files, space, owner, space, group, 
		space, bytes, space, timestamp, space, filename])
    val ls_l : Ty = Punion (aux, [total, entry_t])
end	
