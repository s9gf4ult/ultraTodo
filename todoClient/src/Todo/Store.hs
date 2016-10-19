module Todo.Store where

import Control.DeepSeq
import Control.Lens
import Data.Proxy
import Data.Text (Text)
import GHC.Generics (Generic)
import React.Flux
import React.Flux.Addons.Servant
import Todo.Api

data TodoList
  = TLPending
    -- ^ Waiting for response
  | TLError String
    -- ^ Could not update
  | TLList [APITodo]
    -- ^ Got the list

data TodoState = TodoState
  { _tsEntry    :: !Text
  , _tsTodoList :: !TodoList
  }

makeLenses ''TodoState

data TodoAction
  = UpdateEntry (Maybe Text)
  | UpdateTodoList
  | UpdateTodoListResponse (Either (Int, String) [APITodo])
  deriving (Generic, Show)

instance NFData TodoAction

makePrisms ''TodoAction

cfg :: ApiRequestConfig TodoAPI
cfg = ApiRequestConfig "http://127.0.0.1:8080" NoTimeout

instance StoreData TodoState where
  type StoreAction TodoState = TodoAction
  transform action state = do
    mutate <- case action of
        UpdateEntry t -> do
          print action
          return $ maybe id (set tsEntry) t
        UpdateTodoList -> do
          request cfg (Proxy :: Proxy TodoListAPI) $ \resp ->
            return $ [ SomeStoreAction todoStore $ UpdateTodoListResponse resp ]
          return $ set tsTodoList TLPending
        UpdateTodoListResponse resp -> return $ case resp of
          Left (_, e) -> set tsTodoList (TLError e)
          Right todos -> set tsTodoList (TLList todos)
    return $ mutate state

todoStore :: ReactStore TodoState
todoStore = mkStore $ TodoState
  { _tsEntry = "two"
  , _tsTodoList = TLList []
  }

dispatchTodoClient :: TodoAction -> ViewEventHandler
dispatchTodoClient a = [SomeStoreAction todoStore a]
