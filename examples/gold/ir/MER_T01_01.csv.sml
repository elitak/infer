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
structure MER = struct
    open Model
    val aux : AuxInfo = { coverage = 999, label = NONE, tycomp = zeroComps }
    val loc: location = { lineNo = 0, beginloc = 0, endloc = 0, recNo = 0 }
    val comma : Ty = RefinedBase (aux, StringConst ",", [] )
    val type_t: Ty = RefinedBase(aux, Enum [IntConst 0101, IntConst 0102, IntConst 0103, IntConst 0104 ], [])
    val header: Ty = RefinedBase(aux, StringConst "\"MSN\",\"YYYYMM\",\"Publication Value\",\"Publication Unit\",\"Column Order\"", [])
    val busname: Ty = RefinedBase(aux, Enum [StringConst "\"TEAJBUS\"", 
		StringConst "\"TEEXBUS\"",
		StringConst "\"TEIMBUS\"", StringConst "\"TEPRBUS\"", 
		StringConst "\"TETCBUS\""], [])
    val unitname:Ty = RefinedBase(aux, StringConst "Quadrillion Btu", [])
    val date:Ty = Base (aux, [(Pint (199913, "199913"), loc)])
    val value:Ty = Base (aux, [(Pfloat ("99", "07"), loc)])
    val order:Ty = Base (aux, [(Pint (4, "4"), loc)])
    val record: Ty = Pstruct(aux, [busname, comma, date, comma, value, comma, 
				unitname, comma, order])
    val mer: Ty = Punion(aux, [header, record])
end
