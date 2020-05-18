if not A_IsAdmin
{
   Run *RunAs "%A_ScriptFullPath%"  ;
   ExitApp
}

Gui, Add, Button, x15 y50 w100 gBS, Block Steam
Gui, Add, Button, x+50 w100 gUBS, Unblock Steam
Gui, Add, Button, w100 gDSB, Delete Firewall
Gui, Add, Button, x15 y80 w100 gCSB, Create Firewall
Gui, Font, s11 cRed, Verdana
Gui, Add, Text, x25 y15, Steam Internet Blocker VIA Pert.
Gui, Show, w280 h120, Pert's Steam Blocker Official v1.0
Return

BS:
	run, netsh advfirewall firewall set rule name="BlockSteamIn" new enable=yes,,hide
	run, netsh advfirewall firewall set rule name="BlockSteamIn2" new enable=yes,,hide
	run, netsh advfirewall firewall set rule name="BlockSteamOut" new enable=yes,,hide
	run, netsh advfirewall firewall set rule name="BlockSteamOut2" new enable=yes,,hide
Return

UBS:
	run, netsh advfirewall firewall set rule name="BlockSteamIn" new enable=no,,hide
	run, netsh advfirewall firewall set rule name="BlockSteamIn2" new enable=no,,hide
	run, netsh advfirewall firewall set rule name="BlockSteamOut" new enable=no,,hide
	run, netsh advfirewall firewall set rule name="BlockSteamOut2" new enable=no,,hide
Return

CSB:
	run, netsh advfirewall firewall add rule name="BlockSteamIn" dir=in program="c:\Program Files (x86)\Steam\steam.exe" profile=any action=block,,hide
	run, netsh advfirewall firewall add rule name="BlockSteamIn2" dir=in program="c:\Program Files (x86)\Steam\GameOverlayUI.exe" profile=any action=block,,hide
	run, netsh advfirewall firewall add rule name="BlockSteamOut" dir=out program="c:\Program Files (x86)\Steam\steam.exe" profile=any action=block,,hide
	run, netsh advfirewall firewall add rule name="BlockSteamOut2" dir=out program="c:\Program Files (x86)\Steam\GameOverlayUI.exe" profile=any action=block,,hide
Return

DSB:
	run, netsh advfirewall firewall delete rule name="BlockSteamIn",,hide
	run, netsh advfirewall firewall delete rule name="BlockSteamIn2",,hide
	run, netsh advfirewall firewall delete rule name="BlockSteamOut",,hide
	run, netsh advfirewall firewall delete rule name="BlockSteamOut2",,hide
Return

GuiClose:
  ExitApp
Return