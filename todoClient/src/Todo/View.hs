module Todo.View where

import Control.Lens
import Data.Default
import Data.Text as T
import React.Flux
import React.Plugins.ReactSelect
import Todo.Store


selectOptions :: [SelectOption Text]
selectOptions =
  [ SelectOption "one" "One" Nothing
  , SelectOption "two" "Two" Nothing
  ]

todoClient :: ReactView ()
todoClient = defineControllerView "todoClient" todoStore draw
  where
    draw state () = do
      div_ $ do
        reactSelect_ $ def
          { _spValue    = state ^. tsEntry . re _Just
          , _spOptions  = selectOptions
          , _spOnChange = Just $ \opt -> dispatchTodoClient $ UpdateEntry $ opt ^. seValue }
