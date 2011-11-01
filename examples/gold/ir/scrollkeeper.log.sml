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
structure ScrollKeeper= struct
    open Types

    val aux : AuxInfo = { coverage = 327, label = NONE, tycomp = zeroComps }
    val sw1: Id = Atom.atom("sw1")
    val swAux1 : AuxInfo = { coverage = 327, label = SOME sw1, tycomp = zeroComps }

    val loc : location = { lineNo = 0, beginloc = 0, endloc = 0, recNo = 0 }
    val date : Ty = Base ( aux, [(Pdate "Dec 10", loc)] )
    val sp : Ty = RefinedBase ( aux, StringConst " ", [(Pwhite " ", loc)] )
    val time : Ty = Base ( aux, [(Ptime "04:07:59", loc)] );
    val installing: Ty = RefinedBase (aux, StringConst "Installing ScrollKeeper ", [])
    val num: Ty = Base ( aux, [(Pint (0, "0"), loc)])
    val dot : Ty = RefinedBase ( aux, StringConst ".", [] )
    val dots : Ty = RefinedBase ( aux, StringConst "...", [] )
    val version: Ty = Pstruct(aux, [num, dot, num, dot, num])
    val installlog: Ty = Pstruct(aux, [installing, version, dots])

    val action:Ty = RefinedBase(swAux1, Enum[StringConst "scrollkeeper-rebuilddb: ",
					StringConst "scrollkeeper-update: "], [])
    val sender:Ty = RefinedBase(aux, Enum[StringConst "/usr/bin/scrollkeeper-update: ",
					StringConst "scrollkeeper-update: "], [])
    val colonsp: Ty = RefinedBase ( aux, StringConst ": ", [] )
    val registering: Ty = RefinedBase ( aux, StringConst "Registering ", [] )
    val buildmsg: Ty = RefinedBase(aux, Enum[StringConst "Rebuilding ScrollKeeper database...",
					StringConst "Done rebuilding ScrollKeeper database."], [])
    val path: Ty = Base(aux, [(Ppath "/opt/fbf", loc)])
    val nosuchfile: Ty = RefinedBase ( aux, StringConst ": No such file or directory", [] )
    val regmsg: Ty = Pstruct(aux, [registering, path])
    val update: Ty = Pstruct(aux, [sender, path, nosuchfile])
    val updatemsg: Ty = Punion( aux, [regmsg, update] )

    val switch : Ty = Switch (aux, sw1, [ (StringConst "scrollkeeper-rebuilddb: ", buildmsg), 
			(StringConst "scrollkeeper-update: ", updatemsg) ] )
    val log: Ty = Punion(aux, [installlog, Pstruct(aux, [action, switch])])
    val scrollkeeper : Ty = Pstruct ( aux, [date, sp, time, sp, log])
end
