module Ui exposing (..)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html.Attributes as Attr
import Time
import Utils.Api exposing (Pickup, TrashType)
import Utils.Formatting exposing (..)



-- Color definitions


colors :
    { primary : Element.Color
    , secondary : Element.Color
    , white : Element.Color
    , black : Element.Color
    }
colors =
    { primary = rgb255 45 136 45
    , secondary = rgb255 170 57 57
    , white = rgb255 255 255 255
    , black = rgb255 0 0 0
    }



-- Transition helper


transition : Int -> List String -> Attribute msg
transition duration properties =
    Element.htmlAttribute <|
        Attr.style
            "transition"
            (properties
                |> List.map (\prop -> prop ++ " " ++ String.fromInt duration ++ "ms ease-in-out")
                |> String.join ", "
            )



-- Generic example


hero : { title : String } -> Element msg
hero options =
    column
        [ centerX
        , paddingXY 16 75
        , spacing 24
        ]
        [ column [ spacing 14 ]
            [ el [ centerX, Font.size 48, Font.semiBold ] (text options.title)
            ]
        ]


titleView : String -> Element msg
titleView title =
    el
        [ paddingXY 48 24
        , Font.size 48
        ]
        (text title)


dateTimeView : Time.Zone -> Time.Posix -> Element msg
dateTimeView zone time =
    if Time.posixToMillis time > 0 then
        row []
            [ el
                [ Font.size 36
                ]
                (text <| formatDate zone time)
            ]

    else
        row []
            [ el [] (text "Preračunavam ...") ]


linkButton : ( String, String ) -> Element msg
linkButton ( label, url ) =
    link
        [ Background.color colors.white
        , Border.color colors.primary
        , Font.color colors.primary
        , Border.rounded 6
        , Border.width 2
        , Font.size 16
        , paddingXY 24 8
        , mouseOver
            [ Background.color colors.primary
            , Font.color colors.white
            ]
        , transition 300 [ "color", "background-color" ]
        ]
        { url = url, label = text label }


clickButton : ( String, Maybe msg ) -> Element msg
clickButton ( label, onpress ) =
    Input.button
        [ Background.color colors.white
        , Border.color colors.primary
        , Font.color colors.primary
        , Border.rounded 6
        , Border.width 2
        , Font.size 16
        , paddingXY 24 8
        , mouseOver
            [ Background.color colors.primary
            , Font.color colors.white
            ]
        , transition 300 [ "color", "background-color" ]
        ]
        { onPress = onpress, label = text label }


showPickup : Pickup -> Element msg
showPickup pickup =
    let
        header =
            column [ paddingXY 50 16, width fill ]
                [ row [ width fill, centerX ]
                    [ el
                        [ Font.center
                        , width fill
                        , paddingEach
                            { top = 8
                            , right = 24
                            , bottom = 8
                            , left = 16
                            }
                        , Border.color (rgb255 0 0 0)
                        , Border.widthEach
                            { top = 0
                            , right = 0
                            , bottom = 1
                            , left = 0
                            }
                        ]
                        (text "Odpadki")
                    , el
                        [ Font.center
                        , width fill
                        , paddingEach
                            { top = 8
                            , right = 16
                            , bottom = 8
                            , left = 24
                            }
                        , Border.color (rgb255 0 0 0)
                        , Border.widthEach
                            { top = 0
                            , right = 0
                            , bottom = 1
                            , left = 0
                            }
                        ]
                        (text "Kanta")
                    ]
                ]

        trashRow : TrashType -> Element msg
        trashRow trash =
            row [ paddingXY 0 8, width fill ]
                [ el
                    [ centerY
                    , Font.center
                    , width fill
                    , Background.color (kantaToColor trash.color)
                    , paddingEach
                        { top = 8
                        , right = 24
                        , bottom = 8
                        , left = 16
                        }
                    ]
                    (text trash.type_)
                , el
                    [ Font.center
                    , width fill
                    , Font.color (kantaToColor trash.color)
                    , paddingEach
                        { top = 8
                        , right = 16
                        , bottom = 8
                        , left = 24
                        }
                    ]
                    (text (kantaToString trash.color))
                ]

        trashTable =
            column [ width fill, paddingXY 50 8 ] <|
                List.map trashRow pickup.trash
    in
    column
        [ Font.size 42
        , width fill
        , centerX
        ]
        [ header
        , trashTable
        ]


showNextPickup : Time.Zone -> Pickup -> Element msg
showNextPickup zone pickup =
    column
        [ width fill
        , centerX
        ]
        [ row [ centerX ] [ dateTimeView zone pickup.date ]
        , showPickup pickup
        ]
