# ohos-bst-portable

`binary-sign-tool` 是 OpenHarmony 官方的二进制代码签名工具。

它的源码深埋在 [developtools_hapsigner](https://gitcode.com/openharmony/developtools_hapsigner) 仓库中，构建规则以 GN 配置文件形式存在，并耦合了多个关联仓库。按照官方的构建方法，开发者需要下载整个 OpenHarmony 系统源码，通过 OpenHarmony 的编译构建子系统完成这个工具的构建，构建过程十分繁琐。

本仓库就解决这个问题：将它从 OpenHarmony 源码树中剥离出来，单独构建出制品。

仓库命名仿 openssh-portable 先例：从 OpenBSD 源码树中剥离出来的可移植版本就叫 portable。

## 仓库内容

| 文件 | 用途 |
|------|------|
| `build.sh` | 一键构建脚本 |
| `Makefile` | `binary-sign-tool` 本体的构建规则 |

本仓库不分发制品，也不分发任何上游源码。`build.sh` 脚本运行过程中会实时拉取上游源码并构建出制品。

## 用法

本项目支持在 Linux 和 OpenHarmony 环境中构建和运行。

### 构建期依赖

- 编译器：gcc 或 clang（`build.sh` 脚本会自动探测 `cc`/`gcc`/`clang` 命令）
- GNU 工具集（coreutils、grep、awk……）
- `make`
- `git`
- `perl`（openssl 的 Configure 脚本需要）

### 构建

```sh
./build.sh
```

构建完成后当前目录下会生成可执行文件 `binary-sign-tool`。

### 产物用法

产物与 ohos-sdk 中的 `toolchains/lib/binary-sign-tool` 一致，用法与能力完全同官方：

```sh
./binary-sign-tool sign -selfSign 1 -inFile my_program -outFile my_program
./binary-sign-tool display-sign -inFile my_program
```

## 第三方依赖与许可证

本仓库自身代码（`build.sh` / `Makefile`）使用 MIT 许可证，但制品 `binary-sign-tool` 集成了下面这些开源软件，若用户需要分发制品，须依各许可证履行声明义务：

| 开源软件 | 许可证 |
|------|----------|
| openssl | Apache-2.0（含 doubles SSLeay） |
| zlib | zlib License（BSD-3 兼容） |
| cJSON | MIT |
| libboundscheck（libsec） | MIT |
| elfio | BSD-3-Clause（Boost 兼容） |
| developtools_hapsigner | Apache-2.0 |

