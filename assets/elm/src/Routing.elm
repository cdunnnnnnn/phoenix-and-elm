module Routing exposing (..)

import Navigation
import UrlParser exposing (..)


type Route
    = ListContactsRoute
    | ShowContactRoute Int
    | NotFoundRoute


toPath : Route -> String
toPath route =
    case route of
        ListContactsRoute ->
            "/"

        ShowContactRoute id ->
            "/contacts/" ++ toString id

        NotFoundRoute ->
            "/not-found"


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map ListContactsRoute <| s ""
        , map ShowContactRoute <| s "contacts" </> int
        ]


parse : Navigation.Location -> Route
parse location =
    case UrlParser.parsePath matchers location of
        Just route ->
            route

        Nothing ->
            NotFoundRoute
