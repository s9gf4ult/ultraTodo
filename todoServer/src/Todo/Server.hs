module Todo.Server where

import Network.Wai.Handler.Warp
import Servant
import Todo.Api
import Todo.Server.Impl

server :: Server TodoAPI
server = todoCreate :<|> todoList

startApp :: IO ()
startApp = run 8080 $ serve todoApi server
