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
structure PAGE_LOG = struct
    open Model
    val aux: AuxInfo = {coverage = 1, label = NONE, tycomp = zeroComps }
    val loc : location = {lineNo = 0, beginloc = 0, endloc = 0, recNo = 0}
    val space : Ty = RefinedBase(aux, StringConst " ", [(Pstring " ", loc)])
    val lb: Ty = RefinedBase(aux, StringConst "[", [(Pstring "[", loc)])
    val rb: Ty = RefinedBase(aux, StringConst "]", [(Pstring "]", loc)])

    val date : Ty = Base(aux, [(Pdate "2006.11.21", loc)])
    val time : Ty = Base(aux, [(Ptime "18:46:51", loc)])
    val printername : Ty = Base(aux, [(Pstring "officejet", loc)])
    val op_name: Ty = Poption(aux, RefinedBase(aux, StringConst "(Printer)", [(Pstring "(Printer)", loc)]))
    val printer : Ty = Pstruct(aux, [printername, op_name])
    val user: Ty = Base(aux, [(Pstring "kfisher", loc)])
    val id: Ty = Base(aux, [(Pint (4, "4"), loc)])
    val colon: Ty = RefinedBase(aux, StringConst ":", [(Pstring ":", loc)])
    val pageno: Ty = Base(aux, [(Pint (~1, "-1"), loc)])
    val status: Ty = Base(aux, [(Pint (~1, "-1"), loc)])
    val dash : Ty = RefinedBase(aux, StringConst "-", [(Pstring "-", loc)])

    val localhost: Ty = RefinedBase(aux, StringConst "localhost", [(Pstring "localhost", loc)])

    val page_log: Ty = Pstruct(aux, [printer, space, user, space, id, space, lb, date, colon, time, rb, space,
				pageno, space, status, space, dash, space, localhost])
end	
