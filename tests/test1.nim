import saya

var vk = newVk("your token here")

var response = vk.callMethod("messages.send", %*{"message": "блинблятьб...",
    "random_id": 2124245, "peer_id": 2000000002})

echo(response["response"])

for event in vk.longpoll.listen():
    echo(event)
