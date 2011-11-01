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
structure WINDOWSERVER_LOG = struct
    open Model
    val aux: AuxInfo = {coverage = 1, label = NONE, tycomp = zeroComps }
    val loc : location = {lineNo = 0, beginloc = 0, endloc = 0, recNo = 0}

    val date : Ty = Base(aux, [(Pdate "2006.11.21", loc)])
    val time : Ty = Base(aux, [(Ptime "18:46:51", loc)])
    val space : Ty = Base(aux, [(Pwhite " ", loc)])
    val colon: Ty = RefinedBase(aux, StringConst ":", [(Pstring ":", loc)])
    val id: Ty = Base(aux, [(Pint (4, "4"), loc)])
    val lb: Ty = RefinedBase(aux, StringConst "[", [(Pstring "[", loc)])
    val rb: Ty = RefinedBase(aux, StringConst "]", [(Pstring "]", loc)])
    val lp: Ty = RefinedBase(aux, StringConst "(", [(Pstring "(", loc)])
    val rp: Ty = RefinedBase(aux, StringConst ")", [(Pstring ")", loc)])
    val quote: Ty = RefinedBase(aux, StringConst "\"", [(Pstring "\"", loc)])
    val hex: Ty = RefinedBase(aux, StringME "/[0-9a-fx]+/", [(Pstring "0x467f", loc)])

    val name : Ty = RefinedBase(aux, StringME "/[^\"]+/", [(Pstring "(ipc/send) invalid memory", loc)])
    val errorname : Ty = RefinedBase(aux, StringME "/[^:]+/", [(Pstring "(ipc/send) invalid memory", loc)])
    val msg: Ty = RefinedBase(aux, StringME "/.*/", [(Pstring "UI updates were forcibly disabled by application Dock for over 1 second. Server has re-enabled them.", loc)])

    val displaystr: Ty = RefinedBase(aux, StringConst "Display ", [(Pstring "Display ", loc)])
    val display : Ty = Pstruct(aux, [displaystr, hex, colon, msg])

    val all: Ty = Pstruct(aux, [RefinedBase(aux, StringConst "all", [(Pstring "Display ", loc)]),
			  	Poption(aux, RefinedBase(aux, StringConst " but UA", [(Pstring "Display ", loc)]))])
			
    val component : Ty = Pstruct(aux, [quote, name, quote, space, lp, hex, rp])
    val settonormal : Ty = Pstruct(aux, [component, 
				RefinedBase(aux, StringConst " set hot key operating mode to normal", [(Pstring "", loc)])])
    val settodisable : Ty = Pstruct(aux, [component, 
				RefinedBase(aux, StringConst " set hot key operating mode to ", [(Pstring "", loc)]),
				all,
				RefinedBase(aux, StringConst " disabled", [(Pstring "", loc)])])
    val nownormal: Ty = RefinedBase(aux, StringConst "Hot key operating mode is now normal", [(Pstring "-", loc)])
    val nowdisable: Ty = Pstruct(aux, [RefinedBase(aux, StringConst "Hot key operating mode is now ", [(Pstring "-", loc)]),
		all, RefinedBase(aux, StringConst " disabled", [(Pstring "", loc)])])

    val serverstart: Ty = RefinedBase(aux, StringConst "Server is starting up", [(Pstring " ", loc)])

    val error : Ty = Pstruct(aux, [errorname, colon, space, name, Poption(aux, space), colon, msg])
    val info: Ty = Pstruct(aux, [errorname, colon, space, msg])
    val log: Ty = Punion(aux, [settonormal, settodisable, nownormal, nowdisable, serverstart, display, error, info, msg])
    val windowserver_log: Ty = Pstruct(aux, [date, space, time, space, lb, id, rb, space, log])
end	
