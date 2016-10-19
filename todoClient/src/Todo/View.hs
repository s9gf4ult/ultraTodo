module Todo.View where

import Control.Lens
import Data.Default
import Data.Foldable
import Data.Text as T
import React.Flux
import React.Plugins.ReactSelect
import Todo.Api
import Todo.Store


selectOptions :: [SelectOption Text]
selectOptions =
  [ SelectOption "one" "One"
  , SelectOption "two" "Two"
  ]

todoClient :: ReactView ()
todoClient = defineControllerView "todoClient" todoStore draw
  where
    draw state () = do
      div_ $ do
        reactSelect_ $ def
          { _spValue    = state ^. tsEntry . re _Just
          , _spOptions  = selectOptions
          , _spOnChange = Just $ \opt -> dispatchTodoClient $ UpdateEntry $ opt ^? _Just . seValue }
        button_ [ onClick $ \_ _ -> dispatchTodoClient UpdateTodoList ] $
          elemText "Update"
        case state ^. tsTodoList of
          TLPending -> div_ $ elemText "Updating ..."
          TLError e -> div_ $ elemText $ T.pack e
          TLList l -> ul_ $ for_ l $ \todo -> do
            li_ $ elemText $ todo ^. atText
