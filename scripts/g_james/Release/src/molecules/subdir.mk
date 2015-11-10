################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CPP_SRCS += \
../src/molecules/Atom.cpp \
../src/molecules/CoarseGlucose.cpp \
../src/molecules/Molecule.cpp 

OBJS += \
./src/molecules/Atom.o \
./src/molecules/CoarseGlucose.o \
./src/molecules/Molecule.o 

CPP_DEPS += \
./src/molecules/Atom.d \
./src/molecules/CoarseGlucose.d \
./src/molecules/Molecule.d 


# Each subdirectory must supply rules for building sources it contributes
src/molecules/%.o: ../src/molecules/%.cpp
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C++ Compiler'
	g++ -O3 -Wall -c -fmessage-length=0 -g -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


