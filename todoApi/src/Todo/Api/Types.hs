module Todo.Api.Types where

import Data.Aeson.TH
import Data.List as L
import Data.Text as T
import Text.Inflections
import Todo.Utils

data TodoColor
  = TCRed
  | TCBlue
  | TCGreen
  | TCWhite
  | TCRainbow
    -- ^ :trollface:

deriveJSON
  defaultOptions
  { constructorTagModifier = toUnderscore . L.drop 2 }
  ''TodoColor

data APICreateTodo = APICreateTodo
  { actColor :: TodoColor
  , actText  :: Text
  }

deriveJSON
  defaultOptions
  { fieldLabelModifier = defaultFieldLabelModifier }
  ''APICreateTodo

data APITodo = APITodo
  { atColor :: TodoColor
  , atText  :: Text
  , atId    :: Int
  }

deriveJSON
  defaultOptions
  { fieldLabelModifier = defaultFieldLabelModifier }
  ''APITodo
