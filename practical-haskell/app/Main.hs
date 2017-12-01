module Main where

import Control.Monad
import Data.Aeson (encode, toJSON)
import Data.Time (getCurrentTime)
import Lib
import System.IO (readFile)

main :: IO ()
main = do
    let action = putStrLn "Coucou"
    action
    action
    action
    action
    return ()


ask :: IO ()
ask = do
    putStrLn "Please enter a message"
    name <- getLine
    putStrLn "Please enter a number"
    number <- getLine
    let num = read number :: Int

    putStrLn $ concatMap (\n -> name ++ "\n") [1..num]

    mapM (\n -> putStrLn $ name) [1..num]

    putStrLn "\n"

    let action :: IO ()
        action = putStrLn name

    replicateM_ num action

numbers :: [Int]
numbers = [1,2,3,4]

printConfig :: IO ()
printConfig = do
    contents <- readFile "stack.yaml"
    putStrLn contents

printNumbers :: IO ()
printNumbers = do
    putStrLn (show (3+4))

printTime :: IO ()
printTime = do
    time <- getCurrentTime
    putStrLn (show time)


printJSON :: IO ()
printJSON = do
    print $ encode $ toJSON numbers


beCareful :: Maybe Int
beCareful = do
    Just 6
    Nothing
    return 5

sayHello :: IO String
sayHello = do
    name <- getLine
    putStrLn ("Hello " ++ name)
    return name
