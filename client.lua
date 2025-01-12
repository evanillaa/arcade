
local gotTicket = false
local minutes = 0
local seconds = 0


--===================================== THREADS

--count time
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if gotTicket then
            if hasPlayerRunOutOfTime() then
                QBCore.Functions.Notify("Your ticket has expired.")
                gotTicket = false
                SendNUIMessage({
                    type = "off",
                    game = "",
                })
                SetNuiFocus(false, false)
            end
            countTime()
            displayTime()
        end
    end
end)

--=====================================  FUNCTIONS

function hasPlayerRunOutOfTime()
    return (minutes == 0 and seconds <= 1)
end

function countTime()
    seconds = seconds - 1
    if seconds == 0 then
        seconds = 59
        minutes = minutes - 1
    end

    if minutes == -1 then
        minutes = 0
        seconds = 0
    end
end

function displayTime()
    exports['casinoUi']:DrawCasinoUi('show', "Arcade Card Time</br> "..minutes..":"..seconds)
end

function doesPlayerHaveTicket()
    return gotTicket
end


--=====================================  EVENTS
RegisterNetEvent("arcade:client:openTicketMenu")
AddEventHandler("arcade:client:openTicketMenu", function()
    if gotTicket == false then
        playerBuyTicketMenu()
    else
        returnTicketMenu()
    end
end)

RegisterNetEvent("arcade:client:openArcadeGames")
AddEventHandler("arcade:client:openArcadeGames", function()
    openComputerMenu()
end)

RegisterNetEvent("rcore_arcade:clientticketResult")
AddEventHandler("rcore_arcade:clientticketResult", function(ticket)
    -- Will set time player can be in arcade from Config
    seconds = 1
    minutes = Config.ticketPrice[ticket].time
    -- Tell the script that player has Ticket and can enter.
    gotTicket = true
    QBCore.Functions.Notify("You Bought a "..ticket.." Play Card", "success")
    Wait(1000)
    QBCore.Functions.Notify("Play Time: "..Config.ticketPrice[ticket].time.." minutes", "primary")
end)

RegisterNetEvent('rcore_arcade:client:buyTicket')
AddEventHandler('rcore_arcade:client:buyTicket', function(args)
    local args = tonumber(args)
    if args == 1 then 
        TriggerServerEvent("rcore_arcade:server:buyTicket", 'arcadeblue')
    elseif args == 2 then 
        TriggerServerEvent("rcore_arcade:server:buyTicket", 'arcadegreen')
    else
        TriggerServerEvent("rcore_arcade:server:buyTicket", 'arcadegold')
    end
end)

RegisterNetEvent('rcore_arcade:client:returnTicket')
AddEventHandler('rcore_arcade:client:returnTicket', function()
    minutes = 0
    seconds = 0 
    gotTicket = false
    QBCore.Functions.Notify("Play card is no longer valid", "primary")
    exports['casinoUi']:HideCasinoUi('hide') 
end)

RegisterNUICallback('exit', function()
    SendNUIMessage({
        type = "off",
        game = "",
    })
    SetNuiFocus(false, false)
end)


RegisterNetEvent('rcore_arcade:client:playArcade')
AddEventHandler('rcore_arcade:client:playArcade', function(args)
    local args = tonumber(args)
    if args == 1 then 
        SendNUIMessage({
            type = "on",
            game = 'http://xogos.robinko.eu/PACMAN/',
            gpu = Config.GPUList[2],
            cpu =  Config.CPUList[1],
            SetNuiFocus(true, true)
        })
        elseif args == 2  then
            SendNUIMessage({
                type = "on",
                game = 'http://xogos.robinko.eu/TETRIS/',
                gpu = Config.GPUList[2],
                cpu =  Config.CPUList[1],
                SetNuiFocus(true, true)
            })
        elseif args == 3 then
            SendNUIMessage({
                type = "on",
                game = 'http://xogos.robinko.eu/PONG/',
                gpu = Config.GPUList[2],
                cpu =  Config.CPUList[1],
                SetNuiFocus(true, true)
            })
        elseif args == 4 then
            SendNUIMessage({
                type = "on",
                game = 'http://lama.robinko.eu/fullscreen.html',
                gpu = Config.GPUList[2],
                cpu =  Config.CPUList[1],
                SetNuiFocus(true, true)
            })
        elseif args == 5 then
            SendNUIMessage({
                type = "on",
                game = 'http://uno.robinko.eu/fullscreen.html',
                gpu = Config.GPUList[2],
                cpu =  Config.CPUList[1],
                SetNuiFocus(true, true)
            })
        elseif args == 6 then
            SendNUIMessage({
                type = "on",
                game = 'http://ants.robinko.eu/fullscreen.html',
                gpu = Config.GPUList[2], 
                cpu =  Config.CPUList[1],
                SetNuiFocus(true, true)
            })
        elseif args == 7 then
            SendNUIMessage({
                type = "on",
                game = 'http://xogos.robinko.eu/FlappyParrot/',
                gpu = Config.GPUList[2],
                cpu =  Config.CPUList[1],
                SetNuiFocus(true, true)
            })
        elseif args == 8 then
            SendNUIMessage({
                type = "on",
                game = 'http://zoopaloola.robinko.eu/Embed/fullscreen.html',
                gpu = Config.GPUList[2],
                cpu =  Config.CPUList[1],
                SetNuiFocus(true, true)
            })
        elseif args == 9 then  
            SendNUIMessage({
                type = "on",
                game = 'https://gulper.io',
                gpu = Config.GPUList[2],
                cpu =  Config.CPUList[1],
                SetNuiFocus(true, true)
            })
        else  
            SendNUIMessage({
                type = "on",
                game = 'https://www.google.com/logos/fnbx/solitaire/standalone.html',
                gpu = Config.GPUList[2],
                cpu =  Config.CPUList[1],
                SetNuiFocus(true, true)
            })
    end
end) 


--===================================== Context Menu


function playerBuyTicketMenu()
    TriggerEvent('nh-context:sendMenu', {
        {
            id = 1,
            header = "Arcade Employee",
            txt = ""
        },
        {
            id = 2,
            header = "Blue Play Card",
			txt = "Purchase for $5",
			params = {
                event = "rcore_arcade:client:buyTicket",
                args = '1'
            }
        },
        {
            id = 3,
            header = "Green Play Card",
			txt = "Purchase for $15",
			params = {
                event = "rcore_arcade:client:buyTicket",
                args = '2'

            }
        },
        {
            id = 4,
            header = "Gold Play Card",
			txt = "Purchase for $25",
			params = {
                event = "rcore_arcade:client:buyTicket",
                args = '3'

            }
        },
        {
            id = 5,
            header = "Cancel",
			txt = "",
			params = {
                event = ""
            }
        },
    })
end

function returnTicketMenu()
    TriggerEvent('nh-context:sendMenu', {
        {
            id = 1,
            header = "Arcade Employee",
            txt = ""
        },
        {
            id = 2,
            header = "Stop Using Arcade",
			txt = "End Play Card",
			params = {
                event = "rcore_arcade:client:returnTicket",
            }
        },
        {
            id = 3,
            header = "Cancel",
			txt = "",
			params = {
                event = ""

            }
        },

    })
end


function openComputerMenu()
    if not gotTicket then
        QBCore.Functions.Notify("You do have a valid Play Card", "error")
        return
    end
    TriggerEvent('nh-context:sendMenu', {
        {
            id = 1,
            header = "Arcade Game Selection",
            txt = ""
        },
        {
            id = 2,
            header = "Play Pacman",
			txt = "",
			params = {
                event = "rcore_arcade:client:playArcade",
                args = '1'
            }
        },
        {
            id = 3,
            header = "Play Tetris",
			txt = "",
			params = {
                event = "rcore_arcade:client:playArcade",
                args = '2'
            }
        },
        {
            id = 4,
            header = "Play PingPong",
			txt = "",
			params = {
                event = "rcore_arcade:client:playArcade",
                args = '3'
            }
        },
        {
            id = 5,
            header = "Play Slide a Lama",
			txt = "",
			params = {
                event = "rcore_arcade:client:playArcade",
                args = '4'
            }
        },
        {
            id = 6,
            header = "Play Uno",
			txt = "",
			params = {
                event = "rcore_arcade:client:playArcade",
                args = '5'
            }
        },
        {
            id = 7,
            header = "Play Ants",
			txt = "",
			params = {
                event = "rcore_arcade:client:playArcade",
                args = '6'
            }
        },
        {
            id = 8,
            header = "Play FlappyParrot",
			txt = "",
			params = {
                event = "rcore_arcade:client:playArcade",
                args = '7'
            }
        },
        {
            id = 9,
            header = "Play Zoopaloola",
			txt = "",
			params = {
                event = "rcore_arcade:client:playArcade",
                args = '8'
            }
        },
        {
            id = 10,
            header = "Play Gulper.io (NEW)",
			txt = "",
			params = {
                event = "rcore_arcade:client:playArcade",
                args = '9'
            }
        },
        {
            id = 11,
            header = "Play Solitaire (NEW)",
			txt = "",
			params = {
                event = "rcore_arcade:client:playArcade",
                args = '10'
            }
        },
        {
            id = 12,
            header = "Cancel",
			txt = "",
			params = {
                event = ""
            }
        },
    })
end
