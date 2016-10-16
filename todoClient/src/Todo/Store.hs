module Todo.Store where

import Control.DeepSeq
import Control.Lens
import Data.Text (Text)
import GHC.Generics (Generic)
import React.Flux

data TodoState = TodoState
  { _tsEntry :: !Text
  }

makeLenses ''TodoState

data TodoAction =
  UpdateEntry Text
  deriving (Generic, Show)

instance NFData TodoAction

makePrisms ''TodoAction

instance StoreData TodoState where
  type StoreAction TodoState = TodoAction
  transform action state = do
    mutate <- case action of
        UpdateEntry t -> do
          print action
          return $ set tsEntry t
    return $ mutate state

todoStore :: ReactStore TodoState
todoStore = mkStore $ TodoState
  { _tsEntry = "two"
  }

dispatchTodoClient :: TodoAction -> ViewEventHandler
dispatchTodoClient a = [SomeStoreAction todoStore a]
