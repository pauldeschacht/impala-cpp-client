// Copyright 2012 Cloudera Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

namespace cpp impala
namespace java com.cloudera.impala.thrift

include "Exprs.thrift"

enum TPartitionType {
  UNPARTITIONED,

  // round-robin partitioning
  RANDOM,

  // unordered partitioning on a set of exprs
  HASH_PARTITIONED,

  // ordered partitioning on a list of exprs
  RANGE_PARTITIONED
}

// Specification of how a single logical data stream is partitioned.
// This leaves out the parameters that determine the physical partitioning (for hash
// partitioning, the number of partitions; for range partitioning, the partitions'
// boundaries), which need to be specified by the enclosing structure/context.
struct TDataPartition {
  1: required TPartitionType type
  2: optional list<Exprs.TExpr> partitioning_exprs
}
