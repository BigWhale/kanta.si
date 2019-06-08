module Main exposing (main, view)

import Browser
import Html exposing (Html, div, h1, h2, h3, text)
import Html.Attributes exposing (..)
import Task
import Time exposing (..)
import Time.Extra exposing (..)


main : Program () Model Msg
main =
    Browser.element
        { init = \_ -> init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { calendar : List Day
    , time : Posix
    , zone : Time.Zone
    }


type alias Day =
    { day : Posix
    , kanta : List Kanta
    }


type Kanta
    = Rumena
    | Zelena
    | Rjava
    | Modra
    | Rdeca


init : ( Model, Cmd Msg )
init =
    ( { calendar =
            -- Well, this could be entered differently.
            [ { day = partsToPosix utc (Parts 2019 Jun 11 0 0 0 0), kanta = [ Rjava ] }
            , { day = partsToPosix utc (Parts 2019 Jun 17 0 0 0 0), kanta = [ Rumena, Rdeca ] }
            , { day = partsToPosix utc (Parts 2019 Jun 18 0 0 0 0), kanta = [ Rjava ] }
            , { day = partsToPosix utc (Parts 2019 Jun 24 0 0 0 0), kanta = [ Zelena ] }
            , { day = partsToPosix utc (Parts 2019 Jun 25 0 0 0 0), kanta = [ Rjava ] }
            , { day = partsToPosix utc (Parts 2019 Jul 1 0 0 0 0), kanta = [ Rumena ] }
            , { day = partsToPosix utc (Parts 2019 Jul 2 0 0 0 0), kanta = [ Rjava ] }
            , { day = partsToPosix utc (Parts 2019 Jul 9 0 0 0 0), kanta = [ Rjava ] }
            , { day = partsToPosix utc (Parts 2019 Jul 15 0 0 0 0), kanta = [ Rumena, Zelena ] }
            , { day = partsToPosix utc (Parts 2019 Jul 16 0 0 0 0), kanta = [ Rjava ] }
            , { day = partsToPosix utc (Parts 2019 Jul 22 0 0 0 0), kanta = [ Modra ] }
            , { day = partsToPosix utc (Parts 2019 Jul 23 0 0 0 0), kanta = [ Rjava ] }
            , { day = partsToPosix utc (Parts 2019 Jul 29 0 0 0 0), kanta = [ Rumena ] }
            , { day = partsToPosix utc (Parts 2019 Jul 30 0 0 0 0), kanta = [ Rjava ] }
            , { day = partsToPosix utc (Parts 2019 Aug 5 0 0 0 0), kanta = [ Zelena ] }
            , { day = partsToPosix utc (Parts 2019 Aug 6 0 0 0 0), kanta = [ Rjava ] }
            , { day = partsToPosix utc (Parts 2019 Aug 12 0 0 0 0), kanta = [ Rumena, Rdeca ] }
            , { day = partsToPosix utc (Parts 2019 Aug 13 0 0 0 0), kanta = [ Rjava ] }
            , { day = partsToPosix utc (Parts 2019 Aug 20 0 0 0 0), kanta = [ Rjava ] }
            , { day = partsToPosix utc (Parts 2019 Aug 26 0 0 0 0), kanta = [ Rumena, Zelena ] }
            , { day = partsToPosix utc (Parts 2019 Aug 27 0 0 0 0), kanta = [ Rjava ] }
            , { day = partsToPosix utc (Parts 2019 Sep 3 0 0 0 0), kanta = [ Rjava ] }
            , { day = partsToPosix utc (Parts 2019 Sep 9 0 0 0 0), kanta = [ Rumena ] }
            , { day = partsToPosix utc (Parts 2019 Sep 10 0 0 0 0), kanta = [ Rjava ] }
            , { day = partsToPosix utc (Parts 2019 Sep 16 0 0 0 0), kanta = [ Rumena, Modra ] }
            , { day = partsToPosix utc (Parts 2019 Sep 17 0 0 0 0), kanta = [ Rjava ] }
            , { day = partsToPosix utc (Parts 2019 Sep 23 0 0 0 0), kanta = [ Rumena ] }
            , { day = partsToPosix utc (Parts 2019 Sep 24 0 0 0 0), kanta = [ Rjava ] }
            , { day = partsToPosix utc (Parts 2019 Oct 1 0 0 0 0), kanta = [ Rjava ] }
            , { day = partsToPosix utc (Parts 2019 Jun 7 0 0 0 0), kanta = [ Rumena, Zelena, Rdeca ] }
            , { day = partsToPosix utc (Parts 2019 Oct 8 0 0 0 0), kanta = [ Rjava ] }
            , { day = partsToPosix utc (Parts 2019 Oct 15 0 0 0 0), kanta = [ Rjava ] }
            , { day = partsToPosix utc (Parts 2019 Oct 21 0 0 0 0), kanta = [ Rumena ] }
            , { day = partsToPosix utc (Parts 2019 Oct 22 0 0 0 0), kanta = [ Rjava ] }
            , { day = partsToPosix utc (Parts 2019 Oct 28 0 0 0 0), kanta = [ Zelena ] }
            , { day = partsToPosix utc (Parts 2019 Oct 29 0 0 0 0), kanta = [ Rjava ] }
            , { day = partsToPosix utc (Parts 2019 Nov 4 0 0 0 0), kanta = [ Rumena ] }
            , { day = partsToPosix utc (Parts 2019 Nov 5 0 0 0 0), kanta = [ Rjava ] }
            , { day = partsToPosix utc (Parts 2019 Nov 11 0 0 0 0), kanta = [ Modra ] }
            , { day = partsToPosix utc (Parts 2019 Nov 12 0 0 0 0), kanta = [ Rjava ] }
            , { day = partsToPosix utc (Parts 2019 Nov 18 0 0 0 0), kanta = [ Rumena, Zelena ] }
            , { day = partsToPosix utc (Parts 2019 Nov 19 0 0 0 0), kanta = [ Rjava ] }
            , { day = partsToPosix utc (Parts 2019 Nov 26 0 0 0 0), kanta = [ Rjava ] }
            , { day = partsToPosix utc (Parts 2019 Dec 2 0 0 0 0), kanta = [ Rumena, Rdeca ] }
            , { day = partsToPosix utc (Parts 2019 Dec 3 0 0 0 0), kanta = [ Rjava ] }
            , { day = partsToPosix utc (Parts 2019 Dec 9 0 0 0 0), kanta = [ Zelena ] }
            , { day = partsToPosix utc (Parts 2019 Dec 16 0 0 0 0), kanta = [ Rumena ] }
            , { day = partsToPosix utc (Parts 2019 Dec 17 0 0 0 0), kanta = [ Rjava ] }
            , { day = partsToPosix utc (Parts 2019 Dec 30 0 0 0 0), kanta = [ Rumena, Zelena ] }
            , { day = partsToPosix utc (Parts 2019 Dec 31 0 0 0 0), kanta = [ Rjava ] }
            ]
      , time = Time.millisToPosix 0
      , zone = Time.utc
      }
    , Task.perform Zone Time.here
    )



-- UPDATE


type Msg
    = Tick Posix
    | Zone Time.Zone


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick newTime ->
            ( { model | time = newTime }, Cmd.none )

        Zone zone ->
            ( { model | zone = zone }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every 1000 Tick



-- VIEW


kantaToString : Kanta -> String
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


kantaToOdpadek : Kanta -> String
kantaToOdpadek kanta =
    case kanta of
        Rumena ->
            "Embalaža"

        Zelena ->
            "Mešani odpadki"

        Rjava ->
            "Organski odpadki"

        Modra ->
            "Steklo"

        Rdeca ->
            "Papir"


kantaToColor : Kanta -> String
kantaToColor kanta =
    case kanta of
        Rumena ->
            "yellow-400"

        Zelena ->
            "green-700"

        Rjava ->
            "orange-900"

        Modra ->
            "blue-500"

        Rdeca ->
            "red-600"


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


formatDate : Time.Zone -> Posix -> String
formatDate zone posix =
    (toSloWeekDay <| Time.toWeekday zone posix)
        ++ ", "
        ++ (String.padLeft 2 '0' <| String.fromInt <| Time.toDay zone posix)
        ++ " "
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


kantaToHtml : Kanta -> Html Msg
kantaToHtml kanta =
    div [ class "h-12 mx-auto flex" ]
        [ div [ class "w-1/3" ]
            [ h2
                [ class "text-3xl"
                , class ("bg-" ++ kantaToColor kanta)
                ]
                [ text (kantaToOdpadek kanta) ]
            ]
        , div [ class "w-2/3" ]
            [ h2
                [ class "text-3xl"
                , class ("text-" ++ kantaToColor kanta)
                ]
                [ text (kantaToString kanta) ]
            ]
        ]


kateraKanta : Model -> String -> Bool -> Html Msg
kateraKanta model kdaj tomorrow =
    let
        day =
            if tomorrow then
                matchDay model.calendar (Time.Extra.floor Time.Extra.Day utc (Time.Extra.add Time.Extra.Day 1 model.zone model.time))

            else
                matchDay model.calendar (Time.Extra.floor Time.Extra.Day utc model.time)
    in
    case day of
        Nothing ->
            div [ class "container mt-8 mx-auto text-center" ]
                [ h2 [ class "text-2xl mb-8" ] [ text (kdaj ++ " ne pobirajo smeti.") ]
                ]

        Just foo ->
            div [ class "container mt-8 mx-auto text-center" ]
                [ h2 [ class "text-2xl mb-8" ] [ text (kdaj ++ " pobirajo:") ]
                , div [ class "border border-black p-2" ]
                    [ div [ class "flex text-2xl border-b mb-2 border-black " ]
                        [ div [ class "w-1/3" ] [ text "Odpadki" ]
                        , div [ class "w-2/3" ] [ text "Kanta" ]
                        ]
                    , div [] <|
                        List.map kantaToHtml foo.kanta
                    ]
                ]


matchDay : List Day -> Posix -> Maybe Day
matchDay list day =
    List.head (List.filter (\m -> m.day == day) list)


view model =
    div [ class "container mx-auto" ]
        [ h1 [ class "md:text-3xl text-center mt-8" ] [ text "Katero kanto bomo danes nastavljali?" ]
        , if Time.posixToMillis model.time > 0 then
            div [ class "mb-12" ]
                [ h3 [ class "text-2xl text-center" ]
                    [ text <| formatDate model.zone model.time
                    , text " - "
                    , text <| formatTime model.zone model.time
                    ]
                , kateraKanta model "Danes" False
                ]

          else
            h2 [ class "text-xl text-center" ]
                [ text "Preračunavam ..." ]
        , h1 [ class "text-4xl text-center pt-12" ] [ text "Katero pa JUTRI?" ]
        , if Time.posixToMillis model.time > 0 then
            div []
                [ kateraKanta model "Jutri" True
                ]

          else
            h2 [ class "text-xl text-center" ]
                [ text "Preračunavam ..." ]
        ]
