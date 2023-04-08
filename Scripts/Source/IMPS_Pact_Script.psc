Scriptname IMPS_Pact_Script extends ObjectReference

IMPS_Main_Quest_Script Property IMPS_Main Auto
Message Property styleSelectMessage Auto
MiscObject Property pactForm Auto

ObjectReference newContainer

Event OnContainerChanged(ObjectReference akNewContainer, ObjectReference akOldContainer)
    if akNewContainer == none
        IMPS_Main.Log("None")
    elseif akNewContainer as Actor
        IMPS_Main.Log("Actor")
    elseif IMPS_Main.saleChests.Find(akNewContainer) != -1
        IMPS_Main.Log("Removing Sale")
        IMPS_Main.removeManagedChest(akNewContainer, 0)
        akNewContainer.RemoveItem(pactForm)
    elseif IMPS_Main.trashChests.Find(akNewContainer) != -1
        IMPS_Main.Log("Removing Trash")
        IMPS_Main.removeManagedChest(akNewContainer, 1)
        akNewContainer.RemoveItem(pactForm)
    elseif IMPS_Main.profitChests.Find(akNewContainer) != -1
        IMPS_Main.Log("Removing Profit")
        IMPS_Main.removeManagedChest(akNewContainer, 2)
        akNewContainer.RemoveItem(pactForm)
    else
        int chosenStyle = styleSelectMessage.show() 
        IMPS_Main.Log("Adding: " + chosenStyle)
        IMPS_Main.addManagedChest(akNewContainer, chosenStyle)
        newContainer = akNewContainer
        akNewContainer.RemoveItem(pactForm)
    endif
EndEvent