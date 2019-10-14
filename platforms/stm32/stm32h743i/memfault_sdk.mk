EMBEDDED_MFLT_SDK_ROOT ?=
STM32_CUBE_DIR ?=

EMBEDDED_MFLT_OBJ_DIR := $(BUILDDIR)/memfault

EMBEDDED_MFLT_PLATFORM_PORT_ROOT ?= $(EMBEDDED_MFLT_SDK_ROOT)/platforms/stm32/stm32h743i

MEMFAULT_COMPONENTS := core panics
MEMFAULT_COMPONENTS_DIR := $(EMBEDDED_MFLT_SDK_ROOT)/components
MEMFAULT_COMPONENTS_INC_FOLDERS := $(foreach component, $(MEMFAULT_COMPONENTS), $(MEMFAULT_COMPONENTS_DIR)/$(component)/include)
MEMFAULT_COMPONENTS_SRCS := $(foreach component, $(MEMFAULT_COMPONENTS), $(wildcard $(MEMFAULT_COMPONENTS_DIR)/$(component)/src/*.c))
MEMFAULT_COMPONENTS_SRCS := $(patsubst %memfault_fault_handling_xtensa.c, , $(MEMFAULT_COMPONENTS_SRCS))

MEMFAULT_PLATFORM_SRCS := $(wildcard $(EMBEDDED_MFLT_PLATFORM_PORT_ROOT)/platform_reference_impl/*.c)

STM32_CUBE_HAL_SRC = $(STM32_CUBE_DIR)/Drivers/STM32H7xx_HAL_Driver/Src
MEMFAULT_COREDUMP_FLASH_DRIVER_SRC = \
  $(STM32_CUBE_HAL_SRC)/stm32h7xx_hal_flash_ex.c \
  $(STM32_CUBE_HAL_SRC)/stm32h7xx_hal_flash.c

EMBEDDED_MFLT_SDK_INCLUDES = \
  $(STM32_CUBE_DIR)/Drivers/STM32H7xx_HAL_Driver/Inc/ \
  $(STM32_CUBE_DIR)/Drivers/CMSIS/Device/ST/STM32H7xx/Include \
  $(STM32_CUBE_DIR)/Drivers/CMSIS/Include \
  $(EMBEDDED_MFLT_PLATFORM_PORT_ROOT)/platform_reference_impl \
  $(MEMFAULT_COMPONENTS_INC_FOLDERS)
EMBEDDED_MFLT_SDK_INC   := $(patsubst %,-I%,$(EMBEDDED_MFLT_SDK_INCLUDES))

EMBEDDED_MFLT_SDK_SRCS := \
  $(MEMFAULT_COMPONENTS_SRCS) \
  $(MEMFAULT_PLATFORM_SRCS) \
  $(MEMFAULT_COREDUMP_FLASH_DRIVER_SRC)

EMBEDDED_MFLT_SDK_OBJS = $(addprefix $(EMBEDDED_MFLT_OBJ_DIR)/, $(notdir $(EMBEDDED_MFLT_SDK_SRCS:.c=.o)))
