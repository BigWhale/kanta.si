module Layout exposing (view)

import Generated.Routes as Routes exposing (Route, routes)
import Html exposing (..)
import Html.Attributes exposing (class, href)
import Utils.Spa as Spa


view : Spa.LayoutContext msg -> Html msg
view { page, route } =
    div [ class "app bg-gray-100 h-screen" ]
        [ div [ class "container mx-auto px-4 sm:px-6 lg:px-8 pt-8" ]
            [ viewHeader route
            , page
            ]
        ]


highlightLink : Route -> Route -> Bool
highlightLink route current =
    let
        sr =
            Routes.toPath route

        sc =
            Routes.toPath current
    in
    sr == sc || String.startsWith sr sc && sr /= "/"


viewHeader : Route -> Html msg
viewHeader currentRoute =
    header
        [ class "bg-white overflow-hidden shadow rounded-lg mb-8 text-center" ]
        [ div [ class "inline-block my-4" ]
            [ nav [ class "flex" ]
                [ viewLink currentRoute ( "Domov", routes.top )
                , viewLink currentRoute ( "O Kanti", routes.about )
                , viewLink currentRoute ( "Admin", routes.admin_top )
                ]
            ]
        ]


viewLink : Route -> ( String, Route ) -> Html msg
viewLink currentRoute ( label, route ) =
    if highlightLink route currentRoute then
        div
            [ class "ml-4 px-3 py-2 font-medium text-sm leading-5 rounded-md text-primary-700"
            , class "bg-primary-100 focus:outline-none focus:text-primary-800 focus:bg-primary-200"
            ]
            [ text label ]

    else
        a
            [ class "ml-4 px-3 py-2 font-medium text-sm leading-5 rounded-md text-gray-500 hover:text-gray-700"
            , class "focus:outline-none focus:text-green-600 focus:bg-primary-50"
            , href (Routes.toPath route)
            ]
            [ text label ]
