# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

insertAt = (str, pos, val) ->
    str.substring(0, pos) + val + str.substring(pos, str.length)

Editor = (input, preview) ->
    this.update = ->
        preview.html(markdown.toHTML(input.val()))
    this.surround = (before, after, placeholder) ->
        after = after || before
        placeholder = placeholder || "Type something..."
        caret = input.caret()
        if caret.begin == caret.end
            toinsert = before + placeholder + after
            input.val(insertAt(input.val(), caret.begin, toinsert))
            input.caret(caret.begin + before.length, caret.begin + toinsert.length - after.length)
        else
            input.val(insertAt(input.val(), caret.begin, before))
            input.val(insertAt(input.val(), caret.end + before.length, after))
            input.caret(caret.end + before.length + after.length)
        input.focus()
    this.bold = ->
        this.surround "**"
    this.italic = ->
        this.surround "*"
    this.underline = ->
        this.surround "_"
    this.strikethrough = ->
        this.surround "~~"
    this.link = (prefix, placeholder, url) ->
        prefix = prefix || ''
        placeholder = placeholder || "Link text..."
        url = url || "http://www.example.com/"
        before = prefix + "[" + placeholder + "]("
        after = ')'
        caret = input.caret()
        this.surround(before, after, url)
        if caret.end > caret.begin
            input.caret(caret.begin + prefix.length + 1, caret.begin + before.length - 2)
            input.focus()
    this.image = ->
        this.link '!', "Alt text...", "http://www.example.com/example.png"
    this.paragraph = ->
        caret = input.caret()
        val = input.val()
        lineStart = val.lastIndexOf('\n', caret.begin - 1) + 1
        if lineStart == -1
            lineStart = 0
        lineEnd = val.indexOf('\n', caret.begin)
        if lineEnd == -1
            lineEnd = val.length
        if val[lineStart] == '#' # Heading of at least the first level
            fixed = /^(#+ )(.*)$/.exec(val.substring(lineStart, lineEnd))
            if fixed and fixed.length == 3
                input.val(val.substring(0, lineStart) + fixed[2] + val.substring(lineEnd))
                input.caret(caret.begin - fixed[1].length)
        input.focus()
    this.heading = (level) ->
        this.paragraph() # Dirty hack
        caret = input.caret()
        val = input.val()
        lineStart = val.lastIndexOf('\n', caret.begin - 1) + 1
        if lineStart == -1
            lineStart = 0
        prefix = Array(level + 1).join('#') + ' '
        input.val(val.substring(0, lineStart) + prefix + val.substring(lineStart))
        input.caret(caret.begin + prefix.length)
        input.focus()
    input.get(0).editor = this
    this.update()

$(document).on 'ready page:load', ->
    mdbox = $('#post_content')
    new Editor(mdbox, $("#post-preview-target"))
    mdboxele = mdbox.get(0)
    mdbox.on 'input', (e) ->
        this.editor.update()
    $('.markdown-box-actions a.bold-btn').on 'click', (e) ->
        e.preventDefault()
        mdboxele.editor.bold()
    $('.markdown-box-actions a.italic-btn').on 'click', (e) ->
        e.preventDefault()
        mdboxele.editor.italic()
    $('.markdown-box-actions a.underline-btn').on 'click', (e) ->
        e.preventDefault()
        mdboxele.editor.underline()
    $('.markdown-box-actions a.strike-btn').on 'click', (e) ->
        e.preventDefault()
        mdboxele.editor.strikethrough()
    $('.markdown-box-actions a.link-btn').on 'click', (e) ->
        e.preventDefault()
        mdboxele.editor.link()
    $('.markdown-box-actions a.img-btn').on 'click', (e) ->
        e.preventDefault()
        mdboxele.editor.image()
    $('.markdown-box-actions a.paragraph-btn').on 'click', (e) ->
        e.preventDefault()
        mdboxele.editor.paragraph()
    $('.markdown-box-actions a.heading1-btn').on 'click', (e) ->
        e.preventDefault()
        mdboxele.editor.heading(1)
    $('.markdown-box-actions a.heading2-btn').on 'click', (e) ->
        e.preventDefault()
        mdboxele.editor.heading(2)
    $('.markdown-box-actions a.heading3-btn').on 'click', (e) ->
        e.preventDefault()
        mdboxele.editor.heading(3)
