module Todo.Utils where

import Data.Char
import Text.Inflections

-- | Drops until first upcased character and apply 'toUnderscore' to
-- the rest
defaultFieldLabelModifier :: String -> String
defaultFieldLabelModifier = toUnderscore . dropPrefix

-- | Just drops prefix
dropPrefix :: String -> String
dropPrefix = dropWhile (not . isUpper)
