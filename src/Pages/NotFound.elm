module Pages.NotFound exposing (Flags, Model, Msg, page)

import Generated.Route as Route exposing (Route)
import Html exposing (a, div, h1, text)
import Html.Attributes as Attr
import Page exposing (Document, Page)


type alias Flags =
    ()


type alias Model =
    ()


type alias Msg =
    Never


page : Page Flags Model Msg
page =
    Page.static
        { view = view
        }



-- VIEW


view : Document Msg
view =
    { title = "404 Not Found"
    , body =
        [ div [ Attr.class "page" ]
            [ h1
                [ Attr.class "page__title" ]
                [ text "404 is life." ]
            , a
                [ Attr.class "page__link"
                , Attr.href (Route.toHref Route.Top)
                ]
                [ text "back home?" ]
            ]
        ]
    }
