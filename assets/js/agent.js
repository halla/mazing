
let Agent = {
  init(socket, element) {
    socket.connect();
    let channel = socket.channel("agent:1", {})
    channel.join()
      .receive("ok", resp => { console.log("Joined successfully", resp) })
      .receive("error", resp => { console.log("Unable to join", resp) })

    document.onkeydown = function(e) {
      switch(e.which) {
        case 37: // left
        channel.push("move", { direction: "left" });
        break;

        case 38: // up
        channel.push("move", { direction: "up" });
        break;

        case 39: // right
        channel.push("move", { direction: "right" });
        break;

        case 40: // down
        channel.push("move", { direction: "down" });
        break;

        default: return; // exit this handler for other keys
      }
      e.preventDefault(); //
    }
  }
}

export default Agent
