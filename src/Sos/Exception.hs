{-# LANGUAGE LambdaCase #-}

module Sos.Exception
  ( SosException(..)
  ) where

import Sos.Utils

import Data.ByteString (ByteString)
import Text.Parsec     (ParseError)


data SosException
  -- Error compiling the given regex.
  = SosRegexException
      ByteString -- pattern
      String     -- string reason for failure
  -- Error parsing a command template.
  | SosCommandParseException
      ByteString -- template
      ParseError -- failure
  -- Error applying a list of captured variables to a command template.
  | SosCommandApplyException
      [Either Int ByteString] -- template
      [ByteString]            -- captured variables
      String                  -- string reason for failure

instance Show SosException where
  show (SosRegexException pattrn err) =
    "Error compiling regex '" ++ unpackBS pattrn ++ "': " ++ err
  show (SosCommandParseException template err) =
    "Error parsing command '" ++ unpackBS template ++ "': " ++ show err
  show (SosCommandApplyException template vars err) =
    "Error applying template '" ++ reconstruct template ++ "' to " ++   show vars ++ ": " ++ err
   where
    reconstruct :: [Either Int ByteString] -> String
    reconstruct = concatMap
      (\case
        Left n   -> '\\' : show n
        Right bs -> unpackBS bs)