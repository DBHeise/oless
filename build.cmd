@echo off

msbuild .\oless\oless.vcxproj /t:Rebuild /p:Configuration=Debug;OutDir=..\bin\windows\debug
