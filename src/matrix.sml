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
(******************************************************************************
 ** MATRIX.sml
 ** sml
 **
 ** Guy Blelloch
 ** Signature for the matrix library
 ******************************************************************************)

signature MATRIX =
    sig
	type matrix
	type colVec = matrix
	type rowVec = matrix

	type scalar
	type index
	type subscript = (index * index)
	type size      = (index * index)

	exception badDimension
	exception notInvertable

	val size : matrix -> size
	val nRows : matrix -> index
	val nCols : matrix -> index

	val identity : int -> matrix
	val matrix : (size * scalar) -> matrix

	val sub : (matrix * subscript) -> scalar

	val row : (matrix * index) -> rowVec
	val column : (matrix * index) -> colVec
	val rows : (matrix * index vector) -> matrix
	val columns : (matrix * index vector) -> matrix
	val subRegion : matrix * (index vector * index vector) -> matrix

	val insertElt : (matrix * subscript * scalar) -> matrix
	val insertElts : (matrix * (subscript * scalar) vector) -> matrix

	val updateElt : (scalar->scalar) -> (matrix * subscript) -> matrix

	val appendCols : (matrix * matrix) -> matrix
	val appendRows : (matrix * matrix) -> matrix

	val * : (matrix * matrix) -> matrix
	val + : (matrix * matrix) -> matrix
	val - : (matrix * matrix) -> matrix
	val scale : (matrix * scalar) -> matrix

	val trans : matrix -> matrix
	val toDiag : colVec -> matrix
	val fromDiag : matrix -> colVec

	val gaussJordan' : matrix -> matrix
	val inv : matrix -> matrix
	val det : matrix -> scalar
	val invDet : matrix -> (matrix * scalar)

	val solve : matrix * colVec -> colVec
	val crossProduct : matrix -> colVec
	val norm : matrix -> scalar

	val tabulate : (size * (subscript -> scalar)) -> matrix

	val map : (scalar -> scalar) -> matrix -> matrix
	val mapi : (subscript * scalar -> scalar) -> matrix -> matrix
	val map2 : (scalar * scalar -> scalar) -> matrix * matrix -> matrix

	val fold : (scalar * 'b -> 'b) -> 'b -> matrix -> 'b
	val foldi : (subscript * scalar * 'b -> 'b) -> 'b -> matrix -> 'b

	val fromArray2 : scalar Array2.array -> matrix
	val fromList : scalar list list -> matrix
	val toList : matrix -> scalar list list
	val toString : matrix -> string
	val toStringF : (scalar -> string) -> matrix -> string

    end

