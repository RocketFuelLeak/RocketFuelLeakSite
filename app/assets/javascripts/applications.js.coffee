# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

application_character_realm_lastval = ''

$(document).on 'ready page:load', ->
    $('#application_character_realm').on 'input', (e) ->
        $this = $(this)
        guild_realm = $('#application_character_guild_realm')
        if guild_realm.val() == '' or guild_realm.val() == application_character_realm_lastval
            guild_realm.val($this.val())
        application_character_realm_lastval = $(this).val()
