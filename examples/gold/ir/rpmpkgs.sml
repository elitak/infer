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
structure RPMPKGS = struct
    open Model
    val aux: AuxInfo = {coverage = 35, label = NONE, tycomp = zeroComps }
    val loc : location = {lineNo = 0, beginloc = 0, endloc = 0, recNo = 0}
    val arch_t : Ty = RefinedBase(aux, Enum [StringConst "noarch", StringConst "i386",
			StringConst "i586", StringConst "i686", StringConst "alpha",
			StringConst "sparc", StringConst "mips", StringConst "ppc",
			StringConst "m68k", StringConst "SGI", StringConst "(none)"],
			[(Pstring "i386", loc)])
    val dash : Ty = RefinedBase(aux, StringConst "-", [(Pstring "-", loc)])
    val dot: Ty = RefinedBase(aux, StringConst ".", [(Pstring ".", loc)])
    val rpm: Ty = RefinedBase(aux, StringConst ".rpm", [(Pstring ".rpm", loc)])
    val name: Ty = RefinedBase(aux, StringME "/[0-9a-zA-Z]+/", [(Pstring "4Suite", loc)])
    val version: Ty = RefinedBase(aux, StringME "/[0-9a-zA-Z.]+/", [(Pstring "4Suite", loc)])
    val release: Ty = RefinedBase(aux, StringME "/[0-9a-zA-Z.]+/", [(Pstring "4Suite", loc)])
    val rpmpkgs: Ty = Pstruct(aux, [name, dash, version, dash, release, dot, arch_t, rpm])
end	
