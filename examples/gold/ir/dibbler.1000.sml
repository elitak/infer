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
structure DIBBLER = struct
    open Model
    val aux: AuxInfo = {coverage = 35, label = NONE, tycomp = zeroComps }
    val loc : location = {lineNo = 0, beginloc = 0, endloc = 0, recNo = 0}
    val pn_t: Ty = Base(aux, [(Pint(1243, "1243"), loc)])
    val zipSep_t: Ty = RefinedBase(aux, Enum [StringConst "-", StringConst "/", StringConst " "],
		[(Pstring " ", loc)])
    val zip: Ty = Base(aux, [(Pint(34232, "34232"), loc)])
    val suffix: Ty = Base(aux, [(Pint(4232, "4232"), loc)])
    val extended_zip_t: Ty = Pstruct (aux, [zip, zipSep_t, suffix])
    val smallZip: Ty = Base(aux, [(Pint(34232, "34232"), loc)])
    val largeZip: Ty = Base(aux, [(Pint(34232, "34232"), loc)])
    val pzip : Ty = Punion(aux, [extended_zip_t, smallZip, largeZip])
    val summary_header_t: Ty = Pstruct(aux, [RefinedBase(aux, StringConst "0|", [(Pstring "0|", loc)]),
			Base(aux, [(Pint (234255, "234255"), loc)])])
(*
    val no_ii: Ty = RefinedBase(aux, StringConst "no_ii", [(Pstring "no_ii", loc)])
    val id: Ty = Base(aux, [(Pint (234255, "234255"), loc)])
*)
    val no_ramp_t : Ty = RefinedBase(aux, StringME "/no_ii[0-9]*/", [(Pstring "no_ii73644", loc)])
    val ramp: Ty = Base(aux, [(Pint(234255, "234255"), loc)])
    val dib_ramp_t : Ty = Punion(aux, [ramp, no_ramp_t])
    val space : Ty = RefinedBase(aux, StringConst " ", [(Pstring " ", loc)])
    val bar : Ty = RefinedBase(aux, StringConst "|", [(Pstring "|", loc)])
    val order_num: Ty = Base(aux, [(Pint (234255, "234255"), loc)])
    val att_order_num: Ty = Base(aux, [(Pint (234255, "234255"), loc)])
    val ord_version: Ty = Base(aux, [(Pint (234255, "234255"), loc)])
    val service_tn = Poption (aux, pn_t)
    val billing_tn = Poption (aux, pn_t)
    val nlp_service_tn = Poption (aux, pn_t)
    val nlp_billing_tn = Poption (aux, pn_t)
    val zip_code = Poption (aux, pn_t)
    val order_type: Ty = Base(aux, [(Pstring "34232", loc)])
    val order_details: Ty = Base(aux, [(Pint(34232, "34232"), loc)])
    val unused: Ty = RefinedBase (aux, StringME "/[0-9a-zA-Z ]+/", [(Pstring ("3456"), loc)])
    val stream: Ty = Base(aux, [(Pstring("34232"), loc)])
    val order_header_t: Ty = Pstruct(aux, [
		     order_num, 
		bar, att_order_num, 
		bar, ord_version,
		bar, service_tn, 
		bar, billing_tn, 
		bar, nlp_service_tn, 
		bar, nlp_billing_tn,
		bar, zip_code,
		bar, dib_ramp_t,
		bar, order_type,
		bar, order_details,
		bar, unused,
		bar, stream,
		bar])
    val state: Ty = RefinedBase(aux, StringME "/[0-9a-zA-Z_\\-]+/", [(Pstring("34232"), loc)])
    val tstamp: Ty = Base(aux, [(Pint(34232, "34232"), loc)])
    val event_t : Ty = Pstruct(aux, [state, bar, tstamp])
    val eventSeq: Ty = RArray(aux, SOME(StringConst "|"), NONE, event_t, NONE, [])
    val entry_t = Pstruct(aux, [order_header_t, eventSeq])
    val dibbler_t = Punion(aux, [summary_header_t, entry_t])
end	
