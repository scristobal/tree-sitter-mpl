param $dataset: Dataset;
param $limit: Option<int>;

$dataset:`metric.name`[1h..]
| ifdef($limit) { where message == "value ${$limit}" }
| where code < 500
