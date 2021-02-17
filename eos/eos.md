### 控制虚拟机类型枚举  
``` C++
// 对于调试而言，一个重要的控制就是是否能打印出来完整的调用堆栈
const static eosio::chain::wasm_interface::vm_type default_wasm_runtime = eosio::chain::wasm_interface::vm_type::wavm;

class wasm_interface {
      public:
         enum class vm_type {
            wavm, // 发布版本
            wabt  // 调试版本
         };
}
```
### eos代码中注册虚拟机函数
```C++
REGISTER_INTRINSICS( database_api,
   (db_store_i64,        int(int64_t,int64_t,int64_t,int64_t,int,int))
   (db_update_i64,       void(int,int64_t,int,int))
   (db_remove_i64,       void(int))
   (db_get_i64,          int(int, int, int))
   (db_next_i64,         int(int, int))
   (db_previous_i64,     int(int, int))
   (db_find_i64,         int(int64_t,int64_t,int64_t,int64_t))
   (db_lowerbound_i64,   int(int64_t,int64_t,int64_t,int64_t))
   (db_upperbound_i64,   int(int64_t,int64_t,int64_t,int64_t))
   (db_end_i64,          int(int64_t,int64_t,int64_t))
);
```
### 智能合约中使用上面注册的函数{在eosio.cdt(multi_index.hpp)}
```C++
extern "C" {
      __attribute__((eosio_wasm_import))
      int32_t db_store_i64(uint64_t, uint64_t, uint64_t, uint64_t,  const void*, uint32_t);

      __attribute__((eosio_wasm_import))
      void db_update_i64(int32_t, uint64_t, const void*, uint32_t);

      __attribute__((eosio_wasm_import))
      void db_remove_i64(int32_t);

      __attribute__((eosio_wasm_import))
      int32_t db_get_i64(int32_t, const void*, uint32_t);

      __attribute__((eosio_wasm_import))
      int32_t db_next_i64(int32_t, uint64_t*);

      __attribute__((eosio_wasm_import))
      int32_t db_previous_i64(int32_t, uint64_t*);

      __attribute__((eosio_wasm_import))
      int32_t db_find_i64(uint64_t, uint64_t, uint64_t, uint64_t);

      __attribute__((eosio_wasm_import))
      int32_t db_lowerbound_i64(uint64_t, uint64_t, uint64_t, uint64_t);

      __attribute__((eosio_wasm_import))
      int32_t db_upperbound_i64(uint64_t, uint64_t, uint64_t, uint64_t);

      __attribute__((eosio_wasm_import))
      int32_t db_end_i64(uint64_t, uint64_t, uint64_t);
}
```
在智能合约端系统准备好了多索引容器可以直接使用（多索引容器大致使用了二级索引，一级表示代码的使用账户get_self()，二级表示操作的账户地址scope）    
在eos内部系统使用了特别的数据库，来支持对数据的回滚，具体参考如下的两个对象在eos中的实现方法
``` C++
chainbase::database            db;
chainbase::database            reversible_blocks; ///< a special database to persist blocks that have successfully been applied but are still reversible
```
通过以上的操作，完成了智能合约内部到eos内部的数据共享

### 问题
注册虚拟机函数的时候没有执行时间，时间是怎么控制的？   
这个是没有控制的，出块节点如果对本交易的时间认可就可以继续上链了 
### eosio.contracts安装
eosio.contracts 版本v1.7.2  
#### 依赖如下两个程序的版本，如果版本不对，将编译错误
eos 版本v1.8.16   
eosio.cdt 版本1.6.3  
