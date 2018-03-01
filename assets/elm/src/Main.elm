module Main exposing (main)

import Messages exposing (Msg(UrlChange))
import Model exposing (Model)
import Navigation
import Routing
import Update
import View


main : Program Never Model Msg
main =
    Navigation.program
        UrlChange
        { init = init
        , view = View.view
        , update = Update.update
        , subscriptions = (\_ -> Sub.none)
        }


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    let
        currentRoute =
            Routing.parse location

        model =
            Model.initialModel currentRoute
    in
        Update.urlUpdate model
