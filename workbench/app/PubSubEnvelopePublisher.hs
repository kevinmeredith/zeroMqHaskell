{-# LANGUAGE OverloadedLists   #-}
{-# LANGUAGE OverloadedStrings #-}

--  Pubsub envelope publisher

module Main where

import Control.Concurrent
import Control.Monad
import System.ZMQ4.Monadic

main :: IO ()
main = runZMQ $ do
	-- prepare our publisher
	publisher <- socket Pub
	bind publisher "tcp://*:5563"

	forever $ do
		-- write two messages, each with an envelope and content
		sendMulti publisher ["A", "We don't want to see this"]
		sendMulti publisher ["B", "We would like to see this"]
		liftIO $ threadDelay 1000000