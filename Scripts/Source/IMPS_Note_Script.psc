Scriptname IMPS_Note_Script extends ObjectReference

MiscObject Property quill Auto
Actor Property playerRef Auto
bool quillRemaining = true

Event OnRead()
    if quillRemaining
        Debug.Trace("[IMPS] Quill Remaining")
        playerRef.AddItem(quill)
        quillRemaining = false
    Else
        Debug.Trace("[IMPS] No Quill Remains")
    endif
EndEvent