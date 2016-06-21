{-# LANGUAGE OverloadedStrings #-}
-- |
-- Multithreaded Hello World server (p.65)
-- (Client) REQ >-> ROUTER (Proxy) DEALER >-> REP ([Worker])
-- The client is provided by `hwclient.hs`
-- Compile with -threaded

module Main where

import System.ZMQ4.Monadic
import Control.Monad (forever, replicateM_)
import Data.ByteString.Char8 (unpack)
import Control.Concurrent (threadDelay)
import Text.Printf

main :: IO ()
main =
    runZMQ $ do
    	-- server frontend to talk to clients
    	server <- socket Router
    	bind server "tcp://*:5555"

    	-- socket to talk to workers
    	workers <- socket Dealer
    	bind workers "inproc://workers"

    	-- using inpoc (inter-thread) we expect to share context
    	replicateM_ 5 (async worker)
    	-- connect work threads to client threads via a queue
    	proxy server workers Nothing

worker :: ZMQ z ()
worker = do
	receiver <- socket Rep
	connect receiver "inproc://workers"
	forever $ do
		receive receiver >>= liftIO . printf "received request: %s\n" . unpack

		--simulate work for 1 second
		liftIO $ threadDelay (1 * 1000 * 1000)
		send receiver [] "World"