module Todo.Api.Types where

import Control.DeepSeq
import Control.Lens
import Data.Aeson.TH
import Data.List as L
import Data.Text as T
import GHC.Generics (Generic)
import Text.Inflections
import Todo.Utils

data TodoColor
  = TCRed
  | TCBlue
  | TCGreen
  | TCWhite
  | TCRainbow
    -- ^ :trollface:
  deriving (Eq, Show, Generic)

deriveJSON
  defaultOptions
  { constructorTagModifier = toUnderscore . L.drop 2 }
  ''TodoColor

makePrisms ''TodoColor

instance NFData TodoColor

data APICreateTodo = APICreateTodo
  { _actColor :: TodoColor
  , _actText  :: Text
  } deriving (Eq, Show, Generic)

deriveJSON
  defaultOptions
  { fieldLabelModifier = defaultFieldLabelModifier }
  ''APICreateTodo

makeLenses ''APICreateTodo

instance NFData APICreateTodo

data APITodo = APITodo
  { _atColor :: TodoColor
  , _atText  :: Text
  , _atId    :: Int
  } deriving (Eq, Show, Generic)

deriveJSON
  defaultOptions
  { fieldLabelModifier = defaultFieldLabelModifier }
  ''APITodo

makeLenses ''APITodo

instance NFData APITodo
