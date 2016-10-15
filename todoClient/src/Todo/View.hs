module Todo.View where

import React.Flux
import Todo.Store

todoClient :: ReactView ()
todoClient = defineControllerView "todoClient" todoStore draw
  where
    draw store () = div_ $ elemText "Mkey"
