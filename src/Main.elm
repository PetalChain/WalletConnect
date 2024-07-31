port module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as D

-- MAIN
main : Program () Model Msg
main =
  Browser.element
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

-- PORTS
port sendMessage : String -> Cmd msg
port disconnectMessage : String -> Cmd msg
port messageReceiver : (String -> msg) -> Sub msg

-- MODEL
type alias Model =
  { 
    isConnected : Bool
    , res : String
  }

init : () -> ( Model, Cmd Msg )
init flags =
  ( { isConnected = False, res = ""}
  , Cmd.none
  )

-- UPDATE
type Msg
  = Send
  | DisconnectWallet
  | Recv String

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    DisconnectWallet ->
      ( { model | res = "" }
      , disconnectMessage "Disconnect"
      )

    Send ->
      ( { model | res = "" }
      , sendMessage "Connect"
      )

    Recv message ->
        if message == "disconnect" then
            ( { model | res = "", isConnected = False }
            , Cmd.none
            )
        else
            (
                { model | res = message, isConnected = True }
            , Cmd.none
            )

-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions _ =
  messageReceiver Recv

-- VIEW
view : Model -> Html Msg
view model =
  div []
    [ h1 [] [ text "Wagmi+Metamask Wallet Test" ]
    , p []
        [text model.res]
    , if model.isConnected then
        button [ onClick DisconnectWallet ] [ text "Disconnect" ]
      else
        button [ onClick Send ] [ text "Connect MetaMask" ]
    ]