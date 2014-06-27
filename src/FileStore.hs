module FileStore where

import Control.Monad.Trans
import Control.Applicative
import Data.Text (Text)
import qualified Data.Text as T
import Control.Monad.Trans (liftIO)
import System.Directory (copyFile, doesFileExist)
import System.Random (randomRIO)
import System.FilePath (takeExtension, addExtension, pathSeparator)

data FileStore = Directory FilePath

storeFile :: (Functor m, MonadIO m) => FileStore -> FilePath -> Maybe Text -> m Text
storeFile store@(Directory dir) old Nothing =
  do id' <- show <$> liftIO (randomRIO (10000,9999999) :: IO Double)
     let ext = takeExtension old
     let new = addExtension id' ext
     let full = dir ++ [pathSeparator] ++ new
     e <- liftIO $ doesFileExist full
     case e of
       True -> storeFile store old Nothing
       False -> do
         liftIO $ copyFile old full
         return $ T.pack $ "/store/" ++ new
