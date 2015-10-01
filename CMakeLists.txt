cmake_minimum_required(VERSION 2.8.11)

project(rocksdb)

if (NOT (CMAKE_MAJOR_VERSION LESS 3))
  # Tweak policies (this one disables "missing" dependency warning)
  cmake_policy(SET CMP0046 OLD)
endif(NOT (CMAKE_MAJOR_VERSION LESS 3))

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake/modules/")

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -g -O2 -fPIC -Wall -Werror -DOS_LINUX -DROCKSDB_PLATFORM_POSIX -fno-builtin-memcmp -DNDEBUG -DHAVE_JEMALLOC -Woverloaded-virtual")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g -O2 -fPIC -std=c++11 -Wall -Werror -DOS_LINUX -DROCKSDB_PLATFORM_POSIX -fno-builtin-memcmp -DNDEBUG -DHAVE_JEMALLOC -Woverloaded-virtual -DROCKSDB_ATOMIC_PRESENT -DROCKSDB_FALLOCATE_PRESENT")

find_package(atomic_ops)
if(ATOMIC_OPS_FOUND)
  #message(STATUS "Lib Atomic Found")
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DROCKSDB_ATOMIC_PRESENT")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DROCKSDB_ATOMIC_PRESENT")
endif(ATOMIC_OPS_FOUND)

include(CheckFunctionExists)
CHECK_FUNCTION_EXISTS(fallocate WITH_FALLOCATE)
if(WITH_FALLOCATE)
  #message(STATUS "Fallocate Exists")
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DROCKSDB_FALLOCATE_PRESENTN")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DROCKSDB_FALLOCATE_PRESENT")
endif(WITH_FALLOCATE)

add_custom_command(OUTPUT ${CMAKE_SOURCE_DIR}/util/build_version.cc
  COMMAND 
  chmod 775 ${CMAKE_SOURCE_DIR}/build_version.sh &&
  ${CMAKE_SOURCE_DIR}/build_version.sh
  WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
  COMMENT "build_version.cc updated")

include_directories(${CMAKE_SOURCE_DIR})
include_directories(${CMAKE_SOURCE_DIR}/include)
include_directories(${CMAKE_SOURCE_DIR}/third-party/gtest-1.7.0/fused-src/)

set(rocksdb_srcs
  db/builder.cc 
  db/c.cc 
  db/column_family.cc 
  db/compaction.cc 
  db/compaction_job.cc 
  db/compaction_picker.cc 
  db/db_filesnapshot.cc 
  db/dbformat.cc 
  db/db_impl.cc 
  db/db_impl_debug.cc 
  db/db_impl_readonly.cc 
  db/db_iter.cc 
  db/event_logger_helpers.cc 
  db/file_indexer.cc 
  db/filename.cc 
  db/flush_job.cc 
  db/flush_scheduler.cc 
  db/forward_iterator.cc 
  db/internal_stats.cc 
  db/log_reader.cc 
  db/log_writer.cc 
  db/managed_iterator.cc 
  db/memtable_allocator.cc 
  db/memtable.cc 
  db/memtable_list.cc 
  db/merge_helper.cc 
  db/merge_operator.cc 
  db/repair.cc 
  db/slice.cc 
  db/table_cache.cc 
  db/table_properties_collector.cc 
  db/transaction_log_impl.cc 
  db/version_builder.cc 
  db/version_edit.cc 
  db/version_set.cc 
  db/wal_manager.cc 
  db/write_batch.cc 
  db/write_batch_base.cc 
  db/write_controller.cc 
  db/write_thread.cc 
  port/stack_trace.cc 
  port/port_posix.cc 
  table/adaptive_table_factory.cc 
  table/block_based_filter_block.cc 
  table/block_based_table_builder.cc 
  table/block_based_table_factory.cc 
  table/block_based_table_reader.cc 
  table/block_builder.cc 
  table/block.cc 
  table/block_hash_index.cc 
  table/block_prefix_index.cc 
  table/bloom_block.cc 
  table/cuckoo_table_builder.cc 
  table/cuckoo_table_factory.cc 
  table/cuckoo_table_reader.cc 
  table/flush_block_policy.cc 
  table/format.cc 
  table/full_filter_block.cc 
  table/get_context.cc 
  table/iterator.cc 
  table/merger.cc 
  table/meta_blocks.cc 
  table/plain_table_builder.cc 
  table/plain_table_factory.cc 
  table/plain_table_index.cc 
  table/plain_table_key_coding.cc 
  table/plain_table_reader.cc 
  table/table_properties.cc 
  table/two_level_iterator.cc 
  util/arena.cc 
  util/auto_roll_logger.cc 
  util/bloom.cc 
  util/build_version.cc 
  util/cache.cc 
  util/coding.cc 
  util/comparator.cc 
  util/crc32c.cc 
  util/db_info_dumper.cc 
  util/dynamic_bloom.cc 
  util/env.cc 
  util/env_hdfs.cc 
  util/env_posix.cc 
  util/file_util.cc 
  util/filter_policy.cc 
  util/hash.cc 
  util/hash_cuckoo_rep.cc 
  util/hash_linklist_rep.cc 
  util/hash_skiplist_rep.cc 
  util/histogram.cc 
  util/instrumented_mutex.cc 
  util/iostats_context.cc 
  utilities/backupable/backupable_db.cc 
  utilities/convenience/convenience.cc 
  utilities/checkpoint/checkpoint.cc 
  utilities/compacted_db/compacted_db_impl.cc 
  utilities/document/document_db.cc 
  utilities/document/json_document_builder.cc 
  utilities/document/json_document.cc 
  utilities/geodb/geodb_impl.cc 
  utilities/leveldb_options/leveldb_options.cc 
  utilities/merge_operators/put.cc 
  utilities/merge_operators/string_append/stringappend2.cc 
  utilities/merge_operators/string_append/stringappend.cc 
  utilities/merge_operators/uint64add.cc 
  utilities/redis/redis_lists.cc 
  utilities/spatialdb/spatial_db.cc 
  utilities/ttl/db_ttl_impl.cc 
  utilities/write_batch_with_index/write_batch_with_index.cc 
  util/event_logger.cc 
  util/ldb_cmd.cc 
  util/ldb_tool.cc 
  util/log_buffer.cc 
  util/logging.cc 
  util/memenv.cc 
  util/murmurhash.cc 
  util/mutable_cf_options.cc 
  util/options_builder.cc 
  util/options.cc 
  util/options_helper.cc 
  util/perf_context.cc 
  util/rate_limiter.cc 
  util/skiplistrep.cc 
  util/slice.cc 
  util/sst_dump_tool.cc 
  util/statistics.cc 
  util/status.cc 
  util/string_util.cc 
  util/sync_point.cc 
  util/thread_local.cc 
  util/thread_status_impl.cc 
  util/thread_status_updater.cc 
  util/thread_status_updater_debug.cc 
  util/thread_status_util.cc 
  util/thread_status_util_debug.cc 
  util/vectorrep.cc 
  util/xfunc.cc 
  util/xxhash.cc)

add_library(rocksdb ${rocksdb_srcs})

find_package(snappy)
if(SNAPPY_FOUND)
  #message(STATUS "Snappy Found")
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DSNAPPY")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DSNAPPY")
  target_link_libraries(rocksdb snappy)
endif(SNAPPY_FOUND)

find_package(tcmalloc)
if(Tcmalloc_FOUND)
  #message(STATUS "Lib Snappy Found")
  target_link_libraries(rocksdb tcmalloc)
  find_package(rt)
  if(RT_FOUND)
    #message(STATUS "Lib RT Found")
    target_link_libraries(rocksdb rt)
  endif(RT_FOUND)
endif(Tcmalloc_FOUND)

include(FindZLIB)
find_package(ZLIB)
if(ZLIB_FOUND)
  #message(STATUS "ZLib Found")
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DZLIB")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DZLIB")
  target_link_libraries(rocksdb z)
endif(ZLIB_FOUND)

include(FindBZip2)
find_package(BZip2)
if(BZIP2_FOUND)
  #message(STATUS "BZip2 Found")
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DBZIP2")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DBZIP2")
  target_link_libraries(rocksdb bz2)
endif(BZIP2_FOUND)

find_package(gflags)
if(GFLAGS_FOUND)
  #message(STATUS "GFlags Found")
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DGFLAGS")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DFLAGS")
  target_link_libraries(rocksdb gflags)
endif(GFLAGS_FOUND)

target_link_libraries(rocksdb pthread)

