module Todo.Api
  ( module Todo.Api.Types
  , module Todo.Api
  ) where

import Data.Proxy
import Servant.API
import Todo.Api.Types

type TodoAPI = TodoCreateAPI :<|> TodoListAPI

type TodoCreateAPI
  = "api"
  :> "todo"
  :> "create"
  :> ReqBody '[JSON] APICreateTodo
  :> Post '[JSON] APITodo

type TodoListAPI
  = "api"
  :> "todo"
  :> "list"
  :> Get '[JSON] [APITodo]

todoApi :: Proxy TodoAPI
todoApi = Proxy
