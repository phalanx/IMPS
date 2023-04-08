Scriptname IMPS_MCM_Quest_Script extends nl_mcm_module

IMPS_Main_Quest_Script Property IMPS_Main Auto
IMPS_Config_Quest_Script Property config Auto

GlobalVariable Property DebugEnabled Auto

event OnInit()
    RegisterModule("$IMPS_MAIN_NAME", 0)
endevent

event OnPageInit()
    SetModName("$IMPS_MODNAME")
    SetLandingPage("$IMPS_MAIN_NAME")
    SetPersistentMCMPreset("persistence/settings")
endevent

int Function SaveData()
    return config.SaveConfig()
EndFunction

Function LoadData(int jObj)
    config.LoadConfig(jObj)
EndFunction

event OnPageDraw()
    SetCursorFillMode(TOP_TO_BOTTOM)
    AddHeaderOption("$IMPS_MAIN_HEADER_1")
    AddSliderOptionST("minItems", "$IMPS_MINITEMS", config.minItems)
    AddSliderOptionST("maxItems", "$IMPS_MAXITEMS", config.maxItems)
    AddSliderOptionST("sellPercent", "$IMPS_SELLPERCENT", config.sellPercent)
    AddSliderOptionST("barterMin", "$IMPS_BARTERMIN", config.barterMin, "{1}")
    AddSliderOptionST("barterMax", "$IMPS_BARTERMAX", config.barterMax, "{1}")
    AddToggleOptionST("speechScaling", "$IMPS_SPEECHSCALING", config.speechScaling)
    AddSliderOptionST("timeBeforeUpdates", "$IMPS_TIMEBEFOREUPDATES", config.timeBeforeUpdate)
    AddToggleOptionST("requirePaper", "$IMPS_REQUIREPAPER", config.requirePaper)
    AddToggleOptionST("grantSpeechXP", "$IMPS_GRANTSPEECHXP", config.grantSpeechXP)
    AddSliderOptionST("speechXPPercent", "$IMPS_SPEECHXPPERCENT", config.speechXPPercent)
    AddToggleOptionST("renameChests", "$IMPS_RENAMECHESTS", config.renameChests)
    SetCursorPosition(1)
    AddHeaderOption("$IMPS_MAIN_HEADER_2")
    AddTextOptionST("Uninstall", "$IMPS_UNINSTALL", none)
    AddTextOptionST("DeliverNote", "$IMPS_DELIVERNOTE", none)
    AddTextOptionST("TriggerCoinReload", "$IMPS_TRIGGERCOINRELOAD", none)
    AddTextOptionST("TriggerProcessing", "$IMPS_TRIGGERPROCESSING", none)
    AddTextOptionST("TriggerCoinChoice", "$IMPS_TRIGGERCOINSELECTION", none)
endevent

State TriggerProcessing
    Event OnSelectST(string state_id)
        IMPS_Main.processChests()
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$IMPS_TRIGGERPROCESSING_HELP")
    EndEvent
EndState

State TriggerCoinReload
    Event OnSelectST(string state_id)
        IMPS_Main.importCoinForms()
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$IMPS_TRIGGERCOINRELOAD_HELP")
    EndEvent
EndState

State TriggerCoinChoice
    Event OnSelectST(string state_id)
        IMPS_Main.Log(IMPS_Main.GetCoinType())
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$IMPS_TRIGGERCOINSELECTION_HELP")
    EndEvent
EndState

State Uninstall
    Event OnSelectST(string state_id)
        IMPS_Main.Uninstall()
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$IMPS_UNINSTALL_HELP")
    EndEvent
EndState

State DeliverNote
    Event OnSelectST(string state_id)
        IMPS_Main.DeliverNote()
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$IMPS_DELIVERNOTE_HELP")
    EndEvent
EndState

State minItems
    Event OnSliderOpenST(string state_id)
        SetSliderDialogStartValue(config.minItems)
        SetSliderDialogDefaultValue(10)
        SetSliderDialogInterval(1)
        SetSliderDialogRange(1, 100)
    EndEvent
    Event OnSliderAcceptST(string state_id, float value)
        config.minItems = value as int
        SetSliderOptionValueST(config.minItems)
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$IMPS_MINITEMS_HELP")
    EndEvent
EndState

State maxItems
    Event OnSliderOpenST(string state_id)
        SetSliderDialogStartValue(config.maxItems)
        SetSliderDialogDefaultValue(100)
        SetSliderDialogInterval(1)
        SetSliderDialogRange(10, 500)
    EndEvent
    Event OnSliderAcceptST(string state_id, float value)
        config.maxItems = value as int
        SetSliderOptionValueST(config.maxItems)
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$IMPS_MAXITEMS_HELP")
    EndEvent
EndState

State sellPercent
    Event OnSliderOpenST(string state_id)
        SetSliderDialogStartValue(config.sellPercent)
        SetSliderDialogDefaultValue(20)
        SetSliderDialogInterval(1)
        SetSliderDialogRange(1, 200)
    EndEvent
    Event OnSliderAcceptST(string state_id, float value)
        config.sellPercent = value as int
        SetSliderOptionValueST(config.sellPercent)
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$IMPS_SELLPERCENT_HELP")
    EndEvent
EndState

State barterMin
    Event OnSliderOpenST(string state_id)
        SetSliderDialogStartValue(config.barterMin)
        SetSliderDialogDefaultValue(2)
        SetSliderDialogInterval(0.1)
        SetSliderDialogRange(0, 10)
    EndEvent
    Event OnSliderAcceptST(string state_id, float value)
        config.barterMin = value
        SetSliderOptionValueST(config.barterMin, "{1}")
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$IMPS_BARTERMIN_HELP")
    EndEvent
EndState

State barterMax
    Event OnSliderOpenST(string state_id)
        SetSliderDialogStartValue(config.barterMax)
        SetSliderDialogDefaultValue(3.3)
        SetSliderDialogInterval(0.1)
        SetSliderDialogRange(0, 10)
    EndEvent
    Event OnSliderAcceptST(string state_id, float value)
        config.barterMax = value
        SetSliderOptionValueST(config.barterMax, "{1}")
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$IMPS_BARTERMAX_HELP")
    EndEvent
EndState

State speechScaling
    Event OnSelectST(string state_id)
        config.speechScaling = !config.speechScaling
        SetToggleOptionValueST(config.speechScaling)
    EndEvent

    Event OnHighlightST(string state_id)
        SetInfoText("$IMPS_SPEECHSCALING_HELP")
    EndEvent
EndState

State timeBeforeUpdates
    Event OnSliderOpenST(string state_id)
        SetSliderDialogStartValue(config.timeBeforeUpdate)
        SetSliderDialogDefaultValue(24)
        SetSliderDialogInterval(1)
        SetSliderDialogRange(1, 200)
    EndEvent
    Event OnSliderAcceptST(string state_id, float value)
        config.timeBeforeUpdate = value as int
        SetSliderOptionValueST(config.timeBeforeUpdate)
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$IMPS_TIMEBEFOREUPDATES_HELP")
    EndEvent
EndState

State requirePaper
    Event OnSelectST(string state_id)
        config.requirePaper = !config.requirePaper
        SetToggleOptionValueST(config.requirePaper)
    EndEvent

    Event OnHighlightST(string state_id)
        SetInfoText("$IMPS_REQUIREPAPER_HELP")
    EndEvent
EndState

State grantSpeechXP
    Event OnSelectST(string state_id)
        config.grantSpeechXP = !config.grantSpeechXP
        SetToggleOptionValueST(config.grantSpeechXP)
    EndEvent

    Event OnHighlightST(string state_id)
        SetInfoText("$IMPS_GRANTSPEECHXP_HELP")
    EndEvent
EndState

State speechXPPercent
    Event OnSliderOpenST(string state_id)
        SetSliderDialogStartValue(config.speechXPPercent)
        SetSliderDialogDefaultValue(50)
        SetSliderDialogInterval(1)
        SetSliderDialogRange(0, 200)
    EndEvent
    Event OnSliderAcceptST(string state_id, float value)
        config.speechXPPercent = value as int
        SetSliderOptionValueST(config.speechXPPercent)
    EndEvent
    Event OnHighlightST(string state_id)
        SetInfoText("$IMPS_SPEECHXPMULT")
    EndEvent
EndState

State renameChests
    Event OnSelectST(string state_id)
        config.renameChests = !config.renameChests
        if config.renameChests
            IMPS_Main.NameAllChests()
        else
            IMPS_Main.unNameAllChests()
        endif
        SetToggleOptionValueST(config.renameChests)
    EndEvent

    Event OnHighlightST(string state_id)
        SetInfoText("$IMPS_RENAMECHESTS_HELP")
    EndEvent
EndState