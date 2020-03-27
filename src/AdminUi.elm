module AdminUi exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, type_, value)
import Html.Events exposing (onInput)
import Ui exposing (..)
import Utils.Api exposing (Location, Pickup, TrashType)



-- LOCATION EDIT


tableCell : String -> Bool -> Html msg
tableCell txt edit =
    td
        [ class "px-6 py-4 whitespace-no-wrap text-sm leading-5 font-medium text-gray-900"
        , if edit then
            class "bg-primary-50"

          else
            class ""
        ]
        [ text txt ]


tableInputCell : String -> Bool -> InputType -> (InputType -> String -> msg) -> Html msg
tableInputCell txt edit inType toMsg =
    td
        [ class "px-6 py-4 whitespace-no-wrap text-sm leading-5 text-gray-900"
        , if edit then
            class "bg-primary-50"

          else
            class ""
        ]
        [ if edit then
            input
                [ type_ "text"
                , value txt
                , class "w-32 px-4 py-1 bg-white border border-gray-500 disabled:border-gray-100 font-medium"
                , onInput (toMsg inType)
                ]
                []

          else
            span
                [ class "inline-block w-32 px-4 py-1 bg-white border border-gray-100 text-left" ]
                [ text txt ]
        ]


tableHeaderCell : String -> Html msg
tableHeaderCell label =
    th
        [ class "px-6 py-3 border-b border-gray-200 bg-gray-50"
        , class "text-xs leading-4 font-medium text-gray-500 uppercase tracking-wider"
        ]
        [ text label ]


locationTableView : List Location -> Int -> (InputType -> String -> msg) -> (ButtonType -> msg) -> Html msg
locationTableView locations editId inputMsg buttonMsg =
    let
        header =
            thead []
                [ tr []
                    [ tableHeaderCell "Id"
                    , tableHeaderCell "Street"
                    , tableHeaderCell "Street Number"
                    , tableHeaderCell "City"
                    , tableHeaderCell "Edit"
                    ]
                ]

        rows : Location -> Html msg
        rows row =
            let
                rowEdit =
                    if row.id == editId then
                        True

                    else
                        False
            in
            tr []
                [ tableCell (String.fromInt row.id) rowEdit
                , tableInputCell row.street rowEdit (Street row.id) inputMsg
                , tableInputCell row.street_no rowEdit (StreetNo row.id) inputMsg
                , tableInputCell row.city rowEdit (City row.id) inputMsg
                , td
                    [ class "px-4"
                    , if rowEdit then
                        class "bg-primary-50"

                      else
                        class ""
                    ]
                    [ if row.id == editId then
                        span [ class "flex" ]
                            [ clickButtonId XS "Cancel" (Cancel row.id) buttonMsg
                            , clickButtonId XS "Save" (Save row.id) buttonMsg
                            ]

                      else
                        span [ class "flex" ]
                            [ clickButtonId XS "Edit" (Edit row.id) buttonMsg
                            , clickButtonId XS "Delete" (Delete row.id) buttonMsg
                            ]
                    ]
                ]
    in
    div [ class "flex flex-col" ]
        [ div [ class "-my-2 py-2 overflow-x-auto sm:-mx-6 sm:px-6 lg:-mx-8 lg:px-8" ]
            [ div
                [ class "align-middle inline-block min-w-full shadow overflow-hidden"
                , class "sm:rounded-lg border-b border-gray-200"
                ]
                [ table [ class "min-w-full table-fixed" ]
                    [ header
                    , tbody [ class "table-data" ] <| List.map rows locations
                    ]
                ]
            ]
        ]


viewLocations : List Location -> Int -> (InputType -> String -> msg) -> (ButtonType -> msg) -> Html msg
viewLocations locations editId inputMsg buttonMsg =
    div [ class "mt-2 text-center p-4" ]
        [ h1 [ class "text-2xl mb-4" ] [ text "Available locations" ]
        , locationTableView locations editId inputMsg buttonMsg
        ]
