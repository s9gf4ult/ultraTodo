module Todo.Server where

import Network.Wai.Handler.Warp
import Servant
import Todo.Api

server = undefined

startApp :: IO ()
startApp = run 8080 $ serve todoApi server
