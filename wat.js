const fs = require('fs');
const wabt = require('wabt')();

async function convertWasmToWat(wasmFilePath, watFilePath) {
  // 加载 WABT
  const wabtModule = await wabt.then(wabt => wabt);
  
  // 读取 WASM 文件
  const wasmBuffer = fs.readFileSync(wasmFilePath);
  
  // 解析 WASM 文件
  const module = wabtModule.readWasm(wasmBuffer, { 
    
    readDebugNames: true,
    exceptions: true,
    /** Import/export mutable globals. */
    mutable_globals:true,
    /** Saturating float-to-int operators. */
    sat_float_to_int:true,
    /** Sign-extension operators. */
    sign_extension:true,
    /** SIMD support. */
    simd: true,
    /** Threading support. */
    threads:true,
    /** Typed function references. */
    function_references: true,
    /** Multi-value. */
    multi_value:true,
    /** Tail-call support. */
    tail_call: true,
    /** Bulk-memory operations. */
    bulk_memory:true,
    /** Reference types (externref). */
    reference_types: true,
    /** Custom annotation syntax. */
    annotations: true,
    /** Code metadata. */
    code_metadata:true,
    /** Garbage collection. */
    gc: true,
    /** 64-bit memory */
    memory64: true,
    /** Extended constant expressions. */
    extended_const: true,
    /** Relaxed SIMD. */
    relaxed_simd: true,
  
  });
  
  // 生成 WAT 格式
  const wat = module.toText({ foldExprs: true });
  
  // 将 WAT 写入文件
  fs.writeFileSync(watFilePath, wat);
  
  console.log(`Converted ${wasmFilePath} to ${watFilePath}`);
}

// 示例使用
const wasmFilePath = '/Users/alsc/MyProject/sdk/mydart/sdk/samples/embedder/hello.wasm';
const watFilePath = '/Users/alsc/MyProject/sdk/mydart/sdk/samples/embedder/hello.wat';

convertWasmToWat(wasmFilePath, watFilePath).catch(err => {
  console.error(err);
});
