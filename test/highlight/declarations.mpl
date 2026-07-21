// Directive and parameter declarations retain their semantic roles.
set resolution = default_resolution;
// <- keyword.directive
//  ^^^^^^^^^^ attribute
//             ^ operator
//               ^^^^^^^^^^^^^^^^^^ constant
//                                 ^ punctuation.delimiter

set enabled = true;
// <- keyword.directive
//  ^^^^^^^ attribute
//          ^ operator
//            ^^^^ boolean

param $dataset: Dataset;
// <- keyword.directive
//    ^ punctuation.special
//     ^^^^^^^ variable.parameter
//            ^ punctuation.delimiter
//              ^^^^^^^ type.builtin

param $window: Option<Duration>;
//     ^^^^^^ variable.parameter
//             ^^^^^^ type.builtin
//                   ^ punctuation.bracket
//                    ^^^^^^^^ type.builtin
//                            ^ punctuation.bracket

param $matcher: Regex;
//              ^^^^^ type.builtin
param $text: string;
//           ^^^^^^ type.builtin
param $count: int;
//            ^^^ type.builtin
param $ratio: float;
//            ^^^^^ type.builtin
param $active: bool;
//             ^^^^ type.builtin
param $step: duration;
//           ^^^^^^^^ type.builtin

  $dataset:requests as request_rate
//^ punctuation.special
// ^^^^^^^ variable.parameter
//        ^ punctuation.delimiter
//         ^^^^^^^^ function
//                  ^^ keyword
//                     ^^^^^^^^^^^^ variable
