import saya

var vk = newVk("your token here")

var response = vk.callMethod("messages.send", ("message", "Saya test..."),
    ("random_id", "21242"), ("peer_id", "2000000035"))

echo(response["response"])

for event in vk.longpoll.listen():
    echo(event)
