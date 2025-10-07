# 转换逻辑优化TODO

## 已完成 ✅
1. 创建了 ExpressionProcessor 类 - 专门处理表达式转换
2. 创建了 StatementProcessor 类 - 专门处理语句转换  
3. 在 DartToDartTransformer 中添加了处理器实例字段
4. 在初始化方法中添加了处理器实例化

## 当前问题 ❌
1. ExpressionProcessor 中引用了不存在的方法：
   - `_generateExpressionCode2` 
   - `_escapeString`
   - `_shouldAddValueSuffix`
2. StatementProcessor 中引用了不存在的方法：
   - `_generateStatementCode`
   - `_getDartType`

## 需要修复 🔧
1. 找到实际存在的表达式生成方法
2. 找到实际存在的字符串处理方法
3. 找到实际存在的语句生成方法
4. 修复所有方法引用
5. 确保编译通过
6. 验证输出一致性

## 下一步计划 📋
1. 搜索实际存在的方法名
2. 修复处理器中的方法引用
3. 测试编译
4. 继续优化其他部分
