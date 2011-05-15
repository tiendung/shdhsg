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

    // http://plugins.jquery.com/content/cursor-position
    /* focus to first visible form element */
    $("#reason").focus();
    /* Set the cursor position to the end. Needed for non-Mozilla browsers */
    var caretPos = $("#reason").val().length;
    if($("#reason")[0].createTextRange) { /* For IE */
        var range = $("#reason")[0].createTextRange();
        range.move('character', caretPos);
        range.select();
    }
    else { /* For other browsers */
        $("#reason")[0].setSelectionRange(caretPos, caretPos);
    }
});
