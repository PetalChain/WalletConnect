import { connect, disconnect, watchAccount } from '@wagmi/core'
import { config } from './wagmi'

let app = Elm.Main.init({
  node: document.getElementById('app')
})
let socket = new WebSocket('wss://echo.websocket.org');
app.ports.sendMessage.subscribe(async (message:string) => {
    let connector = config.connectors[0]
    await connect(config, { connector })
});

app.ports.disconnectMessage.subscribe(async (message:string) => {
  await disconnect(config)
  socket.send("disconnect")
});


watchAccount(config, {
  onChange(account) {
    if(account.chainId != undefined) {
      let res = 'Address: ' + (account.addresses ? JSON.stringify(account.addresses) : '') + " ChainId: " + account.chainId ?? '';
      socket.send(res);
    }
  },
})

socket.addEventListener("message", function(event) {
  if(!event.data.includes("Request"))
      app.ports.messageReceiver.send(event.data);
});