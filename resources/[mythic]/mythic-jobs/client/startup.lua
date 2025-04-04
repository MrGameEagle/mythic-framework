AddEventHandler('Jobs:Shared:DependencyUpdate', RetrieveComponents)
function RetrieveComponents()
    Callbacks = exports['mythic-base']:FetchComponent('Callbacks')
    Logger = exports['mythic-base']:FetchComponent('Logger')
    Utils = exports['mythic-base']:FetchComponent('Utils')
    Notification = exports['mythic-base']:FetchComponent('Notification')
    Jobs = exports['mythic-base']:FetchComponent('Jobs')
    Polyzone = exports['mythic-base']:FetchComponent('Polyzone')
    Inventory = exports['mythic-base']:FetchComponent('Inventory')
    Sounds = exports["mythic-base"]:FetchComponent("Sounds")
end

AddEventHandler('Core:Shared:Ready', function()
    exports['mythic-base']:RequestDependencies('Jobs', {
        'Callbacks',
        'Logger',
        'Utils',
        'Notification',
        'Jobs',
        'Polyzone',
        'Inventory',
        'Sounds'
    }, function(error)
        if #error > 0 then return; end
        RetrieveComponents()
    end)
end)