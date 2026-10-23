################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (14.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../Core/Src/ap/Display/Display.c 

OBJS += \
./Core/Src/ap/Display/Display.o 

C_DEPS += \
./Core/Src/ap/Display/Display.d 


# Each subdirectory must supply rules for building sources it contributes
Core/Src/ap/Display/%.o Core/Src/ap/Display/%.su Core/Src/ap/Display/%.cyclo: ../Core/Src/ap/Display/%.c Core/Src/ap/Display/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32F411xE -c -I../Core/Inc -I../Drivers/STM32F4xx_HAL_Driver/Inc -I../Drivers/STM32F4xx_HAL_Driver/Inc/Legacy -I../Drivers/CMSIS/Device/ST/STM32F4xx/Include -I../Drivers/CMSIS/Include -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@"

clean: clean-Core-2f-Src-2f-ap-2f-Display

clean-Core-2f-Src-2f-ap-2f-Display:
	-$(RM) ./Core/Src/ap/Display/Display.cyclo ./Core/Src/ap/Display/Display.d ./Core/Src/ap/Display/Display.o ./Core/Src/ap/Display/Display.su

.PHONY: clean-Core-2f-Src-2f-ap-2f-Display

