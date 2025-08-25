#!/bin/bash


# 检查是否提供了文件路径参数
if [ $# -eq 0 ]; then
    echo "错误：请提供包含文件路径列表的文件作为参数"
    echo "用法: $0 <文件路径列表文件>"
    echo "示例: $0 file_list.txt"
    exit 1
fi

# 获取输入文件路径
input_file="$1"

# 检查输入文件是否存在
if [ ! -f "$input_file" ]; then
    echo "错误：文件 '$input_file' 不存在"
    exit 1
fi

# 检查文件是否为空
if [ ! -s "$input_file" ]; then
    echo "警告：文件 '$input_file' 为空"
    exit 0
fi

echo "开始批量审查文件..."
echo "从文件读取路径: $input_file"
echo "================================"

# 计数器
total_files=0
processed_files=0

# 先统计总文件数
total_files=$(grep -c . "$input_file")
echo "总共需要处理 $total_files 个文件"
echo "================================"

# 逐行读取文件并处理
while IFS= read -r line || [[ -n "$line" ]]; do
    # 跳过空行
    if [ -z "$line" ]; then
        continue
    fi

    # 去除行首尾空白字符
    line=$(echo "$line" | xargs)

    # 跳过处理后为空的行
    if [ -z "$line" ]; then
        continue
    fi

    ((processed_files++))

    echo ""
    echo "[$processed_files/$total_files] 处理文件: $line"
    echo "----------------------------------------"


    # 执行Claude命令，带重试机制
    retry_count=0
    max_retries=3
    success=false

    while [ $retry_count -le $max_retries ] && [ "$success" = false ]; do
        if [ $retry_count -gt 0 ]; then
            echo "⏳ 第 $retry_count 次重试，等待30分钟后继续..."
            echo "等待开始时间: $(date)"
            sleep 1800  # 30分钟 = 1800秒
            echo "等待结束时间: $(date)"
            echo "🔄 开始重试执行命令..."
        fi

        # 执行Claude命令
        echo "claude --dangerously-skip-permissions -p \"$PREFIX_PROMPT $line\""
        claude --dangerously-skip-permissions -p "$PREFIX_PROMPT $line"

        # 检查命令执行结果
        if [ $? -eq 0 ]; then
            echo "✓ 文件 '$line' 审查完成"
            success=true
        else
            ((retry_count++))
            if [ $retry_count -le $max_retries ]; then
                echo "✗ 文件 '$line' 审查失败，将在30分钟后重试 (重试次数: $retry_count/$max_retries)"
            else
                echo "✗ 文件 '$line' 审查最终失败，已达到最大重试次数 ($max_retries)"
            fi
        fi
    done

    echo "----------------------------------------"

done < "$input_file"

echo ""
echo "================================"
echo "批量审查完成！"
echo "总共处理了 $processed_files 个文件"
