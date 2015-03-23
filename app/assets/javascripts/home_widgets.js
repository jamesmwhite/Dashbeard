(function($) {
        $.fn.textWidth = function(){
             var calc = '<span style="display:none">' + $(this).text() + '</span>';
             $('body').append(calc);
             var width = $('body').find('span:last').width();
             $('body').find('span:last').remove();
            return width;
        };
        
        $.fn.marquee = function(args) {
            var that = $(this);
            var textWidth = that.textWidth(),
                offset = that.width(),
                width = offset,
                css = {
                    'text-indent' : that.css('text-indent'),
                    'overflow' : that.css('overflow'),
                    'white-space' : that.css('white-space')
                },
                marqueeCss = {
                    'text-indent' : width,
                    'overflow' : 'hidden',
                    'white-space' : 'nowrap'
                },
                args = $.extend(true, { count: -1, speed: 1e1, leftToRight: false }, args),
                i = 0,
                stop = textWidth*-1,
                dfd = $.Deferred();
            
            function go() {
                if(!that.length) return dfd.reject();
                if(width == stop) {
                    i++;
                    if(i == args.count) {
                        that.css(css);
                        return dfd.resolve();
                    }
                    if(args.leftToRight) {
                        width = textWidth*-1;
                    } else {
                        width = offset;
                    }
                }
                that.css('text-indent', width + 'px');
                if(args.leftToRight) {
                    width++;
                } else {
                    width--;
                }
                setTimeout(go, args.speed);
            };
            if(args.leftToRight) {
                width = textWidth*-1;
                width++;
                stop = offset;
            } else {
                width--;            
            }
            that.css(marqueeCss);
            go();
            return dfd.promise();
        };
    })(jQuery);


// This script async replaces content with data from URL's
dynamic_change = function (fetch_url,html_el,time_delay,next_func,replace) {
        $.ajax({
            url: fetch_url,
            dataType: "text",
            cache: false
        })
        .done(function (response) {
            $("#"+html_el).fadeOut('slow',function(){
                if (replace ===  undefined){
                    $("#"+html_el).html(response);    
                }
                else{
                    $("#"+html_el).replaceWith(response);
                }
                
            }).fadeIn('slow');
        })
        .always(function () {
            setTimeout(next_func, time_delay);
        });
    };



    checkRefresh = function () {
        $.ajax({
            url: "/checkRefresh",
            dataType: "text",
            cache: false
        })
        .done(function (response) {
            if(response != currentMode){
                window.location.reload(1);
            }
            console.log(response);
            console.log(currentMode);

        })
        .always(function () {
            setTimeout(checkRefresh, 30000);
        });
    };