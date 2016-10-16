module React.Plugins.ReactSelect where

import Control.Lens
import Data.Aeson
import Data.Aeson.TH
import Data.Default
import Data.Maybe
import Data.Text as T
import GHCJS.Marshal
import React.Flux
import Todo.Utils

-- | First parameter must have 'ToJSON' and 'FromJSON' instances and must render
-- to String or Integer value
data SelectOption a = SelectOption
  { _seValue          :: !a
  , _seLabel          :: !Text
  , _seClearableValue :: !(Maybe Bool)
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

-- | React-select pass null when value is cleared
type OnChangeHandler handler a = Maybe (SelectOption a) -> handler

data SelectParameters handler a = SelectParameters
  { _spName     :: Maybe Text
    -- ^ Name for hidden element
  , _spValue    :: Maybe a
  , _spOptions  :: [SelectOption a]
  , _spOnChange :: Maybe (OnChangeHandler handler a)
    -- ^ Callback will to call on change
  }

makeLenses ''SelectParameters

instance Default (SelectParameters handler a) where
  def = SelectParameters
    { _spName = Nothing
    , _spValue = Nothing
    , _spOptions = []
    , _spOnChange = Nothing
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
      ]
