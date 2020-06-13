module Pages.About exposing (Flags, Model, Msg, page)

import Html exposing (..)
import Html.Attributes exposing (class)
import Page exposing (Document, Page)
import Ui exposing (..)


type alias Flags =
    ()


type alias Model =
    ()


type alias Msg =
    Never


page : Page Flags Model Msg
page =
    Page.static
        { view = view }



-- VIEW


view : Document Msg
view =
    { title = "About"
    , body =
        [ div [ class "bg-white overflow-hidden shadow rounded-lg" ]
            [ div [ class "px-4 py-5 sm:p-6 text-center" ]
                [ titleView "Kanta.Si" ""
                , p [] [ text "Za tiste dni ... ... ko pozabiš katero kanto pobirajo." ]
                ]
            ]
        ]
    }
