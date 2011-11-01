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
(* set options to control the amount of debugging print-out *)
structure Options = struct
val print_interp_debug = false (* useful for finding where a parse fails *)
val print_pre_reduced_IR = false (* prints the IR as used for parsing *)
val print_tables = false (* prints out the data as it appears in tables *)
val print_functional_deps = false
val print_report = false (* prints out a report summarizing information in Main.main' *)
val reparse_data = false (* try to reparse the data with the simplified IR *)
val print_levels = false (* report each level in TANE *)
val print_verbose = false (* print verbose information *)
val print_complexity = false (*print complexity info *)
val output_histograms = true (*print complexity info *)
end
