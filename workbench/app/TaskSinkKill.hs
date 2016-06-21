{-# LANGUAGE OverloadedStrings #-}

--  Task sink - design 2
--  Adds pub-sub flow to send kill signal to workers

module Main where

import Control.Monad
import Data.Time.Clock
import System.IO
import System.ZMQ4.Monadic

main :: IO ()
main = runZMQ $ do
	receiver <- socket Pull
	bind receiver "tcp://*:5558"

	controller <- socket Pub
	bind controller "tcp://*:5559"

	-- wait for start of batch
	_ <- receive receiver

	-- start clock
	start_Time <- liftIO getCurrentTime

	liftIO $ hSetBuffering stdout NoBuffering
	forM_ [1..100] $ \i -> do
		_ <- receive receiver
		if i `mod` 10 == 0
			then liftIO $ putStr ":"
			else liftIO $ putStr "."

	end_time <- liftIO getCurrentTime
	liftIO . putStrLn $ "Total elapsed time: " ++ 
		show (diffUTCTime end_time start_Time * 1000) ++ "msec"

	liftIO . putStrLn $ "Sending kill signal"

	send controller [] "KILL" 