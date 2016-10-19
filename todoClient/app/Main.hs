module Main where

import React.Flux
import React.Flux.Ajax
import Todo.View

main :: IO ()
main = do
  initAjax
  reactRender "todoClient" todoClient ()
