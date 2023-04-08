Scriptname IMPS_PlayerAlias_Script extends ReferenceAlias

Event OnPlayerLoadGame()
    Debug.Trace("[IMPS] Player Loaded Game")
    int gameLoadEvent = ModEvent.Create("IMPS_GameLoad")
    if gameLoadEvent
        ModEvent.Send(gameLoadEvent)
    endif
EndEvent

