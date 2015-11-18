;NSIS Installer for Xynops-Runtime
;
;Ecrit par Alexandre Gauvrit

;--------------------------------
;Include Modern UI

  !include "MUI2.nsh"

;--------------------------------
;General

	; The name of the installer
	Name "Xynops-Runtime"
	VIProductVersion "1.0"

	; The file to write
	OutFile "Xynops-Runtime.exe"

	; The default installation directory
	InstallDir $PROGRAMFILES\Xynops-Runtime

	; Registry key to check for directory (so if you install again, it will 
	; overwrite the old one automatically)
	InstallDirRegKey HKLM "Software\Xynops" "Install_Dir"

	; Request application privileges for Windows Vista
	RequestExecutionLevel admin

;--------------------------------
;Interface Settings

  !define MUI_HEADERIMAGE
  !define MUI_ICON "xynops.ico"
  !define MUI_HEADERIMAGE_BITMAP "xynops-header.bmp" ; optional
  !define MUI_WELCOMEFINISHPAGE_BITMAP "xynops-finish.bmp" 
  !define MUI_ABORTWARNING

;--------------------------------
;Pages

  !insertmacro MUI_PAGE_WELCOME
  !insertmacro MUI_PAGE_LICENSE "license.txt"
  !insertmacro MUI_PAGE_COMPONENTS
  !insertmacro MUI_PAGE_DIRECTORY
  !insertmacro MUI_PAGE_INSTFILES
  
  !insertmacro MUI_PAGE_FINISH
  
  !insertmacro MUI_UNPAGE_INSTFILES
    
;--------------------------------
;Languages
 
  !insertmacro MUI_LANGUAGE "French"

;--------------------------------
;Installer Sections

; Installation de Xynops_Runtime
Section "Xynops Runtime" SecDummy

  SectionIn RO
  
  ; Copie Installation et suppression du codec
  SetOutPath $INSTDIR
  File "tscc.exe"
  ExecWait '"$INSTDIR\tscc.exe" /s"'
  Delete "tscc.exe"
  
  ; Copie vers dossier Windows
  SetOutPath $WINDIR
  File /r "INF"
  
  ; Copie vers dossier System32 (ou SysWOW64 en x64)
  SetOutPath $SYSDIR
  File /r "Macromed"
  File "COMDLG32.OCX"
  File "l3codecx.acm"
  File "MCI32.OCX"
  File "MCIFR.dll"
  File "mhavi32.ocx"
  File "mhcmbo32.ocx"
  File "mhlocale.dll"
  File "mhrun32.dll"
  File "MSVBVM50.dll"
  File "MSMpiFR.dll"
  File "SSTree.ocx"
  File "unicows.dll"
  File "ViewerProOCX.dll"
  File "VB5FR.dll"
  
  ExecWait '"$INSTDIR\tscc.exe" /s"'
    
  ; Ajout du répertoire d'installlation dans le registre
  WriteRegStr HKLM SOFTWARE\Xynops "Install_Dir" "$INSTDIR"
  
  ; Ecriture des cles de registre de desinstallation pour Windows
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Xynops-Runtime" "DisplayName" "Xynops-Runtime"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Xynops-Runtime" "UninstallString" '"$INSTDIR\uninstall.exe"'
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Xynops-Runtime" "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Xynops-Runtime" "NoRepair" 1
  WriteUninstaller "uninstall.exe"

SectionEnd

; Raccourcis dans le Menu Demarrer
Section "Raccourci dans le Menu Demarrer" MenuDemarrer

  CreateDirectory "$SMPROGRAMS\Xynops-Runtime"
  CreateShortCut "$SMPROGRAMS\Xynops-Runtime\Uninstall.lnk" "$INSTDIR\uninstall.exe" "" "$INSTDIR\uninstall.exe" 0
  
SectionEnd


;--------------------------------
;Descriptions

  ;Language strings
  ;LangString Xynops-Runtime ${LANG_FRENCH} "Installation de Xynops-Runtime"
  LangString DESC_SecDummy ${LANG_FRENCH} "Installation de Xynops-Runtime"
  LangString DESC_MenuDemarrer ${LANG_FRENCH} "Creation d'un raccourci dans le Menu Demarrer"

  ;Assign language strings to sections
  !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
	;!insertmacro MUI_DESCRIPTION_TEXT ${Xynops-Runtime} $(DESC_Xynops-Runtime)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecDummy} $(DESC_SecDummy)
	!insertmacro MUI_DESCRIPTION_TEXT ${MenuDemarrer} $(DESC_MenuDemarrer)
  !insertmacro MUI_FUNCTION_DESCRIPTION_END

;--------------------------------
;Uninstaller Section

Section "Uninstall"

; Remove registry keys
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Xynops-Runtime"
  DeleteRegKey HKLM SOFTWARE\Xynops-Runtime

  ; Remove files and uninstaller
  
  Delete "$INSTDIR\*.*"
  Delete $INSTDIR\uninstall.exe

  ; Remove shortcuts, if any
  Delete "$SMPROGRAMS\Xynops-Runtime\*.*"

  ; Remove directories used
  RMDir "$SMPROGRAMS\Xynops-Runtime"
  RMDir /r "$INSTDIR"

SectionEnd