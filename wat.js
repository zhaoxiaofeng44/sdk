const fs = require('fs');
const wabt = require('wabt')();

async function convertWasmToWat(wasmFilePath, watFilePath) {
  // 加载 WABT
  const wabtModule = await wabt.then(wabt => wabt);
  
  // 读取 WASM 文件
  const wasmBuffer = fs.readFileSync(wasmFilePath);
  
  // 解析 WASM 文件
  const module = wabtModule.readWasm(wasmBuffer, { readDebugNames: true });
  
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
