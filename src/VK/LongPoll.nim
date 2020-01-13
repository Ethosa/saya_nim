# author: Ethosa

import httpclient
import strformat
import strutils
import json


type
    LongPoll* = object
        session: HttpClient
        group_id*: int
        access_token: string
        api: string

proc getServer(l: LongPoll, url: string): seq[string] =
    var
        response: JsonNode = parseJson(l.session.getContent(url))["response"]
        server: string = response["server"].str
        key: string = response["key"].str
        ts: string = response["ts"].str
    return @[server, key, ts]

proc newLongPoll*(client: HttpClient, access_token: string, v: string = "5.103",
                  group_id: int = 0): LongPoll =
    ## Creating a New Longpoll object
    ##
    ## Arguments:
    ##     client {HttpClient} -- HTTP client to access the server
    ##     access_token {string} -- token. Without it, the server will return an error
    ##
    ## Keyword Arguments:
    ##     v {string} -- API version (default: {"5.103"})
    ##     group_id {int} -- Id group. It is necessary only if the token from the group (default: {0})
    ##
    ## Returns:
    ##     LongPoll -- new LongPoll object

    return LongPoll(session: client, group_id: group_id, access_token: access_token, api: v)

iterator listen*(l: LongPoll, wait: int8 = 25): JsonNode =
    ## Start listening for events from the server
    var
        start_server_url: string =
            if l.group_id == 0:
                fmt"https://api.vk.com/method/messages.getLongPollServer?access_token={l.access_token}&v={l.api}"
            else:
                fmt"https://api.vk.com/method/groups.getLongPollServer?access_token={l.access_token}&v={l.api}&group_id={l.group_id}"
        for_server: string =
            if l.group_id == 0:
                "https://$#?act=a_check&key=$#&ts=$#&wait=25&mode=202&version=3"
            else:
                "$#?act=a_check&key=$#&ts=$#&wait=25"
        s: seq[string] = l.getServer(start_server_url)

    while true:
        var
            url: string = for_server % s
            answer: JsonNode = parseJson(l.session.getContent(url))

        if not answer.hasKey("ts"):
            s = l.getServer(start_server_url)

        s[2] = answer["ts"].str
        var updates: JsonNode = answer["updates"]

        for item in updates.items:
            yield item
