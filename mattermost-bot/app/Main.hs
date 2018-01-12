{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
module Main where

import qualified Control.Lens as CL ((^.), (^?))
import Data.Aeson (ToJSON, pairs, (.=), object, toJSON, toEncoding)
import Data.Aeson.Lens (_String, key)
import Data.ByteString (unpack)
import Data.Monoid
import Data.Text.Encoding        (decodeUtf8)
import GHC.Generics
import Lib
import Network.Wreq (get, post, responseBody, responseHeader, responseStatus, statusMessage)
import System.Environment      (getEnv)

data Credentials = Credentials {
    login_id :: String
  , password :: String
} deriving (Generic,  Show)

instance ToJSON Credentials where
    toJSON (Credentials login_id password) =
      object [ "login_id" .= login_id
             , "password" .= password
             ]
    toEncoding(Credentials login_id password) =
      pairs ("login_id" .= login_id <> "password" .= password)

main :: IO ()
main = doPost

doPost :: IO ()
doPost = do
    clientId <- getEnv "LOGIN_ID"
    password <- getEnv "PASSWORD"
    url <- getEnv "URL"
    r <- post url (toJSON $ Credentials clientId password)
    putStrLn $ show $ r CL.^. responseBody . key "username" . _String
    putStrLn $ show $ r CL.^. responseHeader "token"
