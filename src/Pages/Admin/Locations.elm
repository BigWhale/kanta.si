module Pages.Admin.Locations exposing (Flags, Model, Msg, page)

import AdminUi exposing (viewLocations)
import Generated.Route as Route exposing (Route, toHref)
import Global
import Html exposing (..)
import Html.Attributes exposing (class, href, style, tabindex)
import Http
import Page exposing (Document, Page)
import Ui
import Utils.Api as Api


type alias Flags =
    ()


type alias Model =
    { editId : Int
    , locations : List Api.Location
    }


type Msg
    = NoOp
    | GotLocations (Result Http.Error (List Api.Location))
    | UpdateDone (Result Http.Error Api.Location)
    | DeleteDone (Result Http.Error Int)
    | ButtonClicked Ui.ButtonType
    | ValueChanged Ui.InputType String


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
    ( { editId = 0
      , locations = []
      }
    , Api.getLocations GotLocations
    , Cmd.none
    )


update : Global.Model -> Msg -> Model -> ( Model, Cmd Msg, Cmd Global.Msg )
update global msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none, Cmd.none )

        GotLocations (Ok response) ->
            ( { model | locations = response }, Cmd.none, Cmd.none )

        GotLocations (Err _) ->
            ( model, Cmd.none, Cmd.none )

        UpdateDone (Ok response) ->
            let
                _ =
                    Debug.log "Resp" response
            in
            ( { model | editId = 0 }, Cmd.none, Cmd.none )

        UpdateDone (Err _) ->
            ( model, Cmd.none, Cmd.none )

        DeleteDone (Ok id) ->
            let
                _ =
                    Debug.log "Deleted ID" id

                items =
                    Ui.deleteLocationRecord id model.locations
            in
            ( { model | locations = items }, Cmd.none, Cmd.none )

        DeleteDone (Err _) ->
            ( model, Cmd.none, Cmd.none )

        ButtonClicked button ->
            let
                _ =
                    Debug.log "Button Clicked" (Ui.buttonDebugString button)
            in
            case button of
                Ui.Cancel _ ->
                    ( { model | editId = 0 }, Cmd.none, Cmd.none )

                Ui.Edit id ->
                    ( { model | editId = id }, Cmd.none, Cmd.none )

                Ui.Delete id ->
                    ( model, Api.deleteLocation id DeleteDone, Cmd.none )

                Ui.Save id ->
                    let
                        item =
                            Api.getLocationItem id model.locations
                    in
                    case item of
                        Just location ->
                            let
                                _ =
                                    Debug.log "Got" location
                            in
                            ( model, Api.updateLocation id location UpdateDone, Cmd.none )

                        Nothing ->
                            ( model, Cmd.none, Cmd.none )

        ValueChanged field val ->
            let
                _ =
                    Debug.log "Value changed" (Ui.inputDebugString field ++ " to '" ++ val ++ "'")
            in
            case field of
                Ui.Street id ->
                    ( { model | locations = Ui.updateLocationRecord id val (Ui.Street id) model.locations }, Cmd.none, Cmd.none )

                Ui.StreetNo id ->
                    ( { model | locations = Ui.updateLocationRecord id val (Ui.StreetNo id) model.locations }, Cmd.none, Cmd.none )

                Ui.City id ->
                    ( { model | locations = Ui.updateLocationRecord id val (Ui.City id) model.locations }, Cmd.none, Cmd.none )


subscriptions : Global.Model -> Model -> Sub Msg
subscriptions global model =
    Sub.none


view : Global.Model -> Model -> Document Msg
view global model =
    { title = "Some title"
    , body =
        [ div [ class "max-w-7xl mx-auto px-4 sm:px-6 lg:px-8" ]
            [ viewLocations model.locations model.editId ValueChanged ButtonClicked
            ]
        ]
    }
