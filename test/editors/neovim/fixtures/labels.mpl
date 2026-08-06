// Tag and label names are members in every pipeline context.
telemetry:requests
| filter route == "api" and status_code >= 500
//^^^^^^ keyword
//       ^^^^^ variable.member
//             ^^ operator
//                      ^^^ keyword.operator
//                          ^^^^^^^^^^^ variable.member
//                                      ^^ operator
| group by service, region using stats::p95
//^^^^^ keyword
//      ^^ keyword
//         ^^^^^^^ variable.member
//                ^ punctuation.delimiter
//                  ^^^^^^ variable.member
| bucket by le, shard to 1m using histogram(count)
//^^^^^^ keyword
//       ^^ keyword
//          ^^ variable.member
//            ^ punctuation.delimiter
//              ^^^^^ variable.member
| join method, status from archive:latency by method, zone
//^^^^ keyword
//     ^^^^^^ variable.member
//           ^ punctuation.delimiter
//             ^^^^^^ variable.member
//                    ^^^^ keyword
//                         ^^^^^^^ module
//                                ^ punctuation.delimiter
//                                 ^^^^^^^ function
//                                         ^^ keyword
//                                            ^^^^^^ variable.member
//                                                  ^ punctuation.delimiter
//                                                    ^^^^ variable.member
| replace renamed = original ~ #s/old/new/
//^^^^^^^ keyword
//        ^^^^^^^ variable.member
//                ^ operator
//                  ^^^^^^^^ variable.member
//                           ^ operator
//                             ^^^^^^^^^^^ string.regexp
| replace legacy ~ #s/v1/v2/
//        ^^^^^^ variable.member
//               ^ operator
//                 ^^^^^^^^^ string.regexp
| extend normalized = service, fixed = "yes"
//^^^^^^ keyword
//       ^^^^^^^^^^ variable.member
//                  ^ operator
//                    ^^^^^^^ variable.member
//                           ^ punctuation.delimiter
//                             ^^^^^ variable.member
