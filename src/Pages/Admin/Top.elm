module Pages.Admin.Top exposing (Model, Msg, page)

import Generated.Admin.Params as Params
import Html exposing (..)
import Html.Attributes exposing (class)
import Spa.Page
import Utils.Spa exposing (Page)


type alias Model =
    ()


type alias Msg =
    Never


page : Page Params.Top Model Msg model msg appMsg
page =
    Spa.Page.static
        { title = always "Admin Dashboard"
        , view = always view
        }



-- VIEW


view : Html Msg
view =
    div [ class "" ]
        [ h1 [ class "text-2xl" ] [ text "Just a simple admin interface" ]
        ]
