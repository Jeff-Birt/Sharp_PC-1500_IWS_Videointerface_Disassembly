@echo off
REM Tell TASM where to find the correct table to use
REM We are using the lh5801 table
set TASMTABS=%TASM%\tasmTab\
REM Move up to the TASM 'install' directory 
REM call TASM with build args and source file name


@echo Building IWS_VIDEOINTERFACE
%TASM%\tasm323\Tasm323.exe -x7 -g3 -5801 IWS-Video_H16_V1.0.lh5801.asm 
del IWS-Video_H16_V1.0.bin
ren IWS-Video_H16_V1.obj IWS-Video_H16_V1.0.bin

@REM %TASM%\tasm323\Tasm323.exe -x7 -g3 -5801 test.lh5801.asm 

@REM IF "%~1" == "-A01" (
@REM     @echo Building version A01
@REM     %TASM%\tasm323\Tasm323.exe -x7 -g3 -5801 -dA01 PC-1500_ROM-A0x.lh5801.asm 
@REM     del PC-1500_ROM-A01.bin
@REM     del PC-1500_ROM-A01.lst
@REM     ren PC-1500_ROM-A0x.obj PC-1500_ROM-A01.bin
@REM     ren PC-1500_ROM-A0x.lst PC-1500_ROM-A01.lst
@REM ) ELSE IF "%~1" == "-A03" (
@REM     @echo Building version A03
@REM     %TASM%\tasm323\Tasm323.exe -x7 -g3 -5801 -dA03 PC-1500_ROM-A0x.lh5801.asm 
@REM     del PC-1500_ROM-A03.bin
@REM     del PC-1500_ROM-A03.lst
@REM     ren PC-1500_ROM-A0x.obj PC-1500_ROM-A03.bin
@REM     ren PC-1500_ROM-A0x.lst PC-1500_ROM-A03.lst
@REM ) ELSE IF "%~1" == "-A04" (
@REM     @echo Building version A04
@REM     %TASM%\tasm323\Tasm323.exe -x7 -g3 -5801 -dA04 PC-1500_ROM-A0x.lh5801.asm 
@REM     del PC-1500_ROM-A04.bin
@REM     del PC-1500_ROM-A04.lst
@REM     ren PC-1500_ROM-A0x.obj PC-1500_ROM-A04.bin
@REM     ren PC-1500_ROM-A0x.lst PC-1500_ROM-A04.lst
@REM ) ELSE ( 
@REM     @echo Unknown command )


:endparse
