# author: Ethosa

import httpclient
import strutils
import typetraits
import strformat
import json
export json

import LongPoll
export LongPoll


type
    Vk* = object
        access_token: string
        api: string
        session*: HttpClient
        longpoll*: LongPoll

proc callMethod*(vk: Vk, method_name: string, params: JsonNode): JsonNode =
    ## Call any existing VK Api method
    ##
    ## Arguments:
    ##     vk {Vk} -- vk object
    ##     method_name {string}
    ##     params {JsonNode} -- parameters for method
    ##
    ## Returns:
    ##     JsonNode -- response after calling method

    var url = fmt"https://api.vk.com/method/{method_name}?access_token={vk.access_token}&v={vk.api}"

    for i in params.pairs:
        try:
            url &= fmt"&{i[0]}={i[1].str}"
        except:
            url &= fmt"&{i[0]}={i[1]}"
    echo(url)

    var response: JsonNode = parseJson(vk.session.postContent(url.replace(" ", "+")))
    return response


proc newVk*(token: string, api_version: string = "5.103", group_id: int = 0): Vk =
    ## create new Vk object
    ##
    ## Arguments:
    ##     token {string} -- Access token. Without it, the server will return an error
    ##
    ## Keyword Arguments:
    ##     api_version {string} -- API version (default: {"5.103"})
    ##     group_id {int} -- Id group. It is necessary only if the token from the group (default: {0})
    ##
    ## Returns:
    ##     Vk -- new Vk object

    var
        session: HttpClient = newHttpClient()
        vk: Vk = Vk(access_token: token, api: api_version, session: session,
                    longpoll: newLongPoll(session, token, api_version, group_id))
    return vk
