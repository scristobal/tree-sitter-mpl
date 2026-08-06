// Datasets, metric names, aliases, and generated names are not function calls.
(
  telemetry:errors as failures,
//^^^^^^^^^ @namespace
//         ^ @punctuation.delimiter
//          ^^^^^^ @function
//                 ^^ @keyword
//                    ^^^^^^^^ @variable
  $dataset:requests as total
//^ @punctuation.special
// ^^^^^^^ @variable.parameter
//        ^ @punctuation.delimiter
//         ^^^^^^^^ @function
//                  ^^ @keyword
//                     ^^^^^ @variable
   )
// ^ @punctuation.bracket
   | compute error_rate using math::safe::divide
// ^ @punctuation.delimiter
   //^^^^^^^ @keyword
   //        ^^^^^^^^^^ @variable
   //                   ^^^^^ @keyword
   //                         ^^^^ @namespace
   //                             ^^ @punctuation.delimiter
   //                               ^^^^ @namespace
   //                                   ^^ @punctuation.delimiter
   //                                     ^^^^^^ @function
   | as combined
// ^ @punctuation.delimiter
   //^^ @keyword
   //   ^^^^^^^^ @variable
