################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (14.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../Core/Src/ap/StopWatch/StopWatch.c 

OBJS += \
./Core/Src/ap/StopWatch/StopWatch.o 

C_DEPS += \
./Core/Src/ap/StopWatch/StopWatch.d 


# Each subdirectory must supply rules for building sources it contributes
Core/Src/ap/StopWatch/%.o Core/Src/ap/StopWatch/%.su Core/Src/ap/StopWatch/%.cyclo: ../Core/Src/ap/StopWatch/%.c Core/Src/ap/StopWatch/subdir.mk
	arm-none-eabi-gcc "$<" -mcpu=cortex-m4 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32F411xE -c -I../Core/Inc -I../Drivers/STM32F4xx_HAL_Driver/Inc -I../Drivers/STM32F4xx_HAL_Driver/Inc/Legacy -I../Drivers/CMSIS/Device/ST/STM32F4xx/Include -I../Drivers/CMSIS/Include -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@"

clean: clean-Core-2f-Src-2f-ap-2f-StopWatch

clean-Core-2f-Src-2f-ap-2f-StopWatch:
	-$(RM) ./Core/Src/ap/StopWatch/StopWatch.cyclo ./Core/Src/ap/StopWatch/StopWatch.d ./Core/Src/ap/StopWatch/StopWatch.o ./Core/Src/ap/StopWatch/StopWatch.su

.PHONY: clean-Core-2f-Src-2f-ap-2f-StopWatch

