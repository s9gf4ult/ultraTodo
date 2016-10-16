module Todo.View where

import Control.Lens
import Data.Aeson
import Data.Aeson.TH
import Data.Text as T
import GHC.Generics (Generic)
import GHCJS.Marshal
import GHCJS.Types
import React.Flux
import Todo.Store
import Todo.Utils

data SelectOption = SelectOption
  { seValue :: Text
  , seLabel :: Text
  } deriving (Show)

deriveJSON
  defaultOptions
  { fieldLabelModifier = defaultFieldLabelModifier }
  ''SelectOption

instance FromJSVal SelectOption where
  fromJSVal jsval = do
    Just value <- fromJSVal jsval
    return $ case fromJSON value of
      Error e -> Nothing
      Success a -> Just a

selectOptions :: [SelectOption]
selectOptions =
  [ SelectOption "one" "One"
  , SelectOption "two" "Two"
  ]


todoClient :: ReactView ()
todoClient = defineControllerView "todoClient" todoStore draw
  where
    draw state () = do
      div_ $ do
        foreign_ "Select"
          [ "options" @= selectOptions
          , "matchPos" @= ("start" :: Text)
          , "ignoreCase" @= False
          , "value" @= (state ^. tsEntry)
          , callback "onChange" (\val ->
                                  dispatchTodoClient $ UpdateEntry $ seValue val)
          ]
          mempty
