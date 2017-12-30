module PodDB where

import Database.HDBC
import Database.HDBC.Sqlite3
import PodTypes
import Control.Monad(when)
import Data.List(sort)

-- | Initialize DB and return database Connection
connect :: FilePath -> IO Connection
connect fp =
    do dbh <- connectSqlite3 fp
       prepDB dbh
       return dbh

{- | Prepare the database for our data.
We create two tables and ask the database engine to verify some pieces
of data consistency for us:
* castid and epid both are unique primary keys and must never be duplicated
* castURL also is unique
* In the episodes table, for a given podcast (epcast), there must be only
one instance of each given URL or episode ID
-}
prepDB :: IConnection conn => conn -> IO ()
prepDB dbh =
    do tables <- getTables dbh
       when (not ("podcasts" `elem` tables)) $
        do run dbh "CREATE TABLE podcasts (\
                    \castid INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,\
                    \castURL TEXT NOT NULL UNIQUE)" []
           return ()
       when (not ("episodes" `elem` tables)) $
        do run dbh "CREATE TABLE episodes (\
                    \epid INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,\
                    \epcastid INTEGER NOT NULL,\
                    \epurl TEXT NOT NULL,\
                    \epdone INTEGER NOT NULL,\
                    \UNIQUE(epcastid, epurl),\
                    \UNIQUE(epcastid, epid))" []
           return ()
