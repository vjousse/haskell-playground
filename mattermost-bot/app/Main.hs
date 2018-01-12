{-# LANGUAGE OverloadedStrings #-}
module Main where

import Control.Lens
import Data.ByteString (unpack)
import Data.Text.Encoding        (decodeUtf8)
import Lib
import Network.Wreq (get, responseStatus, statusMessage)

main :: IO ()
main = do
    r <- get "http://httpbin.org/get"
    putStrLn $ show . decodeUtf8 $ r ^. responseStatus . statusMessage
