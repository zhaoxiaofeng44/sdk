
// Compiles a dart2wasm-generated main module from `source` which can then
// instantiatable via the `instantiate` method.
//
// `source` needs to be a `Response` object (or promise thereof) e.g. created
// via the `fetch()` JS API.
export async function compileStreaming(source) {
  const builtins = {builtins: ['js-string']};
  return new CompiledApp(
      await WebAssembly.compileStreaming(source, builtins), builtins);
}

// Compiles a dart2wasm-generated wasm modules from `bytes` which is then
// instantiatable via the `instantiate` method.
export async function compile(bytes) {
  const builtins = {builtins: ['js-string']};
  return new CompiledApp(await WebAssembly.compile(bytes, builtins), builtins);
}

// DEPRECATED: Please use `compile` or `compileStreaming` to get a compiled app,
// use `instantiate` method to get an instantiated app and then call
// `invokeMain` to invoke the main function.
export async function instantiate(modulePromise, importObjectPromise) {
  var moduleOrCompiledApp = await modulePromise;
  if (!(moduleOrCompiledApp instanceof CompiledApp)) {
    moduleOrCompiledApp = new CompiledApp(moduleOrCompiledApp);
  }
  const instantiatedApp = await moduleOrCompiledApp.instantiate(await importObjectPromise);
  return instantiatedApp.instantiatedModule;
}

// DEPRECATED: Please use `compile` or `compileStreaming` to get a compiled app,
// use `instantiate` method to get an instantiated app and then call
// `invokeMain` to invoke the main function.
export const invoke = (moduleInstance, ...args) => {
  moduleInstance.exports.$invokeMain(args);
}

class CompiledApp {
  constructor(module, builtins) {
    this.module = module;
    this.builtins = builtins;
  }

  // The second argument is an options object containing:
  // `loadDeferredWasm` is a JS function that takes a module name matching a
  //   wasm file produced by the dart2wasm compiler and returns the bytes to
  //   load the module. These bytes can be in either a format supported by
  //   `WebAssembly.compile` or `WebAssembly.compileStreaming`.
  async instantiate(additionalImports, {loadDeferredWasm} = {}) {
    let dartInstance;

    // Prints to the console
    function printToConsole(value) {
      if (typeof dartPrint == "function") {
        dartPrint(value);
        return;
      }
      if (typeof console == "object" && typeof console.log != "undefined") {
        console.log(value);
        return;
      }
      if (typeof print == "function") {
        print(value);
        return;
      }

      throw "Unable to print message: " + js;
    }

    // Converts a Dart List to a JS array. Any Dart objects will be converted, but
    // this will be cheap for JSValues.
    function arrayFromDartList(constructor, list) {
      const exports = dartInstance.exports;
      const read = exports.$listRead;
      const length = exports.$listLength(list);
      const array = new constructor(length);
      for (let i = 0; i < length; i++) {
        array[i] = read(list, i);
      }
      return array;
    }

    // A special symbol attached to functions that wrap Dart functions.
    const jsWrappedDartFunctionSymbol = Symbol("JSWrappedDartFunction");

    function finalizeWrapper(dartFunction, wrapped) {
      wrapped.dartFunction = dartFunction;
      wrapped[jsWrappedDartFunctionSymbol] = true;
      return wrapped;
    }

    // Imports
    const dart2wasm = {

      _102: () => {
        let stackString = new Error().stack.toString();
        let frames = stackString.split('\n');
        let drop = 2;
        if (frames[0] === 'Error') {
            drop += 1;
        }
        return frames.slice(drop).join('\n');
      },
      _106: s => printToConsole(s),
      _116: (s, p, i) => s.indexOf(p, i),
      _147: (c) =>
      queueMicrotask(() => dartInstance.exports.$invokeCallback(c)),

    };

    const baseImports = {
      dart2wasm: dart2wasm,

      s: [
        "Too few arguments passed. Expected 1 or more, got ",
"Infinity or NaN toInt",
" instead.",
"null",
"Attempt to execute code removed by Dart AOT compiler (TFA)",
"Type '",
"' is not a subtype of type '",
"'",
" in type cast",
"Null",
"Never",
"Type argument substitution not supported for ",
"Type parameter should have been substituted already.",
"other",
"type '",
"' is not a subtype of ",
"' of '",
"Index out of range",
"",
" (",
")",
": ",
"Instance of '",
": index must not be negative",
": no indices are valid",
": index should be less than ",
"RangeError",
"<",
", ",
"X",
" extends ",
">",
"(",
"[",
"]",
"{",
"}",
" => ",
"Null check operator used on a null value",
"Closure: ",
" ",
"?",
"FutureOr",
"required ",
"T",
"Object?",
"Object",
"dynamic",
"void",
"Invalid top type kind",
"ERROR",
"[]",
"NaN",
"Infinity",
"-Infinity",
"-0.0",
"0.0",
"e",
".0",
"[]=",
"start",
"Invalid value",
": Not greater than or equal to ",
": Not in inclusive range ",
"..",
": Valid value range is empty",
": Only valid value is ",
"Invalid argument",
"(s)",
"Concurrent modification during iteration: ",
".",
"...",
"IntegerDivisionByZeroException",
"skipCount",
"value",
"Too few elements",
"Bad state: ",
"-99",
"-98",
"-97",
"-96",
"-95",
"-94",
"-93",
"-92",
"-91",
"-90",
"-89",
"-88",
"-87",
"-86",
"-85",
"-84",
"-83",
"-82",
"-81",
"-80",
"-79",
"-78",
"-77",
"-76",
"-75",
"-74",
"-73",
"-72",
"-71",
"-70",
"-69",
"-68",
"-67",
"-66",
"-65",
"-64",
"-63",
"-62",
"-61",
"-60",
"-59",
"-58",
"-57",
"-56",
"-55",
"-54",
"-53",
"-52",
"-51",
"-50",
"-49",
"-48",
"-47",
"-46",
"-45",
"-44",
"-43",
"-42",
"-41",
"-40",
"-39",
"-38",
"-37",
"-36",
"-35",
"-34",
"-33",
"-32",
"-31",
"-30",
"-29",
"-28",
"-27",
"-26",
"-25",
"-24",
"-23",
"-22",
"-21",
"-20",
"-19",
"-18",
"-17",
"-16",
"-15",
"-14",
"-13",
"-12",
"-11",
"-10",
"-9",
"-8",
"-7",
"-6",
"-5",
"-4",
"-3",
"-2",
"-1",
"0",
"1",
"2",
"3",
"4",
"5",
"6",
"7",
"8",
"9",
"10",
"11",
"12",
"13",
"14",
"15",
"16",
"17",
"18",
"19",
"20",
"21",
"22",
"23",
"24",
"25",
"26",
"27",
"28",
"29",
"30",
"31",
"32",
"33",
"34",
"35",
"36",
"37",
"38",
"39",
"40",
"41",
"42",
"43",
"44",
"45",
"46",
"47",
"48",
"49",
"50",
"51",
"52",
"53",
"54",
"55",
"56",
"57",
"58",
"59",
"60",
"61",
"62",
"63",
"64",
"65",
"66",
"67",
"68",
"69",
"70",
"71",
"72",
"73",
"74",
"75",
"76",
"77",
"78",
"79",
"80",
"81",
"82",
"83",
"84",
"85",
"86",
"87",
"88",
"89",
"90",
"91",
"92",
"93",
"94",
"95",
"96",
"97",
"98",
"99",
"Unsupported operation: ",
"Division resulted in non-finite value",
"bool",
"BoxedBool",
"JSStringImpl",
"_BottomType",
"_TopType",
"_InterfaceTypeParameterType",
"_FunctionTypeParameterType",
"_FutureOrType",
"_InterfaceType",
"_AbstractFunctionType",
"_FunctionType",
"_AbstractRecordType",
"_RecordType",
"DefaultMap",
"_ConstMap",
"CompactLinkedCustomHashMap",
"DefaultSet",
"_ConstSet",
"Record_2",
"Record_3",
"Record_4",
"Record_5",
"Record_6",
"Record_7",
"Record_8",
"Record_9",
"GrowableList",
"ModifiableFixedLengthList",
"ImmutableList",
"UnmodifiableMapView",
"_Environment",
"StringBuffer",
"_StringStackTrace",
"MapEntry",
"_CompactEntriesIterable",
"SubListIterable",
"_SyncStarIterable",
"_Invocation",
"_TypeError",
"_JavaScriptError",
"_TypeCheckVerificationError",
"_AssertionErrorImpl",
"ArgumentError",
"IndexError",
"NoSuchMethodError",
"UnsupportedError",
"StateError",
"ConcurrentModificationError",
"pragma",
"_SyncStarIterator",
"_SuspendState",
"_NamedParameter",
"_Closure",
"_FfiInlineArray",
"Pointer",
"_Compound",
"BoxedInt",
"_CompactIterator",
"_CompactEntriesIterator",
"_RootZone",
"_CompactIteratorImmutable",
"_ZoneFunction",
"_AsyncCallbackEntry",
"_Future",
"_FutureListener",
"_AsyncCompleter",
"StringMatch",
"AsyncError",
"BoxedDouble",
"_GrowableListIterator",
"_FixedSizeListIterator",
"JSArrayImplIterator",
"JSArrayImpl",
"JSValue",
"Symbol",
"_FfiStructLayout",
"ListIterator",
"_I8ByteBuffer",
"U8List",
"OneByteString",
"TwoByteString",
"ClassID",
"SentinelValue",
"TypeTest",
"_Random",
"_TypedListIterator",
"_AsyncSuspendState",
"WasmAnyRef",
"WasmEqRef",
"WasmStructRef",
"WasmArrayRef",
"WasmArray",
"ImmutableWasmArray",
"WasmExternRef",
"WasmFuncRef",
"WasmFunction",
"WasmI8",
"WasmI16",
"WasmI32",
"WasmI64",
"WasmF32",
"WasmF64",
"WasmVoid",
"WasmTable",
"num",
"double",
"int",
"_Type",
"_HashFieldBase",
"_HashBase",
"String",
"ByteBuffer",
"ByteData",
"Uint8List",
"Function",
"Record",
"TypedData",
"TypedDataList",
"_TypedIntList",
"SetBase",
"LinkedHashMap",
"LinkedHashSet",
"ListBase",
"WasmListBase",
"_ModifiableList",
"MapBase",
"_UnmodifiableMapMixin",
"MapView",
"StringSink",
"StackTrace",
"Set",
"_SetIterable",
"Match",
"Pattern",
"Map",
"List",
"Iterator",
"Type",
"Iterable",
"EfficientLengthIterable",
"ListIterable",
"Invocation",
"Exception",
"Error",
"_Error",
"AssertionError",
"TypeError",
"Comparable",
"_TypeUniverse",
"_ListIterable",
"_FfiAbiSpecificMapping",
"HideEfficientLengthIterable",
"NativeType",
"SizedNativeType",
"Struct",
"Union",
"_EqualsAndHashCode",
"_OperatorEqualsAndHashCode",
"_CustomEqualsAndHashCode",
"_Zone",
"Zone",
"ZoneDelegate",
"_AsyncRun",
"_MapCreateIndexMixin",
"_ImmutableLinkedHashMapMixin",
"_Completer",
"Completer",
"_LinkedHashMapMixin",
"_LinkedHashSetMixin",
"Future",
"_IntListMixin",
"_TypedIntListMixin",
"_TypedListCommonOperationsMixin",
"_UnmodifiableSetMixin",
"StringUncheckedOperationsBase",
"_SetCreateIndexMixin",
"_ImmutableLinkedHashSetMixin",
"Sort",
"UnmodifiableListMixin",
"_JSEventLoop",
"FixedLengthListMixin",
"IterableElementError",
"IndexErrorUtils",
"RangeErrorUtils",
"Lists",
"WasmTypedDataBase",
"ByteBufferBase",
"_I16ByteBuffer",
"_I32ByteBuffer",
"_I64ByteBuffer",
"WasmI8ArrayBase",
"WasmStringBase",
"StringBase",
"Random",
"SystemHash",
"_WasmBase",
"minified:Class",
"true",
"false",
"Too few arguments passed. Expected 2 or more, got ",
"Expected integer value, but was not integer.",
"Unhandled dartifyRaw type case: ",
"Too few arguments passed. Expected 0 or more, got ",
"Cannot add to a fixed-length list",
"Cannot add to an unmodifiable list",
"Could not call main",
"JavaScriptError"
      ],

      Math: Math,
      Date: Date,
      Object: Object,
      Array: Array,
      Reflect: Reflect,
    };

    const jsStringPolyfill = {
      "charCodeAt": (s, i) => s.charCodeAt(i),
      "compare": (s1, s2) => {
        if (s1 < s2) return -1;
        if (s1 > s2) return 1;
        return 0;
      },
      "concat": (s1, s2) => s1 + s2,
      "equals": (s1, s2) => s1 === s2,
      "fromCharCode": (i) => String.fromCharCode(i),
      "length": (s) => s.length,
      "substring": (s, a, b) => s.substring(a, b),
      "fromCharCodeArray": (a, start, end) => {
        if (end <= start) return '';

        const read = dartInstance.exports.$wasmI16ArrayGet;
        let result = '';
        let index = start;
        const chunkLength = Math.min(end - index, 500);
        let array = new Array(chunkLength);
        while (index < end) {
          const newChunkLength = Math.min(end - index, 500);
          for (let i = 0; i < newChunkLength; i++) {
            array[i] = read(a, index++);
          }
          if (newChunkLength < chunkLength) {
            array = array.slice(0, newChunkLength);
          }
          result += String.fromCharCode(...array);
        }
        return result;
      },
    };

    const deferredLibraryHelper = {
      "loadModule": async (moduleName) => {
        if (!loadDeferredWasm) {
          throw "No implementation of loadDeferredWasm provided.";
        }
        const source = await Promise.resolve(loadDeferredWasm(moduleName));
        const module = await ((source instanceof Response)
            ? WebAssembly.compileStreaming(source, this.builtins)
            : WebAssembly.compile(source, this.builtins));
        return await WebAssembly.instantiate(module, {
          ...baseImports,
          ...additionalImports,
          "wasm:js-string": jsStringPolyfill,
          "module0": dartInstance.exports,
        });
      },
    };

    dartInstance = await WebAssembly.instantiate(this.module, {
      ...baseImports,
      ...additionalImports,
      "deferredLibraryHelper": deferredLibraryHelper,
      "wasm:js-string": jsStringPolyfill,
    });

    return new InstantiatedApp(this, dartInstance);
  }
}

class InstantiatedApp {
  constructor(compiledApp, instantiatedModule) {
    this.compiledApp = compiledApp;
    this.instantiatedModule = instantiatedModule;
  }

  // Call the main function with the given arguments.
  invokeMain(...args) {
    this.instantiatedModule.exports.$invokeMain(args);
  }
}

