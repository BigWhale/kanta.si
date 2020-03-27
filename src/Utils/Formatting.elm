module Utils.Formatting exposing (..)

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


kantaToClassBg : Barva -> String
kantaToClassBg kanta =
    case kanta of
        Rumena ->
            "bg-rumena"

        Zelena ->
            "bg-zelena"

        Rdeca ->
            "bg-rdeca"

        Modra ->
            "bg-modra"

        Rjava ->
            "bg-rjava"


kantaToClassCol : Barva -> String
kantaToClassCol kanta =
    case kanta of
        Rumena ->
            "text-rumena"

        Zelena ->
            "text-zelena"

        Rdeca ->
            "text-rdeca"

        Modra ->
            "text-modra"

        Rjava ->
            "text-rjava"
