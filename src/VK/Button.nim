# author: Ethosa
import json


proc newTextButton*(label: string = "Saya button ^^",
               payload: string = "", color: string = "primary"): JsonNode =
    return %*{
        "color": color,
        "action": {
            "type": "text",
            "label": label,
            "payload": payload
        }
    }

proc newLocationButton*(payload: string = ""): JsonNode =
    return %*{
        "action": {
            "type": "location",
            "payload": payload
        }
    }

proc newVkPayButton*(payload: string = "", hash: string = ""): JsonNode =
    return %*{
        "action": {
            "type": "vkpay",
            "payload": payload,
            "hash": hash
        }
    }

proc newVkAppsButton*(app_id: int = 6232540, owner_id: int = -157525928,
                      payload: string = "", hash: string = "",
                      label: string = "Saya button ^^"): JsonNode =
    return %*{
        "action": {
            "type": "open_app",
            "app_id": app_id,
            "payload": payload,
            "owner_id": owner_id,
            "hash": hash,
            "label": label
        }
    }
