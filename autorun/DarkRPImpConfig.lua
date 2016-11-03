print "DarkRP Improvable Money Printer Config Loaded"

ImpCfg = {}

	ImpCfg.MaxUpgrade = 5 --The maximum number of upgrades installed on the printer.
	ImpCfg.PrimaryUpgrade = 0 --Which upgrade is the printer when it is created.
	ImpCfg.MaxVolume = 10 --Maximum capacity of money in the printer. Example: StatUpgrade[1][Upgrade]*MaxVolume
	ImpCfg.HotDecrease = 10 --The cooling rate in establishing the cooler.
	ImpCfg.SpawnPaper = 5 --When you create a printer paper supply current.
	ImpCfg.SpawnPaint = 10 --When you create a printer current paint supply.
	ImpCfg.ReFillPaper = 5 --During the filling of the printer will be added to the amount of paper.
	ImpCfg.ReFillPaint = 10 --During the filling amount of printer ink will be added.
	ImpCfg.MaxPaper = 10 --Maximum paper capacity.
	ImpCfg.MaxPaint = 20 --The maximum capacity of the paint.
	ImpCfg.healthPrinter = 100 --Maximum Printer health.
	ImpCfg.ExtractionCooler = true --The ability to remove the cooler.
	ImpCfg.Power = true --When creating a printer, it will be turned on or off?
	ImpCfg.PaymentText1 = "You take " --Start text dispensing.
	ImpCfg.PaymentText2 = "$ from Money Printer!" --End of text dispensing.
	ImpCfg.Money = Color( 230, 230, 230 ) --The Color of money.
	ImpCfg.HealthBar = Color( 255, 0, 0 ) --Color Printer health.
	ImpCfg.BGHealthBar = Color( 170, 170, 170 ) --The background of the printer's health.
	ImpCfg.BGPower = Color( 170, 170, 170 ) --Background in the printer's power switch.
	ImpCfg.PowerOn = Color( 0, 0, 200 ) --Color buttons included printer.
	ImpCfg.PowerOff = Color( 200, 0, 0 ) --Color printer off button.
	ImpCfg.ButtonExtCooler = Color( 100, 200, 255 ) --Color cooler eject button.
	ImpCfg.BGPlayerName = Color( 50, 150, 230 ) --The background player's name.
	ImpCfg.FGPlayerName = Color( 155, 90, 45 ) --Front background player's name.
	ImpCfg.ColorPlayerName = Color( 230, 230, 230 ) --The color of a player's name.
	ImpCfg.UpgradeColor1 = Color( 218, 218, 218 ) --Color printer body when upgrading №1
	ImpCfg.UpgradeColor2 = Color( 255, 242, 0 ) --Color printer body when upgrading №2
	ImpCfg.UpgradeColor3 = Color( 255, 0, 0 ) --Color printer body when upgrading №3
	ImpCfg.UpgradeColor4 = Color( 29, 223, 0 ) --Color printer body when upgrading №4
	ImpCfg.UpgradeColor5 = Color( 0, 242, 242 ) --Color printer body when upgrading №5
	ImpCfg.UpgradeModel1 = "models/props_phx/wheels/magnetic_med_base.mdl" --Model upgrade№1
	ImpCfg.UpgradeModel2 = "models/props_phx/wheels/magnetic_med_base.mdl" --Model upgrade№2
	ImpCfg.UpgradeModel3 = "models/props_phx/wheels/magnetic_med_base.mdl" --Model upgrade№3
	ImpCfg.UpgradeModel4 = "models/props_phx/wheels/magnetic_med_base.mdl" --Model upgrade№4
	ImpCfg.UpgradeModel5 = "models/props_phx/wheels/magnetic_large_base.mdl" --Model upgrade№5
	ImpCfg.BGColor = Color( 50, 150, 230 ) --The background faceplate.
	ImpCfg.BGPrColor = Color( 200, 200, 200 ) --The background of all consumables/states.
	ImpCfg.InstCooler = Color( 7, 247, 247 ) --If the cooler is installed filling indicator changes color to...
	ImpCfg.UpgradesColor = Color( 0, 0, 0 ) --LED Color set upgrades.
	ImpCfg.TempColor = Color( 0, 0, 0 ) --temperature LED color printer.
	ImpCfg.PaintColor = Color( 0, 0, 0 ) --LED color printer ink occupancy.
	ImpCfg.PaperColor = Color( 0, 0, 0 ) --LED color fullness printer paper. 
	ImpCfg.UpgTextColor = Color( 255, 255, 255 ) --Text Color set upgrades
	ImpCfg.TempTextColor = Color( 255, 255, 255 ) --Text color printer temperature.
	ImpCfg.PaintTextColor = Color( 255, 255, 255 ) --Text color fullness printer ink.
	ImpCfg.PaperTextColor = Color( 255, 255, 255 ) --Text color fullness printer paper.
	ImpCfg.BGModuleCooler = Color(0,0,0,180) --The background of the main panel.
	ImpCfg.BGModulePaint = Color(0,0,0,180) --The background of the main panel.
	ImpCfg.BGModulePaper = Color(0,0,0,180) --The background of the main panel.
	ImpCfg.TextModuleCooler = Color( 255,255,255 ) --The color of the text on the main panel.
	ImpCfg.TextModulePaint = Color( 255,255,255 ) --The color of the text on the main panel.
	ImpCfg.TextModulePaper = Color( 255,255,255 ) --The color of the text on the main panel.
	ImpCfg.SurcleBar = { --Format: { Red, Green, Blue }
		{ 200, 150, 100 }, --Color deserted side Circle Bar.
		{ 230, 230, 230 }, --Color filled hand Circle Bar.
		{ 65, 220, 140 }, --The printer is turned off - color changes to Circle Bar.
		{ 155, 90, 45 } --Front background Circle Bar.
	}
	ImpCfg.StatUpgrade = {
	{ 10, 15, 25, 35, 50, 60 }, --The amount of money issued depending on upgrades
	{ 60, 60, 50, 50, 40, 20 } --Time requires to print money, depending on upgrades. "Time is Money"
	}