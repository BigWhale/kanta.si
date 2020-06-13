module Pages.Admin.Dynamic exposing (Flags, Model, Msg, page)

import AdminUi exposing (viewLocations)
import Html exposing (..)
import Http
import Page exposing (Document, Page)
import Ui
import Utils.Api as Api


type alias Flags =
    { param1 : String }


page : Page Flags Model Msg
page =
    Page.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- INIT


type alias Model =
    { slug : String
    , editId : Int
    , locations : List Api.Location
    }


init : Flags -> ( Model, Cmd Msg )
init { param1 } =
    ( { slug = param1
      , editId = 0
      , locations = []
      }
    , case param1 of
        "locations" ->
            Api.getLocations GotLocations

        _ ->
            Cmd.none
    )



-- UPDATE


type Msg
    = GotLocations (Result Http.Error (List Api.Location))
    | UpdateDone (Result Http.Error Api.Location)
    | DeleteDone (Result Http.Error Int)
    | ButtonClicked Ui.ButtonType
    | ValueChanged Ui.InputType String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotLocations (Ok response) ->
            ( { model | locations = response }, Cmd.none )

        GotLocations (Err _) ->
            ( model, Cmd.none )

        UpdateDone (Ok response) ->
            let
                _ =
                    Debug.log "Resp" response
            in
            ( { model | editId = 0 }, Cmd.none )

        UpdateDone (Err _) ->
            ( model, Cmd.none )

        DeleteDone (Ok id) ->
            let
                _ =
                    Debug.log "Deleted ID" id

                items =
                    Ui.deleteLocationRecord id model.locations
            in
            ( { model | locations = items }, Cmd.none )

        DeleteDone (Err _) ->
            ( model, Cmd.none )

        ButtonClicked button ->
            let
                _ =
                    Debug.log "Button Clicked" (Ui.buttonDebugString button)
            in
            case button of
                Ui.Cancel _ ->
                    ( { model | editId = 0 }, Cmd.none )

                Ui.Edit id ->
                    ( { model | editId = id }, Cmd.none )

                Ui.Delete id ->
                    ( model, Api.deleteLocation id DeleteDone )

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
                            ( model, Api.updateLocation id location UpdateDone )

                        Nothing ->
                            ( model, Cmd.none )

        ValueChanged field val ->
            let
                _ =
                    Debug.log "Value changed" (Ui.inputDebugString field ++ " to '" ++ val ++ "'")
            in
            case field of
                Ui.Street id ->
                    ( { model | locations = Ui.updateLocationRecord id val (Ui.Street id) model.locations }, Cmd.none )

                Ui.StreetNo id ->
                    ( { model | locations = Ui.updateLocationRecord id val (Ui.StreetNo id) model.locations }, Cmd.none )

                Ui.City id ->
                    ( { model | locations = Ui.updateLocationRecord id val (Ui.City id) model.locations }, Cmd.none )



-- SUBSCRIPTIONS
--subscriptions model =


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> Document Msg
view model =
    { title = "Some title"
    , body =
        [ case model.slug of
            "locations" ->
                viewLocations model.locations model.editId ValueChanged ButtonClicked

            _ ->
                text ("Location " ++ model.slug ++ " isn't a valid location.")
        ]
    }
