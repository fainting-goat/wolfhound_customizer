import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken}})

socket.connect()

let itemChannel = socket.channel("item", {})

let expand = $(".expand")

expand.one( "click", function() {
        let clickedDiv = $("#" + event.target.id)
        if (clickedDiv.hasClass("expand")) {
            clickedDiv.removeClass("expand")
            itemChannel.push('images', {category: event.target.id})
        }
})

itemChannel.on('item_response', payload => {
    let currentCategory = $("#" + payload.category)
    currentCategory.empty()
    currentCategory.append(payload.html)
})

itemChannel.join()
    .receive("ok", resp => { console.log("Joined successfully", resp) })
    .receive("error", resp => { console.log("Unable to join", resp) })

export default socket
