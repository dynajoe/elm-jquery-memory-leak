port module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)


main =
    Html.program
        { init = ( initialModel, datePicker "date-picker" )
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


port datePicker : String -> Cmd msg


port dateSelected : (String -> msg) -> Sub msg


subscriptions : Model -> Sub Msg
subscriptions model =
    dateSelected DateSelected


type alias Model =
    { selectedDate : String, currentStep : Step }


initialModel : Model
initialModel =
    { selectedDate = "", currentStep = SelectDate }


type Step
    = SelectDate
    | Confirm


type Msg
    = DateSelected String
    | ChangeStep Step


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DateSelected date ->
            ( { model | selectedDate = date }, Cmd.none )

        ChangeStep newStep ->
            let
                newModel =
                    { model | currentStep = newStep }
            in
                case newStep of
                    SelectDate ->
                        ( newModel, datePicker "date-picker" )

                    Confirm ->
                        ( newModel, Cmd.none )


view : Model -> Html Msg
view model =
    case model.currentStep of
        SelectDate ->
            div [ class "select-date-step" ]
                [ input [ type_ "text", id "date-picker" ] []
                , div [ class "step-choices" ]
                    [ button [ onClick <| ChangeStep Confirm ] [ text "Next Step" ]
                    ]
                ]

        Confirm ->
            div [ class "confirm-step" ]
                [ p [] [ text <| "Selection: " ++ model.selectedDate ]
                , div [ class "step-choices" ]
                    [ a [ href "#", onClick <| ChangeStep SelectDate ] [ text "< Back" ]
                    ]
                ]
