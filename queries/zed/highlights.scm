; Directives and declarations
[
  "set"
  "param"
] @keyword

; Pipeline keywords
[
  "sample"
  "filter"
  "where"
  "ifdef"
  "else"
  "extend"
  "align"
  "to"
  "over"
  "using"
  "group"
  "by"
  "bucket"
  "join"
  "from"
  "map"
  "replace"
  "as"
  "compute"
] @keyword

[
  "and"
  "or"
  "not"
  "is"
] @operator

[
  "Dataset"
  "Duration"
  "duration"
  "Regex"
  "Option"
  "string"
  "int"
  "float"
  "bool"
] @type.builtin

; Zed does not distinguish built-in functions from other functions.
[
  "rate"
  "increase"
  "histogram"
  "interpolate_delta_histogram"
  "count"
  "avg"
  "sum"
  "min"
  "max"
] @function

(bucket_by_with_conversion_fn) @function

(comment) @comment

(param_ident
  "$" @punctuation.special
  (identifier) @variable.parameter)

; Zed has no module capture, so datasets and qualified-name modules use type.
(metric_id
  dataset: (identifier) @type)

(metric_id
  name: (metric_name
    (identifier) @function))

(as_clause
  alias: (metric_name
    (identifier) @variable))

(compute_rule
  name: (metric_name
    (identifier) @variable))

(directive
  name: (identifier) @attribute)

(directive
  value: (identifier) @constant)

(filter_atom
  tag: (identifier) @property)

(tags
  (identifier) @property)

(expr
  (identifier) @property)

(extend_expr
  name: (identifier) @property)

(replace_tag
  tag: (identifier) @property)

(replace_rename
  name: (identifier) @property
  tag: (identifier) @property)

(replace_rename_tag
  name: (identifier) @property
  tag: (identifier) @property)

(module
  (identifier) @type)

(func
  (identifier) @function)

(string) @string
(escape_sequence) @string.escape

(regex) @string.regex
(regex_replace) @string.regex

[
  (int)
  (float)
  (inf)
  (time_relative)
  (time_rfc_3339)
  (time_timestamp)
] @number

(bool) @boolean

[
  "|"
  ":"
  "::"
  ","
  ";"
  ".."
] @punctuation.delimiter

[
  "("
  ")"
  "{"
  "}"
  "["
  "]"
] @punctuation.bracket

(interpolation
  ["${" "}"] @punctuation.special)

(optional_type
  ["<" ">"] @punctuation.bracket)

[
  (cmp)
  (cmp_re)
] @operator

[
  "="
  "+"
  "-"
  "*"
  "/"
  "~"
] @operator
