Scriptname IMPS_Quill_Script extends ObjectReference

IMPS_Config_Quest_Script Property config Auto

ObjectReference Property playerRef Auto
MiscObject Property paper Auto
MiscObject Property pact Auto

Event OnEquipped(Actor akActor)
    Debug.Trace("[IMPS] Quill Activated")
    int paperCount = 1
    if config.requirePaper
        paperCount = playerRef.GetItemCount(paper)
    endif
    if paperCount >= 1
        playerRef.RemoveItem(paper)
        playerRef.AddItem(pact)
    else
        Debug.Notification("$IMPS_OUTOFPAPER")
    endif
EndEvent