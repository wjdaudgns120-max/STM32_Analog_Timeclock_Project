################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (14.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../Core/Src/driver/ds3231/ds3231.c 

OBJS += \
./Core/Src/driver/ds3231/ds3231.o 

C_DEPS += \
./Core/Src/driver/ds3231/ds3231.d 


# Each subdirectory must supply rules for building sources it contributes
Core/Src/driver/ds3231/%.o Core/Src/driver/ds3231/%.su Core/Src/driver/ds3231/%.cyclo: ../Core/Src/driver/ds3231/%.c Core/Src/driver/ds3231/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32F411xE -c -I../Core/Inc -I../Drivers/STM32F4xx_HAL_Driver/Inc -I../Drivers/STM32F4xx_HAL_Driver/Inc/Legacy -I../Drivers/CMSIS/Device/ST/STM32F4xx/Include -I../Drivers/CMSIS/Include -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@"

clean: clean-Core-2f-Src-2f-driver-2f-ds3231

clean-Core-2f-Src-2f-driver-2f-ds3231:
	-$(RM) ./Core/Src/driver/ds3231/ds3231.cyclo ./Core/Src/driver/ds3231/ds3231.d ./Core/Src/driver/ds3231/ds3231.o ./Core/Src/driver/ds3231/ds3231.su

.PHONY: clean-Core-2f-Src-2f-driver-2f-ds3231

