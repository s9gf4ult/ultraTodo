module Todo.Store where

import React.Flux

data TodoState = TodoState

data TodoAction = TodoAction

instance StoreData TodoState where
  type StoreAction TodoState = TodoAction
  transform _ _ = return TodoState

todoStore :: ReactStore TodoState
todoStore = mkStore TodoState
