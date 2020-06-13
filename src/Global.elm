module Global exposing
    ( Flags
    , Model
    , Msg
    , init
    , navigate
    , subscriptions
    , update
    , updateUrl
    , view
    )

import Browser exposing (Document)
import Browser.Navigation as Nav
import Components
import Generated.Route as Route exposing (Route)
import Task
import Url exposing (Url)



-- INIT


type alias Flags =
    ()


type alias Model =
    { flags : Flags
    , url : Url
    , key : Nav.Key
    }


init : Flags -> Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    ( Model
        flags
        url
        key
    , Cmd.none
    )



-- UPDATE


type Msg
    = Navigate Route
    | ChangeUrl Url


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Navigate route ->
            let
                _ =
                    Debug.log "Route" Route.toHref route
            in
            ( model
            , Nav.pushUrl model.key (Route.toHref route)
            )

        ChangeUrl url ->
            ( { model | url = url }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view :
    { url : Url
    , page : Document msg
    , global : Model
    , toMsg : Msg -> msg
    , isTransitioning : Bool
    }
    -> Document msg
view { url, page, global, toMsg, isTransitioning } =
    Components.layout
        { page = page
        , route = Maybe.withDefault Route.NotFound (Route.fromUrl url)
        , isTransitioning = isTransitioning
        }



-- COMMANDS


send : msg -> Cmd msg
send =
    Task.succeed >> Task.perform identity


navigate : Route -> Cmd Msg
navigate route =
    send (Navigate route)


updateUrl : Url -> Cmd Msg
updateUrl url =
    send (ChangeUrl url)
