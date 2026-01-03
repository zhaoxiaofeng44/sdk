#!/bin/bash

# 批量测试sample/dart下的所有Dart测试用例
# 将Dart转换为C++，编译并运行

WORKSPACE="/Users/alsc/MyProject/sdk/mydart/sdk/pkg/dart2cpp"
cd "$WORKSPACE"

# 创建输出目录
OUTPUT_DIR="sample/cpp_generated"
TEST_RESULT_FILE="sample_test_results.txt"
SUMMARY_FILE="sample_test_summary.json"

mkdir -p "$OUTPUT_DIR"
rm -f "$TEST_RESULT_FILE"
rm -f "$SUMMARY_FILE"

# 初始化统计
total_files=0
converted_success=0
converted_failed=0
compile_success=0
compile_failed=0
run_success=0
run_failed=0

# JSON格式的结果数组
echo "{" > "$SUMMARY_FILE"
echo "  \"test_results\": [" >> "$SUMMARY_FILE"

first_entry=true

# 获取所有Dart文件
dart_files=$(find sample/dart -name "*.dart" -type f | sort)

for dart_file in $dart_files; do
    total_files=$((total_files + 1))
    filename=$(basename "$dart_file" .dart)
    cpp_output="$OUTPUT_DIR/${filename}.cpp"
    exe_output="$OUTPUT_DIR/${filename}"
    
    echo "========================================" | tee -a "$TEST_RESULT_FILE"
    echo "[$total_files] Testing: $dart_file" | tee -a "$TEST_RESULT_FILE"
    echo "========================================" | tee -a "$TEST_RESULT_FILE"
    
    # 添加JSON分隔符
    if [ "$first_entry" = false ]; then
        echo "    ," >> "$SUMMARY_FILE"
    fi
    first_entry=false
    
    echo "    {" >> "$SUMMARY_FILE"
    echo "      \"file\": \"$dart_file\"," >> "$SUMMARY_FILE"
    echo "      \"filename\": \"$filename\"," >> "$SUMMARY_FILE"
    
    # Step 1: 转换Dart到C++
    echo "Step 1: Converting $dart_file to C++..." | tee -a "$TEST_RESULT_FILE"
    convert_output=$(dart bin/dart2cpp.dart "$dart_file" -o "$cpp_output" 2>&1)
    convert_status=$?
    
    if [ $convert_status -eq 0 ] && [ -f "$cpp_output" ]; then
        echo "✓ Conversion SUCCESS" | tee -a "$TEST_RESULT_FILE"
        echo "      \"conversion\": \"success\"," >> "$SUMMARY_FILE"
        converted_success=$((converted_success + 1))
        
        # Step 2: 编译C++代码
        echo "Step 2: Compiling $cpp_output..." | tee -a "$TEST_RESULT_FILE"
        compile_output=$(g++ -std=c++17 -I cpp/core "$cpp_output" cpp/core/dart_object.cpp cpp/core/dart_string.cpp -o "$exe_output" 2>&1)
        compile_status=$?
        
        if [ $compile_status -eq 0 ] && [ -f "$exe_output" ]; then
            echo "✓ Compilation SUCCESS" | tee -a "$TEST_RESULT_FILE"
            echo "      \"compilation\": \"success\"," >> "$SUMMARY_FILE"
            compile_success=$((compile_success + 1))
            
            # Step 3: 运行程序
            echo "Step 3: Running $exe_output..." | tee -a "$TEST_RESULT_FILE"
            run_output=$(timeout 5s "$exe_output" 2>&1)
            run_status=$?
            
            if [ $run_status -eq 0 ]; then
                echo "✓ Execution SUCCESS" | tee -a "$TEST_RESULT_FILE"
                echo "      \"execution\": \"success\"," >> "$SUMMARY_FILE"
                echo "      \"output\": \"${run_output//\"/\\\"}\"" >> "$SUMMARY_FILE"
                run_success=$((run_success + 1))
            else
                echo "✗ Execution FAILED (exit code: $run_status)" | tee -a "$TEST_RESULT_FILE"
                echo "      \"execution\": \"failed\"," >> "$SUMMARY_FILE"
                echo "      \"execution_error\": \"${run_output//\"/\\\"}\"" >> "$SUMMARY_FILE"
                run_failed=$((run_failed + 1))
            fi
        else
            echo "✗ Compilation FAILED" | tee -a "$TEST_RESULT_FILE"
            echo "      \"compilation\": \"failed\"," >> "$SUMMARY_FILE"
            echo "      \"compilation_error\": \"${compile_output//\"/\\\"}\"," >> "$SUMMARY_FILE"
            echo "      \"execution\": \"skipped\"" >> "$SUMMARY_FILE"
            compile_failed=$((compile_failed + 1))
        fi
    else
        echo "✗ Conversion FAILED" | tee -a "$TEST_RESULT_FILE"
        echo "      \"conversion\": \"failed\"," >> "$SUMMARY_FILE"
        echo "      \"conversion_error\": \"${convert_output//\"/\\\"}\"," >> "$SUMMARY_FILE"
        echo "      \"compilation\": \"skipped\"," >> "$SUMMARY_FILE"
        echo "      \"execution\": \"skipped\"" >> "$SUMMARY_FILE"
        converted_failed=$((converted_failed + 1))
    fi
    
    echo "    }" >> "$SUMMARY_FILE"
    echo "" | tee -a "$TEST_RESULT_FILE"
done

# 结束JSON
echo "  ]," >> "$SUMMARY_FILE"
echo "  \"summary\": {" >> "$SUMMARY_FILE"
echo "    \"total_files\": $total_files," >> "$SUMMARY_FILE"
echo "    \"conversion\": {\"success\": $converted_success, \"failed\": $converted_failed}," >> "$SUMMARY_FILE"
echo "    \"compilation\": {\"success\": $compile_success, \"failed\": $compile_failed}," >> "$SUMMARY_FILE"
echo "    \"execution\": {\"success\": $run_success, \"failed\": $run_failed}" >> "$SUMMARY_FILE"
echo "  }" >> "$SUMMARY_FILE"
echo "}" >> "$SUMMARY_FILE"

# 打印总结
echo "========================================" | tee -a "$TEST_RESULT_FILE"
echo "FINAL SUMMARY" | tee -a "$TEST_RESULT_FILE"
echo "========================================" | tee -a "$TEST_RESULT_FILE"
echo "Total Files:        $total_files" | tee -a "$TEST_RESULT_FILE"
echo "Conversion Success: $converted_success / $total_files" | tee -a "$TEST_RESULT_FILE"
echo "Conversion Failed:  $converted_failed / $total_files" | tee -a "$TEST_RESULT_FILE"
echo "Compile Success:    $compile_success / $converted_success" | tee -a "$TEST_RESULT_FILE"
echo "Compile Failed:     $compile_failed / $converted_success" | tee -a "$TEST_RESULT_FILE"
echo "Run Success:        $run_success / $compile_success" | tee -a "$TEST_RESULT_FILE"
echo "Run Failed:         $run_failed / $compile_success" | tee -a "$TEST_RESULT_FILE"
echo "========================================" | tee -a "$TEST_RESULT_FILE"

echo ""
echo "Results saved to:"
echo "  - Detailed log: $TEST_RESULT_FILE"
echo "  - JSON summary: $SUMMARY_FILE"
