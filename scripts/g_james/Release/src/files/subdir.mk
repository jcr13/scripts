################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CPP_SRCS += \
../src/files/DatFile.cpp \
../src/files/FileHandler.cpp \
../src/files/GaussianInputFileCreator.cpp \
../src/files/GaussianOutputFile.cpp \
../src/files/InputFile.cpp \
../src/files/OutputFile.cpp \
../src/files/SummaryFile.cpp \
../src/files/XYZFile.cpp 

OBJS += \
./src/files/DatFile.o \
./src/files/FileHandler.o \
./src/files/GaussianInputFileCreator.o \
./src/files/GaussianOutputFile.o \
./src/files/InputFile.o \
./src/files/OutputFile.o \
./src/files/SummaryFile.o \
./src/files/XYZFile.o 

CPP_DEPS += \
./src/files/DatFile.d \
./src/files/FileHandler.d \
./src/files/GaussianInputFileCreator.d \
./src/files/GaussianOutputFile.d \
./src/files/InputFile.d \
./src/files/OutputFile.d \
./src/files/SummaryFile.d \
./src/files/XYZFile.d 


# Each subdirectory must supply rules for building sources it contributes
src/files/%.o: ../src/files/%.cpp
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C++ Compiler'
	g++ -O3 -Wall -c -fmessage-length=0 -g -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


