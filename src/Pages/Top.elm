module Pages.Top exposing (Model, Msg, page)

import Generated.Params as Params
import Html exposing (..)
import Html.Attributes exposing (class)
import Http
import Spa.Page
import Task
import Time
import Ui exposing (..)
import Utils.Api exposing (Location, Pickup, TrashType, getLocation, getNext, getToday, getTomorrow, isActive)
import Utils.Spa exposing (Page)



-- MODEL


type alias Model =
    { time : Time.Posix
    , zone : Time.Zone
    , today : Pickup
    , tomorrow : Pickup
    , next : Pickup
    , location : Location
    , status : Status
    }


type Status
    = Loading
    | Loaded
    | Errored String


initialModel : Model
initialModel =
    { time = Time.millisToPosix 0
    , zone = Time.utc
    , today =
        { id = 0
        , location = 0
        , date = Time.millisToPosix 0
        , trash = []
        }
    , tomorrow =
        { id = 0
        , location = 0
        , date = Time.millisToPosix 0
        , trash = []
        }
    , next =
        { id = 0
        , location = 0
        , date = Time.millisToPosix 0
        , trash = []
        }
    , location = { id = 0, street = "", street_no = "", city = "" }
    , status = Loading
    }


page : Page Params.Top Model Msg model msg appMsg
page =
    Spa.Page.element
        { title = always "Kanta.Si"
        , init = always init
        , update = always update
        , view = always view
        , subscriptions = always subscriptions
        }



-- INIT


init : Params.Top -> ( Model, Cmd Msg )
init _ =
    ( initialModel
    , Cmd.batch
        [ Task.perform AdjustTimeZone Time.here
        , getToday GotToday
        , getTomorrow GotTomorrow
        , getLocation 1 GotLocation
        ]
    )



-- UPDATE


type Msg
    = Tick Time.Posix
    | AdjustTimeZone Time.Zone
    | GotToday (Result Http.Error Pickup)
    | GotTomorrow (Result Http.Error Pickup)
    | GotNext (Result Http.Error Pickup)
    | GotLocation (Result Http.Error Location)
    | ButtonClick


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick newTime ->
            ( { model | time = newTime }, Cmd.none )

        AdjustTimeZone newZone ->
            ( { model | zone = newZone }, Cmd.none )

        GotToday (Ok response) ->
            ( { model | today = response, status = Loaded }, Cmd.none )

        GotToday (Err _) ->
            ( { model | status = Errored "Whoops!" }, Cmd.none )

        GotTomorrow (Ok response) ->
            ( { model | tomorrow = response, status = Loaded }, Cmd.none )

        GotTomorrow (Err _) ->
            ( { model | status = Errored "Whoops!" }, Cmd.none )

        GotNext (Ok response) ->
            ( { model | next = response, status = Loaded }, Cmd.none )

        GotNext (Err _) ->
            ( { model | status = Errored "Whoops!" }, Cmd.none )

        GotLocation (Ok response) ->
            ( { model | location = response, status = Loaded }, Cmd.none )

        GotLocation (Err _) ->
            ( { model | status = Errored "Whoops!" }, Cmd.none )

        ButtonClick ->
            ( model, getNext GotNext )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Time.every 1000 Tick



-- VIEW


view : Model -> Html Msg
view model =
    main_ [ class "bg-white overflow-hidden shadow rounded-lg" ]
        [ div [ class "px-4 py-5 sm:p-6 flex flex-col justify-center text-center" ]
            [ titleView "Katero kanto bomo danes?" ""
            , div [ class "mb-12" ] [ dateTimeView model.zone model.time ]
            , if isActive model.today then
                showPickup model.today

              else
                div [ class "text-2xl mb-12" ]
                    [ text "Danes ne pobirajo smeti." ]
            , titleView "Katero pa jutri?" "mt-12"
            , if isActive model.tomorrow then
                showPickup model.tomorrow

              else
                div [ class "text-2xl" ]
                    [ text "Jutri ne pobirajo smeti." ]
            , if not (isActive model.today) && not (isActive model.tomorrow) then
                div [ class "my-12" ]
                    [ clickButton M "Kdaj naj nastavim kanto?!" ButtonClick
                    , if isActive model.next then
                        div [ class "mt-8" ] [ showNextPickup model.zone model.next ]

                      else
                        div [] []
                    ]

              else
                div [] []
            ]
        ]
