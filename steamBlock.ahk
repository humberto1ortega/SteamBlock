; --------------------------------------------------
; MAIN START
; --------------------------------------------------
#Requires AutoHotkey v2.0

; Creating/Deleteing firewall rules require running as admin so only run if user agrees
if !A_IsAdmin {
    try
    {
        Run('*RunAs "' A_ScriptFullPath '"')
    }
    catch
    {
        MsgBox("Admin rights are required to run steam blocker since it creates/deletes firewall rules.")
        ExitApp()
    }

    ExitApp()
}

; Default dimensions and margins/padding between form controls
guiW := 300
guiH := 75
margin := 10
fullWidth := guiW - (margin*2)
currentY := 10
defaultRuleName := "BlockSteamIn"

; Set main gui with the form name
mainGui := Gui(, "Pert's Steam Blocker")
mainGui.SetFont("s11", "Segoe UI")

; Set the status message and check if the firewall is currently active to let the user know
firewallStatus := mainGui.AddText("x10 y" currentY " w" fullWidth " Center" , "Checking Steam Block Status...")
currentY := currentY + 20
; Set the button to toggle the block gui
btnToggleBlock := mainGui.AddButton("x10" " y" currentY " w" fullWidth " h40", "Loading...")
btnToggleBlock.OnEvent("Click", ToggleSteamBlock)
mainGui.OnEvent("Close", (*) => OnSteamBlockClose())
DisplayFirewallActive()

; Show the form
mainGui.Show("w" guiW " h" guiH)


; --------------------------------------------------
; STATUS CHECKING FUNCIONS
; --------------------------------------------------
DisplayFirewallActive(*) {
	; Display the message depending on if the firewall rule exists.
	exists := GetFirewallActive()
	if exists
	{
		firewallStatus.Text := "Steam is Blocked!"
		firewallStatus.SetFont("cGreen")
		btnToggleBlock.Enabled := true
		btnToggleBlock.Text := "Unblock Steam"
		return true
	}
	else
	{
		firewallStatus.Text := "Steam is Unblocked!"
		firewallStatus.SetFont("cRed")
		btnToggleBlock.Enabled := true
		btnToggleBlock.Text := "Block Steam"
		return false
	}
}

DisplayFirewallLoading(blocked) {
	; Display the message to let the user know the firewalls are being set up
	firewallStatus.Text := (blocked ? "Re-Connecting" : "Disconnecting") " Steam's Internet"
	firewallStatus.SetFont("cBlue")
	btnToggleBlock.Enabled := false
	btnToggleBlock.Text := (blocked ? "Unb" : "B") "locking..."
}

GetFirewallActive(*) {	
	; Run the powershell script to see if the firewall rules already exist.
	tempFile := A_Temp "\steam_block_firewall_check.txt"

	; Write to a temp file if the firewall rule exists
	RunWait(
		'cmd.exe /c netsh advfirewall firewall show rule name="' defaultRuleName '" > "' tempFile '"',
		,
		"Hide"
	)

	; Check the file if it was found then delete it
	output := FileRead(tempFile)
	FileDelete(tempFile)
	return !InStr(output, "No rules match")
}

; --------------------------------------------------
; FIRE WALL RULES FUNCTIONS
; --------------------------------------------------
ToggleSteamBlock(*) {
	; Toggles firewall rules active/inactive
	if(GetFirewallActive()) {
		DisplayFirewallLoading(true)
		RemoveAllFirewallRules()
		Sleep(3000) ; 3 seconds
	} else {
		DisplayFirewallLoading(false)
		AddAllFirewallRules()
		Sleep(7000) ; 7 seconds
	}
	; Delay a few seconds before showing steam is blocked/unblocked since it takes a second to kick in
	DisplayFirewallActive()
}

AddAllFirewallRules(*) {
	; Add all the new firewall rules for steamblock
	Run('netsh advfirewall firewall add rule name="BlockSteamIn" dir=in program="C:\Program Files (x86)\Steam\steam.exe" profile=any action=block', , "Hide")
	Run('netsh advfirewall firewall add rule name="BlockSteamOut" dir=out program="C:\Program Files (x86)\Steam\steam.exe" profile=any action=block', , "Hide")
}

RemoveAllFirewallRules(*) {
	; Delete all the firewall rules for steam block
	Run('netsh advfirewall firewall delete rule name="BlockSteamIn"', , "Hide")
	Run('netsh advfirewall firewall delete rule name="BlockSteamOut"', , "Hide")
}

; --------------------------------------------------
; ON CLOSE FUNCTIONS
; --------------------------------------------------
OnSteamBlockClose() {
	; Remove the firewall rules when closing the app
	if(GetFirewallActive()) {
		DisplayFirewallLoading(true)
		RemoveAllFirewallRules()
		Sleep(3000) ; 3 seconds
	}
	ExitApp()
}