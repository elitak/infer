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
structure AI = struct
    open Model
    val aiAux: AuxInfo = {coverage = 3000, label = NONE, tycomp = zeroComps }
    val aiLoc : location = {lineNo = 0, beginloc = 0, endloc = 0, recNo = 0}

    val ip : Ty = Base(aiAux, [(Pip "135.207.23.32", aiLoc)])
    val host1 : Ty = Base(aiAux, [(Phostname "www.cnn.com", aiLoc)])
    val host2 : Ty = RefinedBase(aiAux, StringME "/[^ ]+/", [(Pstring "www.cnn.com", aiLoc)])
    val host: Ty = Punion (aiAux, [host1, host2])
    val client_t : Ty = Punion (aiAux, [ip, host])
    val unauthedId : Ty = RefinedBase(aiAux, StringConst "-", [(Pstring "-", aiLoc)])
    val dash : Ty = RefinedBase(aiAux, StringConst "-", [(Pstring "-", aiLoc)])
    val authedId : Ty = Base(aiAux, [(Pstring "Amnesty", aiLoc)])
    val auth_Id : Ty = Punion(aiAux, [unauthedId, authedId])
    val space : Ty = RefinedBase(aiAux, StringConst " ", [(Pstring " ", aiLoc)])
    val date : Ty = Base(aiAux, [(Pdate "15/Oct/1997", aiLoc)])
    val time : Ty = Base(aiAux, [(Ptime "18:46:51 -0700", aiLoc)])
    val datetime : Ty = Pstruct(aiAux, [RefinedBase(aiAux, StringConst "[", [(Pstring "[", aiLoc)]),
		date, RefinedBase(aiAux, StringConst ":", [(Pstring ":", aiLoc)]), time,
		RefinedBase(aiAux, StringConst "]", [(Pstring "]", aiLoc)])])
    val method: Ty = RefinedBase (aiAux, Enum ([StringConst "GET", StringConst "PUT", StringConst "POST", 
			StringConst "HEAD", StringConst "DELETE", StringConst "LINK", StringConst "UNLINK"]), 
			[(Pstring "GET", aiLoc)]) 
    val quote: Ty = RefinedBase(aiAux, StringConst "\"", [(Pstring "\"", aiLoc)])
    val dot: Ty = RefinedBase(aiAux, StringConst ".", [(Pstring ".", aiLoc)])
    val slash: Ty = RefinedBase(aiAux, StringConst "/", [(Pstring "/", aiLoc)])
    val longpath:Ty = Base(aiAux, [(Ppath "/turkey/amnty1.gif", aiLoc)])
    val shortpath:Ty = RefinedBase(aiAux, StringME "/\\/[^ ]*/", [(Pstring "/", aiLoc)])
    val path: Ty = Punion(aiAux, [longpath, shortpath])
    val intbase:Ty = Base(aiAux, [(Pint (1, "1"), aiLoc)])
    val length:Ty = Punion (aiAux, [intbase, dash])
    val http:Ty = RefinedBase(aiAux, StringConst "HTTP", [(Pstring "HTTP", aiLoc)])
    val request:Ty = Pstruct (aiAux, [quote, method, space, path, space, http, slash, intbase, dot, intbase, quote])
    val response:Ty = RefinedBase(aiAux, Int (100, 600), [(Pint (100, "100"), aiLoc)])
    val ai : Ty = Pstruct(aiAux, [client_t, space, auth_Id, space, auth_Id, space, datetime, space, 
			request, space, response, space, length])
end	
