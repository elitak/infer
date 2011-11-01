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
structure CRASHREPORTER = struct
    open Model
    val aux: AuxInfo = {coverage = 35, label = NONE, tycomp = zeroComps }
    val loc : location = {lineNo = 0, beginloc = 0, endloc = 0, recNo = 0}
    val date : Ty = Base(aux, [(Pdate "15/Oct/1997", loc)])
    val time : Ty = Base(aux, [(Ptime "18:46:51 -0700", loc)])
    val year: Ty = Base(aux, [(Pint (2004, "2004"), loc)])
    val space : Ty = RefinedBase(aux, StringConst " ", [(Pstring " ", loc)])
    val swLabel: Id = Atom.atom("sw")
    val swAux: AuxInfo = {coverage = 35, label = SOME swLabel, tycomp = zeroComps }
    val crashdump: Ty = RefinedBase(swAux, Enum[StringConst "crashdump", StringConst "crashreporterd"], 
				[(Pstring "crashdump", loc)])
    val leftbracket: Ty = RefinedBase(aux, StringConst "[", [(Pstring "[", loc)])
    val rightbracket: Ty = RefinedBase(aux, StringConst "]", [(Pstring "]", loc)])
    val dumpid: Ty = Base(aux, [(Pint (2004, "2004"), loc)])
    val colonsp: Ty = RefinedBase(aux, StringConst ": ", [(Pstring ": ", loc)]) 
    val started: Ty = RefinedBase(aux, StringConst "crashdump started", [(Pstring ": ", loc)]) 
    val start: Ty = RefinedBase(aux, StringConst "Started writing crash report to: ", 
			[(Pstring "Started writing crash report to: ", loc)]) 
    val finish: Ty = RefinedBase(aux, StringConst "Finished writing crash report to: ", 
			[(Pstring "Finished writing crash report to: ", loc)]) 
    val path: Ty = Base(aux, [(Ppath "/Users/kfisher/Library/Logs/CrashReporter/Preview.crash.log", loc)])
    val filename: Ty = RefinedBase(aux, StringME "/[0-9a-zA-Z. ]+/", [(Pstring " ayx", loc)])
    val filepath: Ty = Pstruct(aux, [path, Poption(aux, filename)])
    val unable: Ty = RefinedBase(aux, StringConst "Unable to determine task_t for pid: ", 
			[(Pstring "Unable to determine task_t for pid: ", loc)]) 
    val pid: Ty = Base(aux, [(Pint(95, "95"), loc)])
    val name: Ty = RefinedBase(aux, StringConst " name: Exited process", [(Pstring "name: Exited process", loc)])
    val function: Ty = RefinedBase(aux, StringME "/[^ ]+/", [(Pstring ("mach_msg()"), loc)])
    val reply: Ty = RefinedBase(aux, StringConst " reply failed: ", [(Pstring "srv7", loc)])
    val failedmsg: Ty = RefinedBase(aux, StringME "/.*/", [(Pstring ("(ipc/send) invalid destination port"), loc)])
    val failtorelaunch: Ty = RefinedBase(aux, StringConst "Failed to re-launch ", 
			[(Pstring "Failed to re-launch ", loc)])
    val spdashsp: Ty = RefinedBase(aux, StringConst " - ", [(Pstring " - ", loc)])
    val errorkind: Ty = Base (aux, [(Pstring "CGSError", loc)])
    val errorcode: Ty = Base(aux, [(Pint (1025, "1025"), loc)])
    val shriek: Ty = RefinedBase(aux, StringConst "!", [(Other #"!", loc)])
    val errormsg: Ty = Pstruct(aux, [errorkind, colonsp, errorcode, shriek])
    val dumpreport: Ty = Punion(aux, [started,
				Pstruct(aux, [start, filepath]),
				Pstruct(aux, [finish, filepath]),
				Pstruct(aux, [unable, pid, name]),
				Pstruct(aux, [failtorelaunch, path, spdashsp, errormsg])
				])
    val reporterreport: Ty = Pstruct(aux, [function, reply, failedmsg])
    val report: Ty = Switch(aux, swLabel, [(StringConst "crashdump", dumpreport), 
					   (StringConst "crashreporterd", reporterreport)])
    val crashreport: Ty = Pstruct(aux, [date, space, time, space, year, space, crashdump, leftbracket,
				dumpid, rightbracket, colonsp, report])
end	
