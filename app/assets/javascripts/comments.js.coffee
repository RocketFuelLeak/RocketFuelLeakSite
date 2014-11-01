$(document).on 'ready page:load', ->
    console.log 'comments.js.coffee'
    $('.comment-submit-btn').on 'click', (e) ->
        console.log 'Button pressed'
        $(this).button('loading')
