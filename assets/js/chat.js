let Chat = {
    randomNumber() {
        return Math.floor(Math.random() * 10000000) ;
    },
      
    init(socket){
        let path = window.location.pathname.split('/')
        let room = path[path.length -1]
        let channel = socket.channel('chat:' + room,  {"Id" :this.randomNumber()})
        channel.join()
        this.lsitenForChats(channel)
        // .receive("ok", resp => {console.log("joined", resp)})
    },
    lsitenForChats(channel){

        function submitForm() {
            let userName = document.getElementById("user-name").value
            let userMsg = document.getElementById("user-msg").value

            channel.push('shout', {name: userName, body: userMsg})

            document.getElementById('user-name').value = userName
            document.getElementById('user-msg').value = ''

        }
        channel.on('shout', payload => {
            let chatBox = document.querySelector("#chat-box")
            let msgBlock = document.createElement("p")
            msgBlock.insertAdjacentHTML("beforeend",`<b>${payload.name}:</b> ${payload.body} ` )
            chatBox.appendChild(msgBlock)
        })


        document.getElementById('chat-form').addEventListener('submit', function(e) {
            e.preventDefault()
            submitForm()
        } )
    }
}
export default Chat