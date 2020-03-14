module Utils.Api exposing (..)

import Element as Element exposing (Color)
import Http
import Json.Decode as Decode exposing (Decoder, int, list, string)
import Json.Decode.Extra exposing (datetime)
import Json.Decode.Pipeline exposing (required)
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
    if pickup.id > 0 then
        True

    else
        False



-- DECODERS


locationDecoder : Decoder Location
locationDecoder =
    Decode.succeed Location
        |> required "id" int
        |> required "street" string
        |> required "street_no" string
        |> required "city" string


trashDecoder : Decoder TrashType
trashDecoder =
    Decode.succeed TrashType
        |> required "id" int
        |> required "type" string
        |> required "color" kantaDecoder


kantaDecoder : Decoder Barva
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


pickupDecoder : Decoder Pickup
pickupDecoder =
    Decode.succeed Pickup
        |> required "id" int
        |> required "location" int
        |> required "date" datetime
        |> required "trash" (list trashDecoder)
