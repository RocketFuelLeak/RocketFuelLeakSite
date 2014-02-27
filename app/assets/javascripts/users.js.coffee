$(document).on 'ready page:load', ->
    $('#recaptcha_new').on 'click', (e) ->
        Recaptcha.reload()
    $('#recaptcha_switch_audio').on 'click', (e) ->
        Recaptcha.switch_type('audio')
        $('#recaptcha_response_field').attr('placeholder', 'Enter the numbers you hear')
        $(this).hide()
        $('#recaptcha_switch_image').show()
    $('#recaptcha_switch_image').on 'click', (e) ->
        Recaptcha.switch_type('image')
        $('#recaptcha_response_field').attr('placeholder', 'Enter the words above')
        $(this).hide()
        $('#recaptcha_switch_audio').show()
    $('#recaptcha_help').on 'click', (e) ->
        Recaptcha.showhelp()
    $('#recaptcha_widget').show()
