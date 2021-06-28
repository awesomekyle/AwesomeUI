@echo off
set FILES=auraTracker.lua AwesomeUI.xml main.lua auras.lua
set VERSIONS=_classic_ _classic_era_ _classic_ptr_ _retail_ _ptr_

for %%v in (%VERSIONS%) do (
    set ADDON_PATH="%~dp0\..\%%v\Interface\AddOns\AwesomeUI"
    if exist "%~dp0\..\%%v\" (
        if not exist "%~dp0\..\%%v\Interface\AddOns\AwesomeUI" (
            echo %~dp0\..\%%v\Interface\AddOns\AwesomeUI does not exist, creating it...
            mkdir "%~dp0\..\%%v\Interface\AddOns\AwesomeUI"
        ) else (
            echo %~dp0\..\%%v\Interface\AddOns\AwesomeUI already exists
        )
        cmd /C mklink "%~dp0\..\%%v\Interface\AddOns\AwesomeUI\AwesomeUI.toc" "%~dp0\AwesomeUI.%%v.toc"
        for %%f in (%FILES%) do (
            cmd /C mklink "%~dp0\..\%%v\Interface\AddOns\AwesomeUI\%%f" "%~dp0\%%f"
        )
    )
)

@REM cmd /C mklink /D "%~dp0\_classic_\Interface\AddOns\AwesomeUI" "%~dp0\AwesomeUI"
@REM cmd /C mklink /D "%~dp0\_classic_era_\Interface\AddOns\AwesomeUI" "%~dp0\AwesomeUI"
@REM cmd /C mklink /D "%~dp0\_classic_ptr_\Interface\AddOns\AwesomeUI" "%~dp0\AwesomeUI"
@REM cmd /C mklink /D "%~dp0\_retail_\Interface\AddOns\AwesomeUI" "%~dp0\AwesomeUI"
@REM cmd /C mklink /D "%~dp0\_ptr_\Interface\AddOns\AwesomeUI" "%~dp0\AwesomeUI"
pause
