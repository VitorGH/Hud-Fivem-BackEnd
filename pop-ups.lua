local NotifyTypes = {
    ['verde'] = 'success',
    ['amarelo'] = 'alert',
    ['vermelho'] = 'error'
}

RegisterNetEvent('Notify', function(nTitle, nText, nType, nTime)
    SendNUIMessage({'SendNotify', nTitle, nText, (NotifyTypes[nType] or 'alert'), (nTime or 5000)})
end)

RegisterNetEvent('Progress', function(pText, pTime)
    SendNUIMessage({'SendProgress', pText, pTime})
end)