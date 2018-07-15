import $ from "jquery"
import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken}})

socket.connect()

let itemChannel = socket.channel("item", {})

let expand = $(".expand")

expand.one( "click", function(event) {
    let clickedDiv = $(".expand#" + event.target.id)
    if (clickedDiv.hasClass("expand")) {
        itemChannel.push('images', {category: event.target.id})
    }
})

itemChannel.on('item_response', payload => {
    let currentCategory = $(".expand#" + payload.category)
    currentCategory.empty()
currentCategory.replaceWith(payload.html)
})

itemChannel.join()
    .receive("ok", resp => { console.log("Joined successfully", resp) })
.receive("error", resp => { console.log("Unable to join", resp) })

export default socket
