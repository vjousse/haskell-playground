{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DuplicateRecordFields #-}

module Model
    ( Checklist(..)
    , ChecklistItem(..)
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
    toRow c = [toField $ title (c :: Checklist)]

instance ToJSON Checklist
instance FromJSON Checklist


data ChecklistItem = ChecklistItem { checklistItemId :: Maybe Int,
    itemText :: String,
    finished :: Bool,
    checklist :: Int } deriving (Show, Generic)

instance FromRow ChecklistItem where
    fromRow = ChecklistItem <$> field <*> field <*> field <*> field

instance ToRow ChecklistItem where
    toRow i = [toField $ itemText (i :: ChecklistItem), toField $ finished (i :: ChecklistItem), toField $ checklist ( i :: ChecklistItem) ]

instance ToJSON ChecklistItem

instance FromJSON ChecklistItem


data ChecklistRawSql = ChecklistRawSql {
    checklistId :: Maybe Int,
    title :: String,
    checklistItemId :: Maybe Int,
    itemText :: String,
    finished :: Bool,
    checklist :: Int } deriving (Show, Generic)


instance FromRow ChecklistRawSql where
    fromRow = ChecklistRawSql <$> field <*> field <*> field <*> field <*> field <*> field

instance ToRow ChecklistRawSql where
    toRow c = [toField $ (title :: ChecklistRawSql -> String) c]

instance ToJSON ChecklistRawSql

instance FromJSON ChecklistRawSql
