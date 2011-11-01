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
structure QUARTERLY = struct
    open Model
    val aux: AuxInfo = {coverage = 35, label = NONE, tycomp = zeroComps }
    val loc : location = {lineNo = 0, beginloc = 0, endloc = 0, recNo = 0}
    val quote: Ty = RefinedBase(aux, StringConst "\"", [(Other #"\"", loc)])
    val myyear: Ty = Base(aux, [(Pint(1998, "1998"), loc)])
    val dot: Ty = RefinedBase(aux, StringConst ".", [(Other #".", loc)])
    val myquarter: Ty = Base(aux, [(Pint(1, "1"), loc)])
    val quarter_t: Ty = Pstruct(aux, [quote, myyear, dot, myquarter, quote])
    val quarters_t: Ty = RArray(aux, SOME(StringConst ","), NONE, quarter_t, 
			NONE, [])
    val table_header_t: Ty = Pstruct(aux,[
	RefinedBase(aux, StringConst "\"Personal income\",\"FIPS\",\"AreaName\",", [(Pstring "...", loc)]), quarters_t])
    val incomeseq = RArray(aux, SOME(StringConst ","), NONE, 
			Base(aux, [(Pint(1998, "1998"), loc)]), NONE, [])
    val code =RefinedBase(aux, StringConst "\"010\",\"", [(Pstring "\"010\",\"", loc)])
    val areacode = Base(aux, [(Pint (02, "02"), loc)])
    val quotecommaquote = RefinedBase(aux, StringConst "\",\"", [(Pstring "\",\"", loc)])
    val areaname = RefinedBase(aux, StringME "/[a-zA-Z ]+/", [(Pstring "Colorado", loc)])
    val quotecomma= RefinedBase(aux, StringConst "\",", [(Pstring "\",", loc)])
    val entry_t = Pstruct(aux, [code, areacode, quotecommaquote, areaname, quotecomma, incomeseq])
    val quarterly_t = Punion(aux, [table_header_t, entry_t, 
    		RefinedBase(aux, StringConst "\"Source: Regional Economic Information System, Bureau of Economic Analysis, U.S. Department of Commerce\"", [(Pstring " ", loc)])])
end	
