module Pages.Top exposing (Model, Msg, page)

import Element exposing (..)
import Element.Font as Font
import Generated.Params as Params
import Http
import Spa.Page
import Task
import Time
import Ui exposing (clickButton, dateTimeView, showNextPickup, showPickup, titleView)
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
        { title = always "homepage"
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
subscriptions model =
    Time.every 1000 Tick



-- VIEW


view : Model -> Element Msg
view model =
    column [ centerX, width fill ]
        [ row [ centerX ]
            [ titleView "Katero kanto bomo danes?"
            ]
        , row
            [ centerX
            , paddingEach
                { top = 0
                , right = 0
                , bottom = 48
                , left = 0
                }
            ]
            [ dateTimeView model.zone model.time
            ]
        , if isActive model.today then
            showPickup model.today

          else
            row [ centerX ]
                [ el
                    [ Font.center
                    , Font.size 36
                    ]
                    (text "Danes ne pobirajo smeti.")
                ]
        , row
            [ centerX
            , paddingEach
                { top = 80
                , right = 0
                , bottom = 24
                , left = 0
                }
            ]
            [ titleView "Katero pa jutri?"
            ]
        , if isActive model.tomorrow then
            showPickup model.tomorrow

          else
            row [ centerX ]
                [ el
                    [ Font.center
                    , Font.size 36
                    ]
                    (text "Jutri ne pobirajo smeti.")
                ]
        , if not (isActive model.today) && not (isActive model.tomorrow) then
            column [ width fill ]
                [ row [ centerX, paddingXY 24 76 ]
                    [ el [ centerX ] (clickButton ( "Kdaj naj nastavim kanto?!", Just ButtonClick ))
                    ]
                , if isActive model.next then
                    showNextPickup model.zone model.next

                  else
                    none
                ]

          else
            none
        ]
