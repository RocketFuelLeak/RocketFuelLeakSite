# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

insertAt = (str, pos, val) ->
    str.substring(0, pos) + val + str.substring(pos, str.length)

class Editor
    constructor: (@input, @preview) ->
        if @input == null or @input.length == 0
            return
        @input.get(0).editor = this
        @update()
    update: ->
        @preview.html(markdown.toHTML(@input.val()))
        @preview.html(@preview.html().replace(/https?:\/\/[^y]*youtube\.[^\/]+\/watch\?[^v]*v=([A-Za-z0-9\-_]+)/,
                      "<div class=\"flex-video widescreen\"><iframe src=\"https://www.youtube.com/embed/$1\" allowfullscreen=\"true\" frameborder=\"0\"></iframe></div>"))
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
        @link '!', "Alt text...", "http://www.example.com/example.png"
    youtube: ->
        alert('Simply paste a youtube video link on its own line in the post and it will be automatically converted when viewed.')
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
    #mdbox.on 'input', (e) ->
    #    if this.refreshtimer
    #        clearTimeout this.refreshtimer
    #
    #    this.refreshtimer = setTimeout (->
    #        this.refreshtimer = null
    #        this.editor.update()
    #    ), 500
    $('a[href="#post-tab-preview"]').on 'shown.bs.tab', (e) ->
        mdboxele.editor.update()
    $('.markdown-box-actions a').each (index) ->
        $(this).on 'click', (e) ->
            e.preventDefault()
            a = $(this)
            action = a.data('action')
            param = a.data('action-param')
            if action
                mdboxele.editor[action](param)
    $('ul#news-archive-list > li > a').on 'click', (e) ->
        e.preventDefault()
        #$(this).toggleClass('open')
    $('ul#news-archive-list > li > ul.collapse').on 'show.bs.collapse', (e) ->
        $("ul#news-archive-list > li > a[href='##{$(this).attr('id')}']").addClass('open')
    $('ul#news-archive-list > li > ul.collapse').on 'hide.bs.collapse', (e) ->
        $("ul#news-archive-list > li > a[href='##{$(this).attr('id')}']").removeClass('open')
