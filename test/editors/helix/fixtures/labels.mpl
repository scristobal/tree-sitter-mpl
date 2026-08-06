// Tag and label names are members in every pipeline context.
telemetry:requests
| filter route == "api" and status_code >= 500
//^^^^^^ @keyword
//       ^^^^^ @variable.other.member
//             ^^ @operator
//                      ^^^ @keyword.operator
//                          ^^^^^^^^^^^ @variable.other.member
//                                      ^^ @operator
| group by service, region using stats::p95
//^^^^^ @keyword
//      ^^ @keyword
//         ^^^^^^^ @variable.other.member
//                ^ @punctuation.delimiter
//                  ^^^^^^ @variable.other.member
| bucket by le, shard to 1m using histogram(count)
//^^^^^^ @keyword
//       ^^ @keyword
//          ^^ @variable.other.member
//            ^ @punctuation.delimiter
//              ^^^^^ @variable.other.member
| join method, status from archive:latency by method, zone
//^^^^ @keyword
//     ^^^^^^ @variable.other.member
//           ^ @punctuation.delimiter
//             ^^^^^^ @variable.other.member
//                    ^^^^ @keyword
//                         ^^^^^^^ @namespace
//                                ^ @punctuation.delimiter
//                                 ^^^^^^^ @function
//                                         ^^ @keyword
//                                            ^^^^^^ @variable.other.member
//                                                  ^ @punctuation.delimiter
//                                                    ^^^^ @variable.other.member
| replace renamed = original ~ #s/old/new/
//^^^^^^^ @keyword
//        ^^^^^^^ @variable.other.member
//                ^ @operator
//                  ^^^^^^^^ @variable.other.member
//                           ^ @operator
//                             ^^^^^^^^^^^ @string.regexp
| replace legacy ~ #s/v1/v2/
//        ^^^^^^ @variable.other.member
//               ^ @operator
//                 ^^^^^^^^^ @string.regexp
| extend normalized = service, fixed = "yes"
//^^^^^^ @keyword
//       ^^^^^^^^^^ @variable.other.member
//                  ^ @operator
//                    ^^^^^^^ @variable.other.member
//                           ^ @punctuation.delimiter
//                             ^^^^^ @variable.other.member
