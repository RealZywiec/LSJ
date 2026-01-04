#NoEnv
#SingleInstance Force
SetWorkingDir %A_ScriptDir%
CoordMode, Mouse, Screen

; ===== KONFIGURACJA AKTUALIZACJI (GITHUB) =====
global obecnaWersja := "1.1"
global urlWersja := "https://raw.githubusercontent.com/RealZywiec/LSJ/refs/heads/main/version.txt"
global urlSkrypt := "https://raw.githubusercontent.com/RealZywiec/LSJ/refs/heads/main/LSJ.ahk"
global nazwaPlikuSkryptu := A_ScriptName

; Uruchomienie sprawdzania aktualizacji
SprawdzAktualizacje()

; ===== KONFIGURACJA AFK FARM =====
global aktywny := false
global clickDelay := 30
global craftInterval := 36000
global lastCraftTime := 0
global leafBind := "F6"

global zelazoPozycja_X := 0, zelazoPozycja_Y := 0
global craftSlot1_X := 0, craftSlot1_Y := 0
global craftSlot2_X := 0, craftSlot2_Y := 0
global wynikNozyce_X := 0, wynikNozyce_Y := 0
global slotNozyce_X := 0, slotNozyce_Y := 0

global ustawianieWspolrzednych := false
global ktoreUstawiam := ""

; ===== KONFIGURACJA FISHING =====
global fishingActive := false
global fishingBind := "8"

; ===== GUI - LSJ VERTICAL TABS =====
Gui, -Caption +Border
Gui, Color, 111111, 171717
Gui, +LastFound
Gui, Margin, 0, 0

; Custom Title Bar
Gui, Font, s10 Bold c5dade
Gui, Add, Text, x15 y8 w400 BackgroundTrans vDragBar gDragWindow, LSJ Auto-Farm v%obecnaWersja%
Gui, Font, s10 Bold cWhite
Gui, Add, Button, x485 y5 w20 h20 gMinimizeWindow Background171717 cWhite, _
Gui, Add, Button, x510 y5 w20 h20 gGuiClose Background171717 cWhite, X

; Vertical Menu
Gui, Add, Progress, x15 y40 w1 h340 Background2a4d4f c5dade Vertical, 100
Gui, Font, s9 Bold cWhite
Gui, Add, Button, x25 y50 w100 h35 gShowHome Background171717 cWhite, Strona Glowna
Gui, Add, Button, x25 y95 w100 h35 gShowLeafFarm Background171717 cWhite, Leaf Farm
Gui, Add, Button, x25 y140 w100 h35 gShowFishing Background171717 cWhite, Auto Fishing

; Content Area Background
Gui, Add, Progress, x140 y40 w1 h340 Background2a4d4f c5dade Vertical, 100

; ===== STRONA GLOWNA =====
Gui, Font, s12 Bold c5dade
Gui, Add, Text, x155 y55 w350 vHomeTitle Background111111, Witam z tej strony xzywieccc!
Gui, Font, s9 Normal cWhite
Gui, Add, Text, x155 y85 w350 vHomeText1 Background111111, Zapraszam do korzystania z mojego skryptu.
Gui, Font, s8 Normal c99d9db
Gui, Add, Text, x155 y115 w350 vHomeText2 Background111111, Tool dla LSJ Guild - automatyzacja farmienia lisci i lowienia ryb.
Gui, Add, Text, x155 y155 w350 vHomeText3 Background111111, Funkcje:
Gui, Font, s8 Normal cWhite
Gui, Add, Text, x155 y175 w350 vHomeFunc1 Background111111, - AFK Leaf Farm - automatyczne stawianie i scinanie
Gui, Add, Text, x155 y190 w350 vHomeFunc2 Background111111, - Auto Fishing - automatyczne lowienie (w tle)
Gui, Add, Text, x155 y205 w350 vHomeFunc3 Background111111, - Automatyczne craftowanie nozyc
Gui, Add, Text, x155 y220 w350 vHomeFunc4 Background111111, - Zmienny bind dla fishingu i leaf farm
Gui, Font, s7 Normal c5dade
Gui, Add, Text, x155 y260 w350 vHomeFooter Background111111 Center, Wybierz opcje z menu aby rozpoczac

; ===== LEAF FARM =====
Gui, Font, s8 Bold cWhite
Gui, Add, Text, x155 y55 w350 vLeafTitle Background111111 Hidden, AFK LEAF FARM
Gui, Add, Text, x155 y85 Background111111 vLeafBindLabel Hidden, Hotkey:
Gui, Add, Edit, x210 y82 w40 h20 Background171717 cWhite vLeafBindInput Hidden Limit2, %leafBind%
Gui, Add, Button, x255 y82 w60 h20 gZmienLeafBind Background171717 cWhite vLeafBindBtn Hidden, Zmien
Gui, Font, s8 Normal cWhite
Gui, Add, Text, x155 y110 Background111111 vLeafStatusLabel Hidden, Status:
Gui, Add, Text, x205 y110 w150 vLeafStatus cff4757 Background111111 Hidden, WYLACZONY
Gui, Font, s8 Bold cWhite
Gui, Add, Text, x155 y135 Background111111 vLeafDelayLabel Hidden, Opoznienie (ms):
Gui, Add, Edit, x250 y132 w50 h20 Background171717 cWhite vDelayInput Hidden, %clickDelay%
Gui, Add, Button, x305 y132 w50 h20 gZmienDelay Background171717 cWhite vLeafDelayBtn Hidden, OK
Gui, Add, Text, x155 y160 Background111111 vLeafCraftLabel Hidden, Craft (s):
Gui, Add, Edit, x210 y157 w50 h20 Background171717 cWhite vCraftSecInput Hidden, 36
Gui, Add, Button, x265 y157 w50 h20 gZmienCraftTime Background171717 cWhite vLeafCraftBtn Hidden, OK
Gui, Add, Text, x155 y190 Background111111 vLeafCoordTitle Hidden, WSPOLRZEDNE
Gui, Font, s7 Normal c99d9db
Gui, Add, Text, x155 y208 w350 Background111111 vLeafCoordInfo Hidden, Kliknij przycisk -> wskaz w grze (3s)
Gui, Font, s8 Normal cWhite
Gui, Add, Button, x155 y225 w145 h22 gUstawZelazo Background171717 cWhite vLeafBtn1 Hidden, 1. Zelazo (eq)
Gui, Add, Text, x310 y228 w190 h16 vZelazoKoord c5dade Background111111 Hidden, nie ustawiono
Gui, Add, Button, x155 y252 w145 h22 gUstawCraft1 Background171717 cWhite vLeafBtn2 Hidden, 2. Craft slot #1
Gui, Add, Text, x310 y255 w190 h16 vCraft1Koord c5dade Background111111 Hidden, nie ustawiono
Gui, Add, Button, x155 y279 w145 h22 gUstawCraft2 Background171717 cWhite vLeafBtn3 Hidden, 3. Craft slot #2
Gui, Add, Text, x310 y282 w190 h16 vCraft2Koord c5dade Background111111 Hidden, nie ustawiono
Gui, Add, Button, x155 y306 w145 h22 gUstawWynik Background171717 cWhite vLeafBtn4 Hidden, 4. Wynik (nozyce)
Gui, Add, Text, x310 y309 w190 h16 vWynikKoord c5dade Background111111 Hidden, nie ustawiono
Gui, Add, Button, x155 y333 w145 h22 gUstawSlotNozyce Background171717 cWhite vLeafBtn5 Hidden, 5. Slot (na nozyce)
Gui, Add, Text, x310 y336 w190 h16 vSlotNKoord c5dade Background111111 Hidden, nie ustawiono

; ===== AUTO FISHING =====
Gui, Font, s12 Bold c5dade
Gui, Add, Text, x155 y55 BackgroundTrans vFishTitle Hidden, Auto Fishing
Gui, Font, s8 Normal cWhite
Gui, Add, Text, x155 y90 w350 Background111111 vFishDesc Hidden, Automatyczne lowienie ryb w Minecraft (dziala w tle).
Gui, Add, Text, x155 y125 Background111111 vFishBindLabel Hidden, Hotkey:
Gui, Add, Edit, x210 y122 w40 h20 Background171717 cWhite vFishingBindInput Hidden Limit1, %fishingBind%
Gui, Add, Button, x255 y122 w60 h20 gZmienFishingBind Background171717 cWhite vFishBindBtn Hidden, Zmien
Gui, Add, Text, x155 y155 Background111111 vFishStatusLabel Hidden, Status:
Gui, Add, Text, x205 y155 w200 vFishingStatus cff4757 Background111111 Hidden, WYLACZONY
Gui, Font, s8 Normal c99d9db
Gui, Add, Text, x155 y190 w350 Background111111 vFishInstrTitle Hidden, Instrukcja:
Gui, Font, s8 Normal cWhite
Gui, Add, Text, x155 y210 w350 Background111111 vFishInstr1 Hidden, 1. Wez wedke do reki
Gui, Add, Text, x155 y225 w350 Background111111 vFishInstr2 Hidden, 2. Najedz myszka na wode
Gui, Add, Text, x155 y240 w350 Background111111 vFishInstr3 Hidden, 3. Nacisnij bind aby rozpoczac
Gui, Add, Text, x155 y255 w350 Background111111 vFishInstr4 Hidden, 4. Nacisnij ponownie aby zatrzymac

; Footer
Gui, Add, Progress, x15 y390 w520 h1 Background2a4d4f c5dade, 100
Gui, Font, s7 Normal c5dade
Gui, Add, Text, x15 y400 w520 Background111111 Center, LSJ Guild 2025 | v%obecnaWersja%

Gui, Show, w550 h425, LSJ Auto-Farm v%obecnaWersja%
return

; ===== LOGIKA AKTUALIZACJI =====
SprawdzAktualizacje() {
    global obecnaWersja, urlWersja, urlSkrypt, nazwaPlikuSkryptu
    
    tempWersja := A_Temp . "\lsj_wersja.txt"
    UrlDownloadToFile, %urlWersja%?nocache=%A_TickCount%, %tempWersja%
    
    if (ErrorLevel)
        return
        
    FileRead, nowaWersja, %tempWersja%
    FileDelete, %tempWersja%
    nowaWersja := Trim(nowaWersja, " `t`n`r")

    if (nowaWersja != "" && nowaWersja != obecnaWersja) {
        MsgBox, 4, LSJ Updater, Wykryto nowa wersje! `n`nTwoja: %obecnaWersja%`nNowa: %nowaWersja%`n`nCzy chcesz pobrac aktualizacje?
        IfMsgBox, Yes
        {
            tempSkrypt := A_Temp . "\lsj_nowy.ahk"
            UrlDownloadToFile, %urlSkrypt%?nocache=%A_TickCount%, %tempSkrypt%
            
            if (ErrorLevel) {
                MsgBox, 16, Blad, Nie udalo sie pobrac pliku.
                return
            }
            
            FileRead, nowyKod, %tempSkrypt%
            FileDelete, %tempSkrypt%
            
            FileDelete, %nazwaPlikuSkryptu%
            FileAppend, %nowyKod%, %nazwaPlikuSkryptu%
            
            MsgBox, 64, Sukces, Zaktualizowano do v%nowaWersja%. Skrypt zostanie zrestartowany.
            Run, %nazwaPlikuSkryptu%
            ExitApp
        }
    }
}

; ===== WINDOW CONTROLS =====
DragWindow:
    PostMessage, 0xA1, 2
return
MinimizeWindow:
    Gui, Minimize
return

; ===== MENU NAVIGATION =====
ShowHome:
    Loop, Parse, % "LeafTitle,LeafBindLabel,LeafBindBtn,LeafStatusLabel,LeafStatus,LeafDelayLabel,LeafDelayBtn,LeafCraftLabel,LeafCraftBtn,LeafCoordTitle,LeafCoordInfo,LeafBtn1,LeafBtn2,LeafBtn3,LeafBtn4,LeafBtn5,ZelazoKoord,Craft1Koord,Craft2Koord,WynikKoord,SlotNKoord,DelayInput,CraftSecInput,LeafBindInput", `,
        GuiControl, Hide, %A_LoopField%
    Loop, Parse, % "FishTitle,FishDesc,FishBindLabel,FishBindBtn,FishStatusLabel,FishingStatus,FishInstrTitle,FishInstr1,FishInstr2,FishInstr3,FishInstr4,FishingBindInput", `,
        GuiControl, Hide, %A_LoopField%
    Loop, Parse, % "HomeTitle,HomeText1,HomeText2,HomeText3,HomeFunc1,HomeFunc2,HomeFunc3,HomeFunc4,HomeFooter", `,
        GuiControl, Show, %A_LoopField%
return

ShowLeafFarm:
    Loop, Parse, % "HomeTitle,HomeText1,HomeText2,HomeText3,HomeFunc1,HomeFunc2,HomeFunc3,HomeFunc4,HomeFooter", `,
        GuiControl, Hide, %A_LoopField%
    Loop, Parse, % "FishTitle,FishDesc,FishBindLabel,FishBindBtn,FishStatusLabel,FishingStatus,FishInstrTitle,FishInstr1,FishInstr2,FishInstr3,FishInstr4,FishingBindInput", `,
        GuiControl, Hide, %A_LoopField%
    Loop, Parse, % "LeafTitle,LeafBindLabel,LeafBindBtn,LeafStatusLabel,LeafStatus,LeafDelayLabel,LeafDelayBtn,LeafCraftLabel,LeafCraftBtn,LeafCoordTitle,LeafCoordInfo,LeafBtn1,LeafBtn2,LeafBtn3,LeafBtn4,LeafBtn5,ZelazoKoord,Craft1Koord,Craft2Koord,WynikKoord,SlotNKoord,DelayInput,CraftSecInput,LeafBindInput", `,
        GuiControl, Show, %A_LoopField%
return

ShowFishing:
    Loop, Parse, % "HomeTitle,HomeText1,HomeText2,HomeText3,HomeFunc1,HomeFunc2,HomeFunc3,HomeFunc4,HomeFooter", `,
        GuiControl, Hide, %A_LoopField%
    Loop, Parse, % "LeafTitle,LeafBindLabel,LeafBindBtn,LeafStatusLabel,LeafStatus,LeafDelayLabel,LeafDelayBtn,LeafCraftLabel,LeafCraftBtn,LeafCoordTitle,LeafCoordInfo,LeafBtn1,LeafBtn2,LeafBtn3,LeafBtn4,LeafBtn5,ZelazoKoord,Craft1Koord,Craft2Koord,WynikKoord,SlotNKoord,DelayInput,CraftSecInput,LeafBindInput", `,
        GuiControl, Hide, %A_LoopField%
    Loop, Parse, % "FishTitle,FishDesc,FishBindLabel,FishBindBtn,FishStatusLabel,FishingStatus,FishInstrTitle,FishInstr1,FishInstr2,FishInstr3,FishInstr4,FishingBindInput", `,
        GuiControl, Show, %A_LoopField%
return

; ===== RESZTA FUNKCJI =====
ZmienDelay:
    Gui, Submit, NoHide
    clickDelay := DelayInput
    ToolTip, OK: %clickDelay%ms
    SetTimer, UsunTooltip, 1000
return
ZmienCraftTime:
    Gui, Submit, NoHide
    craftInterval := CraftSecInput * 1000
    ToolTip, OK: %CraftSecInput%s
    SetTimer, UsunTooltip, 1000
return
ZmienLeafBind:
    Gui, Submit, NoHide
    oldBind := leafBind, leafBind := LeafBindInput
    Hotkey, %oldBind%, Off
    Hotkey, %leafBind%, ToggleLeafFarm, On
    ToolTip, OK: %leafBind%
    SetTimer, UsunTooltip, 1000
return
ZmienFishingBind:
    Gui, Submit, NoHide
    oldBind := fishingBind, fishingBind := FishingBindInput
    Hotkey, %oldBind%, Off
    Hotkey, %fishingBind%, ToggleFishing, On
    ToolTip, OK: %fishingBind%
    SetTimer, UsunTooltip, 1000
return
UsunTooltip:
    ToolTip
    SetTimer, UsunTooltip, Off
return
UstawZelazo:
    UstawWspolrzedne("zelazo")
return
UstawCraft1:
    UstawWspolrzedne("craft1")
return
UstawCraft2:
    UstawWspolrzedne("craft2")
return
UstawWynik:
    UstawWspolrzedne("wynik")
return
UstawSlotNozyce:
    UstawWspolrzedne("slotnozyce")
return
UstawWspolrzedne(typ) {
    global ustawianieWspolrzednych, ktoreUstawiam
    ustawianieWspolrzednych := true, ktoreUstawiam := typ
    ToolTip, Ustawiasz: %typ%
    SetTimer, CzekajNaKlikniecie, 100
    Sleep, 3000
}
CzekajNaKlikniecie:
    global ustawianieWspolrzednych, ktoreUstawiam
    if (!ustawianieWspolrzednych)
        return
    if (GetKeyState("LButton", "P")) {
        MouseGetPos, mx, my
        if (ktoreUstawiam = "zelazo") {
            zelazoPozycja_X := mx, zelazoPozycja_Y := my
            GuiControl,, ZelazoKoord, OK X:%mx% Y:%my%
            GuiControl, +c57f287, ZelazoKoord
        } else if (ktoreUstawiam = "craft1") {
            craftSlot1_X := mx, craftSlot1_Y := my
            GuiControl,, Craft1Koord, OK X:%mx% Y:%my%
            GuiControl, +c57f287, Craft1Koord
        } else if (ktoreUstawiam = "craft2") {
            craftSlot2_X := mx, craftSlot2_Y := my
            GuiControl,, Craft2Koord, OK X:%mx% Y:%my%
            GuiControl, +c57f287, Craft2Koord
        } else if (ktoreUstawiam = "wynik") {
            wynikNozyce_X := mx, wynikNozyce_Y := my
            GuiControl,, WynikKoord, OK X:%mx% Y:%my%
            GuiControl, +c57f287, WynikKoord
        } else if (ktoreUstawiam = "slotnozyce") {
            slotNozyce_X := mx, slotNozyce_Y := my
            GuiControl,, SlotNKoord, OK X:%mx% Y:%my%
            GuiControl, +c57f287, SlotNKoord
        }
        ToolTip, OK
        SetTimer, UsunTooltip, 1000
        ustawianieWspolrzednych := false
        SetTimer, CzekajNaKlikniecie, Off
        Sleep, 500
    }
return

; ===== LOGIKA LEAF FARM =====
F6::
ToggleLeafFarm:
    if (zelazoPozycja_X = 0 || craftSlot1_X = 0 || craftSlot2_X = 0 || wynikNozyce_X = 0 || slotNozyce_X = 0) {
        MsgBox, 48, LSJ, Ustaw wszystkie wspolrzedne!
        return
    }
    aktywny := !aktywny
    if (aktywny) {
        GuiControl,, LeafStatus, WLACZONY
        GuiControl, +c57f287, LeafStatus
        lastCraftTime := A_TickCount
        SetTimer, FarmLoop, 10
        SetTimer, SprawdzCraft, 1000
    } else {
        GuiControl,, LeafStatus, WYLACZONY
        GuiControl, +cff4757, LeafStatus
        SetTimer, FarmLoop, Off
        SetTimer, SprawdzCraft, Off
    }
return
FarmLoop:
    if (!aktywny)
        return
    Click, Left
    Sleep, %clickDelay%
    Click, Right
    Sleep, %clickDelay%
return
SprawdzCraft:
    if (!aktywny)
        return
    if (A_TickCount - lastCraftTime >= craftInterval) {
        CraftujNozyce()
        lastCraftTime := A_TickCount
    }
return
CraftujNozyce() {
    SetTimer, FarmLoop, Off
    SetTimer, SprawdzCraft, Off
    Send, {e}
    Sleep, 400
    Click, %zelazoPozycja_X%, %zelazoPozycja_Y%
    Sleep, 150
    Click, %craftSlot1_X%, %craftSlot1_Y%
    Sleep, 150
    Click, %craftSlot1_X%, %craftSlot1_Y%, Right
    Sleep, 150
    Click, %craftSlot2_X%, %craftSlot2_Y%, Right
    Sleep, 150
    Click, %zelazoPozycja_X%, %zelazoPozycja_Y%
    Sleep, 150
    Click, %wynikNozyce_X%, %wynikNozyce_Y%
    Sleep, 150
    Click, %slotNozyce_X%, %slotNozyce_Y%
    Sleep, 150
    Send, {e}
    Sleep, 400
    if (aktywny) {
        SetTimer, FarmLoop, 10
        SetTimer, SprawdzCraft, 1000
    }
}

; ===== AUTO FISHING =====
8::
ToggleFishing:
    fishingActive := !fishingActive
    if (fishingActive) {
        GuiControl,, FishingStatus, WLACZONY
        GuiControl, +c57f287, FishingStatus
        SetTimer, FishingLoop, 10
    } else {
        GuiControl,, FishingStatus, WYLACZONY
        GuiControl, +cff4757, FishingStatus
        SetTimer, FishingLoop, Off
    }
return
FishingLoop:
    if (!fishingActive)
        return
    ControlClick,, ahk_exe javaw.exe,, Right, 1, D
    Sleep, 50
    ControlClick,, ahk_exe javaw.exe,, Right, 1, U
    Sleep, 50
return

GuiClose:
    ExitApp



