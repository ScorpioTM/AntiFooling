#cs ----------------------------------------------------------------------------

 Script Name: AntiFooling UDF
 AutoIt Version: 3.3.8.1
 Author: Scorpio
 Thanks To: Blau
 Date: 04/12/2016

 Script Function:
	Prevent the malware execution exploiting the Anti-Emulation and Anti-Debug techniques used by the Malware.

#ce ----------------------------------------------------------------------------

#comments-start
Processes:
	'VBoxService.exe' (VBOX)
	'VBoxTray.exe' (VBOX)
	'VMwareUser.exe' (VMWARE)
	'VMwareTray.exe' (VMWARE)
	'VMUpgradeHelper.exe' (VMWARE)
	'vmtoolsd.exe' (VMWARE)
	'vmacthlp.exe' (VMWARE)

Files:
	@WindowsDir & '\System32\drivers\VBoxMouse.sys' (VBOX)
	@WindowsDir & '\System32\drivers\VBoxGuest.sys' (VBOX)
	@WindowsDir & '\System32\drivers\VBoxSF.sys' (VBOX)
	@WindowsDir & '\System32\drivers\VBoxVideo.sys' (VBOX)
	@WindowsDir & '\System32\vboxdisp.dll' (VBOX)
	@WindowsDir & '\System32\vboxhook.dll' (VBOX)
	@WindowsDir & '\System32\vboxmrxnp.dll' (VBOX)
	@WindowsDir & '\System32\vboxogl.dll' (VBOX)
	@WindowsDir & '\System32\vboxoglarrayspu.dll' (VBOX)
	@WindowsDir & '\System32\vboxoglcrutil.dll' (VBOX)
	@WindowsDir & '\System32\vboxoglerrorspu.dll' (VBOX)
	@WindowsDir & '\System32\vboxoglfeedbackspu.dll' (VBOX)
	@WindowsDir & '\System32\vboxoglpackspu.dll' (VBOX)
	@WindowsDir & '\System32\vboxoglpassthroughspu.dll' (VBOX)
	@WindowsDir & '\System32\VBoxService.exe' (VBOX)
	@WindowsDir & '\System32\VBoxTray.exe' (VBOX)
	@WindowsDir & '\System32\VBoxControl.exe' (VBOX)
	@WindowsDir & '\System32\drivers\vmmouse.sys' (VMWARE)
	@WindowsDir & '\System32\drivers\vmhgfs.sys' (VMWARE)
	@ProgramFilesDir & '\VMWare\VMware Tools\VMwareUser.exe' (VMWARE)
	@ProgramFilesDir & '\VMWare\VMware Workstation\VMwareTray.exe' (VMWARE)
	@ProgramFilesDir & '\VMWare\VMware Tools\VMUpgradeHelper.exe' (VMWARE)
	@ProgramFilesDir & '\VMWare\VMware Tools\vmtoolsd.exe' (VMWARE)
	@ProgramFilesDir & '\VMWare\VMware Tools\vmacthlp.exe' (VMWARE)

Directories:
	@ProgramFilesDir & '\Oracle\Virtualbox Guest Additions\' (VBOX)
	@ProgramFilesDir & '\VMWare\' (VMWARE)
	@ProgramFilesDir & '\VMWare\VMware Tools' (VMWARE)
	@ProgramFilesDir & '\VMWare\VMware Workstation' (VMWARE)
#comments-end

Global $Artifacts[24]

$Artifacts[0] = @WindowsDir & '\System32\drivers\VBoxMouse.sys|VBOX|0'
$Artifacts[1] = @WindowsDir & '\System32\drivers\VBoxGuest.sys|VBOX|0'
$Artifacts[2] = @WindowsDir & '\System32\drivers\VBoxSF.sys|VBOX|0'
$Artifacts[3] = @WindowsDir & '\System32\drivers\VBoxVideo.sys|VBOX|0'
$Artifacts[4] = @WindowsDir & '\System32\vboxdisp.dll|VBOX|0'
$Artifacts[5] = @WindowsDir & '\System32\vboxhook.dll|VBOX|0'
$Artifacts[6] = @WindowsDir & '\System32\vboxmrxnp.dll|VBOX|0'
$Artifacts[7] = @WindowsDir & '\System32\vboxogl.dll|VBOX|0'
$Artifacts[8] = @WindowsDir & '\System32\vboxoglarrayspu.dll|VBOX|0'
$Artifacts[9] = @WindowsDir & '\System32\vboxoglcrutil.dll|VBOX|0'
$Artifacts[10] = @WindowsDir & '\System32\vboxoglerrorspu.dll|VBOX|0'
$Artifacts[11] = @WindowsDir & '\System32\vboxoglfeedbackspu.dll|VBOX|0'
$Artifacts[12] = @WindowsDir & '\System32\vboxoglpackspu.dll|VBOX|0'
$Artifacts[13] = @WindowsDir & '\System32\vboxoglpassthroughspu.dll|VBOX|0'
$Artifacts[14] = @WindowsDir & '\System32\VBoxService.exe|VBOX|1'
$Artifacts[15] = @WindowsDir & '\System32\VBoxTray.exe|VBOX|1'
$Artifacts[16] = @WindowsDir & '\System32\VBoxControl.exe|VBOX|1'
$Artifacts[17] = @WindowsDir & '\System32\drivers\vmmouse.sys|VMWARE|0'
$Artifacts[18] = @WindowsDir & '\System32\drivers\vmhgfs.sys|VMWARE|0'
$Artifacts[19] = @ProgramFilesDir & '\VMWare\VMware Tools\VMwareUser.exe|VMWARE|1'
$Artifacts[20] = @ProgramFilesDir & '\VMWare\VMware Workstation\VMwareTray.exe|VMWARE|1'
$Artifacts[21] = @ProgramFilesDir & '\VMWare\VMware Tools\VMUpgradeHelper.exe|VMWARE|1'
$Artifacts[22] = @ProgramFilesDir & '\VMWare\VMware Tools\vmtoolsd.exe|VMWARE|1'
$Artifacts[23] = @ProgramFilesDir & '\VMWare\VMware Tools\vmacthlp.exe|VMWARE|1'

Func _AntiFooling($VBox = 1, $VMWare = 1)
	Local $Temp, $i

	For $i = 0 To UBound($Artifacts) - 1
		$Temp = StringSplit($Artifacts[$i], '|')

		If $VBox = 1 And $Temp[2] = 'VBOX' Then
			_Dummy($Temp[1], $Temp[3])
		ElseIf $VMWare = 1 And $Temp[2] = 'VMWARE' Then
			_Dummy($Temp[1], $Temp[3])
		EndIf
	Next
EndFunc

Func _StopFooling()
	Local $Temp, $File, $i

	For $i = 0 To UBound($Artifacts) - 1
		$Temp = StringSplit($Artifacts[$i], '|')
		$File = StringSplit($Temp[1], "\")
		$File = $File[UBound($File) - 1]

		If ProcessExists($File) And $Temp[3] = 1 Then
			ProcessClose($File)
			ProcessWaitClose($File, 5)
		EndIf

		FileSetAttrib($Temp[1], '-RS+NA')
		FileDelete($Temp[1])
	Next

	DirRemove(@ProgramFilesDir & '\VMWare\', 1)
EndFunc

Func _Dummy($Path, $Run)
	Local $File = StringSplit($Path, "\")
	$File = $File[UBound($File) - 1]

	If $Run = 1 Then
		FileCopy(@ScriptFullPath, $Path, 9)
		If Not ProcessExists($File) Then
			Run(@ComSpec & ' /c "' & $Path & '" 2', '', @SW_HIDE)
		EndIf
	Else
		Local $Dummy = FileOpen($Path, 10)
		FileWrite($Dummy, '')
		FileClose($Dummy)
	EndIf
EndFunc