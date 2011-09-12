module Primitives(defaultBindings) where

import Control.Monad.IO.Class (liftIO)
import Data.HashTable (fromList, hashString)

import Evaluate

defaultBindings :: IO Bindings
defaultBindings = sequence
                [fromList hashString
                    [("+", arithLift (+)),
                     ("-", arithLift (-)),
                     ("*", arithLift (*)),
                     ("/", arithLift (/)),


                     ("==", compLift (==)),
                     ("!=", compLift (\x y -> not (x == y))),
                     ("<",  compLift (<)),
                     (">",  compLift (>)),
                     ("<=", compLift (<=)),
                     (">=", compLift (>=)),


                     ("print", PrimFun putStrPrim)]
                ]

arithLift f =
  PrimFun (\[(NumVal x),(NumVal y)] -> (return . NumVal) (f x y))

compLift :: (Value -> Value -> Bool) -> Value
compLift comp = PrimFun (\[a, b] -> (return . BoolVal) (a `comp` b))

putStrPrim :: [Value] -> ProgramEnv Value
putStrPrim [(StrVal str)] = do
           (liftIO . putStr) str
           return Undefined
