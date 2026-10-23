################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (14.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../Core/Src/driver/fnd/fnd.c 

OBJS += \
./Core/Src/driver/fnd/fnd.o 

C_DEPS += \
./Core/Src/driver/fnd/fnd.d 


# Each subdirectory must supply rules for building sources it contributes
Core/Src/driver/fnd/%.o Core/Src/driver/fnd/%.su Core/Src/driver/fnd/%.cyclo: ../Core/Src/driver/fnd/%.c Core/Src/driver/fnd/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32F411xE -c -I../Core/Inc -I../Drivers/STM32F4xx_HAL_Driver/Inc -I../Drivers/STM32F4xx_HAL_Driver/Inc/Legacy -I../Drivers/CMSIS/Device/ST/STM32F4xx/Include -I../Drivers/CMSIS/Include -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@"

clean: clean-Core-2f-Src-2f-driver-2f-fnd

clean-Core-2f-Src-2f-driver-2f-fnd:
	-$(RM) ./Core/Src/driver/fnd/fnd.cyclo ./Core/Src/driver/fnd/fnd.d ./Core/Src/driver/fnd/fnd.o ./Core/Src/driver/fnd/fnd.su

.PHONY: clean-Core-2f-Src-2f-driver-2f-fnd

