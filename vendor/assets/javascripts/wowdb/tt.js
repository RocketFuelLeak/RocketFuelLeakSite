/* C:\Projects\Cobalt\Source\Curse.Azeroth.Web\Content\js\Libs\htmldiff.js */
(function () {

    window.HTMLDiff = (function () {

        function HTMLDiff(a, b) {
            this.a = a;
            this.b = b;
        }

        HTMLDiff.prototype.diff = function () {
            var diff;
            diff = this.diff_list(this.tokenize(this.a), this.tokenize(this.b));
            this.update(this.a, diff.filter(function (_arg) {
                var status, text;
                status = _arg[0], text = _arg[1];
                return status !== '+';
            }));
            return this.update(this.b, diff.filter(function (_arg) {
                var status, text;
                status = _arg[0], text = _arg[1];
                return status !== '-';
            }));
        };

        HTMLDiff.prototype.parseTextNodes = function (node, callback) {
            var handleNode;
            handleNode = function (node) {
                if (node == null) { return false; }
                var n, new_node, new_nodes, old_node, _i, _j, _len, _len2, _ref;
                if (node.nodeType === 3) {
                    if (!/^\s*$/.test(node.nodeValue)) return callback(node);
                } else {
                    _ref = (function () {
                        var _j, _len, _ref, _results;
                        _ref = node.childNodes;
                        _results = [];
                        for (_j = 0, _len = _ref.length; _j < _len; _j++) {
                            n = _ref[_j];
                            _results.push(n);
                        }
                        return _results;
                    })();
                    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
                        old_node = _ref[_i];
                        new_nodes = handleNode(old_node);
                        if (new_nodes) {
                            for (_j = 0, _len2 = new_nodes.length; _j < _len2; _j++) {
                                new_node = new_nodes[_j];
                                node.insertBefore(new_node, old_node);
                            }
                            node.removeChild(old_node);
                        }
                    }
                    return false;
                }
            };
            return handleNode(node);
        };

        HTMLDiff.prototype.tokenize = function (root) {
            var tokens;
            tokens = [];
            this.parseTextNodes(root, function (node) {
                tokens = tokens.concat(node.nodeValue.split(' '));
                return false;
            });
            return tokens;
        };

        HTMLDiff.prototype.update = function (root, diff) {
            var pos;
            pos = 0;
            return this.parseTextNodes(root, function (node) {
                var end, ins_node, new_node, new_nodes, output, part, start, status, text, _i, _len, _ref;
                start = pos;
                end = pos + (node.nodeValue.split(' ')).length;
                pos = end;
                output = (function () {
                    var _i, _len, _ref, _ref2, _results;
                    _ref = diff.slice(start, end);
                    _results = [];
                    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
                        _ref2 = _ref[_i], status = _ref2[0], text = _ref2[1];
                        if (status === '=') {
                            _results.push(text);
                        } else {
                            _results.push('<ins>' + text + '</ins>');
                        }
                    }
                    return _results;
                })();
                output = output.join(' ').replace(/<\/ins> <ins>/g, ' ').replace(/<ins> /g, ' <ins>').replace(/[ ]<\/ins>/g, '</ins> ').replace(/<ins><\/ins>/g, '');
                new_nodes = [];
                new_node = document.createTextNode("");
                new_nodes.push(new_node);
                _ref = output.split(/(<\/?ins>)/);
                for (_i = 0, _len = _ref.length; _i < _len; _i++) {
                    part = _ref[_i];
                    switch (part) {
                        case '<ins>':
                            ins_node = document.createElement('ins');
                            new_nodes.push(ins_node);
                            new_node = document.createTextNode("");
                            ins_node.appendChild(new_node);
                            break;
                        case '</ins>':
                            new_node = document.createTextNode("");
                            new_nodes.push(new_node);
                            break;
                        default:
                            new_node.nodeValue = part;
                    }
                }
                return new_nodes.filter(function (node) {
                    return !(node.nodeType === 3 && node.nodeValue === '');
                });
            });
        };

        HTMLDiff.prototype.diff_list = function (before, after) {
            var i, j, k, lastRow, ohash, subLength, subStartAfter, subStartBefore, thisRow, val, _i, _len, _len2, _len3, _ref, _ref2;
            ohash = {};
            for (i = 0, _len = before.length; i < _len; i++) {
                val = before[i];
                if (!(val in ohash)) ohash[val] = [];
                ohash[val].push(i);
            }
            lastRow = (function () {
                var _ref, _results;
                _results = [];
                for (i = 0, _ref = before.length; 0 <= _ref ? i < _ref : i > _ref; 0 <= _ref ? i++ : i--) {
                    _results.push(0);
                }
                return _results;
            })();
            subStartBefore = subStartAfter = subLength = 0;
            for (j = 0, _len2 = after.length; j < _len2; j++) {
                val = after[j];
                thisRow = (function () {
                    var _ref, _results;
                    _results = [];
                    for (i = 0, _ref = before.length; 0 <= _ref ? i < _ref : i > _ref; 0 <= _ref ? i++ : i--) {
                        _results.push(0);
                    }
                    return _results;
                })();
                _ref2 = (_ref = ohash[val]) != null ? _ref : [];
                for (_i = 0, _len3 = _ref2.length; _i < _len3; _i++) {
                    k = _ref2[_i];
                    thisRow[k] = (k && lastRow[k - 1] ? 1 : 0) + 1;
                    if (thisRow[k] > subLength) {
                        subLength = thisRow[k];
                        subStartBefore = k - subLength + 1;
                        subStartAfter = j - subLength + 1;
                    }
                }
                lastRow = thisRow;
            }
            if (subLength === 0) {
                return [].concat((function () {
                    var _j, _len4, _results;
                    _results = [];
                    for (_j = 0, _len4 = before.length; _j < _len4; _j++) {
                        val = before[_j];
                        _results.push(['-', val]);
                    }
                    return _results;
                })(), (function () {
                    var _j, _len4, _results;
                    _results = [];
                    for (_j = 0, _len4 = after.length; _j < _len4; _j++) {
                        val = after[_j];
                        _results.push(['+', val]);
                    }
                    return _results;
                })());
            } else {
                return [].concat(this.diff_list(before.slice(0, subStartBefore), after.slice(0, subStartAfter)), (function () {
                    var _j, _len4, _ref3, _results;
                    _ref3 = after.slice(subStartAfter, (subStartAfter + subLength));
                    _results = [];
                    for (_j = 0, _len4 = _ref3.length; _j < _len4; _j++) {
                        val = _ref3[_j];
                        _results.push(['=', val]);
                    }
                    return _results;
                })(), this.diff_list(before.slice(subStartBefore + subLength), after.slice(subStartAfter + subLength)));
            }
        };

        return HTMLDiff;

    })();

}).call(this);



jQuery(document).on('ready page:load', function () {
    jQuery.each(jQuery(".change"), function (i, v) {
        var oldDiff = jQuery(v).find(".old .db-tooltip");
        var newDiff = jQuery(v).find(".new .db-tooltip");
        if ((oldDiff.length) && (newDiff.length)) {
            var differ = new HTMLDiff(oldDiff[0], newDiff[0]);
            differ.diff();
        }
    });
});


/* C:\Projects\Cobalt\Source\Curse.Azeroth.Web\Content\js\Libs\jquery.dbTooltip.js */
(function(jQuery) {        
    'use strict';
        // the tooltip element

    var helper = {},
        // the current tooltipped element
        current,
        // the title of the current element, used for restoring
        title,
        // timeout id for delayed tooltips
        tID,
        // flag for mouse tracking
        track = true,
        LastX = 0,
        LastY = 0
    
    jQuery.dbTooltip = {
        blocked: false,
        defaults: {
            delay: 200,
            fade: false,
            showURL: false,
            track: true,
            extraClass: "",
            top: 15,
            left: 15,
            AdvancedTooltips: true,
            id: "db-tooltip-container"
        },
        block: function() {
            jQuery.dbTooltip.blocked = !jQuery.dbTooltip.blocked;
        },
        change_html: function(html) {            
            helper.body.html(html);            
        },
    };
    
    jQuery.fn.extend({
        dbTooltip: function(settings) {
            if(typeof(WowDbSettings) != "undefined")
            {
                jQuery.each(WowDbSettings,function(i,val) {
                    jQuery.dbTooltip.defaults[i] = val;
                });
            }
            settings = jQuery.extend({}, jQuery.dbTooltip.defaults, settings);
            createHelper(settings);

            return this.each(function() {
                    jQuery.data(this, "dbTooltip", settings);
                    this.tOpacity = helper.parent.css("opacity");
                    // copy tooltip into its own expando and remove the title
                    this.tooltipText = this.title;
                    jQuery(this).removeAttr("title");
                    // also remove alt attribute to prevent default tooltip in IE
                    this.alt = "";
                })
                .mouseover(save)
                .mouseout(hide)
                .click(hide);
        },      
        hideWhenEmpty: function() {
            return this.each(function() {
                jQuery(this)[ jQuery(this).html() ? "show" : "hide" ]();
            });
        },
        url: function() {
            return this.attr('href') || this.attr('src');
        }
    });
    
    function createHelper(settings) {
        // there can be only one tooltip helper
        if( helper.parent && jQuery(settings.id).length > 0 )
            return;
        // create the helper, h3 for title, div for url
        helper.parent = jQuery('<div id="' + settings.id + '"><h3></h3><div class="body"></div><div class="url"></div></div>')
            // add to document
            .appendTo(document.body)
            // hide it at first
            .hide();
            
        // apply bgiframe if available
        if ( jQuery.fn.bgiframe )
            helper.parent.bgiframe();
        
        // save references to title and url elements
        helper.title = jQuery('h3', helper.parent);
        helper.body = jQuery('div.body', helper.parent);
        helper.url = jQuery('div.url', helper.parent);
    }
    
    function settings(element) {
        return jQuery.data(element, "dbTooltip");
    }
    
    // main event handler to start showing tooltips
    function handle(event) {
        // show helper, either with timeout or on instant
        if( settings(this).delay )
            tID = setTimeout(show, settings(this).delay);
        else
            show();
        
        // if selected, update the helper position when the mouse moves
        track = !!settings(this).track;
        jQuery(document.body).bind('mousemove', update);
            
        // update at least once
        update(event);
    }
    
    // save elements title before the tooltip is displayed
    function save(unused, ignore_equal) {
        
        // if this is the current source, or it has no title (occurs with click event), stop
        if ( jQuery.dbTooltip.blocked || (this == current && !ignore_equal) || (!this.tooltipText && !settings(this).bodyHandler) )
            return;

        // save current
        current = this;
        title = this.tooltipText;
        
        if ( settings(this).bodyHandler ) 
        {
            helper.title.hide();
            var bodyContent = settings(this).bodyHandler.call(this);
            var script = null;

            if (!bodyContent) {
                bodyContent = settings(this).loadingText;
                var callback = settings(this).callback || 'WP_OnTooltipLoaded';

                if (settings(this).wowTooltip) {
                    var tooltipEntry = settings(this).wowTooltip.call(this);
                    var key = tooltipEntry.Type + '-' + tooltipEntry.Id + '-' + tooltipEntry.OldBuild + '-' + tooltipEntry.NewBuild + '-' + tooltipEntry.ExtraQueryParameters;
                    WP_Tooltips[key] = settings(this).loadingText;

                    var actionName = 'tooltip';

                    if (tooltipEntry.OldBuild && tooltipEntry.NewBuild)
                        actionName = 'dual-tooltip/' + tooltipEntry.OldBuild + '/' + tooltipEntry.NewBuild;


                    var baseUrl = tooltipEntry.HostName;
                    var src = baseUrl + "/" + tooltipEntry.Type + '/' + tooltipEntry.Id + '/' + actionName + '?x';

                    if ((settings(this).AdvancedTooltips || tooltipEntry.SimpleOrAdvanced == 'advanced') && tooltipEntry.SimpleOrAdvanced != 'simple') {
                        src += "&advanced=1";
                    }
                    
                    if (tooltipEntry.ExtraQueryParameters)
                        src += '&' + tooltipEntry.ExtraQueryParameters;

                    src += '&key=' + encodeURIComponent(key);

                    if (baseUrl == location.protocol + '//' + location.host)
                        jQuery.get(src, { callback: callback });
                    else {
                        script = document.createElement('script');
                        script.type = 'text/javascript';
                        script.src = src + '&callback=' + callback;
                    }
                }
            }
            
            if (bodyContent.nodeType || bodyContent.jquery) 
            {
                helper.body.empty().append(bodyContent)
            } 
            else 
            {
                helper.body.html(bodyContent);
            }
                            
            helper.body.show();
            show();
            if (WP_Stretch) // Other sites may not have this function
                WP_Stretch(jQuery('#' + settings(this).id));

            if(script != null)
            {
                jQuery("head").append(script);
            }
            
        } 
        else if ( settings(this).showBody ) 
        {
            var parts = title.split(settings(this).showBody);
            helper.title.html(parts.shift()).show();
            helper.body.empty();
            for(var i = 0, part; (part = parts[i]); i++) {
                if(i > 0)
                    helper.body.append("<br/>");
                helper.body.append(part);
            }
            helper.body.hideWhenEmpty();
        } 
        else 
        {
            helper.title.html(title).show();
            helper.body.hide();
        }
        
        // if element has href or src, add and show it, otherwise hide it
        if( settings(this).showURL && jQuery(this).url() )
            helper.url.html( jQuery(this).url().replace('http://', '') ).show();
        else 
            helper.url.hide();
        
        // add an optional class for this tip
        helper.parent.addClass(settings(this).extraClass);      
            
        handle.apply(this, arguments);
    }
    
    // delete timeout and show helper
    function show() {        
        tID = null;
        if (settings(current) && settings(current).fade) {
            if (helper.parent.is(":animated"))
                helper.parent.stop().show().fadeTo(settings(current).fade, current.tOpacity);
            else
                helper.parent.is(':visible') ? helper.parent.fadeTo(settings(current).fade, current.tOpacity) : helper.parent.fadeIn(settings(current).fade);
        } else {
            helper.parent.show();
        }
        update();
    }
    
    /**
     * callback for mousemove
     * updates the helper position
     * removes itself when no current element
     */
    function update(event)  {
        if (event) {
            if (event.pageX == LastX && event.pageY == LastY)
                return;

            if (!event.pageX)
                event.pageX = LastX;
            else
                LastX = event.pageX;

            if (!event.pageY)
                event.pageY = LastY;
            else
                LastY = event.pageY;
        }

        if(jQuery.dbTooltip.blocked)
            return;
        
        if (event && event.target.tagName == "OPTION") {
            return;
        }
        
        // stop updating when tracking is disabled and the tooltip is visible
        if ( !track && helper.parent.is(":visible")) {
            jQuery(document.body).unbind('mousemove', update)
        }
        
        // if no current element is available, remove this listener
        if( current == null ) {
            jQuery(document.body).unbind('mousemove', update);
            return; 
        }
        
        // remove position helper classes
        helper.parent.removeClass("viewport-right").removeClass("viewport-bottom");
        
        var left = helper.parent[0].offsetLeft;
        var top = helper.parent[0].offsetTop;
        var cachedSettings = settings(current);
        if (!cachedSettings)
        {
            helper.parent.hide();
            jQuery(document.body).unbind('mousemove', update);
            return;
        }
        if (event) {
            // position the helper 15 pixel to bottom right, starting from mouse position
            left = event.pageX + cachedSettings.left + 5;
            top = event.pageY - cachedSettings.top - helper.parent.height() + 5;

            var right='auto';
            if (cachedSettings.positionLeft) {
                right = jQuery(window).width() - left - 20;
                left = 'auto';
            }
            helper.parent.css({
                left: left,
                right: right,
                top: top
            });
        }
        
        var v = viewportCache,
            h = helper.parent[0];
        
        // check horizontal position
        if (v.x + v.cx < h.offsetLeft + h.offsetWidth) {
            left -= h.offsetWidth + 20 + cachedSettings.left;
            helper.parent.css({left: left + 'px'}).addClass("viewport-right");
        }

        // check vertical position        
        if (event && (top - jQuery(window).scrollTop()) < 0) 
        {            
            top = event.pageY + cachedSettings.top;

            var totalAvailableHeight = v.y + v.cy - 15;
            var tooltipMaxY = top + helper.parent.height();
            if (tooltipMaxY > totalAvailableHeight)
                top -= (tooltipMaxY - totalAvailableHeight);

            helper.parent.css({top: top});
        }
    }
    
    var viewportCache = { x: 0, y: 0, cx: 0, cy: 0 };
    function viewport() {
        viewportCache.x = window.scrollX;
        viewportCache.y = window.scrollY;
        viewportCache.cx = window.innerWidth - 20;
        viewportCache.cy = window.innerHeight;
    }
    viewport();

    jQuery(window).resize(function() { viewport(); });
    jQuery(window).scroll(function() { viewport(); });
        
    // hide helper and restore added classes and the title
    function hide(event) {
        
        if(jQuery.dbTooltip.blocked)
            return;        

        // clear timeout if possible
        if(tID)
            clearTimeout(tID);
        // no more current element
        current = null;
        
        var tsettings = settings(this);
        function complete() {
            helper.parent.removeClass( tsettings.extraClass ).hide().css("opacity", "");
        }
        if (tsettings.fade) {
            if (helper.parent.is(':animated'))
                helper.parent.stop().fadeTo(tsettings.fade, 0, complete);
            else
                helper.parent.stop().fadeOut(tsettings.fade, complete);
        } else
            complete();             
    }
    
})(jQuery);

function WP_LoadTooltips(parentElement) {
    if (parentElement)
    {
        WP_LoadTooltipsElements(parentElement.find('a, *[data-tooltip-href]'));
    }
    else
    {
        WP_LoadTooltipsElements(jQuery('a, *[data-tooltip-href]'));
    }
}

function WP_LoadTooltipsElements(elements) {
    var regex = /(.*?)?\/(spells|items|npcs|quests|achievements|world-events|pet-abilities|currencies|wod-talents|i|a|c|q|s)\/([0-9]+)[\/a-z0-9\-]*(\?(simple|advanced))?(#([0-9]+)-([0-9]+))?/i;
    var SigrieReplaces = {
        'i': 'items',
        'a': 'achievements',
        'c': 'npcs',
        'q': 'quests',
        's': 'spells'
    };

    elements.each(function () {
        var link = jQuery(this).attr("href") || jQuery(this).attr("data-tooltip-href");

        if (!link)
            return;

        var queryPart = link.split('#')[0].split('?')[1];
        var hashPart = link.split('#')[1];

        link = link.split('#')[0].split('?')[0]; // Remove hash and query part of URL

        var currentLocation = location.href.split('#')[0].split('?')[0];

        if (!link || link == currentLocation || (location.protocol + '//' + location.host + link) == currentLocation)
            return;

        if (link.substr(0, 11) == 'javascript:') // Do not do this for javascript "links"
            return;

        if (hashPart)
            link = link + '#' + hashPart;

        var res = link.match(regex);

        if (!res) {
            return;
        }

        var hostName = res[1] || ("http://" + window.location.host);
        var controllerName = res[2];
        var id = res[3];
        var simpleOrAdvanced = res[5];
        var oldBuild = res[7];
        var newBuild = res[8];

        /* Sigrie replaces */
        if (SigrieReplaces[controllerName])
            controllerName = SigrieReplaces[controllerName];

        if (hostName == 'http://db.mmo-champion.com')
            hostName = 'http://www.wowdb.com';
        else if (hostName == 'https://db.mmo-champion.com')
            hostName = 'https://www.wowdb.com';

        if (hostName.indexOf('wowdb') == -1) {
            return;
        }

        jQuery(this).dbTooltip({
            bodyHandler: function() {
                var key = controllerName + '-' + id + '-' + oldBuild + '-' + newBuild + '-' + queryPart;
                WP_ActiveTooltip = key;
            },
            wowTooltip: function () {
                return { HostName: hostName, Type: controllerName, Id: id, OldBuild: oldBuild, NewBuild: newBuild, SimpleOrAdvanced: simpleOrAdvanced, ExtraQueryParameters: queryPart };
            },
            loadingText: '<div class="wowdb-tooltip"><div class="db-tooltip"><div class="db-description" style="width: auto">Loading..</div></div></div>'
        });
    });
}

function WP_OnTooltipLoaded(data) {
    var key = data.Key;

    if (typeof (data.OldBuild) != 'undefined' && typeof (data.NewBuild) != 'undefined') {
        var tmp = jQuery('<div/>').attr('id', 'temp').html(data.Tooltip);
        var blocks = tmp.find('.db-tooltip');

        if (blocks.length == 3) {
            var differ = new HTMLDiff(blocks[1], blocks[2]);
            differ.diff();
            data.Tooltip = tmp.html();
        }
    }
    WP_Tooltips[key] = data.Tooltip;

    if (WP_ActiveTooltip == key)
        jQuery.dbTooltip.change_html(data.Tooltip);
    WP_Stretch(jQuery('#db-tooltip-container'));
    jQuery(document.body).trigger('mousemove');
}

function WP_Initialize() {
    WP_Tooltips = {};
    WP_LoadTooltips();
}

jQuery(document).on('ready page:load', function () {
    WP_Initialize();
});

function WP_Stretch(container)
{
    var MAX_WIDTH = 600;

    container.find('.db-description').each(function () {
        /* For each tooltip */
        var tooltip = jQuery(this);
        var currentWidth = tooltip.width();
        var increased = false;

        tooltip.find('.tooltip-table tr, .db-title, h2, h3, .db-achievement-criteria > li').each(function () {
            var maxHeight = parseInt(jQuery(this).attr('data-height'), 10) || 25;

            while (jQuery(this).height() > maxHeight && currentWidth < MAX_WIDTH) {
                increased = true;
                currentWidth += 10;
                tooltip.width(currentWidth);
            }
        });

        if (increased)
            tooltip.width(currentWidth + 20);
    });
}
