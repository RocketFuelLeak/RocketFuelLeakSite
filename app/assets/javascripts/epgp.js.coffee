calculate_epgp = ->
    ep = parseInt($('#epgp-ep-input').val())
    gp = parseInt($('#epgp-gp-input').val())
    pr = ep / (gp + 100)
    $('#epgp-pr-output').val(pr)

$(document).on 'ready page:load', ->
    $('#epgp-ep-input').on 'input', (e) ->
        calculate_epgp()
    $('#epgp-gp-input').on 'input', (e) ->
        calculate_epgp()
