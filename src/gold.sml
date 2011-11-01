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
structure Gold = struct
    open AI
    open BOOT
    open CRASHREPORTER
    open CRASHREPORTER_MOD
    open LS
    open DIBBLER
    open QUARTERLY
    open RAILROAD
    open RPMPKGS
    open Trans
    open Yumtxt 
    open ASL
    open PAGE_LOG
    open WINDOWSERVER_LOG 
    open MER
    open NETSTAT 
    open Populate
    open ScrollKeeper
    open Model
    open Types

    exception Bust

    fun compStr ( s1 : string, s2 : string ) : order =
        if s1 < s2
        then LESS
        else if s1 > s2
             then GREATER
             else EQUAL
    
    structure GoldenMapF = RedBlackMapFn ( struct type ord_key = string
                                                       val compare = compStr
                                           end
                                         )

    type GoldenMap = Ty GoldenMapF.map

    fun buildGold ( kvs : ( string * Ty ) list ) : GoldenMap =
    let fun f ( kv : ( string * Ty ), m : GoldenMap ) : GoldenMap =
        let val ( k, v ) = kv
        in GoldenMapF.insert ( m, k, v )
        end
    in foldl f GoldenMapF.empty kvs
    end 

    val goldens : GoldenMap = buildGold
        [ ( "1967Transactions.short", trans )
        , ( "ai.3000", ai )
        , ( "boot.log", boot_entry )
        , ( "crashreporter.log", crashreport )
        , ( "crashreporter.log.modified", crashreport_mod )
        , ( "dibbler.1000", dibbler_t )
        , ( "ls-l.txt", ls_l )
        , ( "quarterlypersonalincome", quarterly_t )
        , ( "railroad.txt", railroad )
        , ( "rpmpkgs", rpmpkgs )
        , ( "yum.txt", yum )
        , ( "asl.log", asl)
        , ( "page_log", page_log)
        , ( "windowserver_last.log", windowserver_log)
        , ( "MER_T01_01.csv", mer)
        , ( "netstat-an", netstat)
        , ( "scrollkeeper.log", scrollkeeper)
        ]

    (* Determine if there is a useable golden data file *)
    fun hasGold ( s : string ) : bool = GoldenMapF.inDomain ( goldens, s )
    (* Find the golden data file *)
    fun getGold ( s : string ) : Ty option  = GoldenMapF.find ( goldens, s )
    (* Find the golden data file, or die *)
    fun getGolden ( s : string ) : Ty =
      ( case ( getGold s ) of
               NONE   => raise Bust
             | SOME t => t
     )

    fun goldenReport ( descname : string ) : string =
        if hasGold descname
        then let val goldenTy : Ty  = getGolden descname
                 val populated : Ty = populateDataFile ( "data/" ^ descname ) goldenTy
                 val measured : Ty  = measure populated
                 val ()             = print "\n"
		(*
		 val (_, pads) = TyToPADSFile measured "vanilla.p"
		 val () = print (pads ^ "\n")
		*)
                 val nbits : int    = OS.FileSys.fileSize ( "data/" ^ descname ) * 8
                 val goldtystr      = TyToString ( measured )
             in "Golden complexity =\n" ^
                showTyCompNormalized nbits ( getComps populated ) ^
                goldtystr ^ "\n" 
             end
        else "NO GOLDEN FILE FOR: " ^ descname ^ "\n"

end
