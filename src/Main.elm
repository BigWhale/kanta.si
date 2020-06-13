module Main exposing (main)

import Browser exposing (Document)
import Browser.Navigation as Nav exposing (Key)
import Components
import Generated.Pages as Pages
import Generated.Route as Route exposing (Route)
import Global
import Html
import Process
import Task
import Url exposing (Url)


main : Program Flags Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = LinkClicked
        , onUrlChange = UrlChanged
        }




-- INIT


type alias Flags =
    ()


type alias Model =
    { key : Key
    , url : Url
    , isTransitioning : Bool
    , global : Global.Model
    , page : Pages.Model
    }


init : Flags -> Url -> Key -> ( Model, Cmd Msg )
init flags url key =
    let
        ( global, globalCmd ) =
            Global.init flags url key

        ( page, pageCmd, pageGlobalCmd ) =
            Pages.init (fromUrl url) global
    in
    ( Model key url False global page
    , Cmd.batch
        [ Cmd.map Global globalCmd
        , Cmd.map Global pageGlobalCmd
        , Cmd.map Page pageCmd
        ]
    )


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url
    | PageLoaded Url
    | Global Global.Msg
    | Page Pages.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked (Browser.Internal url) ->
            let
                cmdChange =
                    Global.updateUrl url
            in
            ( { model | url = url }
            , Cmd.batch
                [ Nav.pushUrl model.key (Url.toString url)
                , Cmd.map Global cmdChange
                ]
            )

        LinkClicked (Browser.External href) ->
            ( model
            , Nav.load href
            )

        UrlChanged url ->
            ( { model | isTransitioning = True }
            , if Components.showSidebar (Maybe.withDefault Route.NotFound (Route.fromUrl url)) then
                delay 0 (PageLoaded url)

              else
                delay 300 (PageLoaded url)
            )

        PageLoaded url ->
            let
                ( page, pageCmd, globalCmd ) =
                    Pages.init (fromUrl url) model.global
            in
            ( { model
                | isTransitioning = False
                , page = page
              }
            , Cmd.batch
                [ Cmd.map Page pageCmd
                , Cmd.map Global globalCmd
                ]
            )

        Global globalMsg ->
            let
                ( global, globalCmd ) =
                    Global.update globalMsg model.global
            in
            ( { model | global = global }
            , Cmd.map Global globalCmd
            )

        Page pageMsg ->
            let
                ( page, pageCmd, globalCmd ) =
                    Pages.update pageMsg model.page model.global
            in
            ( { model | page = page }
            , Cmd.batch
                [ Cmd.map Page pageCmd
                , Cmd.map Global globalCmd
                ]
            )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ model.global
            |> Global.subscriptions
            |> Sub.map Global
        , model.page
            |> (\page -> Pages.subscriptions page model.global)
            |> Sub.map Page
        ]


view : Model -> Browser.Document Msg
view model =
    let
        documentMap :
            (msg1 -> msg2)
            -> Document msg1
            -> Document msg2
        documentMap fn doc =
            { title = doc.title
            , body = List.map (Html.map fn) doc.body
            }
    in
    Global.view
        { url = model.url
        , page = Pages.view model.page model.global |> documentMap Page
        , global = model.global
        , toMsg = Global
        , isTransitioning = model.isTransitioning
        }


fromUrl : Url -> Route
fromUrl =
    Route.fromUrl >> Maybe.withDefault Route.NotFound


delay : Float -> msg -> Cmd msg
delay ms msg =
    Process.sleep ms
        |> Task.andThen (\_ -> Task.succeed msg)
        |> Task.perform identity
