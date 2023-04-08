Scriptname IMPS_Config_Quest_Script extends Quest

int Property minItems = 10 Auto Hidden
int Property maxItems = 100 Auto Hidden
int Property sellPercent = 20 Auto Hidden
int Property timeBeforeUpdate = 24 Auto Hidden
float Property barterMax = 3.3 Auto Hidden
float Property barterMin = 2.0 Auto Hidden
bool Property speechScaling = true Auto Hidden
bool Property requirePaper = true Auto Hidden
bool Property grantSpeechXP = false Auto Hidden
int Property speechXPPercent = 50 Auto
bool Property renameChests = true Auto Hidden

int Function GetConfigVersion()
    return 3
EndFunction

int Function SaveConfig()
    int jObj = JMap.object()
    JMap.setInt(jObj, "version", GetConfigVersion())
    JMap.setInt(jObj, "minItems", minItems)
    JMap.setInt(jObj, "maxItems", maxItems)
    JMap.setInt(jObj, "sellPercent", sellPercent)
    JMap.setInt(jObj, "timeBeforeUpdate", timeBeforeUpdate)
    JMap.setFlt(jObj, "barterMax", barterMax)
    JMap.setFlt(jObj, "barterMin", barterMin)
    JMap.setInt(jObj, "speechScaling", speechScaling as int)
    JMap.setInt(jObj, "requirePaper", requirePaper as int)
    JMap.setInt(jObj, "grantSpeechXP", grantSpeechXP as int)
    JMap.setInt(jObj, "speechXPPercent", speechXPPercent)
    JMap.setInt(jObj, "renameChests", renameChests as int)
    return jObj
EndFunction

Function LoadConfig(int jObj)
        minItems = JMap.getInt(jObj, "minItems")
        maxItems = JMap.getInt(jObj, "maxItems")
        sellPercent = JMap.getInt(jObj, "sellPercent")
        timeBeforeUpdate = JMap.getInt(jObj, "timeBeforeUpdate")
        requirePaper = JMap.getInt(jObj, "requirePaper") as bool
        if JMap.getInt(jObj, "version") >= 2
            barterMax = JMap.getFlt(jObj, "barterMax")
            barterMin = JMap.getFlt(jObj, "barterMin")
            speechScaling = JMap.getInt(jObj, "speechScaling") as bool
        endif
        if JMap.getInt(jObj, "version") >= 3
            grantSpeechXP = JMap.getInt(jObj, "grantSpeechXP") as bool
            speechXPPercent = JMap.getInt(jObj, "speechXPPercent")
            renameChests = JMap.getInt(jObj, "renameChests") as bool
        endif
EndFunction