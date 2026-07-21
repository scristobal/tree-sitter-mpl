// Interpolation delimiters and parameter references override the containing string.
param $name: string;

telemetry:events
| filter message == "hello ${$name}!"
//                         ^^ punctuation.special
//                           ^ punctuation.special
//                            ^^^^ variable.parameter
//                                ^ punctuation.special
