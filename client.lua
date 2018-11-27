------------------------------------
--- Police Backup, Made by FAXES ---
--- ESX Support by SneakGaming   ---
------------------------------------
local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX                           = nil
local PlayerData              = {}
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

function ShowInfo(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end

function playCode99Sound()
    PlaySoundFrontend(-1, "TIMER_STOP", "HUD_MINI_GAME_SOUNDSET", 1)
    Wait(900)
    PlaySoundFrontend(-1, "TIMER_STOP", "HUD_MINI_GAME_SOUNDSET", 1)
    Wait(900)
    PlaySoundFrontend(-1, "TIMER_STOP", "HUD_MINI_GAME_SOUNDSET", 1)
end

RegisterNetEvent('Fax:ShowInfo')
AddEventHandler('Fax:ShowInfo', function(notetext)
	ShowInfo(notetext)
end)

RegisterNetEvent('Fax:BackupReq')
AddEventHandler('Fax:BackupReq', function(bk, s, playerName)
    local src = s
    local bkLvl = bk
    local bkLvlTxt = "N/A"
    local coords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(src)))
    local street1 = GetStreetNameAtCoord(coords.x, coords.y, coords.z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
    local streetName = (GetStreetNameFromHashKey(street1))

    if PlayerData.job.name == Config.jobname then
        if bkLvl == "1" then
            bkLvlTxt = "~b~code 1"
        elseif bkLvl == "2" then
            bkLvlTxt = "~y~code 2"
        elseif bkLvl == "3" then
            bkLvlTxt = "~r~CODE 3"
            PlaySoundFrontend(-1, "Mission_Pass_Notify", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", 1)
        elseif bkLvl == "99" then
            bkLvlTxt = "~r~~h~CODE 99"
        end
        ShowInfo("Officer ~g~" ..  playerName .. "~w~ is in need of assistance " .. bkLvlTxt .. "~s~. ~o~Location: ~s~" .. streetName .. ".")
        SetNewWaypoint(coords.x, coords.y)

        if bkLvl == "99" then
            playCode99Sound()
        end
    end
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
      if IsControlPressed(0, Config.modifierkey) and IsControlPressed(0, Config.code1key) and PlayerData.job.name == Config.jobname then
        print('help')
        TriggerServerEvent('Fax:BackupReq', '1')
      end
      if IsControlPressed(0, Config.modifierkey) and IsControlPressed(0,  Config.code2key) and PlayerData.job.name == Config.jobname then
        TriggerServerEvent('Fax:BackupReq', '2')
      end
      if IsControlPressed(0, Config.modifierkey) and IsControlPressed(1,  Config.code3key) and PlayerData.job.name == Config.jobname then
        TriggerServerEvent('Fax:BackupReq', '3')
      end
      if IsControlPressed(0, Config.modifierkey) and IsControlPressed(1,  Config.code99key) and PlayerData.job.name == Config.jobname then
        TriggerServerEvent('Fax:BackupReq', '99')
      end
  end
end)
