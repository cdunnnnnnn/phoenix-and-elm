module Update exposing (update, urlUpdate)

import Commands
import Decoders
import Json.Decode as JD
import Messages
    exposing
        ( Msg
            ( FetchContactSuccess
            , FetchContactError
            , FetchContactListSuccess
            , FetchContactListError
            , NavigateTo
            , Paginate
            , ResetSearch
            , SearchContacts
            , UpdateSearchQuery
            , UrlChange
            )
        )
import Model
    exposing
        ( Model
        , RemoteData(Failure, NotRequested, Requesting, Success)
        )
import Navigation
import Routing
    exposing
        ( Route(ListContactsRoute, NotFoundRoute, ShowContactRoute)
        , parse
        , toPath
        )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchContactListSuccess raw ->
            case JD.decodeValue Decoders.contactListDecoder raw of
                Ok payload ->
                    ( { model | contactList = Success payload }, Cmd.none )

                Err err ->
                    ( { model
                        | contactList =
                            Failure "Error while decoding contact list"
                      }
                    , Cmd.none
                    )

        FetchContactListError raw ->
            ( { model
                | contactList = Failure "Error while fetching contact list"
              }
            , Cmd.none
            )

        FetchContactSuccess raw ->
            case JD.decodeValue Decoders.contactDecoder raw of
                Ok payload ->
                    ( { model | contact = Success payload }, Cmd.none )

                Err err ->
                    ( { model
                        | contact = Failure "Error while decoding contact"
                      }
                    , Cmd.none
                    )

        FetchContactError raw ->
            ( { model | contact = Failure "Contact not found" }, Cmd.none )

        NavigateTo route ->
            ( model, Navigation.newUrl (toPath route) )

        Paginate pageNumber ->
            ( model
            , Commands.fetchContactList
                model.flags.socketUrl
                pageNumber
                model.search
            )

        ResetSearch ->
            ( { model | search = "" }
            , Commands.fetchContactList model.flags.socketUrl 1 ""
            )

        SearchContacts ->
            ( { model | contactList = Requesting }
            , Commands.fetchContactList model.flags.socketUrl 1 model.search
            )

        UpdateSearchQuery value ->
            ( { model | search = value }, Cmd.none )

        UrlChange location ->
            let
                currentRoute =
                    parse location
            in
                urlUpdate { model | route = currentRoute }


urlUpdate : Model -> ( Model, Cmd Msg )
urlUpdate model =
    case model.route of
        ListContactsRoute ->
            case model.contactList of
                NotRequested ->
                    ( model
                    , Commands.fetchContactList model.flags.socketUrl 1 ""
                    )

                _ ->
                    ( model, Cmd.none )

        ShowContactRoute id ->
            ( { model | contact = Requesting }
            , Commands.fetchContact model.flags.socketUrl id
            )

        _ ->
            ( model, Cmd.none )
