/*

*/
!define RELEASURL	"http://ftp.mozilla.org/pub/mozilla.org/firefox/releases"
!define APPSIZE	"86000" # kB
!define DLVER	"MultiVersion"
!define APPVER 	"0.0.0.0"
!define APPNAME "Firefox"
!define APP 	"Firefox"
!define DLNAME	"Firefox"
!define APPLANG	"32-64-bit_Multilingual_Online"
!define FOLDER	"FirefoxPortable"
!define MULTILANG
!define FINISHRUN
!define OPTIONS ; Delete if no Components
; !define DESCRIPTION	"Mozilla Web Browser"
!define INPUTBOX
!define SOURCES

SetCompressor /SOLID lzma
SetCompressorDictSize 32

!include "..\_Include\Installer.nsh"
!include "LogicLib.nsh"
!include "x64.nsh"

!insertmacro MUI_LANGUAGE "Afrikaans"
!insertmacro MUI_LANGUAGE "Albanian"
!insertmacro MUI_LANGUAGE "Arabic"
!insertmacro MUI_LANGUAGE "Armenian"
!insertmacro MUI_LANGUAGE "Basque"
!insertmacro MUI_LANGUAGE "Belarusian"
!insertmacro MUI_LANGUAGE "Bosnian"
!insertmacro MUI_LANGUAGE "Breton"
!insertmacro MUI_LANGUAGE "Bulgarian"
!insertmacro MUI_LANGUAGE "Catalan"
!insertmacro MUI_LANGUAGE "Croatian"
!insertmacro MUI_LANGUAGE "Czech"
!insertmacro MUI_LANGUAGE "Danish"
!insertmacro MUI_LANGUAGE "Dutch"
!insertmacro MUI_LANGUAGE "English"
!insertmacro MUI_LANGUAGE "Esperanto"
!insertmacro MUI_LANGUAGE "Estonian"
!insertmacro MUI_LANGUAGE "Finnish"
!insertmacro MUI_LANGUAGE "French"
!insertmacro MUI_LANGUAGE "Galician"
!insertmacro MUI_LANGUAGE "German"
!insertmacro MUI_LANGUAGE "Greek"
!insertmacro MUI_LANGUAGE "Hebrew"
!insertmacro MUI_LANGUAGE "Hindi"
!insertmacro MUI_LANGUAGE "Hungarian"
!insertmacro MUI_LANGUAGE "Icelandic"
!insertmacro MUI_LANGUAGE "Indonesian"
!insertmacro MUI_LANGUAGE "Irish"
!insertmacro MUI_LANGUAGE "Italian"
!insertmacro MUI_LANGUAGE "Japanese"
!insertmacro MUI_LANGUAGE "Khmer"
!insertmacro MUI_LANGUAGE "Korean"
!insertmacro MUI_LANGUAGE "Latvian"
!insertmacro MUI_LANGUAGE "Lithuanian"
!insertmacro MUI_LANGUAGE "Macedonian"
!insertmacro MUI_LANGUAGE "Norwegian"
!insertmacro MUI_LANGUAGE "NorwegianNynorsk"
!insertmacro MUI_LANGUAGE "Polish"
!insertmacro MUI_LANGUAGE "Portuguese"
!insertmacro MUI_LANGUAGE "PortugueseBR"
!insertmacro MUI_LANGUAGE "Romanian"
!insertmacro MUI_LANGUAGE "Russian"
!insertmacro MUI_LANGUAGE "Serbian"
!insertmacro MUI_LANGUAGE "SimpChinese"
!insertmacro MUI_LANGUAGE "Slovak"
!insertmacro MUI_LANGUAGE "Slovenian"
!insertmacro MUI_LANGUAGE "Spanish"
!insertmacro MUI_LANGUAGE "Swedish"
!insertmacro MUI_LANGUAGE "Tamil"
!insertmacro MUI_LANGUAGE "Thai"
!insertmacro MUI_LANGUAGE "TradChinese"
!insertmacro MUI_LANGUAGE "Turkish"
!insertmacro MUI_LANGUAGE "Ukrainian"
!insertmacro MUI_LANGUAGE "Vietnamese"
!insertmacro MUI_LANGUAGE "Welsh"
!insertmacro MUI_LANGUAGE "Zulu"

Var InputVer
Var VER
Function nsDialogsPage
	nsDialogs::Create 1018
	Pop $0
	${NSD_CreateLabel} 0 0 100% 12u "Enter Version Number:"
	Pop $0
	${NSD_CreateText} 0 13u 100% 12u ""
	Pop $InputVer
	nsDialogs::Show
FunctionEnd
Function nsDialogsPageLeave
	${NSD_GetText} $InputVer $R0
StrCmp $R0 "" 0 +3
	MessageBox MB_ICONEXCLAMATION `You must enter a version number!`
Abort
	StrCpy $VER "$R0"
FunctionEnd

Var LNG

Section "${APPNAME} Portable 32 bit" main
Call CheckConnected
	inetc::get  "${RELEASURL}/$VER/win32/$LNG/${APP} Setup $VER.exe" "$TEMP\${APP}PortableTemp\${APP} Setup $VER.exe" /end
	Pop $0
	StrCmp $0 "OK" +3
	MessageBox MB_USERICON "Download of ${APP} Setup $VER.exe ($LNG 32 bit): $0"
	Abort

	SetOutPath "$INSTDIR"
		File "..\..\..\${FOLDER}\${APP}Portable.exe"
	File "/oname=$TEMP\${APP}PortableTemp\7za.exe" "..\_Include\7-Zip\7za.exe"
DetailPrint "Installing ${APPNAME} Portable 32 bit"
	nsExec::Exec `"$TEMP\${APP}PortableTemp\7za.exe" x "$TEMP\${APP}PortableTemp\${APP} Setup $VER.exe" -o"$TEMP\${APP}PortableTemp\Temp"`
	SetOutPath "$INSTDIR\App\${APP}"
	CopyFiles /SILENT "$TEMP\${APP}PortableTemp\Temp\core\*.*" "$INSTDIR\App\${APP}\"

	SetOutPath "$INSTDIR\App\DefaultData\${APP}Profile"
	File "prefs.js"
	File "bookmarks.html"

	ReadINIStr $1 "$INSTDIR\App\${APP}\application.ini" "App" "Version"
	ReadINIStr $2 "$INSTDIR\App\${APP}\application.ini" "Gecko" "MinVersion"
ClearErrors
	FileOpen $0 "$INSTDIR\App\DefaultData\${APP}Profile\prefs.js" a
	IfErrors done
	FileSeek $0 0 END
	FileWrite $0 `user_pref("extensions.lastAppVersion", "$1");`
	FileWriteByte $0 "13"
	FileWriteByte $0 "10"
	FileWrite $0 `user_pref("browser.startup.homepage_override.mstone", "$2");`
	FileWriteByte $0 "13"
	FileWriteByte $0 "10"
	FileClose $0
done:

!ifdef DESCRIPTION
	Call AppInfo
!endif
!ifdef SOURCES
Call Sources
	SetOutPath "$INSTDIR\Other\_Include\7-Zip"
	File "..\_Include\7-Zip\7za.exe"
	SetOutPath "$INSTDIR\Other\Source"
	File "prefs.js"
!endif
!ifdef SOURCES & DESCRIPTION
Call SourceInfo
!endif

SectionEnd

Function .onGUIEnd
	RMDir "/r" "$TEMP\${APP}PortableTemp"
FunctionEnd

Function MultiLang
Push ""
Push 1025
Push "عربي"
Push 1026
Push "Български"
Push 1027
Push "Català"
Push 1028
Push "正體中文 (繁體)"
Push 1029
Push "Čeština"
Push 1030
Push "Dansk"
Push 1031
Push "Deutsch"
Push 1032
Push "Ελληνικά"
Push 1033
Push "English (US)"
Push 1034
Push "Español (de España)"
Push 1035
Push "suomi"
Push 1036
Push "Français"
Push 1037
Push "עברית"
Push 1038
Push "magyar"
Push 1039
Push "íslenska"
Push 1040
Push "Italiano"
Push 1041
Push "日本語"
Push 1042
Push "한국어"
Push 1043
Push "Nederlands"
Push 1044
Push "Norsk bokmål"
Push 1045
Push "Polski"
Push 1046
Push "Português (do Brasil)"
Push 1048
Push "română"
Push 1049
Push "Русский"
Push 1050
Push "Hrvatski"
Push 1051
Push "slovenčina"
Push 1052
Push "Shqip"
Push 1053
Push "Svenska"
Push 1054
Push "ไทย"
Push 1055
Push "Türkçe"
Push 1057
Push "Bahasa Indonesia"
Push 1058
Push "Українська"
Push 1059
Push "Беларуская"
Push 1060
Push "Slovenščina"
Push 1061
Push "Eesti keel"
Push 1062
Push "Latviešu"
Push 1063
Push "lietuvių kalba"
Push 1065
Push "فارسی"
Push 1066
Push "Tiếng Việt"
Push 1067
Push "Հայերեն"
Push 1069
Push "Euskara"
Push 1071
Push "Македонски"
Push 1077
Push "isiZulu"
Push 1078
Push "Afrikaans"
Push 1081
Push "हिन्दी (भारत)"
Push 1084
Push "Gàidhlig"
Push 1087
Push "Қазақ"
Push 1094
Push "ਪੰਜਾਬੀ"
Push 1095
Push "ગુજરાતી"
Push 1096
Push "ଓଡ଼ିଆ"
Push 1097
Push "தமிழ்"
Push 1098
Push "తెలుగు"
Push 1099
Push "ಕನ್ನಡ"
Push 1100
Push "മലയാളം"
Push 1101
Push "অসমীয়া"
Push 1102
Push "मराठी"
Push 1106
Push "Cymraeg"
Push 1107
Push "ខ្មែរ"
Push 1110
Push "Galego"
Push 1122
Push "Frysk"
Push 1127
Push "Pulaar-Fulfulde"
Push 1150
Push "Brezhoneg"
Push 2052
Push "中文 (简体)"
Push 2057
Push "English (British)"
Push 2058
Push "Español (de México)"
Push 2068
Push "Norsk nynorsk"
Push 2070
Push "Português (Europeu)"
Push 2108
Push "Gaeilge"
Push 2117
Push "বাংলা (বাংলাদেশ)"
Push 3098
Push "Српски"
Push 5146
Push "Bosanski"
Push 7177
Push "English (South African)"
Push 9998
Push "Esperanto"
Push 11274
Push "Español (de Argentina)"
Push 13322
Push "Español (de Chile)"

Push A
LangDLL::LangDialog "${APPNAME} Portable Language" "Please select application language."
Pop $LANGUAGE
StrCmp $LANGUAGE "cancel" 0 +2
Abort
FunctionEnd

Section /o "${APPNAME} Portable 64 bit" x64
Delete "$TEMP\${APP}PortableTemp\${APP} Setup $VER.exe"
Call CheckConnected
	inetc::get  "${RELEASURL}/$VER/win64/$LNG/${APP} Setup $VER.exe" "$TEMP\${APP}PortableTemp\${APP} Setup $VER.exe" /end
	Pop $0
	StrCmp $0 "OK" +3
	MessageBox MB_USERICON "Download of ${APP} Setup $VER.exe ($LNG 64 bit): $0"
	Abort

	SetOutPath "$INSTDIR"
		File "..\..\..\${FOLDER}\${APP}Portable.exe"
	File "/oname=$TEMP\${APP}PortableTemp\7za.exe" "..\_Include\7-Zip\7za.exe"
DetailPrint "Installing ${APPNAME} Portable 64 bit"
	nsExec::Exec `"$TEMP\${APP}PortableTemp\7za.exe" x "$TEMP\${APP}PortableTemp\${APP} Setup $VER.exe" -o"$TEMP\${APP}PortableTemp\Temp64"`
	SetOutPath "$INSTDIR\App\${APP}64"
	CopyFiles /SILENT "$TEMP\${APP}PortableTemp\Temp64\core\*.*" "$INSTDIR\App\${APP}64\"

	SetOutPath "$INSTDIR\App\DefaultData\${APP}Profile"
	File "prefs.js"
	File "bookmarks.html"

	ReadINIStr $1 "$INSTDIR\App\${APP}\application.ini" "App" "Version"
	ReadINIStr $2 "$INSTDIR\App\${APP}\application.ini" "Gecko" "MinVersion"
ClearErrors
	FileOpen $0 "$INSTDIR\App\DefaultData\${APP}Profile\prefs.js" a
	IfErrors done
	FileSeek $0 0 END
	FileWrite $0 `user_pref("extensions.lastAppVersion", "$1");`
	FileWriteByte $0 "13"
	FileWriteByte $0 "10"
	FileWrite $0 `user_pref("browser.startup.homepage_override.mstone", "$2");`
	FileWriteByte $0 "13"
	FileWriteByte $0 "10"
	FileClose $0
done:

SectionEnd

Function Init

StrCpy $LNG "en-US"
StrCmp $LANGUAGE "1025" 0 +3
StrCpy $LNG "ar"
Goto lngdone
StrCmp $LANGUAGE "1026" 0 +3
StrCpy $LNG "bg"
Goto lngdone
StrCmp $LANGUAGE "1027" 0 +3
StrCpy $LNG "ca"
Goto lngdone
StrCmp $LANGUAGE "1028" 0 +3
StrCpy $LNG "zh-TW"
Goto lngdone
StrCmp $LANGUAGE "1029" 0 +3
StrCpy $LNG "cs"
Goto lngdone
StrCmp $LANGUAGE "1030" 0 +3
StrCpy $LNG "da"
Goto lngdone
StrCmp $LANGUAGE "1031" 0 +3
StrCpy $LNG "de"
Goto lngdone
StrCmp $LANGUAGE "1032" 0 +3
StrCpy $LNG "el"
Goto lngdone
StrCmp $LANGUAGE "1033" 0 +3
StrCpy $LNG "en-US"
Goto lngdone
StrCmp $LANGUAGE "1034" 0 +3
StrCpy $LNG "es-ES"
Goto lngdone
StrCmp $LANGUAGE "1035" 0 +3
StrCpy $LNG "fi"
Goto lngdone
StrCmp $LANGUAGE "1036" 0 +3
StrCpy $LNG "fr"
Goto lngdone
StrCmp $LANGUAGE "1037" 0 +3
StrCpy $LNG "he"
Goto lngdone
StrCmp $LANGUAGE "1038" 0 +3
StrCpy $LNG "hu"
Goto lngdone
StrCmp $LANGUAGE "1039" 0 +3
StrCpy $LNG "is"
Goto lngdone
StrCmp $LANGUAGE "1040" 0 +3
StrCpy $LNG "it"
Goto lngdone
StrCmp $LANGUAGE "1041" 0 +3
StrCpy $LNG "ja"
Goto lngdone
StrCmp $LANGUAGE "1042" 0 +3
StrCpy $LNG "ko"
Goto lngdone
StrCmp $LANGUAGE "1043" 0 +3
StrCpy $LNG "nl"
Goto lngdone
StrCmp $LANGUAGE "1044" 0 +3
StrCpy $LNG "nb-NO"
Goto lngdone
StrCmp $LANGUAGE "1045" 0 +3
StrCpy $LNG "pl"
Goto lngdone
StrCmp $LANGUAGE "1046" 0 +3
StrCpy $LNG "pt-BR"
Goto lngdone
StrCmp $LANGUAGE "1048" 0 +3
StrCpy $LNG "ro"
Goto lngdone
StrCmp $LANGUAGE "1049" 0 +3
StrCpy $LNG "ru"
Goto lngdone
StrCmp $LANGUAGE "1050" 0 +3
StrCpy $LNG "hr"
Goto lngdone
StrCmp $LANGUAGE "1051" 0 +3
StrCpy $LNG "sk"
Goto lngdone
StrCmp $LANGUAGE "1052" 0 +3
StrCpy $LNG "sq"
Goto lngdone
StrCmp $LANGUAGE "1053" 0 +3
StrCpy $LNG "sv-SE"
Goto lngdone
StrCmp $LANGUAGE "1054" 0 +3
StrCpy $LNG "th"
Goto lngdone
StrCmp $LANGUAGE "1055" 0 +3
StrCpy $LNG "tr"
Goto lngdone
StrCmp $LANGUAGE "1057" 0 +3
StrCpy $LNG "id"
Goto lngdone
StrCmp $LANGUAGE "1058" 0 +3
StrCpy $LNG "uk"
Goto lngdone
StrCmp $LANGUAGE "1059" 0 +3
StrCpy $LNG "be"
Goto lngdone
StrCmp $LANGUAGE "1060" 0 +3
StrCpy $LNG "sl"
Goto lngdone
StrCmp $LANGUAGE "1061" 0 +3
StrCpy $LNG "et"
Goto lngdone
StrCmp $LANGUAGE "1062" 0 +3
StrCpy $LNG "lv"
Goto lngdone
StrCmp $LANGUAGE "1063" 0 +3
StrCpy $LNG "lt"
Goto lngdone
StrCmp $LANGUAGE "1065" 0 +3
StrCpy $LNG "fa"
Goto lngdone
StrCmp $LANGUAGE "1066" 0 +3
StrCpy $LNG "vi"
Goto lngdone
StrCmp $LANGUAGE "1067" 0 +3
StrCpy $LNG "hy-AM"
Goto lngdone
StrCmp $LANGUAGE "1069" 0 +3
StrCpy $LNG "eu"
Goto lngdone
StrCmp $LANGUAGE "1071" 0 +3
StrCpy $LNG "mk"
Goto lngdone
StrCmp $LANGUAGE "1077" 0 +3
StrCpy $LNG "zu"
Goto lngdone
StrCmp $LANGUAGE "1078" 0 +3
StrCpy $LNG "af"
Goto lngdone
StrCmp $LANGUAGE "1081" 0 +3
StrCpy $LNG "hi-IN"
Goto lngdone
StrCmp $LANGUAGE "1084" 0 +3
StrCpy $LNG "gd"
Goto lngdone
StrCmp $LANGUAGE "1087" 0 +3
StrCpy $LNG "kk"
Goto lngdone
StrCmp $LANGUAGE "1094" 0 +3
StrCpy $LNG "pa-IN"
Goto lngdone
StrCmp $LANGUAGE "1095" 0 +3
StrCpy $LNG "gu-IN"
Goto lngdone
StrCmp $LANGUAGE "1096" 0 +3
StrCpy $LNG "or"
Goto lngdone
StrCmp $LANGUAGE "1097" 0 +3
StrCpy $LNG "ta"
Goto lngdone
StrCmp $LANGUAGE "1098" 0 +3
StrCpy $LNG "te"
Goto lngdone
StrCmp $LANGUAGE "1099" 0 +3
StrCpy $LNG "kn"
Goto lngdone
StrCmp $LANGUAGE "1100" 0 +3
StrCpy $LNG "ml"
Goto lngdone
StrCmp $LANGUAGE "1101" 0 +3
StrCpy $LNG "as"
Goto lngdone
StrCmp $LANGUAGE "1102" 0 +3
StrCpy $LNG "mr"
Goto lngdone
StrCmp $LANGUAGE "1106" 0 +3
StrCpy $LNG "cy"
Goto lngdone
StrCmp $LANGUAGE "1107" 0 +3
StrCpy $LNG "km"
Goto lngdone
StrCmp $LANGUAGE "1110" 0 +3
StrCpy $LNG "gl"
Goto lngdone
StrCmp $LANGUAGE "1122" 0 +3
StrCpy $LNG "fy-NL"
Goto lngdone
StrCmp $LANGUAGE "1127" 0 +3
StrCpy $LNG "ff"
Goto lngdone
StrCmp $LANGUAGE "1150" 0 +3
StrCpy $LNG "br"
Goto lngdone
StrCmp $LANGUAGE "2052" 0 +3
StrCpy $LNG "zh-CN"
Goto lngdone
StrCmp $LANGUAGE "2057" 0 +3
StrCpy $LNG "en-GB"
Goto lngdone
StrCmp $LANGUAGE "2058" 0 +3
StrCpy $LNG "es-MX"
Goto lngdone
StrCmp $LANGUAGE "2068" 0 +3
StrCpy $LNG "nn-NO"
Goto lngdone
StrCmp $LANGUAGE "2070" 0 +3
StrCpy $LNG "pt-PT"
Goto lngdone
StrCmp $LANGUAGE "2108" 0 +3
StrCpy $LNG "ga-IE"
Goto lngdone
StrCmp $LANGUAGE "2117" 0 +3
StrCpy $LNG "bn-BD"
Goto lngdone
StrCmp $LANGUAGE "3098" 0 +3
StrCpy $LNG "sr"
Goto lngdone
StrCmp $LANGUAGE "5146" 0 +3
StrCpy $LNG "bs"
Goto lngdone
StrCmp $LANGUAGE "7177" 0 +3
StrCpy $LNG "en-ZA"
Goto lngdone
StrCmp $LANGUAGE "9998" 0 +3
StrCpy $LNG "eo"
Goto lngdone
StrCmp $LANGUAGE "11274" 0 +3
StrCpy $LNG "es-AR"
Goto lngdone
StrCmp $LANGUAGE "13322" 0 +3
StrCpy $LNG "es-CL"
Goto lngdone
lngdone:

SectionSetSize ${x64} 95000 # kB
${If} ${RunningX64}
SectionSetFlags ${x64} 1
${Else}
${EndIf}
FunctionEnd
