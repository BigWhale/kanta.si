module Pages.Admin.Top exposing (Flags, Model, Msg, page)

import Generated.Route as Route exposing (Route, toHref)
import Global
import Html exposing (..)
import Html.Attributes exposing (class, href, tabindex)
import Page exposing (Document, Page)
import Ui


type alias Flags =
    ()


type alias Model =
    { transition : Bool }


type Msg
    = NoOp


page : Page Flags Model Msg
page =
    Page.component
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


init : Global.Model -> Flags -> ( Model, Cmd Msg, Cmd Global.Msg )
init global flags =
    ( { transition = True }, Cmd.none, Cmd.none )


update : Global.Model -> Msg -> Model -> ( Model, Cmd Msg, Cmd Global.Msg )
update global msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none, Cmd.none )


subscriptions : Global.Model -> Model -> Sub Msg
subscriptions global model =
    Sub.none



-- VIEW


view : Global.Model -> Model -> Document Msg
view global model =
    { title = "Admin Dashboard"
    , body =
        [ div [ class "max-w-7xl mx-auto px-4 sm:px-6 lg:px-8" ]
            [ h1 [ class "text-2xl font-semibold text-gray-900" ] [ text "Dashboard" ]
            ]
        ]
    }
