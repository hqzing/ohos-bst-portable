#!/bin/sh
set -e

WORKDIR=$(pwd)

# 按顺序探可用编译器, 不写死 gcc — 鸿蒙上只有 cc/clang, Linux 上常见 gcc, clang 各平台都有
pick_tool() {
    for cand in "$@"; do
        if command -v "$cand" >/dev/null 2>&1; then
            printf '%s' "$cand"
            return 0
        fi
    done
    echo "error: none of [$*] found in PATH" >&2
    return 1
}
CC=$(pick_tool cc gcc clang)
CXX=$(pick_tool c++ g++ clang++)
AR=$(pick_tool ar llvm-ar)
echo "using CC=$CC CXX=$CXX AR=$AR"

# 已编依赖缓存到 deps/, 重跑跳过省时间 (git clone + make openssl 是大头)
mkdir -p "$WORKDIR/deps"

# 编 openssl
if [ ! -f "$WORKDIR/deps/lib/libcrypto.a" ]; then
    git clone https://gitcode.com/openharmony/third_party_openssl.git
    cd third_party_openssl
    git reset --hard 1113de4ce299e781fa60a37c90563545336f0099
    ./Configure --prefix=$WORKDIR/deps no-shared
    make -j$(nproc)
    make install_sw
    cd ..
fi

# 编 zlib
if [ ! -f "$WORKDIR/deps/lib/libz.a" ]; then
    git clone https://gitcode.com/openharmony/third_party_zlib.git
    cd third_party_zlib
    git reset --hard 9a1de89f7c80f8fc811527dd57135b8b4c00a2e8
    ./configure --prefix=$WORKDIR/deps --static
    make -j$(nproc) install
    cd ..
fi

# 编 cjson
if [ ! -f "$WORKDIR/deps/lib/libcjson.a" ]; then
    git clone https://gitcode.com/openharmony/third_party_cJSON.git
    cd third_party_cJSON
    git reset --hard ed51a490e22e7120be055a8b2fdb2a0a7f8676a7
    CFLAGS="-std=c99" make static
    cp cJSON.h $WORKDIR/deps/include
    cp libcjson.a $WORKDIR/deps/lib
    cd ..
fi

# 编 libboundscheck（在 OpenHarmony 项目里面，它被命名为 libsec）
# 项目自带的 Makefile 不符合需求，这里选择自己构造编译命令
if [ ! -f "$WORKDIR/deps/lib/libsec.a" ]; then
    git clone https://gitcode.com/openharmony/third_party_bounds_checking_function.git
    cd third_party_bounds_checking_function
    git reset --hard 2ae82839ecaaa7d031e66ccbd2076d671acfd615
    cd src
    $CC -c *.c  -I../include
    $AR rcs libsec.a *.o
    rm -rf *.o
    cp ../include/* $WORKDIR/deps/include
    cp libsec.a $WORKDIR/deps/lib/
    cd ../..
fi

# 安装 elfio 头文件（这是个纯头文件的库，无需编译）
if [ ! -f "$WORKDIR/deps/include/elfio.hpp" ]; then
    git clone https://gitcode.com/openharmony/third_party_elfio.git
    cd third_party_elfio
    git reset --hard 4a22153663e7e2a6494ac05b908d5249b03bcc5b
    cp elfio/*.hpp $WORKDIR/deps/include
    cd ..
fi

# 编 binary-sign-tool
if [ ! -f "$WORKDIR/binary-sign-tool" ]; then
    git clone https://gitcode.com/openharmony/developtools_hapsigner.git
    cd developtools_hapsigner
    git reset --hard af64510d8d8319f186add6a3e06d0ec6fd73da7f
    cd binary_sign_tool
    cp ../../Makefile ./
    export CXXFLAGS="-I$WORKDIR/deps/include"
    export LDFLAGS="-L$WORKDIR/deps/lib"
    make -j$(nproc)
    cd ../..
    # 把最终产物复制到外面
    cp developtools_hapsigner/binary_sign_tool/binary-sign-tool ./
fi
