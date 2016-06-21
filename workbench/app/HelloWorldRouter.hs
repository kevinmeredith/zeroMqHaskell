{-# LANGUAGE OverloadedStrings #-}

-- Hello World server

module Main where

import Control.Concurrent
import Control.Monad
import System.ZMQ4.Monadic
import Text.Printf
import Data.ByteString.Char8 (unpack, pack)
import Data.List.NonEmpty

main :: IO ()
main = runZMQ $ do
    -- Socket to talk to clients
    responder <- socket Router
    bind responder "tcp://*:5555"

    forever $ do
        response @ (identity : _ : body : []) <- receiveMulti responder
        _ <- liftIO $ putStrLn . show . Prelude.length $ response
        _ <- liftIO $ forM_ response (printf "received request: %s\n" . unpack)
        liftIO $ putStrLn "sending world"
        sendMulti responder $ identity `cons` (pack "" `cons` (pack "world" :| []))