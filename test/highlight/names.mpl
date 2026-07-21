// Datasets, metric names, aliases, and generated names are not function calls.
(
  telemetry:errors as failures,
//^^^^^^^^^ module
//         ^ punctuation.delimiter
//          ^^^^^^ function
//                 ^^ keyword
//                    ^^^^^^^^ variable
  $dataset:requests as total
//^ punctuation.special
// ^^^^^^^ variable.parameter
//        ^ punctuation.delimiter
//         ^^^^^^^^ function
//                  ^^ keyword
//                     ^^^^^ variable
)
// <- punctuation.bracket
| compute error_rate using math::safe::divide
// <- punctuation.delimiter
//^^^^^^^ keyword
//        ^^^^^^^^^^ variable
//                   ^^^^^ keyword
//                         ^^^^ module
//                             ^^ punctuation.delimiter
//                               ^^^^ module
//                                   ^^ punctuation.delimiter
//                                     ^^^^^^ function.call
| as combined
// <- punctuation.delimiter
//^^ keyword
//   ^^^^^^^^ variable
