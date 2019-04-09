let MyMessages = {
    init(socket){
        let channel = socket.channel('my_messages:lobby', {})
        channel.join()
        this.listenForMessages(channel)
        this.listenNotifications(channel)
        this.listenDeleteNotification(channel)
    },

    listenForMessages(channel){
        channel.on('new_message', payload => {
            if(!document.getElementById('notification'))
            {
                let msgList = document.querySelector('.list-link')
                let msgBlock = document.createElement('div')
                msgBlock.setAttribute("id", "notification")
                msgList.appendChild(msgBlock)
            }
        })
    },
    
    listenNotifications(channel){
        channel.on('deleted_messages', payload => {
            console.log("Usunięto wiadomość")
            let notificationWrapper = document.querySelector('#deleted-notification')
            let notification = document.createElement('div')
            notification.setAttribute("class", "alert alert-danger")
            notification.insertAdjacentHTML('beforeend', `Usunięto wiadomość`)
            notificationWrapper.appendChild(notification)
        })
    },
    
    listenDeleteNotification(channel){
        channel.on('delete_notification', payload => {
            let node = document.getElementById('notification');
            if (node.parentNode) {
                node.parentNode.removeChild(node);
            };
        })
    }
}

export default MyMessages