module Components exposing (layout, showSidebar)

import Browser exposing (Document)
import Generated.Route as Route exposing (Route, toHref)
import Html exposing (..)
import Html.Attributes exposing (class, href, style, tabindex)
import Ui


layout :
    { page : Document msg
    , route : Route
    , isTransitioning : Bool
    }
    -> Document msg
layout { page, route, isTransitioning } =
    let
        _ =
            Debug.log "Route" (Route.toHref route)
    in
    { title = page.title
    , body =
        [ header route
        , div
            [ class "transition-opacity duration-300 ease-in-out"
            , if showSidebar route then
                class "opacity-100"

              else if isTransitioning then
                class "opacity-0"

              else
                class "opacity-100"
            ]
            [ div [ class "flex overflow-hidden bg-gray-100" ]
                [ if showSidebar route then
                    Ui.sidebar route

                  else
                    div [] []
                , div [ class "flex flex-col w-0 flex-1 overflow-hidden" ]
                    [ div [ class "flex-1 relative z-0 overflow-y-auto pt-2 pb-6 focus:outline-none md:py-6", tabindex 0 ]
                        [ div [ class "max-w-7xl mx-auto px-4 sm:px-6 lg:px-8" ]
                            page.body
                        ]
                    ]
                ]
            ]
        , footer
        ]
    }


header : Route -> Html msg
header route =
    Html.header []
        [ navbar route
        ]


navbar : Route -> Html msg
navbar currentRoute =
    Html.header
        [ class "bg-white overflow-hidden shadow rounded-lg text-center" ]
        [ div [ class "inline-block my-4" ]
            [ nav [ class "flex" ]
                [ viewLink currentRoute ( "Domov", Route.Top )
                , viewLink currentRoute ( "O Kanti", Route.About )
                , viewLink currentRoute ( "Admin", Route.Admin_Top )
                ]
            ]
        ]


footer : Html msg
footer =
    Html.footer [] []


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
            , href (Route.toHref route)
            ]
            [ text label ]


highlightLink : Route -> Route -> Bool
highlightLink route current =
    let
        sr =
            Route.toHref route

        sc =
            Route.toHref current
    in
    sr == sc || String.startsWith sr sc && sr /= "/"


isTopRoute : Route -> Bool
isTopRoute route =
    route == Route.Top


showSidebar : Route -> Bool
showSidebar route =
    case route of
        Route.Top ->
            False

        Route.About ->
            False

        _ ->
            True
