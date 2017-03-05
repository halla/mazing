
let Maze = {

  init(socket, element) {
    let channel = socket.channel("maze:1", {})
    channel.join()
      .receive("ok", resp => { console.log("Joined successfully", resp) })
      .receive("error", resp => { console.log("Unable to join", resp) })

    let btn = document.getElementById("maze-me");
    btn.addEventListener("click", function(e) {
      let generator_selector = document.getElementById("generator-selector");
      channel.push("maze-me", { generator: generator_selector.value });
    });

    let bindCellListener = function () {
      let cells = document.querySelectorAll('.cell-inner')

      cells.forEach.call(cells, function (c) {
        c.addEventListener("click", function(e) {
          channel.push("set-start-cell", c.dataset.cell)
        })

      });
    };
    
    socket.connect();
    channel.on("new_maze", (resp) => {
      element.innerHTML = resp.html;
      bindCellListener()
    });
    bindCellListener();

  }
}

export default Maze
