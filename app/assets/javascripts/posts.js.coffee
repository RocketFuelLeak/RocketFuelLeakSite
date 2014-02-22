# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

insertAt = (str, pos, val) ->
    str.substring(0, pos) + val + str.substring(pos, str.length)

class Editor
    constructor: (@input, @preview) ->
        @input.get(0).editor = this
        @update()
    update: ->
        @preview.html(markdown.toHTML(@input.val()))
    surround: (before, after = before, placeholder = "Type something...") ->
        caret = @input.caret()
        if caret.begin == caret.end
            toinsert = before + placeholder + after
            @input.val(insertAt(@input.val(), caret.begin, toinsert))
            @input.caret(caret.begin + before.length, caret.begin + toinsert.length - after.length)
        else
            @input.val(insertAt(@input.val(), caret.begin, before))
            @input.val(insertAt(@input.val(), caret.end + before.length, after))
            @input.caret(caret.end + before.length + after.length)
        @input.focus()
    bold: ->
        @surround "**"
    italic: ->
        @surround "*"
    underline: ->
        @surround "_"
    strikethrough: ->
        @surround "~~"
    link: (prefix = '', placeholder = "Link text...", url = "http://example.com/") ->
        before = prefix + "[" + placeholder + "]("
        after = ')'
        caret = @input.caret()
        this.surround(before, after, url)
        if caret.end > caret.begin
            @input.caret(caret.begin + prefix.length + 1, caret.begin + before.length - 2)
            @input.focus()
    image: ->
        link '!', "Alt text...", "http://www.example.com/example.png"
    paragraph: ->
        caret = @input.caret()
        val = @input.val()
        lineStart = val.lastIndexOf('\n', caret.begin - 1) + 1
        if lineStart == -1
            lineStart = 0
        lineEnd = val.indexOf('\n', caret.begin)
        if lineEnd == -1
            lineEnd = val.length
        if val[lineStart] == '#' # Heading of at least the first level
            fixed = /^(#+ )(.*)$/.exec(val.substring(lineStart, lineEnd))
            if fixed and fixed.length == 3
                @input.val(val.substring(0, lineStart) + fixed[2] + val.substring(lineEnd))
                @input.caret(caret.begin - fixed[1].length)
        @input.focus()
    heading: (level) ->
        @paragraph() # Dirty hack
        caret = @input.caret()
        val = @input.val()
        lineStart = val.lastIndexOf('\n', caret.begin - 1) + 1
        if lineStart == -1
            lineStart = 0
        prefix = Array(level + 1).join('#') + ' '
        @input.val(val.substring(0, lineStart) + prefix + val.substring(lineStart))
        @input.caret(caret.begin + prefix.length)
        @input.focus()

$(document).on 'ready page:load', ->
    mdbox = $('#post_content')
    new Editor(mdbox, $("#post-preview-target"))
    mdboxele = mdbox.get(0)
    mdbox.on 'input', (e) ->
        this.editor.update()
    $('.markdown-box-actions a').each (index) ->
        $(this).on 'click', (e) ->
            e.preventDefault()
            a = $(this)
            action = a.data('action')
            param = a.data('action-param')
            if action
                mdboxele.editor[action](param)
