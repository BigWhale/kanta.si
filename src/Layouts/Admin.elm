module Layouts.Admin exposing (view)

import Generated.Routes as Routes exposing (Route, routes)
import Html exposing (..)
import Html.Attributes exposing (class, href)
import Utils.Spa as Spa


view : Spa.LayoutContext msg -> Html msg
view { page, route } =
    div [ class "flex" ]
        [ viewSidebar route
        , div
            [ class "relative z-10 w-full"
            , class "bg-white rounded-r-md shadow px-2 py-4"
            ]
            [ page ]
        ]


viewSidebar : Route -> Html msg
viewSidebar route =
    div [ class "hidden md:flex md:flex-shrink-0" ]
        [ div [ class "flex flex-col w-64 bg-primary-50 pt-5 pb-4 rounded-l-md shadow" ]
            [ div [ class "mt-5 h-0 flex-1 flex flex-col overflow-y-auto" ]
                [ viewLinks route
                    [ ( "Dashboard", routes.admin_top )
                    , ( "Locations", routes.admin_dynamic "locations" )
                    , ( "Pickups", routes.admin_dynamic "pickups" )
                    , ( "Trash types", routes.admin_dynamic "trash" )
                    ]
                ]
            ]
        ]


viewLinks : Route -> List ( String, Route ) -> Html msg
viewLinks route links =
    nav [ class "flex-1 px-4 bg-primary-50" ]
        (List.map (viewLink route) links)


viewLink : Route -> ( String, Route ) -> Html msg
viewLink activeroute ( label, route ) =
    a
        [ class "group flex items-center px-4 py-2 text-sm leading-5 font-medium"
        , class "rounded-md focus:outline-none focus:bg-primary-400 hover:bg-primary-400"
        , class "transition ease-in-out duration-150"
        , if activeroute == route then
            class "bg-primary text-black"

          else
            class "text-black"
        , href (Routes.toPath route)
        ]
        [ text label ]
