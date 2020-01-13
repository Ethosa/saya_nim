# author: Ethosa
import strformat
import json

import Button


type
    Keyboard* = object
        inline: bool
        one_time: bool
        buttons: JsonNode

proc `$`(k: Keyboard): string =
    return fmt"Keyboard one_time={k.one_time}, inline={k.inline}, buttons={k.buttons}"

proc addButton*(k: Keyboard, b: JsonNode) =
    ## Adds a new button to the current line, if possible.
    ## Arguments:
    ##     k {Keyboard} -- keyboard object
    ##     b {JsonNode} -- Button object
    if k.inline:
        if b["action"]["type"].str == "text":
            if len(k.buttons[len(k.buttons)-1]) < 3:
                k.buttons[len(k.buttons)-1].add(b)
        else:
            if len(k.buttons) < 3:
                k.buttons.add(%*[b])
    else:
        if b["action"]["type"].str == "text":
            if len(k.buttons[len(k.buttons)-1]) < 4:
                k.buttons[len(k.buttons)-1].add(b)
        else:
            if len(k.buttons) < 10:
                k.buttons.add(%*[b])

proc addLine*(k: Keyboard) =
    ## Adds a new line for the button, if possible.
    ##
    ## Arguments:
    ##     k {Keyboard} -- Keyboard object
    if k.inline:
        if len(k.buttons) < 3:
            k.buttons.add(%*[])
    else:
        if len(k.buttons) < 10:
            k.buttons.add(%*[])

proc compile*(k: Keyboard): JsonNode =
    ## Creates a string to send to the message.
    ##
    ## Arguments:
    ##     k {Keyboard} -- Keyboard object
    ##
    ## Returns:
    ##     string - compiled string
    var compiled = %*{
        "buttons": k.buttons,
        "one_time": k.one_time,
        "inline": k.inline
    }
    return compiled

proc newKeyboard*(one_time: bool = false, inline: bool = false): Keyboard =
    ## Creates a new Keyboard object for further work with it.
    ##
    ## Keyword Arguments:
    ##     one_time {bool} -- Hides the keyboard after the initial use. (default {false})
    ##     inline {bool} -- Shows the keyboard inside the message. (default {false})
    ##
    ## Returns:
    ##     Keyboard -- new Keyboard object
    return Keyboard(inline: inline, one_time: one_time, buttons: %*[[]])

proc newKeyboard*(other: Keyboard): Keyboard =
    ## Creates a new Keyboard object from other Keyboard object.
    ##
    ## Arguments:
    ##     other {Keyboard} -- other Keyboard object
    ##
    ## Returns:
    ##     Keyboard -- new Keyboard object
    return Keyboard(one_time: other.one_time, inline: other.inline, buttons: other.buttons.copy())
