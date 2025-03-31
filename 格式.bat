@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: ================ 配置区 ================
set "TARGET_DIR=%~dp0bucket"
set LOG_FILE="%~dp0fix_results.log"

:: ================ 初始化 ================
title 文件格式修复工具 v3.2
if not exist %TARGET_DIR%\ (
    echo [错误] bucket目录不存在：%TARGET_DIR%
    pause
    exit /b 1
)

:: 清空旧日志
if exist %LOG_FILE% del %LOG_FILE%

:: ================ 核心修复逻辑 ================
set file_count=0
set success_count=0
set fail_count=0

echo 开始扫描JSON文件（%date% %time%）...
echo 修复日志：> %LOG_FILE%

for /r "%TARGET_DIR%" %%f in (*.json) do (
    set /a file_count+=1
    echo 正在处理：%%~nxf
    
    :: 删除尾部空格（参考网页3的代码格式化思路[3](@ref)）
    powershell -Command "$content = [IO.File]::ReadAllText('%%f'); $content = $content -replace '(?m)\s+$',''; [IO.File]::WriteAllText('%%f', $content)"
    
    :: 添加结尾换行符（解决网页1/2中的测试失败问题[1,2](@ref)）
    powershell -Command "$content = [IO.File]::ReadAllText('%%f'); if (-not $content.EndsWith("`n")) { [IO.File]::WriteAllText('%%f', $content + "`n", [Text.Encoding]::UTF8) }"
    
    :: 验证修复结果（参考网页6的错误处理机制[6](@ref)）
    powershell -Command "$c=Get-Content '%%f' -Raw; if ($c -match '\s$' -or -not $c.EndsWith("`n")) {exit 1}"
    if !errorlevel! equ 0 (
        set /a success_count+=1
        echo [成功] %%~nxf >> %LOG_FILE%
    ) else (
        set /a fail_count+=1
        echo [失败] %%~nxf >> %LOG_FILE%
    )
)

:: ================ 结果输出 ================
echo 修复完成（%date% %time%）
echo ================ 统计 ================
echo 扫描文件总数 : !file_count!
echo 成功修复文件 : !success_count!
echo 修复失败文件 : !fail_count%
echo 详细日志见 : %LOG_FILE%

:: 自动打开日志文件
if exist %LOG_FILE% notepad %LOG_FILE%
timeout /t 15