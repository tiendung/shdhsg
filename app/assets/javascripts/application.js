// FIXME: Tell people that this is a manifest file, real code should go into discrete files
// FIXME: Tell people how Sprockets and CoffeeScript works
//
//= require jquery
//= require jquery_ujs
//= require_tree .

$(document).ready(function(){			
    $("#the_order img[title]").tooltip();
    $("#declaration_of_awesomeness textarea").keyup(function(){
        var usernames = twttr.txt.extractMentions(this.value);
        c = $("#count").val();
        if(usernames.length > 0){
            t = usernames.splice(0,c);
            $("#receivers").html($.unique(t).join(", "))
        }
    });
    $("#reason").supertextarea({
       maxw: 470,
       maxl: 134
    });
})