{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
module Main where

import Control.Monad.IO.Class (liftIO)
import Data.Aeson (FromJSON, ToJSON)
import Database.PostgreSQL.Simple (Only(..), Connection, connectPostgreSQL, query_, query)
import Database.PostgreSQL.Simple.ToRow (ToRow(toRow))
import Database.PostgreSQL.Simple.FromRow (FromRow(fromRow), field)
import Database.PostgreSQL.Simple.ToField (toField)
import GHC.Generics (Generic)
import Web.Scotty as WS (ActionM, ScottyM, json, jsonData, get, post, scotty)

data Checklist = Checklist { checklistId :: Maybe Int,
    title :: String,
    checklistItems :: [ChecklistItem]} deriving (Show, Generic)

instance FromRow Checklist where
    fromRow = Checklist <$> field <*> field <*> pure []

instance ToRow Checklist where
    toRow c = [toField $ title c]

instance ToJSON Checklist
instance FromJSON Checklist


data ChecklistItem = ChecklistItem { checklistItemId :: Maybe Int,
    itemText :: String,
    finished :: Bool,
    checklist :: Int } deriving (Show, Generic)

instance FromRow ChecklistItem where
    fromRow = ChecklistItem <$> field <*> field <*> field <*> field

instance ToRow ChecklistItem where
    toRow i = [toField $ itemText i, toField $ finished i, toField $ checklist i]

instance ToJSON ChecklistItem

instance FromJSON ChecklistItem

server :: Connection -> ScottyM()
server conn = do
    WS.get "/checklists" $ do
        checklists <- liftIO (query_ conn "select id, title from checklists" :: IO [Checklist])
        checkWithItems <- liftIO (mapM (setArray conn) checklists)
        WS.json checkWithItems
    WS.post "/checklistitems" $ do
        item <- WS.jsonData :: WS.ActionM ChecklistItem
        newItem <- liftIO (insertChecklist conn item)
        WS.json newItem

selectChecklistQuery = "select id, name, finished, checklist from checklistitems where checklist = (?)"
insertItemsQuery = "insert into checklistitems (name, finished, checklist) values (?, ?, ?) returning id"

setArray :: Connection -> Checklist -> IO Checklist
setArray conn check = do
    items <- liftIO (query conn selectChecklistQuery (Only $ checklistId check) :: IO [ChecklistItem])
    return check { checklistItems = items }

insertChecklist :: Connection -> ChecklistItem -> IO ChecklistItem
insertChecklist conn item = do
    [Only id] <- query conn insertItemsQuery item
    return item { checklistItemId = id }

main :: IO ()
main = do
    conn <- connectPostgreSQL ("host='127.0.0.1' user='postgres' dbname='rest_api_haskell' password='pass'")
    WS.scotty 1234 $ server conn
