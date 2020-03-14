module Layout exposing (view)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Generated.Routes as Routes exposing (Route, routes)
import Ui exposing (colors)
import Utils.Spa as Spa


view : Spa.LayoutContext msg -> Element msg
view { page, route } =
    column
        [ height fill
        , width fill
        , Font.family
            [ Font.external
                { url = "https://fonts.googleapis.com/css?family=Ubuntu:400,700&display=swap&subset=latin-ext"
                , name = "Ubuntu"
                }
            , Font.sansSerif
            ]
        ]
        [ viewHeader route
        , page
        ]


viewHeader : Route -> Element msg
viewHeader currentRoute =
    column
        [ centerX
        , paddingEach { top = 32, left = 16, right = 16, bottom = 0 }
        ]
        [ row
            [ centerX
            , Background.color colors.primary
            , Font.color colors.white
            ]
            [ viewLink currentRoute ( "Domov", routes.top )
            , viewLink currentRoute ( "O Kanti", routes.about )
            ]
        ]


viewLink : Route -> ( String, Route ) -> Element msg
viewLink currentRoute ( label, route ) =
    if currentRoute == route then
        el
            [ Font.size 16
            , Font.center
            , width (px 150)
            , padding 8
            , Background.color colors.secondary
            ]
            (text label)

    else
        link
            [ Font.size 16
            , Font.center
            , width (px 150)
            , padding 8
            , mouseOver [ alpha 0.5 ]
            ]
            { label = text label
            , url = Routes.toPath route
            }
