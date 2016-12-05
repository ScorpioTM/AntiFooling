#cs ----------------------------------------------------------------------------

 Script Name: AntiFooling UDF
 AutoIt Version: 3.3.8.1
 Author: Scorpio
 Thanks To: Blau
 Date: 04/12/2016

 Script Function:
	Prevent the malware execution exploiting the Anti-Emulation and Anti-Debug techniques used by the Malware.

#ce ----------------------------------------------------------------------------

#RequireAdmin

#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <FileConstants.au3>
#include <AntiFooling.au3>

If $CmdLine[0] = 0 Then
	#Region ### START Koda GUI section ### Form=C:\Users\Windows\Desktop\Form1.kxf
	Local $Form1     = GUICreate('AntiFooling v1.0.0', 370, 166, 323, 275)
	Local $Label1    = GUICtrlCreateLabel('AntiFooling is a tool designed for preventing the malware execution.', 8, 8, 321, 17)
	Local $Label2    = GUICtrlCreateLabel('This is possible through the exploitation of the most common exceptions for', 8, 22, 360, 18)
	Local $Label3    = GUICtrlCreateLabel('Anti-Emulation and Anti-Debuging techniques used by the Malware, that will', 8, 36, 358, 17)
	Local $Label4    = GUICtrlCreateLabel('stop the execution if it detects something.', 8, 50, 199, 17)
	Local $Group1    = GUICtrlCreateGroup('Virtual Machines', 8, 68, 353, 41)
	Local $Checkbox1 = GUICtrlCreateCheckbox('VirtualBox', 16, 80, 97, 17)
	Local $Checkbox2 = GUICtrlCreateCheckbox('VMWare', 256, 80, 97, 17)
	Local $Checkbox3 = GUICtrlCreateCheckbox('Run on System Startup', 8, 110, 130, 17)
	GUICtrlCreateGroup('', -99, -99, 1, 1)
	Local $Button1 = GUICtrlCreateButton('Enable', 8, 132, 169, 25)
	Local $Button2 = GUICtrlCreateButton('Disable', 192, 132, 169, 25)
	GUISetState(@SW_SHOW)
	#EndRegion ### END Koda GUI section ###

	Local $CheckStatus1 = 0
	Local $CheckStatus2 = 0
	Local $CheckStatus3 = 0

	While 1
		Local $nMsg = GUIGetMsg()
		Switch $nMsg
			Case $Button1 ;Start Button
				If $CheckStatus3 = 1 Then ;If Startup is checked
					If @OSArch = 'X86' Then
						If IsAdmin() Then
							If RegRead('HKLM\Software\Microsoft\Windows\CurrentVersion\Run', 'AntiFooling') <> '"' & @ScriptFullPath & '" 1 ' & $CheckStatus1 & ' ' & $CheckStatus2 Then
								RegWrite('HKLM\Software\Microsoft\Windows\CurrentVersion\Run', 'AntiFooling', 'REG_SZ', '"' & @ScriptFullPath & '" 1 ' & $CheckStatus1 & ' ' & $CheckStatus2)
							EndIf
						Else
							If RegRead('HKCU\Software\Microsoft\Windows\CurrentVersion\Run', 'AntiFooling') <> '"' & @ScriptFullPath & '" 1 ' & $CheckStatus1 & ' ' & $CheckStatus2 Then
								RegWrite('HKCU\Software\Microsoft\Windows\CurrentVersion\Run', 'AntiFooling', 'REG_SZ', '"' & @ScriptFullPath & '" 1 ' & $CheckStatus1 & ' ' & $CheckStatus2)
							EndIf
						EndIf
					Else
						If IsAdmin() Then
							If RegRead('HKLM64\Software\Microsoft\Windows\CurrentVersion\Run', 'AntiFooling') <> '"' & @ScriptFullPath & '" 1 ' & $CheckStatus1 & ' ' & $CheckStatus2 Then
								RegWrite('HKLM64\Software\Microsoft\Windows\CurrentVersion\Run', 'AntiFooling', 'REG_SZ', '"' & @ScriptFullPath & '" 1 ' & $CheckStatus1 & ' ' & $CheckStatus2)
							EndIf
						Else
							If RegRead('HKCU\Software\Microsoft\Windows\CurrentVersion\Run', 'AntiFooling') <> '"' & @ScriptFullPath & '" 1 ' & $CheckStatus1 & ' ' & $CheckStatus2 Then
								RegWrite('HKCU\Software\Microsoft\Windows\CurrentVersion\Run', 'AntiFooling', 'REG_SZ', '"' & @ScriptFullPath & '" 1 ' & $CheckStatus1 & ' ' & $CheckStatus2)
							EndIf
						EndIf
					EndIf
				Else
					RegDelete('HKLM64\Software\Microsoft\Windows\CurrentVersion\Run', 'AntiFooling')
					RegDelete('HKLM\Software\Microsoft\Windows\CurrentVersion\Run', 'AntiFooling')
					RegDelete('HKCU\Software\Microsoft\Windows\CurrentVersion\Run', 'AntiFooling')
				EndIf
				_AntiFooling($CheckStatus1, $CheckStatus2) ;Start AntiFooling
			Case $Button2 ;Stop Button
				If $CheckStatus3 = 0 Then ;If Startup is unchecked
					RegDelete('HKLM64\Software\Microsoft\Windows\CurrentVersion\Run', 'AntiFooling')
					RegDelete('HKLM\Software\Microsoft\Windows\CurrentVersion\Run', 'AntiFooling')
					RegDelete('HKCU\Software\Microsoft\Windows\CurrentVersion\Run', 'AntiFooling')
				EndIf
				_StopFooling() ;Stop AntiFooling
			Case $Checkbox1
				If GUICtrlRead($Checkbox1) = 1 Then
					$CheckStatus1 = 1
				Else
					$CheckStatus1 = 0
				EndIf
			Case $Checkbox2
				If GUICtrlRead($Checkbox2) = 1 Then
					$CheckStatus2 = 1
				Else
					$CheckStatus2 = 0
				EndIf
			Case $Checkbox3
				If GUICtrlRead($Checkbox3) = 1 Then
					$CheckStatus3 = 1
				Else
					$CheckStatus3 = 0
				EndIf
			Case $GUI_EVENT_CLOSE
				Exit
		EndSwitch
	WEnd

ElseIf $CmdLine[1] = 1 Then
	_AntiFooling($CmdLine[2], $CmdLine[3])

ElseIf $CmdLine[1] = 2 Then
	TraySetState(2)
	While 1
		Sleep(10000)
	WEnd
EndIf