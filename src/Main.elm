module Main exposing (..)

import Browser
import Html exposing (Html, button, div, input, span, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)


main : Program () Model Msg
main =
    Browser.sandbox { init = init, update = update, view = view }


type alias Model =
    { wordle : List String
    , guesses : List String
    , currentGuess : String
    , maxAttempts : Int
    }


init : Model
init =
    { wordle = [ "H", "E", "L", "L", "O" ], guesses = [], currentGuess = "", maxAttempts = 5 }


type Msg
    = Check String
    | Change String


update : Msg -> Model -> Model
update msg model =
    case msg of
        Check guess ->
            { model
                | guesses = guess :: model.guesses
                , currentGuess = ""
            }

        Change currentGuess ->
            if String.length currentGuess > 5 then
                model

            else
                { model | currentGuess = String.toUpper currentGuess }


view : Model -> Html Msg
view model =
    div []
        (div []
            (List.map
                (\guess -> div [ style "margin" "12px" ] (checkGuess guess model.wordle))
                model.guesses
            )
            :: (if List.length model.guesses < model.maxAttempts then
                    [ div []
                        [ input [ value model.currentGuess, onInput Change ] []
                        , button [ onClick (Check model.currentGuess) ] [ text "Check" ]
                        ]
                    ]

                else
                    []
               )
        )


checkGuess : String -> List String -> List (Html msg)
checkGuess guess wordle =
    let
        defaulStyle =
            [ style "padding" "5px"
            , style "margin" "2px"
            , style "color" "white"
            ]
    in
    List.map2
        (\guessChar wordleChar ->
            if guessChar == wordleChar then
                span
                    (style "background-color" "MediumSeaGreen" :: defaulStyle)
                    [ text guessChar ]

            else if List.member guessChar wordle then
                span
                    (style "background-color" "GoldenRod" :: defaulStyle)
                    [ text guessChar ]

            else
                span
                    (style "background-color" "gray" :: defaulStyle)
                    [ text guessChar ]
        )
        (String.split "" guess)
        wordle
