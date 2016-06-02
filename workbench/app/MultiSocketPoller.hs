{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Monad
import System.ZMQ4.Monadic

main :: IO ()
main = runZMQ $ do
    -- Connect to task ventilator
    receiver <- socket Pull
    connect receiver "tcp://localhost:5557"

    -- Connect to weather server
    subscriber <- socket Sub
    connect subscriber "tcp://localhost:5556"
    subscribe subscriber "10001 "

    -- Process messages from both sockets
    forever $
        poll (-1) [ Sock receiver   [In] (Just receiver_callback)
                  , Sock subscriber [In] (Just subscriber_callback)
                  ]
  where
    -- Process task
    receiver_callback :: [Event] -> ZMQ z ()
    receiver_callback _ = liftIO $ putStrLn ("process task ventillator") >> return ()

    -- Process weather update
    subscriber_callback :: [Event] -> ZMQ z ()
    subscriber_callback _ = liftIO $ putStrLn ("process weather task") >>return ()