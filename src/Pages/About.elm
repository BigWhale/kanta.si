module Pages.About exposing (Model, Msg, page)

import Element exposing (..)
import Generated.Params as Params
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


view : Element Msg
view =
    column [ centerX ]
        [ titleView "O Kanti" ]
