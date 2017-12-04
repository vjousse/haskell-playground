module Lib
    ( cat
    ) where

import System.IO (hGetContents, readFile, IOMode (ReadMode))
import System.Environment

cat :: [String] -> IO ()
cat files@(fileName:args) = do
    mapM_ readFileContent files

-- Read from stdin and output as it is to stdout
-- See http://learnyouahaskell.com/input-and-output
cat _ = interact id

readFileContent :: String -> IO ()
readFileContent fileName = do
    contents <- readFile fileName
    putStr contents
