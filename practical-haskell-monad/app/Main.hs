module Main where

import Control.Monad
import Data.Aeson (encode, toJSON)
import Data.Time (getCurrentTime)
import Lib (cat)
import System.Environment



main :: IO ()
main = do
    args <- getArgs
    cat args

ask :: IO ()
ask = do
    putStrLn "Please enter a message"
    name <- getLine
    putStrLn "Please enter a number"
    number <- getLine
    let num = read number :: Int

    putStrLn $ concatMap (\_ -> name ++ "\n") [1..num]

    mapM_ (\_ -> putStrLn $ name) [1..num]

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
printNumbers = putStrLn $ show $ ((3+4) :: Int)

printTime :: IO ()
printTime = do
    time <- getCurrentTime
    putStrLn (show time)


printJSON :: IO ()
printJSON = do
    print $ encode $ toJSON numbers


sayHello :: IO String
sayHello = do
    name <- getLine
    putStrLn ("Hello " ++ name)
    return name
