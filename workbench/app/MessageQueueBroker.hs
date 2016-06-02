-- Simple message queueing broker
-- same as request-reply broker but using shared queue proxy

module Main where

import System.ZMQ4.Monadic

main :: IO ()
main = runZMQ $ do
  -- socket facing clients
  frontend <- socket Router
  bind frontend "tcp://*:5559"	

  backend <- socket Dealer
  bind backend "tcp://*:5560"

  -- start the proxy
  proxy frontend backend Nothing