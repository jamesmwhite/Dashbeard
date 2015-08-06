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
            if(response != lastRefresh){
                window.location.reload(1);
            }

        })
        .always(function () {
            setTimeout(checkRefresh, 30000);
        });
    };


    changeImage = function(){
        curNum = curNum + 1;
        if(curNum < images.length){
            
        }
        else{
            curNum = 0;
        }
        if(images.length>0){
            document.getElementById("otherImage").src=images[curNum];
        }
        
        setTimeout(changeImage, phototime);
    }


    loadImageRotation = function() {

        $.ajax({
            url: "/getPhotoRefresh",
            dataType: "text",
            cache: false
        })
        .done(function (response) {
            phototime = JSON.parse(response);
        })
        .error(function (err){
            console.log(err);
        })
        .always(function () {

            loadImageRotationFollowOn();

        });      
      
    }

    loadImageRotationFollowOn = function(){
        $.ajax({
            url: "/getImages",
            dataType: "text",
            cache: false
        })
        .done(function (response) {
            var photos = JSON.parse(response);
            for(var i in photos)
            {
                images[i] = photos[i].url;
            }
            
        })
        .always(function () {
            changeImage();
        });  
    }

    organiseSwapping = function(){
        try{
            $.ajax({
            url: "/getContentRefreshTime",
            dataType: "text",
            cache: false
        })
        .done(function (response) {
            parsedVal = JSON.parse(response);
            console.log(parsedVal);
            // if(parsedVal != null && parsedVal > 0){
                swaptime = parsedVal;
            // }
            $("#otherContent").fadeOut('fast');
            window.setInterval(swapContent, swaptime);
        })
        .always(function () {
            // setTimeout(organiseSwapping, 60000);
        });    
        }
        catch(error){
            console.log(error);
        }
        


        
    }
