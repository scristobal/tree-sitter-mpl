// Option brackets and comparison operators have deliberately different captures.
param $limit: Option<int>;
//    ^ @punctuation.special
//     ^^^^^ @variable.parameter
//          ^ @punctuation.delimiter
//            ^^^^^^ @type.builtin
//                  ^ @punctuation.bracket
//                   ^^^ @type.builtin
//                      ^ @punctuation.bracket
//                       ^ @punctuation.delimiter

telemetry:requests[1h..]
//       ^ @punctuation.delimiter
//                ^ @punctuation.bracket
//                 ^^ @constant.numeric
//                   ^^ @punctuation.delimiter
//                     ^ @punctuation.bracket
   | filter (small < $limit and large > 0) or exact == 1
// ^ @punctuation.delimiter
   //^^^^^^ @keyword
   //       ^ @punctuation.bracket
   //        ^^^^^ @variable.other.member
   //              ^ @operator
   //                ^ @punctuation.special
   //                 ^^^^^ @variable.parameter
   //                       ^^^ @keyword.operator
   //                           ^^^^^ @variable.other.member
   //                                 ^ @operator
   //                                    ^ @punctuation.bracket
   //                                      ^^ @keyword.operator
   //                                         ^^^^^ @variable.other.member
   //                                               ^^ @operator
| where not state != "off" and lower <= 1 and upper >= 2 and ready is bool
//^^^^^ @keyword
//      ^^^ @keyword.operator
//          ^^^^^ @variable.other.member
//                ^^ @operator
//                         ^^^ @keyword.operator
//                             ^^^^^ @variable.other.member
//                                   ^^ @operator
//                                        ^^^ @keyword.operator
//                                            ^^^^^ @variable.other.member
//                                                  ^^ @operator
//                                                       ^^^ @keyword.operator
//                                                           ^^^^^ @variable.other.member
//                                                                 ^^ @keyword.operator
//                                                                    ^^^^ @type.builtin
| ifdef($limit) { filter flag == true } else { where flag != false }
//^^^^^ @keyword
//     ^ @punctuation.bracket
//      ^ @punctuation.special
//       ^^^^^ @variable.parameter
//            ^ @punctuation.bracket
//              ^ @punctuation.bracket
//                ^^^^^^ @keyword
//                                    ^ @punctuation.bracket
//                                      ^^^^ @keyword
//                                           ^ @punctuation.bracket
//                                             ^^^^^ @keyword
//                                                                 ^ @punctuation.bracket
   | map + 1
// ^ @punctuation.delimiter
   //^^^ @keyword
   //    ^ @operator
| map - 2
//    ^ @operator
| map * 3
//    ^ @operator
| map / 4
//    ^ @operator
