# ohos-bst-portable

`binary-sign-tool`（bst）是 OpenHarmony 官方的 ELF 代码签名工具，但埋在上游 [`developtools_hapsigner`](https://gitcode.com/openharmony/developtools_hapsigner) 仓库里，依赖 GN/Ninja 构建系统和 openssl / zlib / cJSON / libsec / elfio 等多个第三方库，普通用户很难单独编译。本仓库把它**便携剥离**出来——不修改任何官方源码，仅配一份 `build.sh` + `Makefile`，脱离 GN/Ninja 也能编出与 ohos-sdk 中 `toolchains/lib/binary-sign-tool` 一致的产物。

仓库命名仿 OpenSSH-portable 先例：从 OpenBSD 庞大工程里便携剥离出来、独立可编的子集叫 portable。

## 文件

| 文件 | 用途 |
|------|------|
| `build.sh` | 拉取上游官方源码（openssl / zlib / cJSON / libsec / elfio / developtools_hapsigner），编 binary-sign-tool |
| `Makefile` | binary-sign-tool 本体的构建规则（改编自上游 GN 配置，不改源码） |

## 用法

本项目不分发制品，用户需先构建后使用。本项目支持在 Linux 和 OpenHarmony 环境中构建和运行。

构建期依赖：
- 编译器（gcc 或 clang）
- GNU 工具集（coreutils、grep、awk...）
- make
- git
- perl

构建命令：
```sh
./build.sh
```

产物 `binary-sign-tool` 与 ohos-sdk 中的 `toolchains/lib/binary-sign-tool` 一致，用法与能力完全同官方：
```sh
./binary-sign-tool sign -selfSign 1 -inFile my_program -outFile my_program
./binary-sign-tool display-sign -inFile my_program
```

## 第三方依赖与许可证

`build.sh` 会拉取并编译以下上游源码。本仓库自身代码（`build.sh` / `Makefile`）使用 MIT 许可证，但产物 `binary-sign-tool` 静态链了下面这些第三方库，各自许可证独立、需各自声明：

| 依赖 | 上游许可证 | 在本产物中 |
|------|----------|------------|
| openssl | Apache-2.0 (含 doubles SSLeay) | 静链 libcrypto/libssl |
| zlib | zlib License (BSD-3 兼容) | 静链 libz |
| cJSON | MIT | 静链 libcjson |
| libboundscheck (libsec) | MIT | 静链 libsec |
| elfio | BSD-3-Clause (Boost 兼容) | 纯头文件 |
| developtools_hapsigner (binary-sign-tool 本体) | Apache-2.0 | 可执行文件主体 |

各依赖的完整许可证文本在其源码仓库内，本仓库不复制。产物分发时须依各许可证履行声明义务。
