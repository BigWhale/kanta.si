module Ui exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, href, id)
import Html.Events exposing (onClick)
import Time
import Utils.Api exposing (Location, Pickup, TrashType)
import Utils.Formatting exposing (..)



-- BUTTONS


type ButtonType
    = Edit Int
    | Cancel Int
    | Delete Int
    | Save Int


type InputType
    = Street Int
    | StreetNo Int
    | City Int


getButtonId : ButtonType -> Int
getButtonId btype =
    case btype of
        Edit val ->
            val

        Cancel val ->
            val

        Delete val ->
            val

        Save val ->
            val


buttonDebugString : ButtonType -> String
buttonDebugString btype =
    case btype of
        Edit val ->
            "Edit: " ++ String.fromInt val

        Cancel val ->
            "Cancel: " ++ String.fromInt val

        Delete val ->
            "Delete: " ++ String.fromInt val

        Save val ->
            "Save: " ++ String.fromInt val


inputDebugString : InputType -> String
inputDebugString itype =
    case itype of
        Street id ->
            "Street " ++ String.fromInt id

        StreetNo id ->
            "StreetNo " ++ String.fromInt id

        City id ->
            "City " ++ String.fromInt id


type ButtonSize
    = XL
    | L
    | M
    | S
    | XS


buttonSize : ButtonSize -> String
buttonSize s =
    case s of
        XL ->
            "px-6 py-3 leading-6"

        L ->
            "px-4 py-2 leading-6"

        M ->
            "px-4 py-2 leading-5"

        S ->
            "px-3 py-2 leading-4"

        XS ->
            "px-2.5 py-1.5 leading-4"


titleView : String -> String -> Html msg
titleView title classes =
    h1
        [ class "text-3xl"
        , class classes
        ]
        [ text title ]


dateTimeView : Time.Zone -> Time.Posix -> Html msg
dateTimeView zone time =
    div [ class "text-xl" ]
        [ if Time.posixToMillis time > 0 then
            text <| formatDate zone time

          else
            text "Preračunavam ..."
        ]


linkButton : String -> String -> Html msg
linkButton label url =
    span [ class "inline-flex rounded-mv shadow-sm" ]
        [ a
            [ class "inline-flex items-center px-2.5 py-1.5 border border-transparent text-xs leading-4"
            , class "font-medium rounded text-white bg-green-600 hover:bg-green-500 focus:outline-none"
            , class "focus:border-green-700 focus:shadow-outline-green active:bg-green-700 transition"
            , class "ease-in-out duration-150"
            , href url
            ]
            [ text label ]
        ]


clickButton : ButtonSize -> String -> msg -> Html msg
clickButton size label toMsg =
    span [ class "inline-flex rounded-mv shadow-sm" ]
        [ button
            [ class "inline-flex items-center border border-transparent text-xs font-medium rounded"
            , class "text-white bg-green-600 hover:bg-green-500"
            , class "focus:outline-none focus:border-green-700 focus:shadow-outline-green active:bg-green-700"
            , class "transition ease-in-out duration-150"
            , class (buttonSize size)
            , onClick toMsg
            ]
            [ text label ]
        ]


clickButtonId : ButtonSize -> String -> ButtonType -> (ButtonType -> msg) -> Html msg
clickButtonId size label butType toMsg =
    span [ class "inline-flex rounded-mv shadow-sm text-center px-2" ]
        [ button
            [ id (String.fromInt (getButtonId butType))
            , class "inline-flex items-center border border-transparent text-xs font-medium rounded"
            , class "text-white bg-green-600 hover:bg-green-500 justify-center"
            , class "focus:outline-none focus:border-green-700 focus:shadow-outline-green active:bg-green-700"
            , class "transition ease-in-out duration-150 w-16"
            , class (buttonSize size)
            , onClick (toMsg butType)
            ]
            [ text label ]
        ]


showPickup : Pickup -> Html msg
showPickup pickup =
    let
        header =
            div [ class "flex justify-between border-b border-black mx-auto mb-4 text-2xl" ]
                [ div [ class "w-1/2 text-2xl" ] [ text "Odpadki" ]
                , div [ class "w-1/2 text-2xl " ] [ text "Kanta" ]
                ]

        trashRow : TrashType -> Html msg
        trashRow trash =
            div [ class "flex justify-between align-center mx-auto mb-4" ]
                [ div
                    [ class "w-1/2 px-8 py-4 text-xl md:text-3xl font-bold flex items-center justify-center"
                    , class (kantaToClassBg trash.color)
                    ]
                    [ text trash.type_ ]
                , div
                    [ class "w-1/2 px-8 py-4 text-xl md:text-3xl font-bold flex items-center justify-center"
                    , class (kantaToClassCol trash.color)
                    ]
                    [ text (kantaToString trash.color) ]
                ]

        trashTable =
            div [] <|
                List.map trashRow pickup.trash
    in
    div []
        [ header
        , trashTable
        ]


showNextPickup : Time.Zone -> Pickup -> Html msg
showNextPickup zone pickup =
    div [ class "mt-12" ]
        [ div [ class "mb-12" ] [ dateTimeView zone pickup.date ]
        , showPickup pickup
        ]



-- EDIT HELPERS


updateLocationRecord : Int -> String -> InputType -> List Location -> List Location
updateLocationRecord id value intype locations =
    let
        replaceData item =
            if item.id == id then
                case intype of
                    Street v ->
                        { item | street = value }

                    StreetNo v ->
                        { item | street_no = value }

                    City v ->
                        { item | city = value }

            else
                item
    in
    List.map replaceData locations


deleteLocationRecord : Int -> List Location -> List Location
deleteLocationRecord id list =
    List.filter (\i -> i.id /= id) list
