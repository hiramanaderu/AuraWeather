#!/bin/bash

# 天气穿搭助手 - 一键安装脚本
# 支持 macOS 和 Linux

echo "🌤️  天气穿搭助手 - 安装脚本"
echo "================================"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 检查 Flutter
if ! command -v flutter &> /dev/null; then
    echo "${RED}❌ 未检测到 Flutter${NC}"
    echo ""
    echo "请先安装 Flutter:"
    echo "  1. 访问 https://docs.flutter.dev/get-started/install"
    echo "  2. 下载并安装 Flutter SDK"
    echo "  3. 将 flutter/bin 添加到 PATH"
    exit 1
fi

echo "${GREEN}✅ Flutter 已安装${NC}"
flutter --version
echo ""

# 检查项目目录
PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$PROJECT_DIR"

echo "📁 项目目录: $PROJECT_DIR"

# 获取依赖
echo ""
echo "📦 正在安装依赖..."
flutter pub get

if [ $? -ne 0 ]; then
    echo "${RED}❌ 依赖安装失败${NC}"
    exit 1
fi

echo "${GREEN}✅ 依赖安装完成${NC}"

# 检查设备
echo ""
echo "📱 可用设备:"
flutter devices

# 提示运行
echo ""
echo "${GREEN}🎉 安装完成！${NC}"
echo ""
echo "运行应用:"
echo "  ${YELLOW}flutter run${NC}           # 运行到 Android"
echo "  ${YELLOW}flutter run -d macos${NC}    # 运行到 macOS"
echo ""
echo "更多帮助: ${YELLOW}cat QUICK_START.md${NC}"
