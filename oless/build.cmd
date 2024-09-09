
for %%x in (msbuild) do if not [%%~$PATH:x]=[] set HasMSBuild=1

if NOT DEFINED HasMSBuild (
	cl.exe /Zi /EHsc /std:c++14 /Fe:oless pole.cpp olessoffice.cpp oless.cpp vbahelper.cpp program.cpp
) ELSE (
	msbuild .\oless.vcxproj /t:Rebuild /p:Configuration=Debug;OutDir=..\Debug
)
