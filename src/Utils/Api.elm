module Utils.Api exposing (..)

import Http
import Json.Decode as Decode
import Json.Decode.Extra exposing (datetime)
import Json.Decode.Pipeline exposing (required)
import Json.Encode as Encode
import Time


type Barva
    = Rumena
    | Zelena
    | Rjava
    | Modra
    | Rdeca


type alias Location =
    { id : Int
    , street : String
    , street_no : String
    , city : String
    }


type alias TrashType =
    { id : Int
    , type_ : String
    , color : Barva
    }


type alias Pickup =
    { id : Int
    , location : Int
    , date : Time.Posix
    , trash : List TrashType
    }


getLocation : Int -> (Result Http.Error Location -> msg) -> Cmd msg
getLocation id toMsg =
    Http.get
        { url = "http://localhost:8080/location/" ++ String.fromInt id
        , expect = Http.expectJson toMsg locationDecoder
        }


getLocations : (Result Http.Error (List Location) -> msg) -> Cmd msg
getLocations toMsg =
    Http.get
        { url = "http://localhost:8080/locations/"
        , expect = Http.expectJson toMsg locationListDecoder
        }


updateLocation : Int -> Location -> (Result Http.Error Location -> msg) -> Cmd msg
updateLocation id location toMsg =
    Http.request
        { method = "PATCH"
        , headers = []
        , url = "http://localhost:8080/location/" ++ String.fromInt id
        , body = Http.jsonBody (locationEncoder location)
        , expect = Http.expectJson toMsg locationDecoder
        , timeout = Nothing
        , tracker = Nothing
        }


deleteLocation : Int -> (Result Http.Error Int -> msg) -> Cmd msg
deleteLocation id toMsg =
    Http.request
        { method = "DELETE"
        , headers = []
        , url = "http://localhost:8080/location/" ++ String.fromInt id
        , body = Http.emptyBody
        , expect = Http.expectJson toMsg deleteLocationDecoder
        , timeout = Nothing
        , tracker = Nothing
        }


getToday : (Result Http.Error Pickup -> msg) -> Cmd msg
getToday toMsg =
    Http.get
        { url = "http://localhost:8080/today/"
        , expect = Http.expectJson toMsg pickupDecoder
        }


getTomorrow : (Result Http.Error Pickup -> msg) -> Cmd msg
getTomorrow toMsg =
    Http.get
        { url = "http://localhost:8080/tomorrow/"
        , expect = Http.expectJson toMsg pickupDecoder
        }


getNext : (Result Http.Error Pickup -> msg) -> Cmd msg
getNext toMsg =
    Http.get
        { url = "http://localhost:8080/next/"
        , expect = Http.expectJson toMsg pickupDecoder
        }


isActive : Pickup -> Bool
isActive pickup =
    pickup.id > 0



-- DECODERS


locationDecoder : Decode.Decoder Location
locationDecoder =
    Decode.succeed Location
        |> required "id" Decode.int
        |> required "street" Decode.string
        |> required "street_no" Decode.string
        |> required "city" Decode.string


locationEncoder : Location -> Encode.Value
locationEncoder record =
    Encode.object
        [ ( "id", Encode.int <| record.id )
        , ( "street", Encode.string <| record.street )
        , ( "street_no", Encode.string <| record.street_no )
        , ( "city", Encode.string <| record.city )
        ]


locationListDecoder : Decode.Decoder (List Location)
locationListDecoder =
    Decode.list locationDecoder


deleteLocationDecoder : Decode.Decoder Int
deleteLocationDecoder =
    Decode.field "id" Decode.int


trashDecoder : Decode.Decoder TrashType
trashDecoder =
    Decode.succeed TrashType
        |> required "id" Decode.int
        |> required "type" Decode.string
        |> required "color" kantaDecoder


kantaDecoder : Decode.Decoder Barva
kantaDecoder =
    Decode.string
        |> Decode.andThen
            (\str ->
                case str of
                    "rdeca" ->
                        Decode.succeed Rdeca

                    "rumena" ->
                        Decode.succeed Rumena

                    "zelena" ->
                        Decode.succeed Zelena

                    "rjava" ->
                        Decode.succeed Rjava

                    "modra" ->
                        Decode.succeed Modra

                    _ ->
                        Decode.fail <| "Uknown kanta color."
            )


pickupDecoder : Decode.Decoder Pickup
pickupDecoder =
    Decode.succeed Pickup
        |> required "id" Decode.int
        |> required "location" Decode.int
        |> required "date" datetime
        |> required "trash" (Decode.list trashDecoder)



-- HELPERS


getLocationItem : Int -> List Location -> Maybe Location
getLocationItem id lst =
    List.head (List.filter (\i -> i.id == id) lst)
