
let Agent = {
  init(socket, element) {
    socket.connect();
    let channel = socket.channel("agent:1", {})
    channel.join()
      .receive("ok", resp => { console.log("Joined successfully", resp) })
      .receive("error", resp => { console.log("Unable to join", resp) })

    channel.on("agent_info", (resp) => {
      element.innerHTML = resp.html;
    });

    let agent_selector = document.getElementById("object-selector");
    agent_selector.addEventListener("change", function(e) {
      channel.push("set_active_agent", { agent: agent_selector.value });
    });


    document.getElementById('move-up').addEventListener('click', (e) => {
      channel.push("move", { direction: "up" });
    });
    document.getElementById('move-down').addEventListener('click', (e) => {
      channel.push("move", { direction: "down" });
    });
    document.getElementById('move-left').addEventListener('click', (e) => {
      channel.push("move", { direction: "left" });
    });
    document.getElementById('move-right').addEventListener('click', (e) => {
      channel.push("move", { direction: "right" });
    });
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
