ifneq ($(BUILD_TINY_ANDROID),true)

ROOT_DIR := $(call my-dir)
OMX_VIDEO_PATH := $(ROOT_DIR)/../..

include $(CLEAR_VARS)
LOCAL_PATH:= $(ROOT_DIR)

# ---------------------------------------------------------------------------------
# 				Common definitons
# ---------------------------------------------------------------------------------

libOmxVdec-def := -D__alignx\(x\)=__attribute__\(\(__aligned__\(x\)\)\)
libOmxVdec-def += -D__align=__alignx
libOmxVdec-def += -Dinline=__inline
libOmxVdec-def += -g -O3
libOmxVdec-def += -DIMAGE_APPS_PROC
libOmxVdec-def += -D_ANDROID_
libOmxVdec-def += -DCDECL
libOmxVdec-def += -DT_ARM
libOmxVdec-def += -DNO_ARM_CLZ
libOmxVdec-def += -UENABLE_DEBUG_LOW
libOmxVdec-def += -UENABLE_DEBUG_HIGH
libOmxVdec-def += -DENABLE_DEBUG_ERROR
libOmxVdec-def += -UINPUT_BUFFER_LOG
libOmxVdec-def += -UOUTPUT_BUFFER_LOG
ifeq ($(TARGET_BOARD_PLATFORM),msm8660)
libOmxVdec-def += -DMAX_RES_1080P
libOmxVdec-def += -DPROCESS_EXTRADATA_IN_OUTPUT_PORT
libOmxVdec-def += -DTEST_TS_FROM_SEI
endif
ifeq ($(TARGET_BOARD_PLATFORM),msm8960)
libOmxVdec-def += -DMAX_RES_1080P
libOmxVdec-def += -DMAX_RES_1080P_EBI
libOmxVdec-def += -DPROCESS_EXTRADATA_IN_OUTPUT_PORT
libOmxVdec-def += -D_MSM8960_
endif
ifeq ($(TARGET_BOARD_PLATFORM),msm8974)
libOmxVdec-def += -DMAX_RES_1080P
libOmxVdec-def += -DMAX_RES_1080P_EBI
libOmxVdec-def += -DPROCESS_EXTRADATA_IN_OUTPUT_PORT
libOmxVdec-def += -D_MSM8974_
libOmxVdec-def += -D_HEVC_USE_ADSP_HEAP_
endif
ifeq ($(TARGET_BOARD_PLATFORM),msm7627a)
libOmxVdec-def += -DMAX_RES_720P
endif
ifeq ($(TARGET_BOARD_PLATFORM),msm7630_surf)
libOmxVdec-def += -DMAX_RES_720P
endif
ifeq ($(TARGET_BOARD_PLATFORM),msm8610)
libOmxVdec-def += -DMAX_RES_1080P
libOmxVdec-def += -DMAX_RES_1080P_EBI
libOmxVdec-def += -DPROCESS_EXTRADATA_IN_OUTPUT_PORT
libOmxVdec-def += -DSMOOTH_STREAMING_DISABLED
libOmxVdec-def += -DH264_PROFILE_LEVEL_CHECK
libOmxVdec-def += -D_MSM8974_
endif
ifeq ($(TARGET_BOARD_PLATFORM),msm8226)
libOmxVdec-def += -DMAX_RES_1080P
libOmxVdec-def += -DMAX_RES_1080P_EBI
libOmxVdec-def += -DPROCESS_EXTRADATA_IN_OUTPUT_PORT
libOmxVdec-def += -D_MSM8974_
libOmxVdec-def += -D_HEVC_USE_ADSP_HEAP_
endif
ifeq ($(TARGET_BOARD_PLATFORM),apq8084)
libOmxVdec-def += -DMAX_RES_1080P
libOmxVdec-def += -DMAX_RES_1080P_EBI
libOmxVdec-def += -DPROCESS_EXTRADATA_IN_OUTPUT_PORT
libOmxVdec-def += -D_MSM8974_
libOmxVdec-def += -DVENUS_HEVC
endif
ifeq ($(TARGET_BOARD_PLATFORM),mpq8092)
libOmxVdec-def += -DMAX_RES_1080P
libOmxVdec-def += -DMAX_RES_1080P_EBI
libOmxVdec-def += -DPROCESS_EXTRADATA_IN_OUTPUT_PORT
libOmxVdec-def += -D_MSM8974_
libOmxVdec-def += -DVENUS_HEVC
endif
ifeq ($(TARGET_BOARD_PLATFORM),msm_bronze)
libOmxVdec-def += -DMAX_RES_1080P
libOmxVdec-def += -DMAX_RES_1080P_EBI
libOmxVdec-def += -DPROCESS_EXTRADATA_IN_OUTPUT_PORT
libOmxVdec-def += -D_MSM8974_
libOmxVdec-def += -D_HEVC_USE_ADSP_HEAP_
endif
ifeq ($(TARGET_BOARD_PLATFORM),msm8916)
libOmxVdec-def += -DMAX_RES_1080P
libOmxVdec-def += -DMAX_RES_1080P_EBI
libOmxVdec-def += -DPROCESS_EXTRADATA_IN_OUTPUT_PORT
libOmxVdec-def += -D_MSM8974_
libOmxVdec-def += -D_HEVC_USE_ADSP_HEAP_
endif
libOmxVdec-def += -D_ANDROID_ICS_

ifeq ($(TARGET_USES_ION),true)
libOmxVdec-def += -DUSE_ION
endif

ifneq (1,$(filter 1,$(shell echo "$$(( $(PLATFORM_SDK_VERSION) >= 18 ))" )))
libOmxVdec-def += -DANDROID_JELLYBEAN_MR1=1
endif

ifeq ($(call is-platform-sdk-version-at-least, 22),true)
# This feature is enabled for Android LMR1
libOmxVdec-def += -DFLEXYUV_SUPPORTED
endif

ifeq ($(TARGET_USES_MEDIA_EXTENSIONS),true)
libmm-vdec-def += -DALLOCATE_OUTPUT_NATIVEHANDLE
endif

# ---------------------------------------------------------------------------------
# 			Make the Shared library (libOmxVdec)
# ---------------------------------------------------------------------------------

include $(CLEAR_VARS)
LOCAL_PATH:= $(ROOT_DIR)

libmm-vdec-inc          += $(LOCAL_PATH)/inc 
libmm-vdec-inc          += $(OMX_VIDEO_PATH)/vidc/common/inc
libmm-vdec-inc          += $(call project-path-for,qcom-media)/mm-core/inc
libmm-vdec-inc          += $(call project-path-for,qcom-display)/libgralloc
libmm-vdec-inc          += $(call project-path-for,qcom-display)/libqdutils
libmm-vdec-inc      += $(call project-path-for,qcom-media)/libc2dcolorconvert
libmm-vdec-inc      += $(call project-path-for,qcom-display)/libcopybit
libmm-vdec-inc      += frameworks/av/include/media/stagefright
libmm-vdec-inc      += $(TARGET_OUT_HEADERS)/mm-video/SwVdec

ifneq ($(call is-platform-sdk-version-at-least, 19),true)
libOmxVdec-def += -DMETADATA_FOR_DYNAMIC_MODE
libmm-vdec-inc += $(call project-path-for,qcom-media)/libstagefrighthw
endif

ifeq ($(call is-platform-sdk-version-at-least, 19),true)
# This feature is enabled for Android KK+
libOmxVdec-def += -DADAPTIVE_PLAYBACK_SUPPORTED
endif

LOCAL_MODULE                    := libOmxVdec
LOCAL_MODULE_TAGS               := optional
LOCAL_VENDOR_MODULE             := true
LOCAL_CFLAGS                    := $(libOmxVdec-def)
LOCAL_CFLAGS                    += -Wno-error
LOCAL_C_INCLUDES                += $(libmm-vdec-inc)

LOCAL_HEADER_LIBRARIES := \
    generated_kernel_headers \
    libnativebase_headers \
    libhardware_headers \
    media_plugin_headers \
    libutils_headers

LOCAL_PRELINK_MODULE    := false
LOCAL_SHARED_LIBRARIES  := libui libhardware liblog libutils libbinder \
                           libcutils libdl

LOCAL_SHARED_LIBRARIES  += libqdMetaData

LOCAL_SRC_FILES         := src/frameparser.cpp
LOCAL_SRC_FILES         += src/h264_utils.cpp
LOCAL_SRC_FILES         += src/ts_parser.cpp
LOCAL_SRC_FILES         += src/mp4_utils.cpp
LOCAL_SRC_FILES         += src/hevc_utils.cpp
ifneq (,$(filter msm8974 msm8610 msm8226 apq8084 mpq8092 msm_bronze msm8916,$(TARGET_BOARD_PLATFORM)))
LOCAL_SRC_FILES         += src/omx_vdec_msm8974.cpp
endif

LOCAL_SRC_FILES         += ../common/src/extra_data_handler.cpp
LOCAL_SRC_FILES         += ../common/src/vidc_color_converter.cpp

# omx_vdec_msm8974.cpp:9462:16: address of array 'extra->data' will always evaluate to 'true'
LOCAL_CLANG_CFLAGS      += -Wno-pointer-bool-conversion

include $(BUILD_SHARED_LIBRARY)

endif #BUILD_TINY_ANDROID

# ---------------------------------------------------------------------------------
#                END
# ---------------------------------------------------------------------------------
