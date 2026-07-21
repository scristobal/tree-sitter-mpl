// Function paths distinguish modules from the called function.
telemetry:latency
| align to 1m over 5m using stats::window::percentile
// <- punctuation.delimiter
//^^^^^ keyword
//      ^^ keyword
//         ^^ number
//            ^^^^ keyword
//                 ^^ number
//                    ^^^^^ keyword
//                          ^^^^^ module
//                               ^^ punctuation.delimiter
//                                 ^^^^^^ module
//                                       ^^ punctuation.delimiter
//                                         ^^^^^^^^^^ function.call
| group by service using summarize
// <- punctuation.delimiter
//^^^^^ keyword
//      ^^ keyword
//         ^^^^^^^ variable.member
//                 ^^^^^ keyword
//                       ^^^^^^^^^ function.call
| map math::scale(2)
// <- punctuation.delimiter
//^^^ keyword
//    ^^^^ module
//        ^^ punctuation.delimiter
//          ^^^^^ function.call
//               ^ punctuation.bracket
//                ^ number
//                 ^ punctuation.bracket

// MPL's named aggregation and bucket functions are builtins.
| align using rate
//^^^^^ keyword
//      ^^^^^ keyword
//            ^^^^ function.builtin
| group using increase
//^^^^^ keyword
//      ^^^^^ keyword
//            ^^^^^^^^ function.builtin
| group using count
//            ^^^^^ function.builtin
| group using avg
//            ^^^ function.builtin
| group using sum
//            ^^^ function.builtin
| group using min
//            ^^^ function.builtin
| group using max
//            ^^^ function.builtin
| bucket using histogram()
//^^^^^^ keyword
//       ^^^^^ keyword
//             ^^^^^^^^^ function.builtin
| bucket using interpolate_delta_histogram()
//             ^^^^^^^^^^^^^^^^^^^^^^^^^^^ function.builtin
| bucket using interpolate_cumulative_histogram(rate, count)
//             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ function.builtin
//                                                  ^ punctuation.delimiter
