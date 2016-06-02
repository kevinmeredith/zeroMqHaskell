{-# LANGUAGE OverloadedStrings #-}

-- Hello World server in Haskell
-- Binds REP socket to tcp://*:5560
-- Expects "hello" from clietn, replies with "World"

module Main where

import System.ZMQ4.Monadic
import Control.Monad
import Data.ByteString.Char8 (pack, unpack)
import Control.Concurrent (threadDelay)

main :: IO ()
main = runZMQ $ do
    responder <- socket Rep
    connect responder "tcp://localhost:5560"
    
    forever $ do
      message <- receive responder 
      liftIO $ do
      	putStrLn $ "Received " ++ (unpack message)
      	threadDelay (1 * 1000 * 1000) -- wait 1 second
      send responder [] "World"	