import saya_nim/src/saya

var vk = newVk("your token here", group_id=123123)

var
    kb: Keyboard = newKeyboard(true)
    button = newTextButton()
    button1 = newTextButton(color="negative", label="negative от слова nigga")
kb.addButton(button)
kb.addButton(button1)

var response = vk.callMethod("messages.send", %*{"message": "блинблятьб...",
    "random_id": 2124245, "peer_id": 2000000002, "keyboard": kb.compile()})

echo(response)

for event in vk.longpoll.listen():
    echo(event)
