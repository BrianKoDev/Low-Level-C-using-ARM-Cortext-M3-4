# Project Description
Various low level C programming projects using ARM Cortex M3/M4 processors. 

## Task 1
In embedded applications that need trigonometric functions, the high accuracy provided by C library implementations is often not needed. One approach to determine (less accurate) values for trigonometric functions is to use the Taylor series expansion. This project contains code for a Cortex-M4 with a single-precision floating-point unit that it is able to estimate sin(𝑥) using the first three terms of the Taylor series. 

Performance Analysis Report

## Task 2
The purpose of this task is to minimize the execution time when run on a Cortex-M3. The program stores a short sequence of 8-bit data samples that have been obtained from an analogue-to-digital convertor. The program is able to perform filtering by cross-correlation with a digital filter. 
Note the following about the application. 
1. The samples are always 8-bit unsigned values. 
2. The program allows the number of samples to be changed simply by adding or removing 8-bit values in the data area labelled samples, subject to there being a minimum of 8 samples and a maximum of 64 samples. 
3. The values of the filter data are fixed and the number of filter values is fixed. 

Performance Analysis Report

## Task 3
This purpose of this task is the same as for task 2, but execution time is minimized for Cortex-M4. The Cortex-M4 has additional DSP and SIMD instructions available which allows you to make further reductions to the execution time. 

Performance Analysis Report

## Task 4
This report provides an overview of the main features of the AXI bus, the similarities and differences of AHB and AXI, suitable examples of bus signals demonstrating the operations of the features new in AXI. 

Report