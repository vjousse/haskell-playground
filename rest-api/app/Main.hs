{-# LANGUAGE OverloadedStrings #-}
module Main where

import Control.Monad.IO.Class (liftIO)
import Database.PostgreSQL.Simple (Only(..), Connection, connectPostgreSQL, query_, query)
import Web.Scotty as WS (ActionM, ScottyM, json, jsonData, get, post, scotty)
import Model (Checklist(checklistItems, checklistId), ChecklistItem(checklistItemId), ChecklistRawSql)

server :: Connection -> ScottyM()
server conn = do
    WS.get "/checklists" $ do
        checklists <- liftIO (query_ conn "select id, title from checklists" :: IO [Checklist])
        checkWithItems <- liftIO (mapM (setArray conn) checklists)
        WS.json checkWithItems

    WS.get "/checklistsjoin" $ do
        checklists <- liftIO (query_ conn selectChecklistJoinQuery :: IO [ChecklistRawSql])
        WS.json checklists

    WS.post "/checklistitems" $ do
        item <- WS.jsonData :: WS.ActionM ChecklistItem
        newItem <- liftIO (insertChecklist conn item)
        WS.json newItem

selectChecklistQuery = "select id, name, finished, checklist from checklistitems where checklist = (?)"
insertItemsQuery = "insert into checklistitems (name, finished, checklist) values (?, ?, ?) returning id"

selectChecklistJoinQuery = "select l.id, l.title, i.id, i.name, i.finished, i.checklist from checklists as l left join checklistitems as i on l.id=i.checklist group by l.id,i.id order by l.id"

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
