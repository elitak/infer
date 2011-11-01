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
structure Config = struct
    (********************************************************************************)
    (*********************  Configuration *******************************************)
    (********************************************************************************)
    val DEF_HIST_PERCENTAGE   = 0.01
    val DEF_STRUCT_PERCENTAGE = 0.1
    val DEF_JUNK_PERCENTAGE   =  0.1
    val DEF_NOISE_PERCENTAGE  =  0.0
    val DEF_ARRAY_WIDTH_THRESHOLD =  4
    val DEF_ARRAY_MIN_WIDTH_THRESHOLD =  0
    val DEF_MAX_TABLE_ROWS = 2000
    val DEF_MAX_TABLE_COLS = 200
    val DEF_EXTRACT_HEADER_FOOTER = true
    val def_maxHeaderChunks = 3
    val def_depthLimit   = 50
    val def_outputDir    = "gen/"
    val def_descName     = "generatedDescription"
    val def_srcFiles     = [] : string list
    val def_printLineNos = false
    val def_printIDs     = true
    val def_entropy      = false

    val depthLimit        = ref def_depthLimit
    val outputDir         = ref def_outputDir
    val descName          = ref def_descName
    val srcFiles          = ref def_srcFiles
    val printLineNos      = ref def_printLineNos
    val printIDs          = ref def_printIDs
    val printEntropy      = ref def_entropy
    val executableDir     = ref ""
    val lexName	          = ref "vanilla"
    val goldenRun         = ref false

    val HIST_PERCENTAGE   = ref DEF_HIST_PERCENTAGE
    val STRUCT_PERCENTAGE = ref DEF_STRUCT_PERCENTAGE
    val JUNK_PERCENTAGE   = ref DEF_JUNK_PERCENTAGE
    val NOISE_PERCENTAGE  = ref DEF_NOISE_PERCENTAGE
    val ARRAY_WIDTH_THRESHOLD = ref DEF_ARRAY_WIDTH_THRESHOLD
    val ARRAY_MIN_WIDTH_THRESHOLD = ref DEF_ARRAY_MIN_WIDTH_THRESHOLD

    fun histEqTolerance   x = Real.ceil((!HIST_PERCENTAGE)   * Real.fromInt(x)) 
    fun isStructTolerance x = Real.ceil((!STRUCT_PERCENTAGE) * Real.fromInt(x)) 
    fun isJunkTolerance   x = Real.ceil((!JUNK_PERCENTAGE)   * Real.fromInt(x)) 
    fun isNoiseTolerance  x = Real.ceil((!NOISE_PERCENTAGE)  * Real.fromInt(x)) 

    fun parametersToString () = 
	(   ("Source files to process: "^(String.concat (!srcFiles))   ^"\n")^
	    ("Output directory: "      ^(!outputDir) ^"\n")^
	    ("Output description file: " ^(!descName) ^"\n")^
	    ("Max depth to explore: "  ^(Int.toString (!depthLimit))^"\n")^
 	    ("Print line numbers in output contexts: "        ^(Bool.toString (!printLineNos))^"\n")^
 	    ("Print ids and output type tokens: "             ^(Bool.toString (!printIDs))^"\n")^
	    ("Print Entropy: "                                ^(Bool.toString (!printEntropy))^"\n")^
	    ("Histogram comparison tolerance (percentage): "  ^(Real.toString (!HIST_PERCENTAGE))^"\n")^
	    ("Struct determination tolerance (percentage): "  ^(Real.toString (!STRUCT_PERCENTAGE))^"\n")^
	    ("Noise level threshold (percentage): "           ^(Real.toString (!NOISE_PERCENTAGE))^"\n")^
	    ("Width threshold for array: "                    ^( Int.toString (!ARRAY_WIDTH_THRESHOLD))^"\n")^
	    ("Minimum width threshold for array: "            ^( Int.toString (!ARRAY_MIN_WIDTH_THRESHOLD))^"\n")^
	    ("Junk threshold (percentage): "                  ^(Real.toString (!JUNK_PERCENTAGE))^"\n"))

    fun printParameters () = print (parametersToString ())

    (********************************************************************************)
    (*********************  END Configuration ***************************************)
    (********************************************************************************)

end
