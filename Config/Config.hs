module Config where

import           IHP.Environment
import           IHP.FrameworkConfig
import           IHP.Prelude
import qualified System.Environment  as Env

config :: ConfigBuilder
config = do
    env <- getEnvFromEnv
    option env
    option (AppHostname "localhost")

getEnvFromEnv :: MonadIO m => m Environment
getEnvFromEnv = do
  result <- liftIO $ Env.lookupEnv "ENV"
  case result of
    Just "dev" -> pure Development
    _          -> pure Production
