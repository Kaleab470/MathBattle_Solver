; **************************************************************************
; === Define constants ===
; **************************************************************************
!define VER "0.0.0.0"
!define APPNAME "Mozilla Firefox"
!define APP "Firefox"
!define APPDIR "App\Firefox"
!define APPEXE "firefox.exe"
!define APPDIR64 "App\Firefox64"
!define APPEXE64 "firefox.exe"

;--- Define RegKeys ---
	!define REGKEYVALUE1 "HKEY_CLASSES_ROOT\mailto\shell\open\command"
	!define REGVALUE1 ""

; ---Define Local Dirs, SubDirs (if any) beginnig with back-slash and Portable Dirs ---
	!define LOCALDIR1 "$APPDATA\Mozilla"
	!define SUBDIR1 ""
	!define LOCALDIR2 "$LOCALAPPDATA\Mozilla"
	!define SUBDIR2 ""

; **************************************************************************
; === Best Compression ===
; **************************************************************************
SetCompressor /SOLID lzma
SetCompressorDictSize 32

; **************************************************************************
; === Includes ===
; **************************************************************************
!include "..\_Include\Launcher.nsh" 
!include "LogicLib.nsh"
!include "x64.nsh"
!include "FileFunc.nsh"

; **************************************************************************
; === Set basic information ===
; **************************************************************************
Name "${APPNAME} Portable"
OutFile "..\..\..\FirefoxPortable\${APP}Portable.exe"
Icon "${APP}.ico"

; **************************************************************************
; === Other Actions ===
; **************************************************************************
Var PARENTDIR
Var USER
Var THUNDERBIRDUSER
Var PLUGINPATH

Function MultiUser
ReadINIStr $USER "$EXEDIR\${APP}Portable.ini" "${APP}Portable" "User"
StrCmp $USER "" 0 +3
WriteINIStr "$EXEDIR\${APP}Portable.ini" "${APP}Portable" "User" "${APP}"
StrCpy $USER "${APP}"
IfFileExists "$EXEDIR\Data\$USER\*.*" +3
CreateDirectory "$EXEDIR\Data\$USER"
CopyFiles /SILENT  "$EXEDIR\App\DefaultData\${APP}Profile\*.*" "$EXEDIR\Data\$USER"
FunctionEnd

Function Init
	${GetParent} "$EXEDIR" "$PARENTDIR"
	StrCpy $PLUGINPATH "$EXEDIR\Data\Plugins;$PARENTDIR\CommonFiles\Plugins"
${If} ${RunningX64}
${AndIf} ${FileExists} "$EXEDIR\${APPDIR64}\${APPEXE64}"
IfFileExists "$PARENTDIR\CommonFiles\Java64\bin\plugin2\npjp2.dll" 0 +2
	StrCpy $PLUGINPATH "$PLUGINPATH;$PARENTDIR\CommonFiles\Java64\bin\plugin2"
IfFileExists "$PARENTDIR\CommonFiles\Java_64\bin\plugin2\npjp2.dll" 0 +2
	StrCpy $PLUGINPATH "$PLUGINPATH;$PARENTDIR\CommonFiles\Java_64\bin\plugin2"
	nsisFirewall::AddAuthorizedApplication "$EXEDIR\${APPDIR64}\${APPEXE64}" "${APPNAME} Portable 64 bit"
${Else}
IfFileExists "$PARENTDIR\CommonFiles\Java\bin\plugin2\npjp2.dll" 0 +2
	StrCpy $PLUGINPATH "$PLUGINPATH;$PARENTDIR\CommonFiles\Java\bin\plugin2"
	nsisFirewall::AddAuthorizedApplication "$EXEDIR\${APPDIR}\${APPEXE}" "${APPNAME} Portable"
${EndIf}
System::Call 'Kernel32::SetEnvironmentVariableA(t, t) i("MOZ_PLUGIN_PATH", "$PLUGINPATH").r0'
FunctionEnd

Function CheckInit
	ReadINIStr $0 "$EXEDIR\${APP}Portable.ini" "${APP}Portable" "ThunderbirdAssociate"
	StrCmp $0 "false" CheckInitEnd
	WriteINIStr "$EXEDIR\${APP}Portable.ini" "${APP}Portable" "ThunderbirdAssociate" "true"
	IfFileExists "$PARENTDIR\ThunderbirdPortable\App\Thunderbird\thunderbird.exe" RegThunder
	Goto CheckInitEnd
RegThunder:
	${registry::BackupValue} "${REGKEYVALUE1}" "${REGVALUE1}"
	Sleep 50
	${registry::Unload}
ReadINIStr $THUNDERBIRDUSER "$PARENTDIR\ThunderbirdPortable\ThunderbirdPortable.ini" "ThunderbirdPortable" "User"
	WriteRegStr HKEY_CLASSES_ROOT "mailto\shell\open\command" "" `"$PARENTDIR\ThunderbirdPortable\App\Thunderbird\thunderbird.exe" -profile "$PARENTDIR\ThunderbirdPortable\Data\$THUNDERBIRDUSER" -compose "%1"`
CheckInitEnd:
FunctionEnd

;**********************************************************
Function Close
${If} ${RunningX64}
${AndIf} ${FileExists} "$EXEDIR\${APPDIR64}\${APPEXE64}"
	nsisFirewall::RemoveAuthorizedApplication "$EXEDIR\${APPDIR64}\${APPEXE64}"
${Else}
	nsisFirewall::RemoveAuthorizedApplication "$EXEDIR\${APPDIR}\${APPEXE}"
${EndIf}
FunctionEnd

Function CheckClose
	ReadINIStr $0 "$EXEDIR\${APP}Portable.ini" "${APP}Portable" "ThunderbirdAssociate"
	StrCmp $0 "false" CheckCloseEnd
	IfFileExists "$PARENTDIR\ThunderbirdPortable\App\Thunderbird\thunderbird.exe" UnRegThunder
	Goto CheckCloseEnd
UnRegThunder:
	${registry::RestoreBackupValue} "${REGKEYVALUE1}" "${REGVALUE1}"
	Sleep 50
	${registry::Unload}
CheckCloseEnd:
FunctionEnd

; **************************************************************************
; === Run Application ===
; **************************************************************************
Function Launch
${GetParameters} $0
${If} ${RunningX64}
${AndIf} ${FileExists} "$EXEDIR\${APPDIR64}\${APPEXE64}"
SetOutPath "$EXEDIR\${APPDIR64}"
ExecWait `"$EXEDIR\${APPDIR64}\${APPEXE64}" -profile "$EXEDIR\Data\$USER" $0`
${Else}
SetOutPath "$EXEDIR\${APPDIR}"
ExecWait `"$EXEDIR\${APPDIR}\${APPEXE}" -profile "$EXEDIR\Data\$USER" $0`
${EndIf}
WriteINIStr "$EXEDIR\Data\${APP}Portable.ini" "${APP}Portable" "GoodExit" "true"
newadvsplash::stop
FunctionEnd

; **************************************************************************
; ==== Running ====
; **************************************************************************

Section "Main"

	Call MultiUser
	Call CheckStart

	Call BackupLocalDirs

	Call Init
	Call CheckInit
	
		Call SplashLogo
		Call Launch

	Call Restore

SectionEnd

Function Restore

	Call Close
	Call CheckClose

	Call RestoreLocalDirs

FunctionEnd

; **************************************************************************
; ==== Actions on Folders =====
; **************************************************************************
Function BackupLocalDirs
	${directory::BackupLocal} "${LOCALDIR1}" "${SUBDIR1}"
	${directory::BackupLocal} "${LOCALDIR2}" "${SUBDIR2}"

FunctionEnd

Function RestoreLocalDirs
	${directory::RestoreLocal} "${LOCALDIR1}" "${SUBDIR1}"
	${directory::RestoreLocal} "${LOCALDIR2}" "${SUBDIR2}"
FunctionEnd
