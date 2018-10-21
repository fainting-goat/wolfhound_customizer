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
    itemChannel.push('set_selections', {keyword: keyword, selections: selected});
});

$('#load').click(function () {
    let keyword = $('#keywordLoad').val();
    itemChannel.push('get_selections', {keyword: keyword})
});

itemChannel.on('item_response', payload => {
    let currentCategory = $(".expand#" + payload.category);
    currentCategory.empty();
    currentCategory.replaceWith(payload.html);
});

itemChannel.on('load_response', payload => {
    let parsedSelections = payload.selections;

    $("input[type=radio]").each(function () {
        this.checked = false;
    });

    parsedSelections.forEach(function(item) {
        let itemElement = $("input[value='" + item + "']");
        if (itemElement.length) {
            itemElement[0].checked = true;
        }
    });

    $("#loadResults").html("<h4>" + payload.message + "</h4>");
});

itemChannel.on('save_response', payload => {
    let message = payload.message;

    $("#saveResults").html("<h3>" + message + "</h3>");
});

itemChannel.join()
.receive("ok", resp => { console.log("Joined successfully", resp) })
.receive("error", resp => { console.log("Unable to join", resp) })

export default socket
