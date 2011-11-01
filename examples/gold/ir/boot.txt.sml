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
structure BOOT = struct
    open Model
    val aux: AuxInfo = {coverage = 35, label = NONE, tycomp = zeroComps }
    val loc : location = {lineNo = 0, beginloc = 0, endloc = 0, recNo = 0}
    val date : Ty = Base(aux, [(Pdate "15/Oct/1997", loc)])
    val time : Ty = Base(aux, [(Ptime "18:46:51 -0700", loc)])
    val space : Ty = RefinedBase(aux, StringConst " ", [(Pstring " ", loc)])
    val colon: Ty = RefinedBase(aux, StringConst ":", [(Pstring ":", loc)])
    val server: Ty = RefinedBase(aux, StringConst " srv7 ", [(Pstring "srv7", loc)])
    val daemon : Ty = RefinedBase(aux, StringME "/[^:]+/", [(Pstring ("acpid"), loc)])
    val msg: Ty = RefinedBase(aux, StringME "/.*/", [(Pstring ("some message"), loc)])
    val sp: Ty = Base(aux, [(Pwhite " ", loc)]) 
    val lastmsg: Ty = RefinedBase(aux, StringConst "last message repeated ", [(Pstring "last message repeated ", loc)]) 
    val inttimes: Ty = Base(aux, [(Pint(32, "32"), loc)])
    val times: Ty = RefinedBase(aux, StringConst " times", [(Pstring " times", loc)]) 
    val daemon_msg : Ty = Pstruct(aux, [daemon, colon, sp, Poption(aux, msg)])
    val sys_msg : Ty = Pstruct(aux, [lastmsg, inttimes, times])
    val message: Ty = Punion (aux, [daemon_msg, sys_msg])
    val boot_entry: Ty = Pstruct(aux, [date, space, time, server, message])
end	
