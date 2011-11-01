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
structure Yumtxt = struct
    open Types

    val yumAux : AuxInfo = { coverage = 327, label = NONE, tycomp = zeroComps }
    val swLabel : Id = Atom.atom("sw1")
    val swAux : AuxInfo = { coverage = 327, label = SOME swLabel, tycomp = zeroComps }

    val yumLoc : location = { lineNo = 0, beginloc = 0, endloc = 0, recNo = 0 }

    val date1 : Ty = Base ( yumAux, [(Pdate "Dec 10", yumLoc)] )
    val sp1 : Ty = RefinedBase ( yumAux, StringConst " ", [(Pwhite " ", yumLoc)] )
    val time1 : Ty = Base ( yumAux, [(Ptime "04:07:59", yumLoc)] );
    val sp2 : Ty = RefinedBase ( yumAux, StringConst " ", [(Pwhite " ", yumLoc)] )
    val insupdsp : Ty = RefinedBase ( yumAux, StringConst " ", [(Pwhite " ", yumLoc)] )
    val installUpdateR : Refined = Enum [StringConst "Installed", StringConst "Updated" ]
    val erasedR : Refined = StringConst "Erased"

    val methodTok : LToken list = [(Pstring "Installed", yumLoc)]
    val method : Ty =
           RefinedBase ( swAux, Enum [ StringConst "Installed", StringConst "Updated", StringConst "Erased" ], methodTok )

    val colsp : Ty = RefinedBase ( yumAux, StringConst ": ", [] )
    val packagename : Ty = RefinedBase ( yumAux, StringME "/[^.]+/", [(Pstring "util-linux", yumLoc)] )
    val arch : Ty = Base ( yumAux, [(Pstring "x86_64", yumLoc)])
    val version: Ty = RefinedBase (yumAux, StringME "/[0-9a-zA-Z.\\-_]+/", [])
    val dot : Ty = RefinedBase ( yumAux, StringConst ".", [] )
    val ins_update_package : Ty =
        Pstruct ( yumAux, [ packagename, dot, arch, insupdsp, version ] )
    val eor : Ty = Base ( yumAux, [(Pstring "ruby", yumLoc)] )
    val erase_package : Ty = Pstruct ( yumAux, [ eor ] )
    val switch : Ty = Switch ( yumAux, swLabel, [ ( installUpdateR, ins_update_package), ( erasedR, erase_package ) ] )
    val yum : Ty = Pstruct ( yumAux, [ date1, sp1, time1, sp2, method, colsp, switch ] )

end
