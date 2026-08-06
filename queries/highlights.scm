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

; Bucket functions and arguments are grammar keywords rather than identifiers.
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
] @function.builtin

(bucket_by_with_conversion_fn) @function.builtin

(comment) @comment

; Parameters retain their sigil without allowing the nested identifier to
; acquire a competing generic variable capture.
(param_ident
  "$" @punctuation.special
  (identifier) @variable.parameter)

; Metric identifiers consist of a dataset and a metric name. A parameterized
; dataset is already handled by the param_ident pattern above.
(metric_id
  dataset: (identifier) @module)

(metric_id
  name: (metric_name
    (identifier) @function))

; Names introduced for a metric stream.
(as_clause
  alias: (metric_name
    (identifier) @variable))

(compute_rule
  name: (metric_name
    (identifier) @variable))

; Directive names are attributes of the query. An unquoted identifier in a
; directive value is a constant, not another declaration.
(directive
  name: (identifier) @attribute)

(directive
  value: (identifier) @constant)

; Tags and tag references.
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

; A qualified callable is highlighted component-by-component instead of as a
; single range, so e.g. prom::rate has a module and a terminal function.
(module
  (identifier) @module)

(func
  (identifier) @function.builtin
  (#any-of? @function.builtin
    "abs"
    "avg"
    "const"
    "count"
    "eq"
    "gt"
    "gte"
    "histogram"
    "increase"
    "interpolate_cumulative_histogram"
    "interpolate_delta_histogram"
    "last"
    "linear"
    "lt"
    "lte"
    "max"
    "min"
    "neq"
    "prev"
    "rate"
    "sum"))

(func
  (identifier) @function
  (#not-any-of? @function
    "abs"
    "avg"
    "const"
    "count"
    "eq"
    "gt"
    "gte"
    "histogram"
    "increase"
    "interpolate_cumulative_histogram"
    "interpolate_delta_histogram"
    "last"
    "linear"
    "lt"
    "lte"
    "max"
    "min"
    "neq"
    "prev"
    "rate"
    "sum"))

(string) @string
(escape_sequence) @string

(regex) @string
(regex_replace) @string

[
  (int)
  (float)
  (inf)
  (time_relative)
  (time_rfc_3339)
  (time_timestamp)
] @number

(bool) @constant.builtin

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

; Interpolation braces override both the containing string and generic braces.
(interpolation
  ["${" "}"] @punctuation.special)

; Angle brackets delimit Option<T>; angle comparisons are operators.
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
