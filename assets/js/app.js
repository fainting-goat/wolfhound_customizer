// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
// import "phoenix_html"
import lightbox2 from "lightbox2"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

import css from "../css/app.css"
import socket from "./socket"

import jquery from "jquery"

$('.flavorButton').click(function () {
    let flavor = this.id;
    $("input[type=radio]").each(function () {
        if ($(this).attr('id').includes(flavor) ) {
            this.checked = true;
        }
        else {
            this.checked = false;
        }
    })
});

$('body').on("click", ".expand", function () {
    let category = $(this).attr("for");
    let categoryDiv = $("#" + category + "_div");

    if (categoryDiv.hasClass("expanded")) {
        categoryDiv.removeClass("expanded");
        categoryDiv.addClass("collapsed");
    }
    else {
        categoryDiv.removeClass("collapsed");
        categoryDiv.addClass("expanded");
    }
});


$('#createButton').click(function () {
    $('#createButton').enabled = false;
});

