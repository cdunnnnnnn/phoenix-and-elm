module Contact.View exposing (render, showView)

import Html exposing (Html, div, h3, h4, header, i, img, li, p, text, ul)
import Html.Attributes exposing (class, classList, id, src)
import Html.Events exposing (onClick)
import Messages exposing (Msg(NavigateTo))
import Model
    exposing
        ( Contact
        , Model
        , RemoteData(NotRequested, Requesting, Failure, Success)
        )
import Routing exposing (Route(ShowContactRoute))
import Shared.View


render : Model -> Html Msg
render model =
    case model.contact of
        Success contact ->
            showDetailView contact

        Requesting ->
            Shared.View.warningMessage
                "fa fa-spin fa-cog fa-2x fa-fw"
                "Fetching contact"
                (text "")

        Failure error ->
            Shared.View.warningMessage
                "fa fa-meh-o fa-stack-2x"
                error
                Shared.View.backToHomeLink

        NotRequested ->
            text ""


showView : Contact -> ( String, Html Msg )
showView contact =
    let
        classes =
            classList
                [ ( "card", True )
                , ( "male", contact.gender == 0 )
                , ( "female", contact.gender == 1 )
                ]
    in
        ( toString contact.id
        , div [ classes, onClick (NavigateTo (ShowContactRoute contact.id)) ]
            [ div [ class "inner" ]
                [ cardHeader contact
                , cardBody contact
                ]
            ]
        )


showDetailView : Contact -> Html Msg
showDetailView contact =
    let
        classes =
            classList
                [ ( "person-detail", True )
                , ( "male", contact.gender == 0 )
                , ( "female", contact.gender == 1 )
                ]

        ( _, content ) =
            showView contact
    in
        div [ id "contacts_show" ]
            [ header []
                [ h3 []
                    [ text "Person detail" ]
                ]
            , Shared.View.backToHomeLink
            , div [ classes ]
                [ content ]
            ]


cardHeader : Contact -> Html Msg
cardHeader contact =
    let
        fullName =
            contact.first_name ++ " " ++ contact.last_name
    in
        header []
            [ div [ class "avatar-wrapper" ]
                [ img [ class "avatar", src contact.picture ] [] ]
            , div [ class "info-wrapper" ]
                [ h4 []
                    [ text fullName ]
                , ul [ class "meta" ]
                    [ li []
                        [ i [ class "fa fa-map-marker" ] []
                        , text contact.location
                        ]
                    , li []
                        [ i [ class "fa fa-birthday-cake" ] []
                        , text contact.birth_date
                        ]
                    ]
                ]
            ]


cardBody : Contact -> Html Msg
cardBody contact =
    div [ class "card-body" ]
        [ div [ class "headline" ]
            [ p []
                [ text contact.headline ]
            ]
        , ul [ class "contact-info" ]
            [ li []
                [ i [ class "fa fa-phone" ] []
                , text contact.phone_number
                ]
            , li []
                [ i [ class "fa fa-envelope" ] []
                , text contact.email
                ]
            ]
        ]
