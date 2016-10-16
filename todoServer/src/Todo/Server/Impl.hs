module Todo.Server.Impl where

import Todo.Api
import Control.Monad.Base

todoCreate :: (MonadBase IO m) => APICreateTodo -> m APITodo
todoCreate = undefined

todoList :: (MonadBase IO m) => m [APITodo]
todoList = do
  liftBase $ print "list"
  return
    [ APITodo TCWhite "Create ultimate weapon" 1
    , APITodo TCBlue "Kill all the people" 2
    , APITodo TCRed "Make me happy" 3
    ]
