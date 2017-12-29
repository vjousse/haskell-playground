{-# LANGUAGE DeriveGeneric #-}

module Model
    ( Checklist(..)
    , ChecklistItem(..)
    , ChecklistRawSql(..)
    ) where

import Data.Aeson (FromJSON, ToJSON)
import Database.PostgreSQL.Simple.ToRow (ToRow(toRow))
import Database.PostgreSQL.Simple.FromRow (FromRow(fromRow), field)
import Database.PostgreSQL.Simple.ToField (toField)
import GHC.Generics (Generic)

data Checklist = Checklist { checklistId :: Maybe Int,
    title :: String,
    checklistItems :: [ChecklistItem]} deriving (Show, Generic)

instance FromRow Checklist where
    fromRow = Checklist <$> field <*> field <*> pure []

instance ToRow Checklist where
    toRow c = [toField $ title c ]

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


data ChecklistRawSql = ChecklistRawSql {
    sqlChecklistId :: Maybe Int,
    sqlTitle :: String,
    sqlChecklistItemId :: Maybe Int,
    sqlItemText :: String,
    sqlFinished :: Bool,
    sqlChecklist :: Int } deriving (Show, Generic)


instance FromRow ChecklistRawSql where
    fromRow = ChecklistRawSql <$> field <*> field <*> field <*> field <*> field <*> field

instance ToRow ChecklistRawSql where
    toRow c = [toField $ sqlTitle c]

instance ToJSON ChecklistRawSql

instance FromJSON ChecklistRawSql
