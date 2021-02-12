import {Socket, Presence} from "phoenix"
let Chat = {
    randomNumber() {
        return Math.floor(Math.random() * 10000000) ;
    },
      
    
    init()
    {
        //socket
        // debugger
        let user = this.randomNumber()
        let socket = new Socket("/socket", {params: {user: user}})
        
        socket.connect()

        //room
        let path = window.location.pathname.split('/')
        let room = path[path.length -1]
        let channel = socket.channel('chat:' + room, {})
        

        let presences = {}
        // let room = socket.channel("room:lobby", {})
        channel.on("presence_state", state => {
          presences = Presence.syncState(presences, state)
          render(presences)
        })

        channel.on("presence_diff", diff => {
          presences = Presence.syncDiff(presences, diff)
          render(presences)
        })
        channel.join()
        this.lsitenForChats(channel)
        // room.join()
        // Presence
        

        // let formatTimestamp = (timestamp) => {
        //   let date = new Date(timestamp)
        //   return date.toLocaleTimeString()
        // }
        // let listBy = (user, {metas: metas}) => {
        //   return {
        //     user: user,
        //     onlineAt: formatTimestamp(metas[0].online_at)
        //   }
        // }

        // let userList = document.getElementById("UserList")
        // let render = (presences) => {
        //   userList.innerHTML = Presence.list(presences, listBy)
        //     .map(presence => `
        //       <li>
        //         <b>${presence.user}</b>
        //         <br><small>online since ${presence.onlineAt}</small>
        //       </li>
        //     `)
        //     .join("")
        // }
        // Channels
        





        
        // .receive("ok", resp => {console.log("joined", resp)})
    },
    lsitenForChats(channel){

        function submitForm() {
            // let userName = document.getElementById("user-name").value
            let userMsg = document.getElementById("user-msg").value
            channel.push('shout', {body: userMsg})
            // document.getElementById('user-name').value = userName
            document.getElementById('user-msg').value = ''

        }
        channel.on('typing' ,
            console.log("typing")
        )
        channel.on('shout', payload => {
            let chatBox = document.querySelector("#chat-box")
            let msgBlock = document.createElement("p")
            msgBlock.insertAdjacentHTML("beforeend",`${payload.body}`)
            chatBox.appendChild(msgBlock)
        })

        document.getElementById('chat-form').addEventListener('submit', function(e) {
            e.preventDefault()
            submitForm()
        } )
    }
}
export default Chat