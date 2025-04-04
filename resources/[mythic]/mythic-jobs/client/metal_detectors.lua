--Detectors converted from Sandbox to Mythic by Ozzy.

_metalDetectorPropsLoaded = {}

function RegisterMetalDetectors()
   
    for _, obj in ipairs(_metalDetectorPropsLoaded) do
        if DoesEntityExist(obj) then
            DeleteObject(obj)
        end
    end
    _metalDetectorPropsLoaded = {}

    for k, v in pairs(_metalDetectorLocations) do
      
        Polyzone.Create:Box(
            string.format("%s-metal-detector-zone", k), 
            vector3(v.coords.x, v.coords.y, v.coords.z), 
            2.0, 2.0, 
            {
                heading = v.coords.w,
                minZ = v.minZ, 
                maxZ = v.maxZ, 
                debugPoly = true
            }, 
            {}
        )

        local model = GetHashKey(v.modelName)
    
        local existingProp = GetClosestObjectOfType(v.coords.x, v.coords.y, v.coords.z, 1.5, model, false, false, false)
        if existingProp ~= 0 then
            print(string.format("[Metal Detector] Skipping prop creation at %s, existing MLO prop detected.", k))
        else
           
            RequestModel(model)
            while not HasModelLoaded(model) do
                Citizen.Wait(1)
            end
            
            local obj = CreateObject(model, v.coords.x, v.coords.y, v.coords.z - 1, false, false, false)
            SetEntityHeading(obj, v.coords.w)
            FreezeEntityPosition(obj, true)
            table.insert(_metalDetectorPropsLoaded, obj)
        end
    end
end

AddEventHandler("Polyzone:Enter", function(id, testedPoint, insideZones, data)
    for k, v in pairs(_metalDetectorLocations) do
        if id == string.format("%s-metal-detector-zone", k) then
    
            if Inventory.Items:HasType(2, 1) then
                print("[Metal Detector] Weapon detected, triggering sound event")
                Callbacks:ServerCallback("MetalDetector:Server:Sync", v.coords, function() end)
            else
                print("[Metal Detector] No weapon detected.")
            end
        end
    end
end)


RegisterNetEvent("MetalDetector:Client:Sync", function(data)
    local _pedc = GetEntityCoords(LocalPlayer.state.ped, true)
    local distance = #(vector3(_pedc.x, _pedc.y, _pedc.z) - vector3(data.x, data.y, data.z))

    if distance <= 5.0 then
        print("[Metal Detector] Playing sound for weapon detection")
        PlaySoundFromCoord(-1, "CHECKPOINT_MISSED", data.x, data.y, data.z, "HUD_MINI_GAME_SOUNDSET", 0, 2.5, 1)
    end
end)

RegisterMetalDetectors()