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
structure Tests = struct
    open Types
    open Model

    (* Some locations to use *)
    val ln1 : location = { lineNo = 1, beginloc = 10, endloc = 20, recNo = 1 }
    val ln2 : location = { lineNo = 2, beginloc = 12, endloc = 22, recNo = 1 }
    val ln3 : location = { lineNo = 3, beginloc = 13, endloc = 23, recNo = 1 }
    val ln4 : location = { lineNo = 4, beginloc = 14, endloc = 24, recNo = 1 }

    (* Some AuxInfo structures to use *)
    val a1 : AuxInfo = { coverage = 7
                       , label    = NONE
                       , tycomp   = zeroComps
                       }
    fun freq ( n : int ) : AuxInfo = { coverage = n, label = NONE, tycomp = zeroComps }

    (* Some tokens to use *)
    val tint1  : Token = Pint 1
    val tint2  : Token = Pint 22
    val tint3  : Token = Pint 333
    val tint4  : Token = Pint 4444
    val tint5  : Token = Pint 55555
    val tint6  : Token = Pint 666666
    val tint7  : Token = Pint 7777777
    val tint8  : Token = Pint 88888888
    val tint9  : Token = Pint 999999999
    val tint10 : Token = Pint 1000000000
    val tip1   : Token = Pip "100.034.176.202"
    val tip2   : Token = Pip "101.034.176.102"
    val tip3   : Token = Pip "102.777.555.333"
    val tbxml1 : Token = PbXML ("<tag>some junk1</tag>", "attribute1") (* length 31 *)
    val tbxml2 : Token = PbXML ("<tag>more junk2</tag>", "attribute2") (* length 31 *)
    val tbxml3 : Token = PbXML ("<tag>more junk3</tag>", "attribute2") (* length 31 *)
    val texml1 : Token = PeXML ("<tag>some junk1</tag>", "attribute1") (* length 31 *)
    val texml2 : Token = PeXML ("<tag>more junk2</tag>", "attribute2") (* length 31 *)
    val texml3 : Token = PeXML ("<tag>more junk3</tag>", "attribute2") (* length 31 *)
    val ttime1 : Token = Ptime "12:12:12"
    val ttime2 : Token = Ptime "01:23:45"
    val ttime3 : Token = Ptime "12:34:56"
    val ttime4 : Token = Ptime "12:12:12pm +0700"
    val tstr1  : Token = Pstring "12:12:12"                    (* length 8 *)
    val tstr2  : Token = Pstring "HIGH THEIR"                  (* length 10 *)
    val tstr3  : Token = Pstring "Gupe nga lata!!"             (* length 15 *)
    val tstr4  : Token = Pstring "Cant parse this (mj hammer)" (* length 27 *)
    val tstr5  : Token = Pstring "" (* Zero length string *)
    val tstr6  : Token = Pstring "12:12:12pm +0700"
    val tgrp1  : Token = Pgroup { left  = (tip1, ln1)
                                , body  = [ (tip2, ln2) ]
                                , right = (tip1, ln1)
                                }
    val twht1  : Token = Pwhite "  "          (* length 2 *)
    val twht2  : Token = Pwhite "\t\t\t\t  "  (* length 6 *)
    val toth1  : Token = Other #"a"
    val toth2  : Token = Other #"b"
    val toth3  : Token = Other #"c"
    val temp1  : Token = Pempty
    val terr1  : Token = Error
    (* Some contexts to use *)
    val ctxt1  : Context = [ ( tstr2, ln1 ), ( twht1, ln2 ), ( toth2, ln3 ) ]
    val ctxt2  : Context = [ ( tip2, ln1 ), ( tint2, ln2 ), ( tstr5, ln3 ) ]

    (* Some token lists to use *)
    val ltl1     : LToken list = [ ( tint1, ln1 ) ]
    val ltl2     : LToken list = [ ( tint1, ln1 ), ( tint2, ln2 ), ( tint4, ln2 )
                                 , ( tint5, ln3 ) ]
    val ltlip1   : LToken list = [ ( tip1, ln1 ), ( tip2, ln2 ), ( tip3, ln3 ) ]
    val ltlbxml1 : LToken list = [ ( tbxml1, ln1 ) ]
    val ltlbxml2 : LToken list = [ ( tbxml2, ln1 ) ]
    val ltlbxml3 : LToken list = [ ( tbxml1, ln1 ), ( tbxml2, ln2 ), ( tbxml3,ln3 ) ]
    val ltlexml1 : LToken list = [ ( texml1, ln1 ) ]
    val ltlexml2 : LToken list = [ ( texml2, ln1 ) ]
    val ltlexml3 : LToken list = [ ( texml1, ln1 ), ( texml2, ln2 ), ( texml3, ln3 ) ]
    val ltltime1 : LToken list = [ ( ttime1, ln1 ) ]
    val ltltime2 : LToken list = [ ( ttime2, ln1 ) ]
    val ltltime3 : LToken list = [ ( ttime1, ln1 ), ( ttime2, ln2 ), ( ttime3, ln3 ) ]
    val ltltime4 : LToken list = [ ( ttime4, ln1 ) ]
    val ltlstr1  : LToken list = [ ( tstr1, ln4 ) ]
    val ltlstr2  : LToken list = [ ( tstr6, ln4 ) ]
    val ltlstr3  : LToken list = [ ( tstr2, ln4 ) ]
    val ltlstr4  : LToken list = [ ( tstr1, ln1 ), ( tstr2, ln2 )
                                 , ( tstr3, ln3 ), ( tstr4, ln4 )
                                 ]
    val ltlstr5  : LToken list = [ ( tstr5, ln4 ) ]
    val ltlgrp1  : LToken list = [ ( tgrp1, ln1 ) ]
    val ltlwht2  : LToken list = [ ( twht1, ln1 ), ( twht2, ln2 ) ]
    val ltloth3  : LToken list = [ ( toth1, ln1 ), ( toth2, ln2 ), ( toth3, ln3 ) ]
    val ltlemp1  : LToken list = [ ( temp1, ln1 ) ]
    val ltlerr1  : LToken list = [ ( terr1, ln1 ) ]
    val ltlint2  : LToken list = [ ( tint2, ln2 ) ]

    (* Some refined base types to use *)
    val rsme1  : Refined = StringME "one"
    val rsme2  : Refined = StringME "four"
    val rsme3  : Refined = StringME "three"
    val rint1  : Refined = Int ( 4, 7 )
    val rint2  : Refined = Int ( 444, 777 )
    val rintc1 : Refined = IntConst 83838383838
    val rstr1  : Refined = StringConst "abcdefgh"
    val rstr2  : Refined = StringConst "a"
    val rstr3  : Refined = StringConst "b"
    val rstr4  : Refined = StringConst "" (* Zero length string *)
    val renum1 : Refined = Enum [ rintc1, rstr1 ]
    val rlbl1  : Refined = LabelRef (Atom.atom "label")
    val rintc2 : Refined = IntConst 0

    (* Some Base Ty structures to use *)
    val ty1  : Ty = Base ( a1, [] )
    val ty2  : Ty = Base ( a1, ltl2 )
    val ty3  : Ty = Base ( freq 100, ltlip1 )
    val ty4  : Ty = Base ( a1, ltlbxml3  )
    val ty5  : Ty = Base ( a1, ltlexml3 )
    val ty6  : Ty = Base ( a1, ltltime3 )
    val ty7  : Ty = Base ( a1, ltlstr4 )
    val ty8  : Ty = Base ( a1, ltlgrp1 )
    val ty9  : Ty = Base ( freq 100, ltlwht2 )
    val ty10 : Ty = Base ( freq 100, ltloth3 )
    val ty11 : Ty = Base ( a1, ltlemp1 )
    val ty12 : Ty = Base ( a1, ltlerr1 )
    val ty13 : Ty = Base ( a1, ltlstr5 )
    val ty14 : Ty = Base ( freq 100, ltlstr2 )
    val ty15 : Ty = Base ( freq 900, ltlint2 )

    (* Some RefinedBase Ty structures to use *)
    val ty20 : Ty = RefinedBase ( a1, rsme1, ltlstr4 )
    val ty21 : Ty = RefinedBase ( freq 100, rint1, ltl2 )
    val ty22 : Ty = RefinedBase ( freq 100, rintc1, ltl2 )
    val ty23 : Ty = RefinedBase ( freq 900, rstr1, ltlstr4 )
    val ty24 : Ty = RefinedBase ( a1, renum1, ltlstr4 )
    val ty25 : Ty = RefinedBase ( a1, rlbl1, [] )
    val ty26 : Ty = RefinedBase ( a1, rstr4, ltlstr4 )
    val ty27 : Ty = RefinedBase ( a1, rintc2, ltl2 )

    (* Now to test structured, but unrefined types *)
    val ty30 : Ty = Pstruct ( a1, [ ty3, ty9, ty21, ty10 ] )
    val ty31 : Ty = Punion  ( a1, [ ty3, ty9, ty21, ty10 ] )
    val ty32 : Ty = Parray  ( a1, { tokens  = []
                                  , lengths = [ ( 6, 12 ) ]
                                  , first   = ty3
                                  , body    = ty9
                                  , last    = ty10
                                  }
                            )
    val ty33 : Ty = TBD    ( a1, 12, [ ctxt1, ctxt2 ] )
    val ty34 : Ty = Bottom ( a1, 12, [ ctxt1, ctxt2 ] )

    (* Test refined structures *)
    val ty40 : Ty = Switch ( a1
                           , Atom.atom "Switch1"
                           , [ ( rintc1, ty22 ), ( rstr1, ty23 ) ]
                           )
    val ty41 : Ty = RArray ( a1
                           , NONE
                           , NONE
                           , ty9
                           , NONE
                           , [ ( 6, 12 ) ]
                           )
    (*--------------------------------------------------------------------
      Comparison 1: Ptime "12:12:12" vs Pstring "12:12:12"
      --------------------------------------------------------------------*)
    val ty50  : Ty = Base (a1, ltltime1)
    val ty51  : Ty = Base (a1, ltlstr1)
    val ty52  : Ty = Base (a1, ltltime4)
    val ty53  : Ty = Base (a1, ltlstr2)
    val ty54  : Ty = Punion (a1, [ ty14, ty15 ] )
    val ty55  : Ty = Switch ( a1
                           , Atom.atom "Switch2"
                           , [ ( rstr2, ty14 ), ( rstr3, ty15 ) ]
                           )


    (* Carry out the measurements on the Ty structures *)
    val m1  : Ty = measure ty1;
    val p1  : string = showTyComp (getComps m1);
    val m2  : Ty = measure ty2;
    val p2  : string = showTyComp (getComps m2);
    val m3  : Ty = measure ty3;
    val p3  : string = showTyComp (getComps m3);
    val m4  : Ty = measure ty4;
    val p4  : string = showTyComp (getComps m4);
    val m5  : Ty = measure ty5;
    val p5  : string = showTyComp (getComps m5);
    val m6  : Ty = measure ty6;
    val p6  : string = showTyComp (getComps m6);
    val m7  : Ty = measure ty7;
    val p7  : string = showTyComp (getComps m7);
    val m8  : Ty = measure ty8;
    val p8  : string = showTyComp (getComps m8);
    val m9  : Ty = measure ty9;
    val p9  : string = showTyComp (getComps m9);
    val m10 : Ty = measure ty10;
    val p10 : string = showTyComp (getComps m10);
    val m11 : Ty = measure ty11;
    val p11 : string = showTyComp (getComps m11);
    val m12 : Ty = measure ty12;
    val p12 : string = showTyComp (getComps m12);
    val m13 : Ty = measure ty13;
    val p13 : string = showTyComp (getComps m13);
    val m14 : Ty = measure ty14;
    val p14 : string = showTyComp (getComps m14);
    val m15 : Ty = measure ty15;
    val p15 : string = showTyComp (getComps m15);

    val m20 : Ty = measure ty20;
    val p20 : string = showTyComp (getComps m20);
    val m21 : Ty = measure ty21;
    val p21 : string = showTyComp (getComps m21);
    val m22 : Ty = measure ty22;
    val p22 : string = showTyComp (getComps m22);
    val m23 : Ty = measure ty23;
    val p23 : string = showTyComp (getComps m23);
    val m24 : Ty = measure ty24;
    val p24 : string = showTyComp (getComps m24);
    val (RefinedBase (a24, r24, tl24)) = m24;
    val (Enum rl) = r24;
    val m25 : Ty = measure ty25;
    val p25 : string = showTyComp (getComps m25);
    val m26 : Ty = measure ty26;
    val p26 : string = showTyComp (getComps m26);
    val m27 : Ty = measure ty27;
    val p27 : string = showTyComp (getComps m27);

    val m30 : Ty = measure ty30;
    val p30 : string = showTyComp (getComps m30);
    val m31 : Ty = measure ty31;
    val p31 : string = showTyComp (getComps m31);
    val m32 : Ty = measure ty32;
    val p32 : string = showTyComp (getComps m32);
    val (Parray (a32, s32)) = m32;
    val m33 : Ty = measure ty33;
    val p33 : string = showTyComp (getComps m33);
    val m34 : Ty = measure ty34;
    val p34 : string = showTyComp (getComps m34);

    val m40 : Ty = measure ty40;
    val m41 : Ty = measure ty41;
    val (RArray (a40, osep40, oterm40, body40, olen40, lens)) = m41;

    val m50 : Ty = measure ty50;
    val m51 : Ty = measure ty51;
    val m52 : Ty = measure ty52;
    val m53 : Ty = measure ty53;
    val m54 : Ty = measure ty54;
    val m55 : Ty = measure ty55;
    val (Switch (a55, id55, brs55)) = m55;
    val (Base (a55a,ltl55a)) = #2 (hd brs55)
    val (Base (a55b,ltl55b)) = #2 (hd (tl brs55))

end
