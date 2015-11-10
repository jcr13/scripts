################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CPP_SRCS += \
../src/entropy/Data.cpp \
../src/entropy/Entropy.cpp \
../src/entropy/EntropyResults.cpp 

OBJS += \
./src/entropy/Data.o \
./src/entropy/Entropy.o \
./src/entropy/EntropyResults.o 

CPP_DEPS += \
./src/entropy/Data.d \
./src/entropy/Entropy.d \
./src/entropy/EntropyResults.d 


# Each subdirectory must supply rules for building sources it contributes
src/entropy/%.o: ../src/entropy/%.cpp
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C++ Compiler'
	g++ -O3 -Wall -c -fmessage-length=0 -g -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


