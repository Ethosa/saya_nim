# author: Ethosa

import httpclient
import strformat
import json
export json


type
    Vk* = object
        access_token: string
        api: string
        session*: HttpClient

proc callMethod*(vk: Vk, method_name: string, params: varargs[(string, string)]): JsonNode =
    var url = fmt"https://api.vk.com/method/{method_name}?access_token={vk.access_token}&v={vk.api}"

    for i in 0..<params.len:
        url &= fmt"&{params[i][0]}={params[i][1]}"

    var response: JsonNode = parseJson(vk.session.postContent(url))
    return response

proc newVk*(token: string, api_version: string = "5.103"): Vk =
    var vk: Vk = Vk(access_token: token, api: api_version, session: newHttpClient())
    return vk
