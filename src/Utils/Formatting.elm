module Utils.Formatting exposing (..)

import Element as Element exposing (..)
import Time exposing (..)
import Utils.Api exposing (..)


formatDate : Time.Zone -> Posix -> String
formatDate zone posix =
    (toSloWeekDay <| Time.toWeekday zone posix)
        ++ ", "
        ++ (String.padLeft 2 '0' <| String.fromInt <| Time.toDay zone posix)
        ++ ". "
        ++ (toSloMonth <| Time.toMonth zone posix)
        ++ " "
        ++ (String.fromInt <| Time.toYear zone posix)


formatTime : Time.Zone -> Posix -> String
formatTime zone posix =
    (String.padLeft 2 '0' <| String.fromInt <| Time.toHour zone posix)
        ++ ":"
        ++ (String.padLeft 2 '0' <| String.fromInt <| Time.toMinute zone posix)
        ++ ":"
        ++ (String.padLeft 2 '0' <| String.fromInt <| Time.toSecond zone posix)



-- Stringy stuff


toSloWeekDay : Weekday -> String
toSloWeekDay weekday =
    case weekday of
        Mon ->
            "Ponedeljek"

        Tue ->
            "Torek"

        Wed ->
            "Sreda"

        Thu ->
            "Četrtek"

        Fri ->
            "Petek"

        Sat ->
            "Sobota"

        Sun ->
            "Nedelja"


toSloMonth : Month -> String
toSloMonth month =
    case month of
        Jan ->
            "januar"

        Feb ->
            "februar"

        Mar ->
            "marec"

        Apr ->
            "april"

        May ->
            "maj"

        Jun ->
            "junij"

        Jul ->
            "julij"

        Aug ->
            "avgust"

        Sep ->
            "september"

        Oct ->
            "oktober"

        Nov ->
            "november"

        Dec ->
            "december"


kantaToString : Barva -> String
kantaToString kanta =
    case kanta of
        Rumena ->
            "Rumena"

        Zelena ->
            "Zelena"

        Rjava ->
            "Rjava"

        Modra ->
            "Modra (rjava vrečka)"

        Rdeca ->
            "Rdeča"


kantaToColor : Barva -> Element.Color
kantaToColor kanta =
    case kanta of
        Rumena ->
            rgb255 240 240 0

        Zelena ->
            rgb255 45 136 45

        Rdeca ->
            rgb255 230 57 57

        Modra ->
            rgb255 30 50 255

        Rjava ->
            rgb255 125 80 10
