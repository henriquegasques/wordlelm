module Main exposing (..)

import Browser
import Html exposing (Html, button, div, input, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)


main : Program () Model Msg
main =
    Browser.sandbox { init = init, update = update, view = view }


type alias Model =
    { wordle : String
    , guesses : List String
    , currentGuess : String
    , maxAttempts : Int
    }


init : Model
init =
    { wordle = "HELLO", guesses = [], currentGuess = "", maxAttempts = 5 }


type Msg
    = Check String
    | Change String


update : Msg -> Model -> Model
update msg model =
    case msg of
        Check guess ->
            { model
                | guesses = List.append model.guesses [ guess ]
                , currentGuess = ""
            }

        Change currentGuess ->
            if String.length currentGuess > 5 then
                model

            else
                { model | currentGuess = currentGuess }


view : Model -> Html Msg
view model =
    div []
        ([ div [] (List.map (\guess -> div [] [ text guess ]) model.guesses) ]
            ++ (if List.length model.guesses < model.maxAttempts then
                    [ div []
                        [ input [ value model.currentGuess, onInput Change ] []
                        , button [ onClick (Check model.currentGuess) ] [ text "Check" ]
                        ]
                    ]

                else
                    []
               )
        )
