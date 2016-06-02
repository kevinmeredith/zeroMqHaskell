{-# LANGUAGE ScopedTypeVariables #-}

module Main where

import           Control.Monad
import qualified Data.ByteString.Char8 as BS
import    	     System.Random
import           System.ZMQ4.Monadic
import 			 Text.Printf

main :: IO ()
main = runZMQ $ do
	publisher <- socket Pub
	bind publisher "tcp://*:5556"

	forever $ do
		zipcode     :: Int <- liftIO $ randomRIO (0, 100000)
		temperature :: Int <- liftIO $ randomRIO (-30, 135)
		relhumidity :: Int <- liftIO $ randomRIO (10, 60)

		let update = printf "%05d %d %d" zipcode temperature relhumidity
		send publisher [] (BS.pack update)