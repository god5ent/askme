import Rails from "@rails/ujs"

import * as ActiveStorage from "@rails/activestorage"
import "channels"

Rails.start()

ActiveStorage.start()

document.addEventListener('DOMContentLoaded', () => {
    const askButton = document.getElementById('ask-button')
    const askForm = document.getElementById('ask-form')

    askButton.addEventListener('click', (event) => {
        event.preventDefault()

        setTimeout(() => {
            const displayStyle = askForm.style.display === 'block' ? 'none' : 'block'
            askForm.style.display = displayStyle
        }, 300)
    })
})
