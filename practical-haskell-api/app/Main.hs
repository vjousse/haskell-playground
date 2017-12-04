{-# LANGUAGE OverloadedStrings #-}
module Main where

import qualified Web.Scotty as WS
import Data.Monoid ((<>))

main :: IO ()
main = do
    putStrLn "Starting Server..."

    WS.scotty 3000 $ do
        WS.get "/hello/:name" $ do
            name <- WS.param "name"
            WS.text ("hello " <> name <> "!")
