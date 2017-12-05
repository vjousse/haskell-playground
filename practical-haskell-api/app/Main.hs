{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
module Main where

import qualified Web.Scotty as WS
import Data.Monoid ((<>))
import Data.Aeson (FromJSON, ToJSON)
import GHC.Generics

data User = User { userId :: Int, userName :: String } deriving (Show, Generic)

instance ToJSON User
instance FromJSON User

bob :: User
bob = User { userId = 1, userName = "bob" }

jenny :: User
jenny = User { userId = 2, userName = "jenny" }

allUsers :: [User]
allUsers = [bob, jenny]

matchesId :: Int -> User -> Bool
matchesId id user = userId user == id

main :: IO ()
main = do
    putStrLn "Starting Server..."

    WS.scotty 3000 $ do
        WS.get "/hello/:name" $ do
            name <- WS.param "name"
            WS.text ("hello " <> name <> "!")
        WS.get "/users" $ do
            WS.json allUsers
        WS.get "/users/:id" $ do
            id <- WS.param "id"
            WS.json (filter (matchesId id) allUsers)


