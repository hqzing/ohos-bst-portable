# Makefile for binary-sign-tool
# 改编自
#   developtools/hapsigner/binary_sign_tool/BUILD.gn
#   developtools/hapsigner/hapsigntool_cpp/signature_tools.gni
#
# 使用示例：
#   make              # 默认构建
#   make clean        # 清理
#   make VERBOSE=1    # 打印详细命令

#--------------------- 用户可改变量 ---------------------
CXX        ?= g++
CXXFLAGS   ?=
LDFLAGS    ?=

#--------- 将 GN 配置文件改写成 Makefile 形式 ------------

# 为增加方便校准核对，变量名保持不变，依然采用小写形式

# signature_tools.gni
signature_tools_root_path = $(shell realpath .)
signature_tools_utils = $(signature_tools_root_path)/utils
signature_tools_cmd = $(signature_tools_root_path)/cmd
signature_tools_error = $(signature_tools_root_path)/error
signature_tools_codesigning = $(signature_tools_root_path)/codesigning
signature_tools_common = $(signature_tools_root_path)/common
signature_tools_hap = $(signature_tools_root_path)/hap
signature_tools_profile = $(signature_tools_root_path)/profile
signature_tools_signer = $(signature_tools_root_path)/signer
signature_tools_api = $(signature_tools_root_path)/api

hapsigntool_cpp_root_path = $(shell realpath ../hapsigntool_cpp)
hapsigntool_cpp_signer = $(hapsigntool_cpp_root_path)/signer
hapsigntool_cpp_common = $(hapsigntool_cpp_root_path)/common
hapsigntool_cpp_profile = $(hapsigntool_cpp_root_path)/profile
hapsigntool_cpp_utils = $(hapsigntool_cpp_root_path)/utils
hapsigntool_cpp_codesigning = $(hapsigntool_cpp_root_path)/codesigning
hapsigntool_cpp_cmd = $(hapsigntool_cpp_root_path)/cmd
hapsigntool_cpp_hap = $(hapsigntool_cpp_root_path)/hap

# cmd/signature_tools_cmd.gni
signature_tools_cmd_include = \
    $(signature_tools_cmd)/include \
    $(hapsigntool_cpp_cmd)/include

signature_tools_cmd_src = \
    $(signature_tools_cmd)/src/cmd_util.cpp \
    $(signature_tools_cmd)/src/params_run_tool.cpp \
    $(signature_tools_cmd)/src/params_trust_list.cpp \
    $(hapsigntool_cpp_cmd)/src/params.cpp


# codesigning/signature_tools_codesigning.gni
signature_tools_codesigning_include = \
    $(signature_tools_codesigning)/fsverity/include \
    $(signature_tools_codesigning)/sign/include \
    $(hapsigntool_cpp_codesigning)/sign/include \
    $(hapsigntool_cpp_codesigning)/utils/include \
    $(hapsigntool_cpp_codesigning)/fsverity/include

signature_tools_codesigning_src = \
    $(signature_tools_codesigning)/fsverity/src/fs_verity_descriptor.cpp \
    $(hapsigntool_cpp_codesigning)/fsverity/src/fs_verity_digest.cpp \
    $(signature_tools_codesigning)/fsverity/src/fs_verity_generator.cpp \
    $(hapsigntool_cpp_codesigning)/fsverity/src/fs_verity_hash_algorithm.cpp \
    $(signature_tools_codesigning)/fsverity/src/merkle_tree_builder.cpp \
    $(hapsigntool_cpp_codesigning)/fsverity/src/fs_verity_descriptor_with_sign.cpp \
    $(hapsigntool_cpp_codesigning)/utils/src/fs_digest_utils.cpp \
    $(hapsigntool_cpp_codesigning)/utils/src/cms_utils.cpp \
    $(hapsigntool_cpp_codesigning)/sign/src/bc_signeddata_generator.cpp \
    $(signature_tools_codesigning)/sign/src/code_signing.cpp

# common/signature_tools_common.gni
signature_tools_common_include = \
    $(signature_tools_common)/include \
    $(hapsigntool_cpp_common)/include

signature_tools_common_src = \
    $(hapsigntool_cpp_common)/src/byte_buffer.cpp \
    $(hapsigntool_cpp_common)/src/digest_parameter.cpp \
    $(hapsigntool_cpp_common)/src/digest_common.cpp \
    $(hapsigntool_cpp_common)/src/localization_adapter.cpp \
    $(signature_tools_common)/src/options.cpp


# hap/signature_tools_hap.gni
signature_tools_hap_include = \
    $(signature_tools_hap)/verify/include \
    $(hapsigntool_cpp_hap)/verify/include \
    $(hapsigntool_cpp_hap)/config/include \
    $(signature_tools_hap)/entity/include \
    $(signature_tools_hap)/provider/include \
    $(signature_tools_hap)/sign/include \
    $(signature_tools_hap)/utils/include

signature_tools_hap_src = \
    $(hapsigntool_cpp_hap)/config/src/signer_config.cpp \
    $(hapsigntool_cpp_hap)/entity/src/content_digest_algorithm.cpp \
    $(signature_tools_hap)/entity/src/param_constants.cpp \
    $(hapsigntool_cpp_hap)/entity/src/signature_algorithm_helper.cpp \
    $(signature_tools_hap)/provider/src/self_sign_sign_provider.cpp \
    $(signature_tools_hap)/provider/src/local_sign_provider.cpp \
    $(hapsigntool_cpp_hap)/provider/src/remote_sign_provider.cpp \
    $(signature_tools_hap)/provider/src/sign_provider.cpp \
    $(signature_tools_hap)/sign/src/sign_elf.cpp \
    $(signature_tools_hap)/verify/src/verify_elf.cpp \
    $(hapsigntool_cpp_hap)/utils/src/dynamic_lib_handle.cpp \
    $(signature_tools_hap)/sign/src/bc_pkcs7_generator.cpp

# profile/signature_tools_profile.gni
signature_tools_profile_include = \
    $(hapsigntool_cpp_profile)/include

signature_tools_profile_src = \
    $(signature_tools_profile)/src/profile_info.cpp \
    $(hapsigntool_cpp_profile)/src/profile_verify.cpp \
    $(hapsigntool_cpp_profile)/src/pkcs7_data.cpp \
    $(signature_tools_profile)/src/profile_sign_tool.cpp


# signer/binary_sign_tool_signer.gni
binary_sign_tool_signer_include = \
    $(hapsigntool_cpp_signer)/include

binary_sign_tool_signer_src = \
    $(hapsigntool_cpp_signer)/src/local_signer.cpp \
    $(hapsigntool_cpp_signer)/src/signer_factory.cpp


# utils/signature_tools_utils.gni
signature_tools_utils_include = \
    $(signature_tools_utils)/include \
    $(hapsigntool_cpp_utils)/include

signature_tools_utils_src = \
    $(hapsigntool_cpp_utils)/src/verify_cert_openssl_utils.cpp \
    $(signature_tools_utils)/src/file_utils.cpp \
    $(hapsigntool_cpp_utils)/src/key_store_helper.cpp \
    $(hapsigntool_cpp_utils)/src/string_utils.cpp \
    $(hapsigntool_cpp_utils)/src/verify_hap_openssl_utils.cpp

# BUILD.gn
signature_tools_main_include = \
    $(signature_tools_api)/include

signature_tools_main_src = \
    main.cpp \
    $(signature_tools_api)/src/sign_tool_service_impl.cpp

signature_tools_main_include += \
    $(signature_tools_utils_include) \
    $(signature_tools_codesigning_include) \
    $(signature_tools_common_include) \
    $(signature_tools_hap_include) \
    $(signature_tools_profile_include) \
    $(binary_sign_tool_signer_include) \
    $(signature_tools_cmd_include)

signature_tools_main_src += \
    $(signature_tools_utils_src) \
    $(signature_tools_codesigning_src) \
    $(signature_tools_common_src) \
    $(signature_tools_hap_src) \
    $(signature_tools_profile_src) \
    $(binary_sign_tool_signer_src) \
    $(signature_tools_cmd_src)

#------------------- 真正的构建逻辑 ---------------------

CXXFLAGS += -std=c++17 -fno-rtti -fstack-protector-strong -Wno-c++20-extensions -include cstdint
INC_FLAGS = $(addprefix -I, $(signature_tools_main_include))
LIBS = -lsec -lcjson -lcrypto -lssl
TARGET = binary-sign-tool
OBJS = $(signature_tools_main_src:.cpp=.o)

.PHONY: all clean

all: $(TARGET)

# 链接
$(TARGET): $(OBJS)
	$(CXX) $(OBJS) -o $@ $(LDFLAGS) $(LIBS)

# 编译
%.o: %.cpp
	$(CXX) $(CXXFLAGS) $(INC_FLAGS) -c $< -o $@

clean:
	rm -f $(OBJS) $(TARGET)
