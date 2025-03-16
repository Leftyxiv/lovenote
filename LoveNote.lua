-- LoveNote: A special addon to send love notes to my wife

-- Initialize addon frame and register events
local LoveNote = CreateFrame("Frame", "LoveNoteFrame")
LoveNote:RegisterEvent("PLAYER_LOGIN")
LoveNote:RegisterEvent("ADDON_LOADED")

-- Initialize variables
local addonName = "LoveNote"
local messageTimer = nil
local messageInterval = math.random(1200, 1800) -- 20-30 minutes in seconds
local lastMessageTime = 0

-- Pool of love messages
local loveMessages = {
    "I love you more than words can express! <3",
    "You make every day brighter just by being you! :)",
    "Missing you while you're adventuring in Azeroth! <3",
    "You're my favorite person in this world (and in Azeroth)! <3",
    "Just wanted to remind you how special you are to me! <3",
    "Your smile lights up my world! :)",
    "Thinking of you and smiling! <3",
    "You're the best thing that's ever happened to me! <3",
    "I cherish every moment we spend together! <3",
    "You're my favorite healer in game and in life! <3",
    "My heart belongs to you, forever and always! <3",
    "You're the sweetest and most amazing person I know! :)",
    "I'm so lucky to have you in my life! <3",
    "You're my soulmate and best friend! <3",
    "Your love makes me feel like I can conquer any raid boss! <3",
    "I love you to Northrend and back! <3",
    "You're more precious to me than all the gold in Azeroth! <3",
    "Every day with you is an epic adventure! <3",
    "You're the legendary drop I've been waiting for all my life! <3",
    "My love for you is stronger than any titan! <3",
    "You're the light of my life in the darkest dungeons! <3",
    "I'd cross any ocean and climb any mountain for you! <3",
    "You're my favorite distraction from questing! <3",
    "Your love buffs me more than any spell could! <3",
    "I love you more today than yesterday, but less than tomorrow! <3",
    "You're the most beautiful character in all of Azeroth! <3",
    "My heart does a critical hit every time I see you! <3",
    "You're the reason I smile every day! :)",
    "I love you more than my main loves their best gear! <3",
    "You're the perfect companion for this journey called life! <3",
    "Your love is the most powerful enchantment! <3",
    "You're my favorite person to party with, in game and in life! <3",
    "I'd choose you over any epic mount or rare pet! <3",
    "You're the best thing that's ever dropped into my life! <3",
    "My love for you has no cooldown! <3",
    "You're my favorite quest reward! <3",
    "I love you more than my character loves leveling up! <3",
    "You're the rarest and most valuable treasure in any realm! <3",
    "My heart is yours, now and forever! <3",
    "You're my favorite view in any zone! <3",
    "I love every little thing about you! <3",
    "You're the best part of waking up every morning! <3",
    "My love for you is more endless than grinding reputation! <3",
    "You're my favorite hearthstone destination! <3",
    "I'd reroll on any server just to be with you! <3",
    "You're the most beautiful flower in all of Azeroth's gardens! <3",
    "I love you more than all the stars in the sky! <3",
    "You're my most treasured bind-on-pickup! <3",
    "My heart is permanently bound to yours! <3",
    "You're the most amazing person I've ever met! <3"
}

-- Function to create and show a pop-up window with a love message
local function ShowLovePopup(message)
    -- Create the frame if it doesn't exist
    if not LoveNote.popup then
        local popup = CreateFrame("Frame", "LoveNotePopup", UIParent, "BackdropTemplate")
        LoveNote.popup = popup
        
        -- Set size and position
        popup:SetSize(400, 150)
        popup:SetPoint("CENTER", UIParent, "CENTER", 0, 100)
        
        -- Set backdrop (background and border)
        popup:SetBackdrop({
            bgFile = "Interface/Tooltips/UI-Tooltip-Background",
            edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
            tile = true,
            tileSize = 16,
            edgeSize = 16,
            insets = { left = 4, right = 4, top = 4, bottom = 4 }
        })
        popup:SetBackdropColor(0.8, 0.2, 0.5, 0.9) -- Pink background
        
        -- Add a title
        local title = popup:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        title:SetPoint("TOP", popup, "TOP", 0, -15)
        title:SetText("Love Note")
        title:SetTextColor(1, 1, 1)
        popup.title = title
        
        -- Add message text
        local text = popup:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        text:SetPoint("CENTER", popup, "CENTER", 0, 0)
        text:SetWidth(360)
        text:SetJustifyH("CENTER")
        text:SetTextColor(1, 1, 1)
        popup.text = text
        
        -- Add a close button
        local closeButton = CreateFrame("Button", nil, popup, "UIPanelButtonTemplate")
        closeButton:SetSize(80, 22)
        closeButton:SetPoint("BOTTOM", popup, "BOTTOM", 0, 15)
        closeButton:SetText("Close")
        closeButton:SetScript("OnClick", function() popup:Hide() end)
        popup.closeButton = closeButton
        
        -- Add heart decorations
        local leftHeart = popup:CreateTexture(nil, "ARTWORK")
        leftHeart:SetTexture("Interface/Icons/INV_ValentinesCard01")
        leftHeart:SetSize(32, 32)
        leftHeart:SetPoint("LEFT", popup, "LEFT", 20, 0)
        
        local rightHeart = popup:CreateTexture(nil, "ARTWORK")
        rightHeart:SetTexture("Interface/Icons/INV_ValentinesCard01")
        rightHeart:SetSize(32, 32)
        rightHeart:SetPoint("RIGHT", popup, "RIGHT", -20, 0)
    end
    
    -- Update and show the popup
    LoveNote.popup.text:SetText(message)
    LoveNote.popup:Show()
    
    -- Auto-hide after 15 seconds
    C_Timer.After(15, function()
        if LoveNote.popup:IsShown() then
            LoveNote.popup:Hide()
        end
    end)
end

-- Function to send a love message to chat
local function SendLoveMessage(showPopup)
    -- Get a random message from the pool
    local messageIndex = math.random(1, #loveMessages)
    local message = loveMessages[messageIndex]
    
    -- Send the message to the chat
    DEFAULT_CHAT_FRAME:AddMessage("|cFFFF69B4[Love Note]|r " .. message)
    
    -- Show popup if requested
    if showPopup then
        ShowLovePopup(message)
    end
    
    -- Update the last message time
    lastMessageTime = GetTime()
    
    -- Set a new random interval for the next message
    messageInterval = math.random(1200, 1800) -- 20-30 minutes in seconds
end

-- Function to check if it's time to send a new message
local function CheckMessageTimer()
    local currentTime = GetTime()
    if currentTime - lastMessageTime >= messageInterval then
        SendLoveMessage(true) -- Show popup for timed messages too
    end
end

-- Simple slash command handler function
SLASH_LOVENOTE1 = "/lovenote"
SLASH_LOVENOTE2 = "/ln"
SlashCmdList["LOVENOTE"] = function(msg)
    -- Convert to lowercase
    msg = string.lower(msg or "")
    
    if msg == "toggle" or msg == "" then
        LoveNoteDB.enabled = not LoveNoteDB.enabled
        if LoveNoteDB.enabled then
            DEFAULT_CHAT_FRAME:AddMessage("|cFFFF69B4[Love Note]|r Love notes enabled! <3")
            if not messageTimer then
                messageTimer = C_Timer.NewTicker(60, CheckMessageTimer)
            end
        else
            DEFAULT_CHAT_FRAME:AddMessage("|cFFFF69B4[Love Note]|r Love notes disabled. Type /ln toggle to enable again.")
            if messageTimer then
                messageTimer:Cancel()
                messageTimer = nil
            end
        end
    elseif msg == "now" then
        -- Send a message immediately
        DEFAULT_CHAT_FRAME:AddMessage("|cFFFF69B4[Love Note]|r Sending a love message now...")
        SendLoveMessage(true) -- Show popup for manual messages
    elseif msg == "help" then
        DEFAULT_CHAT_FRAME:AddMessage("|cFFFF69B4[Love Note]|r Commands:")
        DEFAULT_CHAT_FRAME:AddMessage("  /ln toggle - Toggle love notes on/off")
        DEFAULT_CHAT_FRAME:AddMessage("  /ln now - Send a love message immediately")
        DEFAULT_CHAT_FRAME:AddMessage("  /ln test - Test if slash commands are working")
        DEFAULT_CHAT_FRAME:AddMessage("  /ln help - Show this help message")
    else
        DEFAULT_CHAT_FRAME:AddMessage("|cFFFF69B4[Love Note]|r Unknown command. Type /ln help for a list of commands.")
    end
end

-- Event handler function
local function OnEvent(self, event, arg1, ...)
    if event == "ADDON_LOADED" and arg1 == addonName then
        -- Initialize saved variables if they don't exist
        if not LoveNoteDB then
            LoveNoteDB = {
                enabled = true,
                messages = loveMessages
            }
        else
            -- Use saved custom messages if available
            if LoveNoteDB.messages and #LoveNoteDB.messages > 0 then
                loveMessages = LoveNoteDB.messages
            end
        end
        
        DEFAULT_CHAT_FRAME:AddMessage("|cFFFF69B4[Love Note]|r Addon loaded! Type /ln help for commands.")
    elseif event == "PLAYER_LOGIN" then
        -- Display welcome message
        C_Timer.After(2, function()
            -- Show welcome message in chat
            DEFAULT_CHAT_FRAME:AddMessage("|cFFFF69B4[Love Note]|r Welcome back, my love! I hope you have a wonderful time in Azeroth today. I love you! <3")
            
            -- Show welcome message in popup
            ShowLovePopup("Welcome back, my love! I hope you have a wonderful time in Azeroth today. I love you! <3")
            
            -- Send first love message after a short delay
            C_Timer.After(10, function()
                SendLoveMessage(false) -- Don't show popup for the first message since we already showed the welcome popup
            end)
            
            -- Start the timer for periodic messages
            if not messageTimer and LoveNoteDB.enabled then
                messageTimer = C_Timer.NewTicker(60, CheckMessageTimer) -- Check every minute
            end
        end)
    end
end

-- Register the event handler
LoveNote:SetScript("OnEvent", OnEvent) 