{-# LANGUAGE OverloadedStrings #-}

-- Request/Reply Hello World with broker
-- Binds REQ socket to tcp://localhost:5559
-- Sends "hello" to server, expects "World" back

-- start broker first!

module Main where

import System.ZMQ4.Monadic
import Control.Monad (forM_)
import Data.ByteString.Char8 (unpack)
import Text.Printf

main :: IO ()
main = 
	runZMQ $ do
		requester <- socket Req
		connect requester "tcp://localhost:5559"
		forM_ [1..10] $ \i -> do
			send requester [] "Hello"
			msg <- receive requester
			liftIO $ printf "Received reply %d %s\n" (i :: Int) (unpack msg)