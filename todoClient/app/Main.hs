module Main where

import React.Flux
import Todo.View

main :: IO ()
main = reactRender "todoClient" todoClient ()
