Scriptname IMPS_Main_Quest_Script extends Quest

IMPS_Config_Quest_Script Property config Auto
Book Property startingNote Auto
Quest Property WICourier Auto
Actor Property playerRef Auto

int jcoinArray
int totalCoinWeight
Form[] coinTypes

string salePrefix = "Imp's Sale "
string trashPrefix = "Imp's Trash "
string profitPrefix = "Imp's Profit "

ObjectReference[] Property saleChests Auto Hidden
ObjectReference[] Property trashChests Auto Hidden
ObjectReference[] Property profitChests Auto Hidden

Event OnInit()
    Log("Init")
    DeliverNote()
    jcoinArray = JArray.object()
    JValue.retain(jcoinArray, "IMPS")
    Maintenance()
EndEvent

Function DeliverNote()
    (WICourier as WICourierScript).addItemToContainer(startingNote)
EndFunction

Function Maintenance()
    Log("Maintenance Running")
    RegisterForModEvent("IMPS_GameLoad", "Maintenance")
    RegisterForSingleUpdateGameTime(config.timeBeforeUpdate)
    importCoinForms()
    NameAllChests()
EndFunction

Function Uninstall()
    UnregisterForUpdateGameTime()
    UnNameAllChests()
    Jvalue.releaseObjectsWithTag("IMPS")
    saleChests = new ObjectReference[1]
    trashChests = new ObjectReference[1]
EndFunction

Function Log(string text)
    Debug.Trace("[IMPS] " + text)
EndFunction

Function addManagedChest(ObjectReference chest, int style)
    string chestPrefix
    if style == 0
        saleChests = PapyrusUtil.PushObjRef(saleChests, chest)
        chestPrefix = salePrefix
    elseif style == 1
        trashChests = PapyrusUtil.PushObjRef(trashChests, chest)
        chestPrefix = trashPrefix
    elseif style == 2
        profitChests = PapyrusUtil.PushObjRef(profitChests, chest)
        chestPrefix = profitPrefix
    else
        Log("Incorrect button: " + style)
        return
    endif
    if config.renameChests
        chest.SetDisplayName(chestPrefix + chest.GetBaseObject().GetName())
    endif
    logChestArrays()
EndFunction

Function logChestArrays()
    int i = 0

    Log("Sales Chests:")
    while i < saleChests.Length
        Log("    " + saleChests[i].GetBaseObject().GetName())
        i += 1
    endwhile

    i = 0
    Log("Trash Chests:")
    while i < trashChests.Length
        Log("    " + trashChests[i].GetBaseObject().GetName())
        i += 1
    endwhile

    i = 0
    Log("Profit Chests:")
    while i < profitChests.Length
        Log("    " + profitChests[i].GetBaseObject().GetName())
        i += 1
    endwhile
EndFunction

Function removeManagedChest(ObjectReference chest, int style)
    if style == 0
        saleChests = PapyrusUtil.RemoveObjRef(saleChests, chest)
    elseif style == 1
        trashChests = PapyrusUtil.RemoveObjRef(trashChests, chest)
    elseif style == 2
        profitChests = PapyrusUtil.RemoveObjRef(profitChests, chest)
    endif
    if config.renameChests
        chest.SetDisplayName(chest.GetBaseObject().GetName())
    endif
EndFunction

Function processChest(ObjectReference chest)
    int numItems = chest.GetNumItems()
    if numItems == 0
        return
    endif
    int randomItems = Utility.RandomInt(config.minItems, config.maxItems)

    int i = 0
    float totalSellValue = 0
    while i < randomItems
        int itemIndex = Utility.RandomInt(0, numItems - 1)
        Form itemForm = chest.GetNthForm(itemIndex)
        if itemForm && coinTypes.Find(itemForm) == -1
            totalSellValue += itemForm.GetGoldValue()
            chest.RemoveItem(itemForm)
            numItems = chest.GetNumItems()
            if numItems == 0
                i = randomItems
            endif
        endif
        i += 1
    endwhile

    float playerSpeech = playerRef.GetActorValue("Speechcraft")
    if playerSpeech > 100
        playerSpeech = 100
    endif

    float priceFactor = 1/(config.barterMax - ((config.barterMax - config.barterMin) * playerSpeech/100))
   
    float sellDecimal = config.sellPercent / 100.0

    if config.grantSpeechXP
        float xpGain = totalSellValue * 0.36 * (config.speechXPPercent/100)
        Game.AdvanceSkill("Speechcraft", xpGain)
    endif

    totalSellValue = totalSellValue * priceFactor * sellDecimal

    ObjectReference profitChest = chest
    if profitChests.Length > 0
        int profitIndex = Utility.RandomInt(0, profitChests.Length - 1)
        if profitChests[profitIndex] != None
            profitChest = profitChests[profitIndex]
        endif
    endif

    if totalSellValue > 0.5 && totalSellValue < 1
        totalSellValue = 1
    endif
    Log("Total Sell Value: " + totalSellValue)
    profitChest.addItem(GetCoinType(), totalSellValue as int)
    
EndFunction

Form Function GetCoinType()
    int coinByWeight = Utility.RandomInt(1, totalCoinWeight)
    Log("Coin by weight: " + coinByWeight)
    int i = 0
    while i < JArray.count(jcoinArray)
        if coinByWeight <= JMap.getInt(JArray.getObj(jcoinArray, i), "weight")
            Log("Chosen coin's weight: " + JMap.getInt(JArray.getObj(jcoinArray, i), "weight"))
            return JMap.getForm(JArray.getObj(jcoinArray, i), "form")
        endif
        i += 1
    endWhile
    Log("No coin selected")
EndFunction

Function processChests()
    int i = 0
    while i < saleChests.Length
        processChest(saleChests[i])
        i += 1
    endwhile
    i = 0
    while i < trashChests.Length
        trashChests[i].RemoveAllItems()
        i += 1
    endWhile
EndFunction

Event OnUpdateGameTime()
    Log("Processing triggered")
    processChests()
    RegisterForSingleUpdateGameTime(config.timeBeforeUpdate)
endEvent

Function importCoinForms()
    JArray.clear(jcoinArray)
    int jDir = JValue.readFromDirectory("Data/IMPS")
    string[] jFileNameArray = JMap.allKeysPArray(jDir)
    
    int i = 0
    while i < jFileNameArray.Length
        Log("Reading File " + jFileNameArray[i])
        int jcoinsFromFile = JMap.getObj(jDir, jFileNameArray[i])
        jArray.addFromArray(jcoinArray, jcoinsFromFile)
        i += 1
    endWhile
    i = 0
    totalCoinWeight = 0
    coinTypes = new Form[1]
    while i < JArray.count(jcoinArray)
        totalCoinWeight += JMap.getInt(JArray.getObj(jcoinArray, i), "weight")
        JMap.setInt(JArray.getObj(jcoinArray, i), "weight", totalCoinWeight)

        coinTypes = PapyrusUtil.PushForm(coinTypes, JMap.getForm(JArray.getObj(jcoinArray, i), "form"))
        string coinName = JMap.getStr(JArray.getObj(jcoinArray, i), "name")
        Log(coinName + " total weight " + totalCoinWeight)
        i += 1
    endwhile
    coinTypes = PapyrusUtil.ClearNone(coinTypes)
    Log("Total Weight: " + totalCoinWeight)
EndFunction

Function UnNameAllChests()
    int i = 0
    ObjectReference chest
    while i < saleChests.Length
        chest = saleChests[i]
        chest.SetDisplayName(chest.GetBaseObject().GetName())
        i += 1
    endwhile
    i = 0
    while i < trashChests.Length
        chest = trashChests[i]
        chest.SetDisplayName(chest.GetBaseObject().GetName())
        i += 1
    endwhile
    i = 0
    while i < profitChests.Length
        chest = profitChests[i]
        chest.SetDisplayName(chest.GetBaseObject().GetName())
        i += 1
    endwhile
 
endFunction

Function NameAllChests()
    int i = 0
    ObjectReference chest
    while i < saleChests.Length
        chest = saleChests[i]
        chest.SetDisplayName(salePrefix + chest.GetBaseObject().GetName())
        i += 1
    endwhile
    i = 0
    while i < trashChests.Length
        chest = trashChests[i]
        chest.SetDisplayName(trashPrefix + chest.GetBaseObject().GetName())
        i += 1
    endwhile
    i = 0
    while i < profitChests.Length
        chest = profitChests[i]
        chest.SetDisplayName(profitPrefix + chest.GetBaseObject().GetName())
        i += 1
    endwhile
 
endFunction