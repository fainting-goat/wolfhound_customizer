import $ from "jquery"
import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken}});

socket.connect()

let itemChannel = socket.channel("item", {});

let expand = $(".expand")

expand.one( "click", function(event) {
    let clickedDiv = $(".expand#" + event.target.id);
    if (clickedDiv.hasClass("expand")) {
        itemChannel.push('images', {category: event.target.id})
    }
});

$('#save').click(function () {
    let selected = [];

    $('input:checked').each(function() {
        selected.push($(this).attr('value'));
    });

    let keyword = $('#keyword').val();
    itemChannel.push('set_selections', {keyword: keyword, selections: selected})
});

$('#load').click(function () {
    let keyword = $('#keywordLoad').val();
    itemChannel.push('get_selections', {keyword: keyword})
});

itemChannel.on('item_response', payload => {
    let currentCategory = $(".expand#" + payload.category);
    currentCategory.empty();
currentCategory.replaceWith(payload.html)
});

itemChannel.on('load_response', payload => {
    let currentCategory = $("#expanded_" + payload.category +"_div");
    let subDiv = $("#colormap_div");
    subDiv.remove();
    currentCategory.empty();
    currentCategory.replaceWith(payload.html)
});

itemChannel.join()
.receive("ok", resp => { console.log("Joined successfully", resp) })
.receive("error", resp => { console.log("Unable to join", resp) })

export default socket
