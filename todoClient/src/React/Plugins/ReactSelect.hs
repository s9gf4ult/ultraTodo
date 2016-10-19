module React.Plugins.ReactSelect where

import Control.Lens
import Data.Aeson
import Data.Aeson.TH
import Data.Default
import Data.List as L
import Data.Maybe
import Data.Text as T
import GHCJS.Marshal
import React.Flux
import Text.Inflections
import Todo.Utils

-- | First parameter must have 'ToJSON' and 'FromJSON' instances and must render
-- to String or Integer value
data SelectOption a = SelectOption
  { _seValue          :: !a
  , _seLabel          :: !Text
  } deriving (Show)

makeLenses ''SelectOption

deriveJSON
  defaultOptions
  { fieldLabelModifier = defaultFieldLabelModifier }
  ''SelectOption

instance (FromJSON a) => FromJSVal (SelectOption a) where
  fromJSVal j = do
    Just value <- fromJSVal j
    return $ case fromJSON value of
      Error _ -> Nothing
      Success a -> Just a

data SelectMatchPos
  = SMStart
  | SMAny

makePrisms ''SelectMatchPos

deriveJSON
  defaultOptions
  { constructorTagModifier = toUnderscore . L.drop 2 }
  ''SelectMatchPos

data SelectMatchProp
  = SPLabel
  | SPValue
  | SPAny

makePrisms ''SelectMatchProp

deriveJSON
  defaultOptions
  { constructorTagModifier = toUnderscore . L.drop 2 }
  ''SelectMatchProp

-- | React-select pass null when value is cleared
type OnChangeHandler handler a = Maybe (SelectOption a) -> handler

data SelectParameters handler a = SelectParameters
  { _spName       :: Maybe Text
    -- ^ Name for hidden element
  , _spValue      :: Maybe a
  , _spOptions    :: [SelectOption a]
  , _spOnChange   :: Maybe (OnChangeHandler handler a)
    -- ^ Callback will to call on change
  , _spMatchPos   :: Maybe SelectMatchPos
  , _spMatchProp  :: Maybe SelectMatchProp
  , _spIgnoreCase :: Maybe Bool
  }

makeLenses ''SelectParameters

instance Default (SelectParameters handler a) where
  def = SelectParameters
    { _spName       = Nothing
    , _spValue      = Nothing
    , _spOptions    = []
    , _spOnChange   = Nothing
    , _spMatchPos   = Nothing
    , _spMatchProp  = Nothing
    , _spIgnoreCase = Nothing
    }

reactSelect_
  :: forall handler a
   . (ToJSON a, FromJSON a, CallbackFunction handler handler)
  => SelectParameters handler a
  -> ReactElementM handler ()
reactSelect_ selectParams = foreign_ "Select" opts mempty
  where
    opts :: [PropertyOrHandler handler]
    opts = catMaybes
      [ ("name" @=) <$> (selectParams ^. spName)
      , ("value" @=) <$> (selectParams ^. spValue)
      , Just $ "options" @= (selectParams ^. spOptions)
      , callback "onChange" <$> (selectParams ^. spOnChange)
      , ("matchPos" @=) <$> (selectParams ^. spMatchPos)
      , ("matchProp" @=) <$> (selectParams ^. spMatchProp)
      , ("ignoreCase" @=) <$> (selectParams ^. spIgnoreCase)
      ]
