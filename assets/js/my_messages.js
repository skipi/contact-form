let MyMessages = {
    init(socket){
        let channel = socket.channel('my_messages:lobby', {})
        channel.join()
        this.listenForMessages(channel)
    },

    listenForMessages(channel){
        document.getElementById('message-form').addEventListener('submit', function(e){
            // e.preventDefault()
            channel.push('newmessage', {})
        })
        
        channel.on('newmessage', payload => {
            let test = document.querySelector('#test')
            let msgBlock = document.createElement('div')
            // msgBlock.style.backgroundColor = "red"

            msgBlock.insertAdjacentHTML('beforeend', `Nowa wiadomość`)
            test.appendChild(msgBlock)
        })
    }
}

export default MyMessages