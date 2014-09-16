sequence = [108, 111, 118, 101]
index = 0
max = sequence.length

active = false

play = ->
    console.log 'playing song'
    index = 0
    audio = $('audio#lovesong')
    active = true
    audio.trigger 'play'

$ ->
    $('audio#lovesong').on 'abort ended pause', ->
        active = false

$(document).on 'keypress', (e) ->
    if active then return
    code = e.keyCode or e.charCode
    if index >= max - 1
        play()
    else if code == sequence[index]
        index++;
