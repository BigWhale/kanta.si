module Pages.About exposing (Model, Msg, page)

import Generated.Params as Params
import Html exposing (..)
import Html.Attributes exposing (class)
import Spa.Page
import Ui exposing (..)
import Utils.Spa exposing (Page)


type alias Model =
    ()


type alias Msg =
    Never


page : Page Params.About Model Msg model msg appMsg
page =
    Spa.Page.static
        { title = always "O Kanti"
        , view = always view
        }



-- VIEW


view : Html Msg
view =
    div [ class "bg-white overflow-hidden shadow rounded-lg" ]
        [ div [ class "px-4 py-5 sm:p-6 text-center" ]
            [ titleView "Kanta.Si" ""
            , p [] [ text "Za tiste dni ... ... ko pozabiš katero kanto pobirajo." ]
            ]
        ]
