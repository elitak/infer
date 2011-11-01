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
structure Trans = struct
    open Model
    val aux : AuxInfo = { coverage = 999, label = NONE, tycomp = zeroComps }
    val loc: location = { lineNo = 0, beginloc = 0, endloc = 0, recNo = 0 }
    val sp : Ty = Base (aux, [(Pwhite " ", loc)] )
    val type_t: Ty = RefinedBase(aux, Enum [IntConst 0101, IntConst 0102, IntConst 0103, IntConst 0104 ], [])
    val id:Ty = Base (aux, [(Pint (2701, "2701"), loc)])
    val value1:Ty = Base (aux, [(Pfloat ("99", "07"), loc)])
    val value2:Ty = Base (aux, [(Pfloat ("99", "07"), loc)])
    val value3:Ty = Base (aux, [(Pfloat ("99", "07"), loc)])
    val trans: Ty = Pstruct ( aux, [ type_t, sp, id, sp, value1, sp, value2, sp, value3, sp ] )
end
